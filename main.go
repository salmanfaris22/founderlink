package main

import (
	"bufio"
	"context"
	"encoding/json"
	"fmt"
	"math/rand"
	"net"
	"net/http"
	"os"
	"os/signal"
	"strings"
	"sync"
	"syscall"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"github.com/google/uuid"
	"github.com/gorilla/mux"
	"github.com/gorilla/websocket"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"golang.org/x/crypto/bcrypt"
)

// ═══════════════════════ CONFIG ═══════════════════════

type Config struct {
	Port        string
	DatabaseURL string
	JWTSecret   string
	Env         string
}

func loadConfig() Config {
	return Config{
		Port:        envOr("PORT", "8080"),
		DatabaseURL: envOr("DATABASE_URL", "postgresql://postgres:Salman@40567633800@db.vounmegpaovvrfffolyf.supabase.co:5432/postgres?sslmode=require"),
		JWTSecret:   envOr("JWT_SECRET", "founderlink-secret-change-me"),
		Env:         envOr("ENV", "development"),
	}
}
func envOr(k, d string) string {
	if v := os.Getenv(k); v != "" {
		return v
	}
	return d
}

// ═══════════════════════ LOGGER ═══════════════════════

var log *zap.Logger

func initLogger(e string) {
	var cfg zap.Config
	if e == "production" {
		cfg = zap.NewProductionConfig()
	} else {
		cfg = zap.NewDevelopmentConfig()
		cfg.EncoderConfig.EncodeLevel = zapcore.CapitalColorLevelEncoder
	}
	var err error
	log, err = cfg.Build()
	if err != nil {
		panic(err)
	}
}

// ═══════════════════════ DB ═══════════════════════

type DB struct{ pool *pgxpool.Pool }

func newDB(ctx context.Context, dsn string) (*DB, error) {
	pcfg, err := pgxpool.ParseConfig(dsn)
	if err != nil {
		return nil, err
	}
	pcfg.MaxConns = 30
	pcfg.MinConns = 5
	pcfg.MaxConnLifetime = time.Hour
	pcfg.MaxConnIdleTime = 30 * time.Minute
	pool, err := pgxpool.NewWithConfig(ctx, pcfg)
	if err != nil {
		return nil, err
	}
	return &DB{pool: pool}, pool.Ping(ctx)
}
func (d *DB) close() { d.pool.Close() }
func (d *DB) exec(ctx context.Context, sql string, args ...any) error {
	_, err := d.pool.Exec(ctx, sql, args...)
	return err
}
func (d *DB) qrow(ctx context.Context, sql string, args ...any) pgx.Row {
	return d.pool.QueryRow(ctx, sql, args...)
}
func (d *DB) query(ctx context.Context, sql string, args ...any) (pgx.Rows, error) {
	return d.pool.Query(ctx, sql, args...)
}

func (d *DB) migrate(ctx context.Context) {
	ddl := []string{
		`CREATE EXTENSION IF NOT EXISTS "uuid-ossp"`,
		`CREATE EXTENSION IF NOT EXISTS pg_trgm`,
		// users — now with username, profile_public, follow_request
		`CREATE TABLE IF NOT EXISTS users (
			id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
			username VARCHAR(40) UNIQUE NOT NULL,
			name VARCHAR(120) NOT NULL,
			email VARCHAR(255) UNIQUE NOT NULL,
			password_hash TEXT NOT NULL,
			avatar TEXT NOT NULL DEFAULT '',
			cover_image TEXT NOT NULL DEFAULT '',
			bio TEXT NOT NULL DEFAULT '',
			headline VARCHAR(220) NOT NULL DEFAULT '',
			role VARCHAR(60) NOT NULL DEFAULT 'founder',
			skills TEXT[] NOT NULL DEFAULT '{}',
			location VARCHAR(120) NOT NULL DEFAULT '',
			website VARCHAR(300) NOT NULL DEFAULT '',
			linkedin VARCHAR(300) NOT NULL DEFAULT '',
			twitter VARCHAR(300) NOT NULL DEFAULT '',
			looking_for TEXT NOT NULL DEFAULT '',
			is_investor BOOLEAN NOT NULL DEFAULT FALSE,
			is_verified BOOLEAN NOT NULL DEFAULT FALSE,
			is_public BOOLEAN NOT NULL DEFAULT TRUE,
			followers_count INT NOT NULL DEFAULT 0,
			following_count INT NOT NULL DEFAULT 0,
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		)`,
		`ALTER TABLE users ADD COLUMN IF NOT EXISTS username VARCHAR(40) UNIQUE`,
		`ALTER TABLE users ADD COLUMN IF NOT EXISTS is_public BOOLEAN NOT NULL DEFAULT TRUE`,
		`CREATE INDEX IF NOT EXISTS idx_users_email ON users(email)`,
		`CREATE INDEX IF NOT EXISTS idx_users_username ON users(username)`,
		`CREATE INDEX IF NOT EXISTS idx_users_role ON users(role)`,
		`CREATE INDEX IF NOT EXISTS idx_users_name_trgm ON users USING gin(name gin_trgm_ops)`,
		// follow requests (for private accounts)
		`CREATE TABLE IF NOT EXISTS follow_requests (
			id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
			requester_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			target_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			status VARCHAR(20) NOT NULL DEFAULT 'pending',
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			UNIQUE(requester_id, target_id)
		)`,
		`CREATE INDEX IF NOT EXISTS idx_fr_target ON follow_requests(target_id, status)`,
		// posts
		`CREATE TABLE IF NOT EXISTS posts (
			id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
			user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			type VARCHAR(20) NOT NULL DEFAULT 'post',
			title TEXT NOT NULL DEFAULT '',
			content TEXT NOT NULL,
			tags TEXT[] NOT NULL DEFAULT '{}',
			media_url TEXT NOT NULL DEFAULT '',
			likes_count INT NOT NULL DEFAULT 0,
			comments_count INT NOT NULL DEFAULT 0,
			shares_count INT NOT NULL DEFAULT 0,
			is_pinned BOOLEAN NOT NULL DEFAULT FALSE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		)`,
		`CREATE INDEX IF NOT EXISTS idx_posts_user_id ON posts(user_id)`,
		`CREATE INDEX IF NOT EXISTS idx_posts_type ON posts(type)`,
		`CREATE INDEX IF NOT EXISTS idx_posts_created_at ON posts(created_at DESC)`,
		`CREATE TABLE IF NOT EXISTS post_likes (
			user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
			PRIMARY KEY (user_id, post_id)
		)`,
		`CREATE TABLE IF NOT EXISTS post_bookmarks (
			user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
			PRIMARY KEY (user_id, post_id)
		)`,
		`CREATE TABLE IF NOT EXISTS idea_votes (
			user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
			vote_type VARCHAR(10) NOT NULL DEFAULT 'up',
			PRIMARY KEY (user_id, post_id)
		)`,
		// comments
		`CREATE TABLE IF NOT EXISTS comments (
			id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
			post_id UUID NOT NULL REFERENCES posts(id) ON DELETE CASCADE,
			user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			parent_id UUID REFERENCES comments(id) ON DELETE CASCADE,
			content TEXT NOT NULL,
			likes_count INT NOT NULL DEFAULT 0,
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		)`,
		`CREATE INDEX IF NOT EXISTS idx_comments_post ON comments(post_id)`,
		`CREATE TABLE IF NOT EXISTS comment_likes (
			user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			comment_id UUID NOT NULL REFERENCES comments(id) ON DELETE CASCADE,
			PRIMARY KEY (user_id, comment_id)
		)`,
		// follows
		`CREATE TABLE IF NOT EXISTS follows (
			follower_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			following_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			PRIMARY KEY (follower_id, following_id)
		)`,
		`CREATE INDEX IF NOT EXISTS idx_follows_follower ON follows(follower_id)`,
		`CREATE INDEX IF NOT EXISTS idx_follows_following ON follows(following_id)`,
		// projects
		`CREATE TABLE IF NOT EXISTS projects (
			id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
			owner_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			name VARCHAR(200) NOT NULL,
			tagline TEXT NOT NULL DEFAULT '',
			description TEXT NOT NULL DEFAULT '',
			stage VARCHAR(50) NOT NULL DEFAULT 'idea',
			industry VARCHAR(120) NOT NULL DEFAULT '',
			seeking TEXT[] NOT NULL DEFAULT '{}',
			equity_offer VARCHAR(60) NOT NULL DEFAULT '',
			funding_needed VARCHAR(120) NOT NULL DEFAULT '',
			website VARCHAR(300) NOT NULL DEFAULT '',
			deck_url TEXT NOT NULL DEFAULT '',
			logo TEXT NOT NULL DEFAULT '',
			cover TEXT NOT NULL DEFAULT '',
			views INT NOT NULL DEFAULT 0,
			interested_count INT NOT NULL DEFAULT 0,
			is_published BOOLEAN NOT NULL DEFAULT TRUE,
			price VARCHAR(100) NOT NULL DEFAULT '',
			is_paid BOOLEAN NOT NULL DEFAULT FALSE,
			pricing_description TEXT NOT NULL DEFAULT '',
			progress_percent INT NOT NULL DEFAULT 0,
			progress_notes TEXT NOT NULL DEFAULT '',
			progress_stage VARCHAR(120) NOT NULL DEFAULT '',
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		)`,
		`ALTER TABLE projects ADD COLUMN IF NOT EXISTS price VARCHAR(100) NOT NULL DEFAULT ''`,
		`ALTER TABLE projects ADD COLUMN IF NOT EXISTS is_paid BOOLEAN NOT NULL DEFAULT FALSE`,
		`ALTER TABLE projects ADD COLUMN IF NOT EXISTS pricing_description TEXT NOT NULL DEFAULT ''`,
		`ALTER TABLE projects ADD COLUMN IF NOT EXISTS progress_percent INT NOT NULL DEFAULT 0`,
		`ALTER TABLE projects ADD COLUMN IF NOT EXISTS progress_notes TEXT NOT NULL DEFAULT ''`,
		`ALTER TABLE projects ADD COLUMN IF NOT EXISTS progress_stage VARCHAR(120) NOT NULL DEFAULT ''`,
		`CREATE INDEX IF NOT EXISTS idx_projects_owner ON projects(owner_id)`,
		`CREATE INDEX IF NOT EXISTS idx_projects_stage ON projects(stage)`,
		`CREATE INDEX IF NOT EXISTS idx_projects_name_trgm ON projects USING gin(name gin_trgm_ops)`,
		`CREATE TABLE IF NOT EXISTS project_views (
			project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
			user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			viewed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			PRIMARY KEY (project_id, user_id)
		)`,
		// project sections — now with type (info, notes, coming_soon)
		`CREATE TABLE IF NOT EXISTS project_sections (
			id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
			project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
			title VARCHAR(200) NOT NULL,
			content TEXT NOT NULL DEFAULT '',
			section_type VARCHAR(40) NOT NULL DEFAULT 'info',
			order_index INT NOT NULL DEFAULT 0,
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		)`,
		`ALTER TABLE project_sections ADD COLUMN IF NOT EXISTS section_type VARCHAR(40) NOT NULL DEFAULT 'info'`,
		`CREATE INDEX IF NOT EXISTS idx_sections_project ON project_sections(project_id, order_index)`,
		// team members — now with is_admin, invite_expires_at
		`CREATE TABLE IF NOT EXISTS team_members (
			id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
			project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
			user_id UUID REFERENCES users(id) ON DELETE SET NULL,
			name VARCHAR(120) NOT NULL,
			role VARCHAR(120) NOT NULL,
			equity VARCHAR(60) NOT NULL DEFAULT '',
			status VARCHAR(30) NOT NULL DEFAULT 'invited',
			is_admin BOOLEAN NOT NULL DEFAULT FALSE,
			invite_expires_at TIMESTAMPTZ,
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		)`,
		`ALTER TABLE team_members ADD COLUMN IF NOT EXISTS is_admin BOOLEAN NOT NULL DEFAULT FALSE`,
		`ALTER TABLE team_members ADD COLUMN IF NOT EXISTS invite_expires_at TIMESTAMPTZ`,
		`CREATE INDEX IF NOT EXISTS idx_team_project ON team_members(project_id)`,
		// project join requests
		`CREATE TABLE IF NOT EXISTS project_join_requests (
			id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
			project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
			user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			message TEXT NOT NULL DEFAULT '',
			desired_role VARCHAR(120) NOT NULL DEFAULT '',
			status VARCHAR(30) NOT NULL DEFAULT 'pending',
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			UNIQUE(project_id, user_id)
		)`,
		`CREATE INDEX IF NOT EXISTS idx_joinreq_project ON project_join_requests(project_id)`,
		// tasks — with allowed_creators (admin system)
		`CREATE TABLE IF NOT EXISTS tasks (
			id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
			project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
			title VARCHAR(300) NOT NULL,
			description TEXT NOT NULL DEFAULT '',
			status VARCHAR(30) NOT NULL DEFAULT 'backlog',
			priority VARCHAR(20) NOT NULL DEFAULT 'medium',
			assignee_id UUID REFERENCES users(id) ON DELETE SET NULL,
			created_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			due_date DATE,
			order_index INT NOT NULL DEFAULT 0,
			tags TEXT[] NOT NULL DEFAULT '{}',
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		)`,
		`CREATE INDEX IF NOT EXISTS idx_tasks_project ON tasks(project_id, status, order_index)`,
		// investor interests
		`CREATE TABLE IF NOT EXISTS investor_interests (
			id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
			investor_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
			message TEXT NOT NULL DEFAULT '',
			amount VARCHAR(100) NOT NULL DEFAULT '',
			status VARCHAR(30) NOT NULL DEFAULT 'pending',
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			UNIQUE(investor_id, project_id)
		)`,
		`CREATE INDEX IF NOT EXISTS idx_interests_project ON investor_interests(project_id)`,
		// conversations — now with group management
		`CREATE TABLE IF NOT EXISTS conversations (
			id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
			project_id UUID REFERENCES projects(id) ON DELETE CASCADE,
			is_group BOOLEAN NOT NULL DEFAULT FALSE,
			name VARCHAR(200) NOT NULL DEFAULT '',
			created_by UUID REFERENCES users(id) ON DELETE SET NULL,
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		)`,
		`ALTER TABLE conversations ADD COLUMN IF NOT EXISTS project_id UUID REFERENCES projects(id) ON DELETE CASCADE`,
		`ALTER TABLE conversations ADD COLUMN IF NOT EXISTS is_group BOOLEAN NOT NULL DEFAULT FALSE`,
		`ALTER TABLE conversations ADD COLUMN IF NOT EXISTS name VARCHAR(200) NOT NULL DEFAULT ''`,
		`ALTER TABLE conversations ADD COLUMN IF NOT EXISTS created_by UUID REFERENCES users(id) ON DELETE SET NULL`,
		`CREATE INDEX IF NOT EXISTS idx_conv_project ON conversations(project_id)`,
		`CREATE TABLE IF NOT EXISTS conversation_members (
			conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
			user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			is_admin BOOLEAN NOT NULL DEFAULT FALSE,
			joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
			PRIMARY KEY (conversation_id, user_id)
		)`,
		`ALTER TABLE conversation_members ADD COLUMN IF NOT EXISTS is_admin BOOLEAN NOT NULL DEFAULT FALSE`,
		`ALTER TABLE conversation_members ADD COLUMN IF NOT EXISTS joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW()`,
		`CREATE INDEX IF NOT EXISTS idx_conv_member_user ON conversation_members(user_id)`,
		`CREATE TABLE IF NOT EXISTS messages (
			id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
			conversation_id UUID NOT NULL REFERENCES conversations(id) ON DELETE CASCADE,
			sender_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			content TEXT NOT NULL,
			msg_type VARCHAR(20) NOT NULL DEFAULT 'text',
			read BOOLEAN NOT NULL DEFAULT FALSE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		)`,
		`ALTER TABLE messages ADD COLUMN IF NOT EXISTS msg_type VARCHAR(20) NOT NULL DEFAULT 'text'`,
		`CREATE INDEX IF NOT EXISTS idx_messages_conv ON messages(conversation_id, created_at DESC)`,
		// notifications
		`CREATE TABLE IF NOT EXISTS notifications (
			id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
			user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
			actor_id UUID REFERENCES users(id) ON DELETE SET NULL,
			type VARCHAR(60) NOT NULL,
			message TEXT NOT NULL,
			ref_id UUID,
			ref_type VARCHAR(60) NOT NULL DEFAULT '',
			read BOOLEAN NOT NULL DEFAULT FALSE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		)`,
		`CREATE INDEX IF NOT EXISTS idx_notif_user ON notifications(user_id, created_at DESC)`,
		// Auto-reject expired invites: run as background job
		// project_update_log for "coming soon" tracking
		`CREATE TABLE IF NOT EXISTS project_updates (
			id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
			project_id UUID NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
			title VARCHAR(300) NOT NULL,
			content TEXT NOT NULL DEFAULT '',
			is_coming_soon BOOLEAN NOT NULL DEFAULT FALSE,
			release_date DATE,
			created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
		)`,
		`CREATE INDEX IF NOT EXISTS idx_proj_updates ON project_updates(project_id, created_at DESC)`,
	}
	ok, warn := 0, 0
	for _, s := range ddl {
		if _, err := d.pool.Exec(ctx, s); err != nil {
			warn++
		} else {
			ok++
		}
	}
	log.Info("migrate done", zap.Int("ok", ok), zap.Int("warn", warn))
}

// ═══════════════════════ MODELS ═══════════════════════

type User struct {
	ID             string    `json:"id"`
	Username       string    `json:"username"`
	Name           string    `json:"name"`
	Email          string    `json:"email,omitempty"`
	Avatar         string    `json:"avatar"`
	CoverImage     string    `json:"cover_image"`
	Bio            string    `json:"bio"`
	Headline       string    `json:"headline"`
	Role           string    `json:"role"`
	Skills         []string  `json:"skills"`
	Location       string    `json:"location"`
	Website        string    `json:"website"`
	LinkedIn       string    `json:"linkedin"`
	Twitter        string    `json:"twitter"`
	LookingFor     string    `json:"looking_for"`
	IsInvestor     bool      `json:"is_investor"`
	IsVerified     bool      `json:"is_verified"`
	IsPublic       bool      `json:"is_public"`
	FollowersCount int       `json:"followers_count"`
	FollowingCount int       `json:"following_count"`
	IsFollowing    bool      `json:"is_following"`
	FollowPending  bool      `json:"follow_pending"`
	CreatedAt      time.Time `json:"created_at"`
}

type Post struct {
	ID            string    `json:"id"`
	UserID        string    `json:"user_id"`
	Author        *User     `json:"author,omitempty"`
	Type          string    `json:"type"`
	Title         string    `json:"title"`
	Content       string    `json:"content"`
	Tags          []string  `json:"tags"`
	MediaURL      string    `json:"media_url"`
	LikesCount    int       `json:"likes_count"`
	CommentsCount int       `json:"comments_count"`
	SharesCount   int       `json:"shares_count"`
	IsPinned      bool      `json:"is_pinned"`
	IsLiked       bool      `json:"is_liked"`
	IsBookmarked  bool      `json:"is_bookmarked"`
	UpVotes       int       `json:"up_votes"`
	DownVotes     int       `json:"down_votes"`
	MyVote        string    `json:"my_vote"`
	CreatedAt     time.Time `json:"created_at"`
	UpdatedAt     time.Time `json:"updated_at"`
}

type Comment struct {
	ID         string     `json:"id"`
	PostID     string     `json:"post_id"`
	UserID     string     `json:"user_id"`
	Author     *User      `json:"author,omitempty"`
	ParentID   *string    `json:"parent_id,omitempty"`
	Content    string     `json:"content"`
	LikesCount int        `json:"likes_count"`
	IsLiked    bool       `json:"is_liked"`
	Replies    []*Comment `json:"replies,omitempty"`
	CreatedAt  time.Time  `json:"created_at"`
}

type Project struct {
	ID                 string           `json:"id"`
	OwnerID            string           `json:"owner_id"`
	Owner              *User            `json:"owner,omitempty"`
	Name               string           `json:"name"`
	Tagline            string           `json:"tagline"`
	Description        string           `json:"description"`
	Stage              string           `json:"stage"`
	Industry           string           `json:"industry"`
	Seeking            []string         `json:"seeking"`
	EquityOffer        string           `json:"equity_offer"`
	FundingNeeded      string           `json:"funding_needed"`
	Website            string           `json:"website"`
	DeckURL            string           `json:"deck_url"`
	Logo               string           `json:"logo"`
	Cover              string           `json:"cover"`
	Views              int              `json:"views"`
	InterestedCount    int              `json:"interested_count"`
	IsPublished        bool             `json:"is_published"`
	Price              string           `json:"price"`
	IsPaid             bool             `json:"is_paid"`
	PricingDescription string           `json:"pricing_description"`
	ProgressPercent    int              `json:"progress_percent"`
	ProgressNotes      string           `json:"progress_notes"`
	ProgressStage      string           `json:"progress_stage"`
	Sections           []ProjectSection `json:"sections,omitempty"`
	TeamMembers        []TeamMember     `json:"team_members,omitempty"`
	Updates            []ProjectUpdate  `json:"updates,omitempty"`
	CreatedAt          time.Time        `json:"created_at"`
	UpdatedAt          time.Time        `json:"updated_at"`
}

type ProjectSection struct {
	ID          string    `json:"id"`
	ProjectID   string    `json:"project_id"`
	Title       string    `json:"title"`
	Content     string    `json:"content"`
	SectionType string    `json:"section_type"` // info, notes, coming_soon
	OrderIndex  int       `json:"order_index"`
	CreatedAt   time.Time `json:"created_at"`
}

type ProjectUpdate struct {
	ID           string    `json:"id"`
	ProjectID    string    `json:"project_id"`
	Title        string    `json:"title"`
	Content      string    `json:"content"`
	IsComingSoon bool      `json:"is_coming_soon"`
	ReleaseDate  *string   `json:"release_date,omitempty"`
	CreatedAt    time.Time `json:"created_at"`
}

type TeamMember struct {
	ID              string     `json:"id"`
	ProjectID       string     `json:"project_id"`
	UserID          *string    `json:"user_id,omitempty"`
	Name            string     `json:"name"`
	Role            string     `json:"role"`
	Equity          string     `json:"equity"`
	Status          string     `json:"status"`
	IsAdmin         bool       `json:"is_admin"`
	InviteExpiresAt *time.Time `json:"invite_expires_at,omitempty"`
	CreatedAt       time.Time  `json:"created_at"`
}

type InvestorInterest struct {
	ID         string    `json:"id"`
	InvestorID string    `json:"investor_id"`
	Investor   *User     `json:"investor,omitempty"`
	ProjectID  string    `json:"project_id"`
	Message    string    `json:"message"`
	Amount     string    `json:"amount"`
	Status     string    `json:"status"`
	CreatedAt  time.Time `json:"created_at"`
}

type Task struct {
	ID          string    `json:"id"`
	ProjectID   string    `json:"project_id"`
	Title       string    `json:"title"`
	Description string    `json:"description"`
	Status      string    `json:"status"`
	Priority    string    `json:"priority"`
	AssigneeID  *string   `json:"assignee_id,omitempty"`
	Assignee    *User     `json:"assignee,omitempty"`
	CreatedBy   string    `json:"created_by"`
	Creator     *User     `json:"creator,omitempty"`
	DueDate     *string   `json:"due_date,omitempty"`
	OrderIndex  int       `json:"order_index"`
	Tags        []string  `json:"tags"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
}

type JoinRequest struct {
	ID          string    `json:"id"`
	ProjectID   string    `json:"project_id"`
	UserID      string    `json:"user_id"`
	User        *User     `json:"user,omitempty"`
	Message     string    `json:"message"`
	DesiredRole string    `json:"desired_role"`
	Status      string    `json:"status"`
	CreatedAt   time.Time `json:"created_at"`
}

type Message struct {
	ID             string    `json:"id"`
	ConversationID string    `json:"conversation_id"`
	SenderID       string    `json:"sender_id"`
	Sender         *User     `json:"sender,omitempty"`
	Content        string    `json:"content"`
	MsgType        string    `json:"msg_type"`
	Read           bool      `json:"read"`
	CreatedAt      time.Time `json:"created_at"`
}

type Conversation struct {
	ID          string       `json:"id"`
	ProjectID   *string      `json:"project_id,omitempty"`
	IsGroup     bool         `json:"is_group"`
	Name        string       `json:"name"`
	CreatedBy   *string      `json:"created_by,omitempty"`
	Members     []ConvMember `json:"members"`
	LastMessage *Message     `json:"last_message,omitempty"`
	UnreadCount int          `json:"unread_count"`
	UpdatedAt   time.Time    `json:"updated_at"`
}

type ConvMember struct {
	User
	IsAdmin  bool      `json:"is_admin"`
	JoinedAt time.Time `json:"joined_at"`
}

type Notification struct {
	ID        string    `json:"id"`
	UserID    string    `json:"user_id"`
	ActorID   *string   `json:"actor_id,omitempty"`
	Actor     *User     `json:"actor,omitempty"`
	Type      string    `json:"type"`
	Message   string    `json:"message"`
	RefID     *string   `json:"ref_id,omitempty"`
	RefType   string    `json:"ref_type"`
	Read      bool      `json:"read"`
	CreatedAt time.Time `json:"created_at"`
}

type FollowRequest struct {
	ID          string    `json:"id"`
	RequesterID string    `json:"requester_id"`
	Requester   *User     `json:"requester,omitempty"`
	TargetID    string    `json:"target_id"`
	Status      string    `json:"status"`
	CreatedAt   time.Time `json:"created_at"`
}

// ═══════════════════════ JWT ═══════════════════════

type Claims struct {
	UserID string `json:"uid"`
	jwt.RegisteredClaims
}
type Auth struct{ secret []byte }

func newAuth(s string) *Auth { return &Auth{secret: []byte(s)} }
func (a *Auth) issue(userID string) (string, error) {
	now := time.Now()
	return jwt.NewWithClaims(jwt.SigningMethodHS256, Claims{
		UserID: userID,
		RegisteredClaims: jwt.RegisteredClaims{
			IssuedAt:  jwt.NewNumericDate(now),
			ExpiresAt: jwt.NewNumericDate(now.Add(7 * 24 * time.Hour)),
		},
	}).SignedString(a.secret)
}
func (a *Auth) verify(tok string) (*Claims, error) {
	t, err := jwt.ParseWithClaims(tok, &Claims{}, func(t *jwt.Token) (any, error) {
		if _, ok := t.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("bad method")
		}
		return a.secret, nil
	})
	if err != nil || !t.Valid {
		return nil, fmt.Errorf("invalid token")
	}
	return t.Claims.(*Claims), nil
}

// ═══════════════════════ WS HUB ═══════════════════════

type WSEvent struct {
	Type    string `json:"type"`
	Payload any    `json:"payload"`
}
type wsClient struct {
	userID string
	conn   *websocket.Conn
	send   chan []byte
}
type Hub struct {
	mu         sync.RWMutex
	clients    map[string]*wsClient
	register   chan *wsClient
	unregister chan *wsClient
}

func newHub() *Hub {
	return &Hub{clients: make(map[string]*wsClient), register: make(chan *wsClient, 64), unregister: make(chan *wsClient, 64)}
}
func (h *Hub) run() {
	for {
		select {
		case c := <-h.register:
			h.mu.Lock()
			h.clients[c.userID] = c
			h.mu.Unlock()
		case c := <-h.unregister:
			h.mu.Lock()
			if cur, ok := h.clients[c.userID]; ok && cur == c {
				delete(h.clients, c.userID)
				close(c.send)
			}
			h.mu.Unlock()
		}
	}
}
func (h *Hub) push(uid string, evt WSEvent) {
	data, _ := json.Marshal(evt)
	h.mu.RLock()
	c, ok := h.clients[uid]
	h.mu.RUnlock()
	if ok {
		select {
		case c.send <- data:
		default:
		}
	}
}
func (h *Hub) broadcast(uids []string, evt WSEvent) {
	data, _ := json.Marshal(evt)
	h.mu.RLock()
	defer h.mu.RUnlock()
	for _, id := range uids {
		if c, ok := h.clients[id]; ok {
			select {
			case c.send <- data:
			default:
			}
		}
	}
}
func (c *wsClient) writePump() {
	tk := time.NewTicker(54 * time.Second)
	defer func() { tk.Stop(); c.conn.Close() }()
	for {
		select {
		case msg, ok := <-c.send:
			c.conn.SetWriteDeadline(time.Now().Add(10 * time.Second))
			if !ok {
				c.conn.WriteMessage(websocket.CloseMessage, []byte{})
				return
			}
			c.conn.WriteMessage(websocket.TextMessage, msg)
		case <-tk.C:
			c.conn.SetWriteDeadline(time.Now().Add(10 * time.Second))
			if c.conn.WriteMessage(websocket.PingMessage, nil) != nil {
				return
			}
		}
	}
}

// ═══════════════════════ USERNAME GENERATION ═══════════════════════

var adjectives = []string{"swift", "bold", "bright", "cool", "dark", "epic", "fast", "great", "high", "keen", "mad", "neat", "odd", "pure", "raw", "real", "rich", "safe", "smart", "true", "vast", "wild", "wise", "zen"}
var nouns = []string{"builder", "coder", "creator", "dev", "founder", "hacker", "maker", "pilot", "rider", "runner", "seeker", "thinker", "trader", "walker", "wizard"}

func generateUsername(db *DB, ctx context.Context, base string) string {
	// Clean base
	cleaned := strings.ToLower(strings.ReplaceAll(strings.ReplaceAll(base, " ", ""), "-", ""))
	if len(cleaned) > 12 {
		cleaned = cleaned[:12]
	}
	if cleaned == "" {
		cleaned = adjectives[rand.Intn(len(adjectives))] + nouns[rand.Intn(len(nouns))]
	}
	// Try base username
	candidate := cleaned
	for i := 0; i < 100; i++ {
		var exists bool
		db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM users WHERE username=$1)`, candidate).Scan(&exists)
		if !exists {
			return candidate
		}
		if i < 10 {
			candidate = fmt.Sprintf("%s%d", cleaned, rand.Intn(9999))
		} else {
			candidate = fmt.Sprintf("%s%s%d", adjectives[rand.Intn(len(adjectives))], nouns[rand.Intn(len(nouns))], rand.Intn(999))
		}
	}
	return cleaned + uuid.New().String()[:6]
}

// ═══════════════════════ SERVICE ═══════════════════════

type Svc struct {
	db   *DB
	auth *Auth
	hub  *Hub
}

const sqlUserCols = `id,username,name,email,avatar,cover_image,bio,headline,role,skills,location,website,linkedin,twitter,looking_for,is_investor,is_verified,is_public,followers_count,following_count,created_at`

const sqlPostCols = `p.id,p.user_id,p.type,p.title,p.content,p.tags,p.media_url,p.likes_count,p.comments_count,p.shares_count,p.is_pinned,p.created_at,p.updated_at,u.id,u.username,u.name,u.avatar,u.headline,u.role,u.is_verified`
const sqlPostJoin = `FROM posts p JOIN users u ON u.id=p.user_id`

const sqlProjectCols = `id,owner_id,name,tagline,description,stage,industry,seeking,equity_offer,funding_needed,website,deck_url,logo,cover,views,interested_count,is_published,price,is_paid,pricing_description,progress_percent,progress_notes,progress_stage,created_at,updated_at`

func scanUser(row pgx.Row) (*User, error) {
	u := &User{}
	var skills []string
	err := row.Scan(&u.ID, &u.Username, &u.Name, &u.Email, &u.Avatar, &u.CoverImage, &u.Bio, &u.Headline, &u.Role, &skills, &u.Location, &u.Website, &u.LinkedIn, &u.Twitter, &u.LookingFor, &u.IsInvestor, &u.IsVerified, &u.IsPublic, &u.FollowersCount, &u.FollowingCount, &u.CreatedAt)
	if err != nil {
		return nil, err
	}
	if skills == nil {
		skills = []string{}
	}
	u.Skills = skills
	return u, nil
}

func scanPost(row pgx.Row, callerID string, d *DB, ctx context.Context) (*Post, error) {
	p := &Post{}
	au := &User{}
	var tags []string
	err := row.Scan(&p.ID, &p.UserID, &p.Type, &p.Title, &p.Content, &tags, &p.MediaURL, &p.LikesCount, &p.CommentsCount, &p.SharesCount, &p.IsPinned, &p.CreatedAt, &p.UpdatedAt, &au.ID, &au.Username, &au.Name, &au.Avatar, &au.Headline, &au.Role, &au.IsVerified)
	if err != nil {
		return nil, err
	}
	if tags == nil {
		tags = []string{}
	}
	p.Tags = tags
	p.Author = au
	if callerID != "" {
		d.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM post_likes WHERE user_id=$1 AND post_id=$2)`, callerID, p.ID).Scan(&p.IsLiked)
		d.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM post_bookmarks WHERE user_id=$1 AND post_id=$2)`, callerID, p.ID).Scan(&p.IsBookmarked)
		d.qrow(ctx, `SELECT COUNT(*) FROM idea_votes WHERE post_id=$1 AND vote_type='up'`, p.ID).Scan(&p.UpVotes)
		d.qrow(ctx, `SELECT COUNT(*) FROM idea_votes WHERE post_id=$1 AND vote_type='down'`, p.ID).Scan(&p.DownVotes)
		var vt string
		d.qrow(ctx, `SELECT vote_type FROM idea_votes WHERE user_id=$1 AND post_id=$2`, callerID, p.ID).Scan(&vt)
		p.MyVote = vt
	}
	return p, nil
}

func collectUsers(rows pgx.Rows, callerID string, d *DB, ctx context.Context) ([]User, error) {
	var out []User
	for rows.Next() {
		u := &User{}
		var skills []string
		if err := rows.Scan(&u.ID, &u.Username, &u.Name, &u.Email, &u.Avatar, &u.CoverImage, &u.Bio, &u.Headline, &u.Role, &skills, &u.Location, &u.Website, &u.LinkedIn, &u.Twitter, &u.LookingFor, &u.IsInvestor, &u.IsVerified, &u.IsPublic, &u.FollowersCount, &u.FollowingCount, &u.CreatedAt); err != nil {
			continue
		}
		if skills == nil {
			skills = []string{}
		}
		u.Skills = skills
		if callerID != "" {
			d.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM follows WHERE follower_id=$1 AND following_id=$2)`, callerID, u.ID).Scan(&u.IsFollowing)
			d.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM follow_requests WHERE requester_id=$1 AND target_id=$2 AND status='pending')`, callerID, u.ID).Scan(&u.FollowPending)
		}
		out = append(out, *u)
	}
	if out == nil {
		out = []User{}
	}
	return out, nil
}

func collectPosts(rows pgx.Rows, callerID string, d *DB, ctx context.Context) ([]Post, error) {
	var out []Post
	for rows.Next() {
		p := &Post{}
		au := &User{}
		var tags []string
		if err := rows.Scan(&p.ID, &p.UserID, &p.Type, &p.Title, &p.Content, &tags, &p.MediaURL, &p.LikesCount, &p.CommentsCount, &p.SharesCount, &p.IsPinned, &p.CreatedAt, &p.UpdatedAt, &au.ID, &au.Username, &au.Name, &au.Avatar, &au.Headline, &au.Role, &au.IsVerified); err != nil {
			continue
		}
		if tags == nil {
			tags = []string{}
		}
		p.Tags = tags
		p.Author = au
		if callerID != "" {
			d.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM post_likes WHERE user_id=$1 AND post_id=$2)`, callerID, p.ID).Scan(&p.IsLiked)
			d.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM post_bookmarks WHERE user_id=$1 AND post_id=$2)`, callerID, p.ID).Scan(&p.IsBookmarked)
			d.qrow(ctx, `SELECT COUNT(*) FROM idea_votes WHERE post_id=$1 AND vote_type='up'`, p.ID).Scan(&p.UpVotes)
			d.qrow(ctx, `SELECT COUNT(*) FROM idea_votes WHERE post_id=$1 AND vote_type='down'`, p.ID).Scan(&p.DownVotes)
			var vt string
			d.qrow(ctx, `SELECT vote_type FROM idea_votes WHERE user_id=$1 AND post_id=$2`, callerID, p.ID).Scan(&vt)
			p.MyVote = vt
		}
		out = append(out, *p)
	}
	if out == nil {
		out = []Post{}
	}
	return out, nil
}

func scanProjectRow(row pgx.Row) (*Project, error) {
	p := &Project{}
	var seeking []string
	err := row.Scan(&p.ID, &p.OwnerID, &p.Name, &p.Tagline, &p.Description, &p.Stage, &p.Industry, &seeking, &p.EquityOffer, &p.FundingNeeded, &p.Website, &p.DeckURL, &p.Logo, &p.Cover, &p.Views, &p.InterestedCount, &p.IsPublished, &p.Price, &p.IsPaid, &p.PricingDescription, &p.ProgressPercent, &p.ProgressNotes, &p.ProgressStage, &p.CreatedAt, &p.UpdatedAt)
	if err != nil {
		return nil, err
	}
	if seeking == nil {
		seeking = []string{}
	}
	p.Seeking = seeking
	return p, nil
}

func (s *Svc) notify(ctx context.Context, userID string, actorID *string, typ, msg string, refID *string, refType string) {
	id := uuid.New().String()
	s.db.exec(ctx, `INSERT INTO notifications(id,user_id,actor_id,type,message,ref_id,ref_type) VALUES($1,$2,$3,$4,$5,$6,$7)`, id, userID, actorID, typ, msg, refID, refType)
	n := Notification{ID: id, UserID: userID, ActorID: actorID, Type: typ, Message: msg, RefID: refID, RefType: refType}
	if actorID != nil {
		n.Actor = s.GetUser(ctx, *actorID, "")
	}
	s.hub.push(userID, WSEvent{Type: "notification", Payload: n})
}

func (s *Svc) convMemberIDs(ctx context.Context, convID string) []string {
	rows, _ := s.db.query(ctx, `SELECT user_id FROM conversation_members WHERE conversation_id=$1`, convID)
	if rows == nil {
		return nil
	}
	defer rows.Close()
	var ids []string
	for rows.Next() {
		var id string
		rows.Scan(&id)
		ids = append(ids, id)
	}
	return ids
}

func (s *Svc) verifyProjectOwner(ctx context.Context, projectID, ownerID string) error {
	var pid string
	if err := s.db.qrow(ctx, `SELECT owner_id FROM projects WHERE id=$1`, projectID).Scan(&pid); err != nil {
		return fmt.Errorf("not found")
	}
	if pid != ownerID {
		return fmt.Errorf("unauthorized")
	}
	return nil
}

func (s *Svc) canManageProjectTasks(ctx context.Context, projectID, userID string) bool {
	var ownerID string
	s.db.qrow(ctx, `SELECT owner_id FROM projects WHERE id=$1`, projectID).Scan(&ownerID)
	if ownerID == userID {
		return true
	}
	var isAdmin bool
	s.db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM team_members WHERE project_id=$1 AND user_id=$2 AND is_admin=TRUE AND status='accepted')`, projectID, userID).Scan(&isAdmin)
	return isAdmin
}

func (s *Svc) isProjectMember(ctx context.Context, projectID, userID string) bool {
	var ownerID string
	s.db.qrow(ctx, `SELECT owner_id FROM projects WHERE id=$1`, projectID).Scan(&ownerID)
	if ownerID == userID {
		return true
	}
	var exists bool
	s.db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM team_members WHERE project_id=$1 AND user_id=$2 AND status='accepted')`, projectID, userID).Scan(&exists)
	return exists
}

// Background job: auto-reject expired invites
func (s *Svc) startBackgroundJobs(ctx context.Context) {
	go func() {
		ticker := time.NewTicker(1 * time.Hour)
		defer ticker.Stop()
		for {
			select {
			case <-ticker.C:
				s.db.exec(context.Background(), `UPDATE team_members SET status='rejected' WHERE status='pending' AND invite_expires_at IS NOT NULL AND invite_expires_at < NOW()`)
				s.db.exec(context.Background(), `UPDATE project_join_requests SET status='rejected' WHERE status='pending' AND created_at < NOW() - INTERVAL '7 days'`)
			case <-ctx.Done():
				return
			}
		}
	}()
}

// ── User Service ──

func (s *Svc) GetUser(ctx context.Context, userID, callerID string) *User {
	u, err := scanUser(s.db.qrow(ctx, `SELECT `+sqlUserCols+` FROM users WHERE id=$1`, userID))
	if err != nil {
		return nil
	}
	if callerID != "" && callerID != userID {
		s.db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM follows WHERE follower_id=$1 AND following_id=$2)`, callerID, userID).Scan(&u.IsFollowing)
		s.db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM follow_requests WHERE requester_id=$1 AND target_id=$2 AND status='pending')`, callerID, userID).Scan(&u.FollowPending)
	}
	return u
}

func (s *Svc) GetUserByUsername(ctx context.Context, username, callerID string) *User {
	u, err := scanUser(s.db.qrow(ctx, `SELECT `+sqlUserCols+` FROM users WHERE username=$1`, username))
	if err != nil {
		return nil
	}
	if callerID != "" && callerID != u.ID {
		s.db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM follows WHERE follower_id=$1 AND following_id=$2)`, callerID, u.ID).Scan(&u.IsFollowing)
		s.db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM follow_requests WHERE requester_id=$1 AND target_id=$2 AND status='pending')`, callerID, u.ID).Scan(&u.FollowPending)
	}
	return u
}

func (s *Svc) Register(ctx context.Context, name, email, password, role string) (string, *User, error) {
	var exists bool
	s.db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM users WHERE email=$1)`, email).Scan(&exists)
	if exists {
		return "", nil, fmt.Errorf("email already registered")
	}
	hash, err := bcrypt.GenerateFromPassword([]byte(password), 12)
	if err != nil {
		return "", nil, err
	}
	if role == "" {
		role = "founder"
	}
	id := uuid.New().String()
	username := generateUsername(s.db, ctx, name)
	if err := s.db.exec(ctx, `INSERT INTO users(id,username,name,email,password_hash,role) VALUES($1,$2,$3,$4,$5,$6)`, id, username, name, email, string(hash), role); err != nil {
		return "", nil, err
	}
	tok, _ := s.auth.issue(id)
	return tok, s.GetUser(ctx, id, ""), nil
}

func (s *Svc) Login(ctx context.Context, email, password string) (string, *User, error) {
	var id, hash string
	if err := s.db.qrow(ctx, `SELECT id,password_hash FROM users WHERE email=$1`, email).Scan(&id, &hash); err != nil {
		return "", nil, fmt.Errorf("invalid credentials")
	}
	if bcrypt.CompareHashAndPassword([]byte(hash), []byte(password)) != nil {
		return "", nil, fmt.Errorf("invalid credentials")
	}
	tok, _ := s.auth.issue(id)
	return tok, s.GetUser(ctx, id, ""), nil
}

func (s *Svc) UpdateProfile(ctx context.Context, userID string, b map[string]any) error {
	// Handle username change
	if newUsername, ok := b["username"].(string); ok && newUsername != "" {
		newUsername = strings.ToLower(strings.ReplaceAll(newUsername, " ", ""))
		var curUsername string
		s.db.qrow(ctx, `SELECT username FROM users WHERE id=$1`, userID).Scan(&curUsername)
		if newUsername != curUsername {
			var taken bool
			s.db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM users WHERE username=$1 AND id!=$2)`, newUsername, userID).Scan(&taken)
			if taken {
				return fmt.Errorf("username already taken")
			}
		}
	}
	return s.db.exec(ctx, `UPDATE users SET name=COALESCE($2,name),username=COALESCE(NULLIF($3,''),username),bio=COALESCE($4,bio),headline=COALESCE($5,headline),role=COALESCE($6,role),skills=COALESCE($7,skills),location=COALESCE($8,location),website=COALESCE($9,website),linkedin=COALESCE($10,linkedin),twitter=COALESCE($11,twitter),looking_for=COALESCE($12,looking_for),avatar=COALESCE($13,avatar),cover_image=COALESCE($14,cover_image),is_investor=COALESCE($15,is_investor),is_public=COALESCE($16,is_public),updated_at=NOW() WHERE id=$1`,
		userID, b["name"], b["username"], b["bio"], b["headline"], b["role"], b["skills"], b["location"], b["website"], b["linkedin"], b["twitter"], b["looking_for"], b["avatar"], b["cover_image"], b["is_investor"], b["is_public"])
}

func (s *Svc) SearchUsers(ctx context.Context, q, role, callerID string) ([]User, error) {
	var conds []string
	var args []any
	i := 1
	if q != "" {
		conds = append(conds, fmt.Sprintf(`(name ILIKE $%d OR bio ILIKE $%d OR headline ILIKE $%d OR username ILIKE $%d)`, i, i, i, i))
		args = append(args, "%"+q+"%")
		i++
	}
	if role != "" {
		conds = append(conds, fmt.Sprintf(`role=$%d`, i))
		args = append(args, role)
		i++
	}
	where := ""
	if len(conds) > 0 {
		where = "WHERE " + strings.Join(conds, " AND ")
	}
	rows, err := s.db.query(ctx, `SELECT `+sqlUserCols+` FROM users `+where+` ORDER BY followers_count DESC LIMIT 50`, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	return collectUsers(rows, callerID, s.db, ctx)
}

func (s *Svc) ToggleFollow(ctx context.Context, followerID, followingID string) (bool, bool, error) {
	if followerID == followingID {
		return false, false, fmt.Errorf("cannot follow yourself")
	}
	// Check target's privacy
	var isPublic bool
	s.db.qrow(ctx, `SELECT is_public FROM users WHERE id=$1`, followingID).Scan(&isPublic)

	var already bool
	s.db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM follows WHERE follower_id=$1 AND following_id=$2)`, followerID, followingID).Scan(&already)
	if already {
		ct, err := s.db.pool.Exec(ctx, `DELETE FROM follows WHERE follower_id=$1 AND following_id=$2`, followerID, followingID)
		if err != nil {
			return false, false, err
		}
		if ct.RowsAffected() > 0 {
			s.db.exec(ctx, `UPDATE users SET followers_count=GREATEST(followers_count-1,0) WHERE id=$1`, followingID)
			s.db.exec(ctx, `UPDATE users SET following_count=GREATEST(following_count-1,0) WHERE id=$1`, followerID)
		}
		return false, false, nil
	}

	if !isPublic {
		// Send follow request
		var reqExists bool
		s.db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM follow_requests WHERE requester_id=$1 AND target_id=$2)`, followerID, followingID).Scan(&reqExists)
		if reqExists {
			// Cancel request
			s.db.exec(ctx, `DELETE FROM follow_requests WHERE requester_id=$1 AND target_id=$2`, followerID, followingID)
			return false, false, nil
		}
		reqID := uuid.New().String()
		s.db.exec(ctx, `INSERT INTO follow_requests(id,requester_id,target_id) VALUES($1,$2,$3)`, reqID, followerID, followingID)
		msg := "wants to follow you"
		if actor := s.GetUser(ctx, followerID, ""); actor != nil {
			msg = actor.Name + " wants to follow you"
		}
		s.notify(ctx, followingID, &followerID, "follow_request", msg, &followerID, "user")
		return false, true, nil // pending
	}

	ct, err := s.db.pool.Exec(ctx, `INSERT INTO follows(follower_id,following_id) VALUES($1,$2) ON CONFLICT DO NOTHING`, followerID, followingID)
	if err != nil {
		return false, false, err
	}
	if ct.RowsAffected() > 0 {
		s.db.exec(ctx, `UPDATE users SET followers_count=followers_count+1 WHERE id=$1`, followingID)
		s.db.exec(ctx, `UPDATE users SET following_count=following_count+1 WHERE id=$1`, followerID)
		msg := "started following you"
		if actor := s.GetUser(ctx, followerID, ""); actor != nil {
			msg = actor.Name + " started following you"
		}
		s.notify(ctx, followingID, &followerID, "follow", msg, &followerID, "user")
	}
	return true, false, nil
}

func (s *Svc) HandleFollowRequest(ctx context.Context, targetID, requesterID, action string) error {
	var reqID string
	if err := s.db.qrow(ctx, `SELECT id FROM follow_requests WHERE requester_id=$1 AND target_id=$2 AND status='pending'`, requesterID, targetID).Scan(&reqID); err != nil {
		return fmt.Errorf("request not found")
	}
	if action == "accept" {
		s.db.exec(ctx, `UPDATE follow_requests SET status='accepted' WHERE id=$1`, reqID)
		s.db.exec(ctx, `INSERT INTO follows(follower_id,following_id) VALUES($1,$2) ON CONFLICT DO NOTHING`, requesterID, targetID)
		s.db.exec(ctx, `UPDATE users SET followers_count=followers_count+1 WHERE id=$1`, targetID)
		s.db.exec(ctx, `UPDATE users SET following_count=following_count+1 WHERE id=$1`, requesterID)
		msg := "accepted your follow request"
		if actor := s.GetUser(ctx, targetID, ""); actor != nil {
			msg = actor.Name + " accepted your follow request"
		}
		s.notify(ctx, requesterID, &targetID, "follow_accepted", msg, &targetID, "user")
	} else {
		s.db.exec(ctx, `UPDATE follow_requests SET status='declined' WHERE id=$1`, reqID)
	}
	return nil
}

func (s *Svc) PendingFollowRequests(ctx context.Context, userID string) ([]FollowRequest, error) {
	rows, err := s.db.query(ctx, `SELECT id,requester_id,target_id,status,created_at FROM follow_requests WHERE target_id=$1 AND status='pending' ORDER BY created_at DESC`, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []FollowRequest
	for rows.Next() {
		fr := FollowRequest{}
		rows.Scan(&fr.ID, &fr.RequesterID, &fr.TargetID, &fr.Status, &fr.CreatedAt)
		fr.Requester = s.GetUser(ctx, fr.RequesterID, "")
		out = append(out, fr)
	}
	if out == nil {
		out = []FollowRequest{}
	}
	return out, nil
}

func (s *Svc) Followers(ctx context.Context, userID, callerID string) ([]User, error) {
	rows, err := s.db.query(ctx, `SELECT `+sqlUserCols+` FROM users JOIN follows f ON f.follower_id=users.id WHERE f.following_id=$1 ORDER BY f.created_at DESC LIMIT 200`, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	return collectUsers(rows, callerID, s.db, ctx)
}

func (s *Svc) Following(ctx context.Context, userID, callerID string) ([]User, error) {
	rows, err := s.db.query(ctx, `SELECT `+sqlUserCols+` FROM users JOIN follows f ON f.following_id=users.id WHERE f.follower_id=$1 ORDER BY f.created_at DESC LIMIT 200`, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	return collectUsers(rows, callerID, s.db, ctx)
}

// ── Post Service ──

func (s *Svc) CreatePost(ctx context.Context, p *Post) (*Post, error) {
	p.ID = uuid.New().String()
	if p.Tags == nil {
		p.Tags = []string{}
	}
	if err := s.db.exec(ctx, `INSERT INTO posts(id,user_id,type,title,content,tags,media_url) VALUES($1,$2,$3,$4,$5,$6,$7)`, p.ID, p.UserID, p.Type, p.Title, p.Content, p.Tags, p.MediaURL); err != nil {
		return nil, err
	}
	post, err := s.GetPost(ctx, p.ID, p.UserID)
	if err != nil {
		return nil, err
	}
	go func() {
		rows, err2 := s.db.query(context.Background(), `SELECT follower_id FROM follows WHERE following_id=$1`, p.UserID)
		if err2 != nil {
			return
		}
		defer rows.Close()
		for rows.Next() {
			var fid string
			rows.Scan(&fid)
			s.hub.push(fid, WSEvent{Type: "new_post", Payload: post})
		}
	}()
	return post, nil
}

func (s *Svc) GetPost(ctx context.Context, postID, callerID string) (*Post, error) {
	return scanPost(s.db.qrow(ctx, `SELECT `+sqlPostCols+` `+sqlPostJoin+` WHERE p.id=$1`, postID), callerID, s.db, ctx)
}
func (s *Svc) DeletePost(ctx context.Context, userID, postID string) error {
	ct, err := s.db.pool.Exec(ctx, `DELETE FROM posts WHERE id=$1 AND user_id=$2`, postID, userID)
	if err != nil {
		return err
	}
	if ct.RowsAffected() == 0 {
		return fmt.Errorf("not found or not owner")
	}
	return nil
}
func (s *Svc) Feed(ctx context.Context, callerID string, page, limit int) ([]Post, error) {
	rows, err := s.db.query(ctx, `SELECT `+sqlPostCols+` `+sqlPostJoin+` WHERE p.user_id IN (SELECT following_id FROM follows WHERE follower_id=$1) OR p.user_id=$1 ORDER BY p.is_pinned DESC,p.created_at DESC LIMIT $2 OFFSET $3`, callerID, limit, (page-1)*limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	return collectPosts(rows, callerID, s.db, ctx)
}
func (s *Svc) Explore(ctx context.Context, callerID, postType string, tags []string, page, limit int) ([]Post, error) {
	var conds []string
	var args []any
	i := 1
	if postType != "" {
		conds = append(conds, fmt.Sprintf(`p.type=$%d`, i))
		args = append(args, postType)
		i++
	}
	if len(tags) > 0 {
		conds = append(conds, fmt.Sprintf(`p.tags && $%d`, i))
		args = append(args, tags)
		i++
	}
	where := ""
	if len(conds) > 0 {
		where = "WHERE " + strings.Join(conds, " AND ")
	}
	args = append(args, limit, (page-1)*limit)
	rows, err := s.db.query(ctx, `SELECT `+sqlPostCols+` `+sqlPostJoin+` `+where+fmt.Sprintf(` ORDER BY p.likes_count DESC,p.created_at DESC LIMIT $%d OFFSET $%d`, i, i+1), args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	return collectPosts(rows, callerID, s.db, ctx)
}
func (s *Svc) UserPosts(ctx context.Context, userID, callerID string, page, limit int) ([]Post, error) {
	rows, err := s.db.query(ctx, `SELECT `+sqlPostCols+` `+sqlPostJoin+` WHERE p.user_id=$1 ORDER BY p.is_pinned DESC,p.created_at DESC LIMIT $2 OFFSET $3`, userID, limit, (page-1)*limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	return collectPosts(rows, callerID, s.db, ctx)
}
func (s *Svc) LikePost(ctx context.Context, userID, postID string) (int, bool) {
	var liked bool
	s.db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM post_likes WHERE user_id=$1 AND post_id=$2)`, userID, postID).Scan(&liked)
	if liked {
		s.db.exec(ctx, `DELETE FROM post_likes WHERE user_id=$1 AND post_id=$2`, userID, postID)
		s.db.exec(ctx, `UPDATE posts SET likes_count=GREATEST(likes_count-1,0) WHERE id=$1`, postID)
	} else {
		s.db.exec(ctx, `INSERT INTO post_likes(user_id,post_id) VALUES($1,$2) ON CONFLICT DO NOTHING`, userID, postID)
		s.db.exec(ctx, `UPDATE posts SET likes_count=likes_count+1 WHERE id=$1`, postID)
		var ownerID string
		if s.db.qrow(ctx, `SELECT user_id FROM posts WHERE id=$1`, postID).Scan(&ownerID) == nil && ownerID != userID {
			msg := "liked your post"
			if actor := s.GetUser(ctx, userID, ""); actor != nil {
				msg = actor.Name + " liked your post"
			}
			s.notify(ctx, ownerID, &userID, "like", msg, &postID, "post")
		}
	}
	var count int
	s.db.qrow(ctx, `SELECT likes_count FROM posts WHERE id=$1`, postID).Scan(&count)
	return count, !liked
}
func (s *Svc) BookmarkPost(ctx context.Context, userID, postID string) bool {
	var exists bool
	s.db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM post_bookmarks WHERE user_id=$1 AND post_id=$2)`, userID, postID).Scan(&exists)
	if exists {
		s.db.exec(ctx, `DELETE FROM post_bookmarks WHERE user_id=$1 AND post_id=$2`, userID, postID)
		return false
	}
	s.db.exec(ctx, `INSERT INTO post_bookmarks(user_id,post_id) VALUES($1,$2) ON CONFLICT DO NOTHING`, userID, postID)
	return true
}
func (s *Svc) VoteIdea(ctx context.Context, userID, postID, voteType string) (int, int, string, error) {
	var existing string
	s.db.qrow(ctx, `SELECT vote_type FROM idea_votes WHERE user_id=$1 AND post_id=$2`, userID, postID).Scan(&existing)
	if existing == voteType {
		s.db.exec(ctx, `DELETE FROM idea_votes WHERE user_id=$1 AND post_id=$2`, userID, postID)
		voteType = ""
	} else if existing != "" {
		s.db.exec(ctx, `UPDATE idea_votes SET vote_type=$3 WHERE user_id=$1 AND post_id=$2`, userID, postID, voteType)
	} else {
		s.db.exec(ctx, `INSERT INTO idea_votes(user_id,post_id,vote_type) VALUES($1,$2,$3) ON CONFLICT(user_id,post_id) DO UPDATE SET vote_type=$3`, userID, postID, voteType)
	}
	var up, down int
	s.db.qrow(ctx, `SELECT COUNT(*) FROM idea_votes WHERE post_id=$1 AND vote_type='up'`, postID).Scan(&up)
	s.db.qrow(ctx, `SELECT COUNT(*) FROM idea_votes WHERE post_id=$1 AND vote_type='down'`, postID).Scan(&down)
	return up, down, voteType, nil
}

// ── Comment Service ──

const sqlCommentCols = `c.id,c.post_id,c.user_id,c.parent_id,c.content,c.likes_count,c.created_at,u.id,u.username,u.name,u.avatar,u.role`
const sqlCommentJoin = `FROM comments c JOIN users u ON u.id=c.user_id`

func (s *Svc) CreateComment(ctx context.Context, c *Comment) (*Comment, error) {
	c.ID = uuid.New().String()
	if err := s.db.exec(ctx, `INSERT INTO comments(id,post_id,user_id,parent_id,content) VALUES($1,$2,$3,$4,$5)`, c.ID, c.PostID, c.UserID, c.ParentID, c.Content); err != nil {
		return nil, err
	}
	s.db.exec(ctx, `UPDATE posts SET comments_count=comments_count+1 WHERE id=$1`, c.PostID)
	var ownerID string
	if s.db.qrow(ctx, `SELECT user_id FROM posts WHERE id=$1`, c.PostID).Scan(&ownerID) == nil && ownerID != c.UserID {
		msg := "commented on your post"
		if actor := s.GetUser(ctx, c.UserID, ""); actor != nil {
			msg = actor.Name + " commented on your post"
		}
		s.notify(ctx, ownerID, &c.UserID, "comment", msg, &c.PostID, "post")
	}
	out := &Comment{}
	au := &User{}
	s.db.qrow(ctx, `SELECT `+sqlCommentCols+` `+sqlCommentJoin+` WHERE c.id=$1`, c.ID).Scan(&out.ID, &out.PostID, &out.UserID, &out.ParentID, &out.Content, &out.LikesCount, &out.CreatedAt, &au.ID, &au.Username, &au.Name, &au.Avatar, &au.Role)
	out.Author = au
	return out, nil
}

func (s *Svc) PostComments(ctx context.Context, postID, callerID string) ([]Comment, error) {
	rows, err := s.db.query(ctx, `SELECT `+sqlCommentCols+` `+sqlCommentJoin+` WHERE c.post_id=$1 AND c.parent_id IS NULL ORDER BY c.created_at ASC`, postID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []Comment
	for rows.Next() {
		c := Comment{}
		au := &User{}
		rows.Scan(&c.ID, &c.PostID, &c.UserID, &c.ParentID, &c.Content, &c.LikesCount, &c.CreatedAt, &au.ID, &au.Username, &au.Name, &au.Avatar, &au.Role)
		c.Author = au
		rrows, _ := s.db.query(ctx, `SELECT `+sqlCommentCols+` `+sqlCommentJoin+` WHERE c.parent_id=$1 ORDER BY c.created_at`, c.ID)
		if rrows != nil {
			for rrows.Next() {
				r := &Comment{}
				rau := &User{}
				rrows.Scan(&r.ID, &r.PostID, &r.UserID, &r.ParentID, &r.Content, &r.LikesCount, &r.CreatedAt, &rau.ID, &rau.Username, &rau.Name, &rau.Avatar, &rau.Role)
				r.Author = rau
				c.Replies = append(c.Replies, r)
			}
			rrows.Close()
		}
		out = append(out, c)
	}
	if out == nil {
		out = []Comment{}
	}
	return out, nil
}

// ── Project Service ──

func (s *Svc) CreateProject(ctx context.Context, p *Project) (*Project, error) {
	p.ID = uuid.New().String()
	if p.Seeking == nil {
		p.Seeking = []string{}
	}
	if err := s.db.exec(ctx, `INSERT INTO projects(id,owner_id,name,tagline,description,stage,industry,seeking,equity_offer,funding_needed,website,deck_url,logo,cover,price,is_paid,pricing_description) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17)`,
		p.ID, p.OwnerID, p.Name, p.Tagline, p.Description, p.Stage, p.Industry, p.Seeking, p.EquityOffer, p.FundingNeeded, p.Website, p.DeckURL, p.Logo, p.Cover, p.Price, p.IsPaid, p.PricingDescription); err != nil {
		return nil, err
	}
	return s.GetProject(ctx, p.ID, p.OwnerID)
}

func (s *Svc) GetProject(ctx context.Context, id, callerID string) (*Project, error) {
	p, err := scanProjectRow(s.db.qrow(ctx, `SELECT `+sqlProjectCols+` FROM projects WHERE id=$1`, id))
	if err != nil {
		return nil, err
	}
	p.Owner = s.GetUser(ctx, p.OwnerID, callerID)
	p.Sections, _ = s.ProjectSections(ctx, id)
	p.TeamMembers, _ = s.TeamMembers(ctx, id)
	p.Updates, _ = s.ProjectUpdatesList(ctx, id)
	return p, nil
}

func (s *Svc) UpdateProject(ctx context.Context, ownerID, id string, b map[string]any) error {
	return s.db.exec(ctx, `UPDATE projects SET name=COALESCE($3,name),tagline=COALESCE($4,tagline),description=COALESCE($5,description),stage=COALESCE($6,stage),industry=COALESCE($7,industry),seeking=COALESCE($8,seeking),equity_offer=COALESCE($9,equity_offer),funding_needed=COALESCE($10,funding_needed),website=COALESCE($11,website),deck_url=COALESCE($12,deck_url),logo=COALESCE($13,logo),cover=COALESCE($14,cover),is_published=COALESCE($15,is_published),price=COALESCE($16,price),is_paid=COALESCE($17,is_paid),pricing_description=COALESCE($18,pricing_description),progress_percent=COALESCE($19,progress_percent),progress_notes=COALESCE($20,progress_notes),progress_stage=COALESCE($21,progress_stage),updated_at=NOW() WHERE id=$1 AND owner_id=$2`,
		id, ownerID, b["name"], b["tagline"], b["description"], b["stage"], b["industry"], b["seeking"], b["equity_offer"], b["funding_needed"], b["website"], b["deck_url"], b["logo"], b["cover"], b["is_published"], b["price"], b["is_paid"], b["pricing_description"], b["progress_percent"], b["progress_notes"], b["progress_stage"])
}

func (s *Svc) ListProjects(ctx context.Context, callerID, stage, industry string, page, limit int) ([]Project, error) {
	conds := []string{"is_published=TRUE"}
	var args []any
	i := 1
	if stage != "" {
		conds = append(conds, fmt.Sprintf(`stage=$%d`, i))
		args = append(args, stage)
		i++
	}
	if industry != "" {
		conds = append(conds, fmt.Sprintf(`industry ILIKE $%d`, i))
		args = append(args, "%"+industry+"%")
		i++
	}
	args = append(args, limit, (page-1)*limit)
	rows, err := s.db.query(ctx, `SELECT `+sqlProjectCols+` FROM projects WHERE `+strings.Join(conds, " AND ")+fmt.Sprintf(` ORDER BY interested_count DESC,created_at DESC LIMIT $%d OFFSET $%d`, i, i+1), args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []Project
	for rows.Next() {
		p, err := scanProjectRow(rows)
		if err != nil {
			continue
		}
		p.Owner = s.GetUser(ctx, p.OwnerID, callerID)
		out = append(out, *p)
	}
	if out == nil {
		out = []Project{}
	}
	return out, nil
}

func (s *Svc) IncrViews(ctx context.Context, id, userID string) {
	ct, _ := s.db.pool.Exec(ctx, `INSERT INTO project_views(project_id,user_id) VALUES($1,$2) ON CONFLICT DO NOTHING`, id, userID)
	if ct.RowsAffected() > 0 {
		s.db.exec(ctx, `UPDATE projects SET views=views+1 WHERE id=$1`, id)
	}
}

func (s *Svc) ProjectSections(ctx context.Context, projectID string) ([]ProjectSection, error) {
	rows, err := s.db.query(ctx, `SELECT id,project_id,title,content,section_type,order_index,created_at FROM project_sections WHERE project_id=$1 ORDER BY order_index`, projectID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []ProjectSection
	for rows.Next() {
		sec := ProjectSection{}
		rows.Scan(&sec.ID, &sec.ProjectID, &sec.Title, &sec.Content, &sec.SectionType, &sec.OrderIndex, &sec.CreatedAt)
		out = append(out, sec)
	}
	if out == nil {
		out = []ProjectSection{}
	}
	return out, nil
}

func (s *Svc) UpsertSection(ctx context.Context, ownerID string, sec *ProjectSection) (*ProjectSection, error) {
	if err := s.verifyProjectOwner(ctx, sec.ProjectID, ownerID); err != nil {
		return nil, err
	}
	if sec.SectionType == "" {
		sec.SectionType = "info"
	}
	if sec.ID == "" {
		sec.ID = uuid.New().String()
		s.db.exec(ctx, `INSERT INTO project_sections(id,project_id,title,content,section_type,order_index) VALUES($1,$2,$3,$4,$5,$6)`, sec.ID, sec.ProjectID, sec.Title, sec.Content, sec.SectionType, sec.OrderIndex)
	} else {
		s.db.exec(ctx, `UPDATE project_sections SET title=$2,content=$3,section_type=$4,order_index=$5,updated_at=NOW() WHERE id=$1`, sec.ID, sec.Title, sec.Content, sec.SectionType, sec.OrderIndex)
	}
	out := &ProjectSection{}
	s.db.qrow(ctx, `SELECT id,project_id,title,content,section_type,order_index,created_at FROM project_sections WHERE id=$1`, sec.ID).Scan(&out.ID, &out.ProjectID, &out.Title, &out.Content, &out.SectionType, &out.OrderIndex, &out.CreatedAt)
	return out, nil
}

func (s *Svc) DeleteSection(ctx context.Context, ownerID, sectionID string) error {
	var pid string
	if err := s.db.qrow(ctx, `SELECT p.owner_id FROM projects p JOIN project_sections sec ON sec.project_id=p.id WHERE sec.id=$1`, sectionID).Scan(&pid); err != nil {
		return fmt.Errorf("not found")
	}
	if pid != ownerID {
		return fmt.Errorf("unauthorized")
	}
	return s.db.exec(ctx, `DELETE FROM project_sections WHERE id=$1`, sectionID)
}

// Project Updates / Coming Soon
func (s *Svc) ProjectUpdatesList(ctx context.Context, projectID string) ([]ProjectUpdate, error) {
	rows, err := s.db.query(ctx, `SELECT id,project_id,title,content,is_coming_soon,release_date::text,created_at FROM project_updates WHERE project_id=$1 ORDER BY created_at DESC`, projectID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []ProjectUpdate
	for rows.Next() {
		u := ProjectUpdate{}
		rows.Scan(&u.ID, &u.ProjectID, &u.Title, &u.Content, &u.IsComingSoon, &u.ReleaseDate, &u.CreatedAt)
		out = append(out, u)
	}
	if out == nil {
		out = []ProjectUpdate{}
	}
	return out, nil
}

func (s *Svc) CreateProjectUpdate(ctx context.Context, ownerID string, u *ProjectUpdate) (*ProjectUpdate, error) {
	if err := s.verifyProjectOwner(ctx, u.ProjectID, ownerID); err != nil {
		return nil, err
	}
	u.ID = uuid.New().String()
	if err := s.db.exec(ctx, `INSERT INTO project_updates(id,project_id,title,content,is_coming_soon,release_date) VALUES($1,$2,$3,$4,$5,$6::date)`,
		u.ID, u.ProjectID, u.Title, u.Content, u.IsComingSoon, u.ReleaseDate); err != nil {
		return nil, err
	}
	u.CreatedAt = time.Now()
	return u, nil
}

func (s *Svc) DeleteProjectUpdate(ctx context.Context, ownerID, updateID string) error {
	var pid string
	if err := s.db.qrow(ctx, `SELECT p.owner_id FROM projects p JOIN project_updates pu ON pu.project_id=p.id WHERE pu.id=$1`, updateID).Scan(&pid); err != nil {
		return fmt.Errorf("not found")
	}
	if pid != ownerID {
		return fmt.Errorf("unauthorized")
	}
	return s.db.exec(ctx, `DELETE FROM project_updates WHERE id=$1`, updateID)
}

func (s *Svc) TeamMembers(ctx context.Context, projectID string) ([]TeamMember, error) {
	rows, err := s.db.query(ctx, `SELECT id,project_id,user_id,name,role,equity,status,is_admin,invite_expires_at,created_at FROM team_members WHERE project_id=$1 ORDER BY created_at`, projectID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []TeamMember
	for rows.Next() {
		m := TeamMember{}
		rows.Scan(&m.ID, &m.ProjectID, &m.UserID, &m.Name, &m.Role, &m.Equity, &m.Status, &m.IsAdmin, &m.InviteExpiresAt, &m.CreatedAt)
		out = append(out, m)
	}
	if out == nil {
		out = []TeamMember{}
	}
	return out, nil
}

func (s *Svc) AddTeamMember(ctx context.Context, ownerID string, m *TeamMember) (*TeamMember, error) {
	if err := s.verifyProjectOwner(ctx, m.ProjectID, ownerID); err != nil {
		return nil, err
	}
	// Must be an existing user if user_id is provided
	if m.UserID != nil && *m.UserID != "" {
		var exists bool
		s.db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM users WHERE id=$1)`, *m.UserID).Scan(&exists)
		if !exists {
			return nil, fmt.Errorf("user not found")
		}
		// Get user name
		var uname string
		s.db.qrow(ctx, `SELECT name FROM users WHERE id=$1`, *m.UserID).Scan(&uname)
		if m.Name == "" {
			m.Name = uname
		}
	}
	m.ID = uuid.New().String()
	m.Status = "pending"
	expires := time.Now().Add(7 * 24 * time.Hour)
	m.InviteExpiresAt = &expires
	if err := s.db.exec(ctx, `INSERT INTO team_members(id,project_id,user_id,name,role,equity,status,is_admin,invite_expires_at) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9)`, m.ID, m.ProjectID, m.UserID, m.Name, m.Role, m.Equity, m.Status, m.IsAdmin, expires); err != nil {
		return nil, err
	}
	if m.UserID != nil {
		var pname string
		s.db.qrow(ctx, `SELECT name FROM projects WHERE id=$1`, m.ProjectID).Scan(&pname)
		s.notify(ctx, *m.UserID, &ownerID, "project_invite", "You got a project invitation to join: "+pname, &m.ProjectID, "project")
		s.hub.push(*m.UserID, WSEvent{Type: "notification", Payload: map[string]any{"type": "project_invite", "message": "You got a project invitation to join: " + pname, "project_id": m.ProjectID}})
	}
	return m, nil
}

func (s *Svc) RespondToInvite(ctx context.Context, memberID, userID, action string) error {
	var tmUserID *string
	var tmProjectID string
	var tmStatus string
	if err := s.db.qrow(ctx, `SELECT user_id,project_id,status FROM team_members WHERE id=$1`, memberID).Scan(&tmUserID, &tmProjectID, &tmStatus); err != nil {
		return fmt.Errorf("not found")
	}
	if tmUserID == nil || *tmUserID != userID {
		return fmt.Errorf("unauthorized")
	}
	if tmStatus != "pending" {
		return fmt.Errorf("already responded")
	}
	if action == "accept" {
		s.db.exec(ctx, `UPDATE team_members SET status='accepted',invite_expires_at=NULL WHERE id=$1`, memberID)
	} else {
		s.db.exec(ctx, `UPDATE team_members SET status='declined' WHERE id=$1`, memberID)
	}
	return nil
}

func (s *Svc) UpdateTeamMemberAdmin(ctx context.Context, ownerID, memberID string, isAdmin bool) error {
	var pid string
	if err := s.db.qrow(ctx, `SELECT p.owner_id FROM projects p JOIN team_members t ON t.project_id=p.id WHERE t.id=$1`, memberID).Scan(&pid); err != nil {
		return fmt.Errorf("not found")
	}
	if pid != ownerID {
		return fmt.Errorf("unauthorized")
	}
	return s.db.exec(ctx, `UPDATE team_members SET is_admin=$2 WHERE id=$1`, memberID, isAdmin)
}

func (s *Svc) RemoveTeamMember(ctx context.Context, ownerID, memberID string) error {
	var pid string
	if err := s.db.qrow(ctx, `SELECT p.owner_id FROM projects p JOIN team_members t ON t.project_id=p.id WHERE t.id=$1`, memberID).Scan(&pid); err != nil {
		return fmt.Errorf("not found")
	}
	if pid != ownerID {
		return fmt.Errorf("unauthorized")
	}
	return s.db.exec(ctx, `DELETE FROM team_members WHERE id=$1`, memberID)
}

// ── Join Requests ──

func (s *Svc) SubmitJoinRequest(ctx context.Context, userID, projectID, message, role string) (*JoinRequest, error) {
	if s.isProjectMember(ctx, projectID, userID) {
		return nil, fmt.Errorf("already a member")
	}
	id := uuid.New().String()
	if err := s.db.exec(ctx, `INSERT INTO project_join_requests(id,project_id,user_id,message,desired_role) VALUES($1,$2,$3,$4,$5) ON CONFLICT(project_id,user_id) DO UPDATE SET message=$4,desired_role=$5,status='pending'`, id, projectID, userID, message, role); err != nil {
		return nil, err
	}
	var ownerID string
	if s.db.qrow(ctx, `SELECT owner_id FROM projects WHERE id=$1`, projectID).Scan(&ownerID) == nil {
		msg := "wants to join your project"
		if actor := s.GetUser(ctx, userID, ""); actor != nil {
			msg = actor.Name + " wants to join your project"
		}
		s.notify(ctx, ownerID, &userID, "team_invite", msg, &projectID, "project")
	}
	return &JoinRequest{ID: id, ProjectID: projectID, UserID: userID, Message: message, DesiredRole: role, Status: "pending", CreatedAt: time.Now()}, nil
}

func (s *Svc) ListJoinRequests(ctx context.Context, ownerID, projectID string) ([]JoinRequest, error) {
	if err := s.verifyProjectOwner(ctx, projectID, ownerID); err != nil {
		return nil, err
	}
	rows, err := s.db.query(ctx, `SELECT id,project_id,user_id,message,desired_role,status,created_at FROM project_join_requests WHERE project_id=$1 ORDER BY created_at DESC`, projectID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []JoinRequest
	for rows.Next() {
		jr := JoinRequest{}
		rows.Scan(&jr.ID, &jr.ProjectID, &jr.UserID, &jr.Message, &jr.DesiredRole, &jr.Status, &jr.CreatedAt)
		jr.User = s.GetUser(ctx, jr.UserID, "")
		out = append(out, jr)
	}
	if out == nil {
		out = []JoinRequest{}
	}
	return out, nil
}

func (s *Svc) UpdateJoinRequest(ctx context.Context, ownerID, reqID, status string) error {
	var pid, userID, role string
	if err := s.db.qrow(ctx, `SELECT p.owner_id,jr.user_id,jr.desired_role FROM projects p JOIN project_join_requests jr ON jr.project_id=p.id WHERE jr.id=$1`, reqID).Scan(&pid, &userID, &role); err != nil {
		return fmt.Errorf("not found")
	}
	if pid != ownerID {
		return fmt.Errorf("unauthorized")
	}
	s.db.exec(ctx, `UPDATE project_join_requests SET status=$2 WHERE id=$1`, reqID, status)
	if status == "accepted" {
		var pjID string
		s.db.qrow(ctx, `SELECT project_id FROM project_join_requests WHERE id=$1`, reqID).Scan(&pjID)
		user := s.GetUser(ctx, userID, "")
		name := "Member"
		if user != nil {
			name = user.Name
		}
		s.db.exec(ctx, `INSERT INTO team_members(id,project_id,user_id,name,role,status) VALUES($1,$2,$3,$4,$5,'accepted') ON CONFLICT DO NOTHING`, uuid.New().String(), pjID, userID, name, role)
		s.notify(ctx, userID, &ownerID, "team_invite", "Your join request was accepted!", &pjID, "project")
	}
	return nil
}

// ── Task Service ──

func (s *Svc) ListTasks(ctx context.Context, projectID, callerID string) ([]Task, error) {
	rows, err := s.db.query(ctx, `SELECT id,project_id,title,description,status,priority,assignee_id,created_by,due_date::text,order_index,tags,created_at,updated_at FROM tasks WHERE project_id=$1 ORDER BY order_index,created_at`, projectID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []Task
	for rows.Next() {
		t := Task{}
		var tags []string
		rows.Scan(&t.ID, &t.ProjectID, &t.Title, &t.Description, &t.Status, &t.Priority, &t.AssigneeID, &t.CreatedBy, &t.DueDate, &t.OrderIndex, &tags, &t.CreatedAt, &t.UpdatedAt)
		if tags == nil {
			tags = []string{}
		}
		t.Tags = tags
		if t.AssigneeID != nil {
			t.Assignee = s.GetUser(ctx, *t.AssigneeID, "")
		}
		t.Creator = s.GetUser(ctx, t.CreatedBy, "")
		out = append(out, t)
	}
	if out == nil {
		out = []Task{}
	}
	return out, nil
}

func (s *Svc) CreateTask(ctx context.Context, task *Task) (*Task, error) {
	task.ID = uuid.New().String()
	if task.Tags == nil {
		task.Tags = []string{}
	}
	if task.Status == "" {
		task.Status = "backlog"
	}
	if task.Priority == "" {
		task.Priority = "medium"
	}
	if err := s.db.exec(ctx, `INSERT INTO tasks(id,project_id,title,description,status,priority,assignee_id,created_by,due_date,order_index,tags) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9::date,$10,$11)`,
		task.ID, task.ProjectID, task.Title, task.Description, task.Status, task.Priority, task.AssigneeID, task.CreatedBy, task.DueDate, task.OrderIndex, task.Tags); err != nil {
		return nil, err
	}
	// Push WS event to all project members
	tasks, _ := s.ListTasks(ctx, task.ProjectID, task.CreatedBy)
	for _, t := range tasks {
		if t.ID == task.ID {
			tt := t
			memberIDs := s.projectMemberIDs(context.Background(), task.ProjectID)
			s.hub.broadcast(memberIDs, WSEvent{Type: "task_created", Payload: tt})
			return &tt, nil
		}
	}
	return task, nil
}

func (s *Svc) UpdateTask(ctx context.Context, taskID, callerID string, b map[string]any) (*Task, error) {
	var projectID string
	if err := s.db.qrow(ctx, `SELECT project_id FROM tasks WHERE id=$1`, taskID).Scan(&projectID); err != nil {
		return nil, fmt.Errorf("not found")
	}
	if err := s.db.exec(ctx, `UPDATE tasks SET title=COALESCE($2,title),description=COALESCE($3,description),status=COALESCE($4,status),priority=COALESCE($5,priority),assignee_id=COALESCE($6,assignee_id),due_date=COALESCE($7::date,due_date),order_index=COALESCE($8,order_index),updated_at=NOW() WHERE id=$1`,
		taskID, b["title"], b["description"], b["status"], b["priority"], b["assignee_id"], b["due_date"], b["order_index"]); err != nil {
		return nil, err
	}
	// Fetch updated task
	tasks, _ := s.ListTasks(ctx, projectID, callerID)
	for _, t := range tasks {
		if t.ID == taskID {
			tt := t
			memberIDs := s.projectMemberIDs(context.Background(), projectID)
			s.hub.broadcast(memberIDs, WSEvent{Type: "task_updated", Payload: tt})
			return &tt, nil
		}
	}
	return nil, nil
}

func (s *Svc) DeleteTask(ctx context.Context, callerID, taskID string) error {
	var projectID string
	if err := s.db.qrow(ctx, `SELECT project_id FROM tasks WHERE id=$1`, taskID).Scan(&projectID); err != nil {
		return fmt.Errorf("not found")
	}
	if !s.canManageProjectTasks(ctx, projectID, callerID) {
		return fmt.Errorf("unauthorized")
	}
	if err := s.db.exec(ctx, `DELETE FROM tasks WHERE id=$1`, taskID); err != nil {
		return err
	}
	memberIDs := s.projectMemberIDs(context.Background(), projectID)
	s.hub.broadcast(memberIDs, WSEvent{Type: "task_deleted", Payload: map[string]string{"id": taskID, "project_id": projectID}})
	return nil
}

func (s *Svc) projectMemberIDs(ctx context.Context, projectID string) []string {
	var ids []string
	var ownerID string
	if s.db.qrow(ctx, `SELECT owner_id FROM projects WHERE id=$1`, projectID).Scan(&ownerID) == nil {
		ids = append(ids, ownerID)
	}
	rows, _ := s.db.query(ctx, `SELECT user_id FROM team_members WHERE project_id=$1 AND user_id IS NOT NULL AND status='accepted'`, projectID)
	if rows != nil {
		defer rows.Close()
		for rows.Next() {
			var uid string
			rows.Scan(&uid)
			ids = append(ids, uid)
		}
	}
	return ids
}

// ── Investor Interests ──

func (s *Svc) ExpressInterest(ctx context.Context, investorID, projectID, message, amount string) (*InvestorInterest, error) {
	var ownerID string
	if s.db.qrow(ctx, `SELECT owner_id FROM projects WHERE id=$1`, projectID).Scan(&ownerID) == nil {
		if ownerID == investorID {
			return nil, fmt.Errorf("cannot express interest in your own project")
		}
	}
	id := uuid.New().String()
	if err := s.db.exec(ctx, `INSERT INTO investor_interests(id,investor_id,project_id,message,amount) VALUES($1,$2,$3,$4,$5) ON CONFLICT(investor_id,project_id) DO UPDATE SET message=$4,amount=$5,status='pending'`, id, investorID, projectID, message, amount); err != nil {
		return nil, err
	}
	s.db.exec(ctx, `UPDATE projects SET interested_count=interested_count+1 WHERE id=$1`, projectID)
	if ownerID != "" {
		msg := "An investor is interested in your project"
		if actor := s.GetUser(ctx, investorID, ""); actor != nil {
			msg = actor.Name + " is interested in your project"
		}
		s.notify(ctx, ownerID, &investorID, "investor_interest", msg, &projectID, "project")
	}
	return &InvestorInterest{ID: id, InvestorID: investorID, ProjectID: projectID, Message: message, Amount: amount, Status: "pending", CreatedAt: time.Now()}, nil
}

func (s *Svc) ProjectInterests(ctx context.Context, ownerID, projectID string) ([]InvestorInterest, error) {
	if err := s.verifyProjectOwner(ctx, projectID, ownerID); err != nil {
		return nil, err
	}
	rows, err := s.db.query(ctx, `SELECT id,investor_id,project_id,message,amount,status,created_at FROM investor_interests WHERE project_id=$1 ORDER BY created_at DESC`, projectID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []InvestorInterest
	for rows.Next() {
		i := InvestorInterest{}
		rows.Scan(&i.ID, &i.InvestorID, &i.ProjectID, &i.Message, &i.Amount, &i.Status, &i.CreatedAt)
		i.Investor = s.GetUser(ctx, i.InvestorID, "")
		out = append(out, i)
	}
	if out == nil {
		out = []InvestorInterest{}
	}
	return out, nil
}

func (s *Svc) UpdateInterestStatus(ctx context.Context, ownerID, interestID, status string) error {
	var pid string
	if err := s.db.qrow(ctx, `SELECT p.owner_id FROM projects p JOIN investor_interests ii ON ii.project_id=p.id WHERE ii.id=$1`, interestID).Scan(&pid); err != nil {
		return fmt.Errorf("not found")
	}
	if pid != ownerID {
		return fmt.Errorf("unauthorized")
	}
	return s.db.exec(ctx, `UPDATE investor_interests SET status=$2 WHERE id=$1`, interestID, status)
}

// ── Messaging Service ──

func (s *Svc) buildConv(ctx context.Context, convID, callerID string) (*Conversation, error) {
	conv := &Conversation{ID: convID}
	var projectID *string
	var isGroup bool
	var name string
	var createdBy *string
	s.db.qrow(ctx, `SELECT project_id,is_group,name,created_by,updated_at FROM conversations WHERE id=$1`, convID).Scan(&projectID, &isGroup, &name, &createdBy, &conv.UpdatedAt)
	conv.ProjectID = projectID
	conv.IsGroup = isGroup
	conv.Name = name
	conv.CreatedBy = createdBy
	rows, _ := s.db.query(ctx, `SELECT u.id,u.username,u.name,u.avatar,u.headline,u.role,u.is_verified,cm.is_admin,cm.joined_at FROM users u JOIN conversation_members cm ON cm.user_id=u.id WHERE cm.conversation_id=$1`, convID)
	if rows != nil {
		defer rows.Close()
		for rows.Next() {
			m := ConvMember{}
			rows.Scan(&m.ID, &m.Username, &m.Name, &m.Avatar, &m.Headline, &m.Role, &m.IsVerified, &m.IsAdmin, &m.JoinedAt)
			conv.Members = append(conv.Members, m)
		}
	}
	if conv.Members == nil {
		conv.Members = []ConvMember{}
	}
	msg := &Message{}
	if err := s.db.qrow(ctx, `SELECT id,conversation_id,sender_id,content,read,created_at FROM messages WHERE conversation_id=$1 ORDER BY created_at DESC LIMIT 1`, convID).Scan(&msg.ID, &msg.ConversationID, &msg.SenderID, &msg.Content, &msg.Read, &msg.CreatedAt); err == nil {
		conv.LastMessage = msg
	}
	s.db.qrow(ctx, `SELECT COUNT(*) FROM messages WHERE conversation_id=$1 AND sender_id!=$2 AND read=FALSE`, convID, callerID).Scan(&conv.UnreadCount)
	return conv, nil
}

func (s *Svc) GetOrCreateConv(ctx context.Context, userA, userB string) (*Conversation, error) {
	var convID string
	s.db.qrow(ctx, `SELECT cm1.conversation_id FROM conversation_members cm1 JOIN conversation_members cm2 ON cm2.conversation_id=cm1.conversation_id JOIN conversations c ON c.id=cm1.conversation_id WHERE cm1.user_id=$1 AND cm2.user_id=$2 AND c.is_group=FALSE LIMIT 1`, userA, userB).Scan(&convID)
	if convID == "" {
		convID = uuid.New().String()
		s.db.exec(ctx, `INSERT INTO conversations(id,is_group,name,created_by) VALUES($1,FALSE,'',$2)`, convID, userA)
		s.db.exec(ctx, `INSERT INTO conversation_members(conversation_id,user_id,is_admin) VALUES($1,$2,TRUE),($1,$3,FALSE)`, convID, userA, userB)
	}
	return s.buildConv(ctx, convID, userA)
}

func (s *Svc) CreateGroupConv(ctx context.Context, creatorID, name string, memberIDs []string) (*Conversation, error) {
	convID := uuid.New().String()
	if err := s.db.exec(ctx, `INSERT INTO conversations(id,is_group,name,created_by) VALUES($1,TRUE,$2,$3)`, convID, name, creatorID); err != nil {
		return nil, err
	}
	s.db.exec(ctx, `INSERT INTO conversation_members(conversation_id,user_id,is_admin) VALUES($1,$2,TRUE)`, convID, creatorID)
	for _, mid := range memberIDs {
		if mid != creatorID {
			s.db.exec(ctx, `INSERT INTO conversation_members(conversation_id,user_id,is_admin) VALUES($1,$2,FALSE) ON CONFLICT DO NOTHING`, convID, mid)
		}
	}
	return s.buildConv(ctx, convID, creatorID)
}

func (s *Svc) RenameGroup(ctx context.Context, callerID, convID, newName string) error {
	var isAdmin bool
	s.db.qrow(ctx, `SELECT is_admin FROM conversation_members WHERE conversation_id=$1 AND user_id=$2`, convID, callerID).Scan(&isAdmin)
	if !isAdmin {
		return fmt.Errorf("only admins can rename")
	}
	return s.db.exec(ctx, `UPDATE conversations SET name=$2 WHERE id=$1`, convID, newName)
}

func (s *Svc) AddGroupMember(ctx context.Context, callerID, convID, newUserID string) error {
	var isAdmin bool
	s.db.qrow(ctx, `SELECT is_admin FROM conversation_members WHERE conversation_id=$1 AND user_id=$2`, convID, callerID).Scan(&isAdmin)
	var createdBy *string
	s.db.qrow(ctx, `SELECT created_by FROM conversations WHERE id=$1`, convID).Scan(&createdBy)
	if !isAdmin && (createdBy == nil || *createdBy != callerID) {
		return fmt.Errorf("only admins can add members")
	}
	return s.db.exec(ctx, `INSERT INTO conversation_members(conversation_id,user_id,is_admin) VALUES($1,$2,FALSE) ON CONFLICT DO NOTHING`, convID, newUserID)
}

func (s *Svc) RemoveGroupMember(ctx context.Context, callerID, convID, targetUserID string) error {
	var isAdmin bool
	s.db.qrow(ctx, `SELECT is_admin FROM conversation_members WHERE conversation_id=$1 AND user_id=$2`, convID, callerID).Scan(&isAdmin)
	if !isAdmin && callerID != targetUserID {
		return fmt.Errorf("unauthorized")
	}
	return s.db.exec(ctx, `DELETE FROM conversation_members WHERE conversation_id=$1 AND user_id=$2`, convID, targetUserID)
}

func (s *Svc) GetOrCreateProjectChat(ctx context.Context, projectID, callerID string) (*Conversation, error) {
	var convID string
	s.db.qrow(ctx, `SELECT id FROM conversations WHERE project_id=$1 AND is_group=TRUE LIMIT 1`, projectID).Scan(&convID)
	if convID == "" {
		var pname string
		var ownerID string
		s.db.qrow(ctx, `SELECT name,owner_id FROM projects WHERE id=$1`, projectID).Scan(&pname, &ownerID)
		convID = uuid.New().String()
		s.db.exec(ctx, `INSERT INTO conversations(id,project_id,is_group,name,created_by) VALUES($1,$2,TRUE,$3,$4)`, convID, projectID, pname+" Team", ownerID)
		s.db.exec(ctx, `INSERT INTO conversation_members(conversation_id,user_id,is_admin) VALUES($1,$2,TRUE) ON CONFLICT DO NOTHING`, convID, ownerID)
		trows, _ := s.db.query(ctx, `SELECT user_id FROM team_members WHERE project_id=$1 AND user_id IS NOT NULL AND status='accepted'`, projectID)
		if trows != nil {
			for trows.Next() {
				var uid string
				trows.Scan(&uid)
				s.db.exec(ctx, `INSERT INTO conversation_members(conversation_id,user_id,is_admin) VALUES($1,$2,FALSE) ON CONFLICT DO NOTHING`, convID, uid)
			}
			trows.Close()
		}
	}
	s.db.exec(ctx, `INSERT INTO conversation_members(conversation_id,user_id,is_admin) VALUES($1,$2,FALSE) ON CONFLICT DO NOTHING`, convID, callerID)
	return s.buildConv(ctx, convID, callerID)
}

func (s *Svc) ListConvs(ctx context.Context, userID string) ([]Conversation, error) {
	rows, err := s.db.query(ctx, `SELECT conversation_id FROM conversation_members WHERE user_id=$1 ORDER BY (SELECT updated_at FROM conversations WHERE id=conversation_id) DESC`, userID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []Conversation
	for rows.Next() {
		var cid string
		rows.Scan(&cid)
		if c, err := s.buildConv(ctx, cid, userID); err == nil {
			out = append(out, *c)
		}
	}
	if out == nil {
		out = []Conversation{}
	}
	return out, nil
}

func (s *Svc) GetMessages(ctx context.Context, convID, callerID string, page, limit int) ([]Message, error) {
	var isMember bool
	s.db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM conversation_members WHERE conversation_id=$1 AND user_id=$2)`, convID, callerID).Scan(&isMember)
	if !isMember {
		return nil, fmt.Errorf("not a member")
	}
	rows, err := s.db.query(ctx, `SELECT m.id,m.conversation_id,m.sender_id,m.content,m.msg_type,m.read,m.created_at,u.id,u.username,u.name,u.avatar,u.role FROM messages m JOIN users u ON u.id=m.sender_id WHERE m.conversation_id=$1 ORDER BY m.created_at DESC LIMIT $2 OFFSET $3`, convID, limit, (page-1)*limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []Message
	for rows.Next() {
		m := Message{}
		sender := &User{}
		rows.Scan(&m.ID, &m.ConversationID, &m.SenderID, &m.Content, &m.MsgType, &m.Read, &m.CreatedAt, &sender.ID, &sender.Username, &sender.Name, &sender.Avatar, &sender.Role)
		m.Sender = sender
		out = append(out, m)
	}
	s.db.exec(ctx, `UPDATE messages SET read=TRUE WHERE conversation_id=$1 AND sender_id!=$2`, convID, callerID)
	s.db.exec(ctx, `UPDATE conversations SET updated_at=NOW() WHERE id=$1`, convID)
	if out == nil {
		out = []Message{}
	}
	return out, nil
}

func (s *Svc) SendMessage(ctx context.Context, senderID, convID, content, msgType string) (*Message, error) {
	var isMember bool
	s.db.qrow(ctx, `SELECT EXISTS(SELECT 1 FROM conversation_members WHERE conversation_id=$1 AND user_id=$2)`, convID, senderID).Scan(&isMember)
	if !isMember {
		return nil, fmt.Errorf("not a member")
	}
	if msgType == "" {
		msgType = "text"
	}
	msgID := uuid.New().String()
	var createdAt time.Time
	s.db.qrow(ctx, `INSERT INTO messages(id,conversation_id,sender_id,content,msg_type) VALUES($1,$2,$3,$4,$5) RETURNING created_at`, msgID, convID, senderID, content, msgType).Scan(&createdAt)
	s.db.exec(ctx, `UPDATE conversations SET updated_at=NOW() WHERE id=$1`, convID)
	msg := &Message{ID: msgID, ConversationID: convID, SenderID: senderID, Content: content, MsgType: msgType, CreatedAt: createdAt, Sender: s.GetUser(ctx, senderID, "")}
	s.hub.broadcast(s.convMemberIDs(ctx, convID), WSEvent{Type: "new_message", Payload: msg})
	return msg, nil
}

// ── Notification Service ──

func (s *Svc) Notifications(ctx context.Context, userID string, page, limit int) ([]Notification, int, error) {
	rows, err := s.db.query(ctx, `SELECT id,user_id,actor_id,type,message,ref_id,ref_type,read,created_at FROM notifications WHERE user_id=$1 ORDER BY created_at DESC LIMIT $2 OFFSET $3`, userID, limit, (page-1)*limit)
	if err != nil {
		return nil, 0, err
	}
	defer rows.Close()
	var out []Notification
	for rows.Next() {
		n := Notification{}
		rows.Scan(&n.ID, &n.UserID, &n.ActorID, &n.Type, &n.Message, &n.RefID, &n.RefType, &n.Read, &n.CreatedAt)
		if n.ActorID != nil {
			n.Actor = s.GetUser(ctx, *n.ActorID, "")
		}
		out = append(out, n)
	}
	var unread int
	s.db.qrow(ctx, `SELECT COUNT(*) FROM notifications WHERE user_id=$1 AND read=FALSE`, userID).Scan(&unread)
	if out == nil {
		out = []Notification{}
	}
	return out, unread, nil
}
func (s *Svc) MarkNotifsRead(ctx context.Context, userID string) {
	s.db.exec(ctx, `UPDATE notifications SET read=TRUE WHERE user_id=$1`, userID)
}

// ═══════════════════════ HTTP ═══════════════════════

func writeJSON(w http.ResponseWriter, code int, v any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	json.NewEncoder(w).Encode(v)
}
func ok(w http.ResponseWriter, v any)       { writeJSON(w, 200, v) }
func created(w http.ResponseWriter, v any)  { writeJSON(w, 201, v) }
func msgOK(w http.ResponseWriter, m string) { ok(w, map[string]string{"message": m}) }
func fail(w http.ResponseWriter, m string, code int) {
	writeJSON(w, code, map[string]string{"error": m})
}
func decode(r *http.Request, v any) error { return json.NewDecoder(r.Body).Decode(v) }
func qs(r *http.Request, k, d string) string {
	if v := r.URL.Query().Get(k); v != "" {
		return v
	}
	return d
}
func qi(r *http.Request, k string, d int) int {
	n := d
	fmt.Sscan(r.URL.Query().Get(k), &n)
	if n < 1 {
		return d
	}
	return n
}

type ctxKey string

const keyUID ctxKey = "uid"

func corsMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {

		ww := wrappedWriter{w} // ✅ important

		ww.Header().Set("Access-Control-Allow-Origin", "*")
		ww.Header().Set("Access-Control-Allow-Headers", "Content-Type, Authorization")
		ww.Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")

		if r.Method == "OPTIONS" {
			w.WriteHeader(http.StatusOK)
			return
		}

		next.ServeHTTP(ww, r)
	})
}

type rrw struct {
	http.ResponseWriter
	status int
}

func (r *rrw) WriteHeader(code int) { r.status = code; r.ResponseWriter.WriteHeader(code) }

func logMiddleware(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()

		ww := wrappedWriter{w} // ✅ use wrapped writer

		next.ServeHTTP(ww, r)

		log.Info("http",
			zap.String("m", r.Method),
			zap.String("p", r.URL.Path),
			zap.String("t", time.Since(start).String()),
		)
	})
}

func authMiddleware(a *Auth) mux.MiddlewareFunc {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			hdr := r.Header.Get("Authorization")
			if hdr == "" {
				fail(w, "unauthorized", 401)
				return
			}
			parts := strings.SplitN(hdr, " ", 2)
			if len(parts) != 2 {
				fail(w, "invalid auth header", 401)
				return
			}
			claims, err := a.verify(parts[1])
			if err != nil {
				fail(w, "invalid token", 401)
				return
			}
			next.ServeHTTP(w, r.WithContext(context.WithValue(r.Context(), keyUID, claims.UserID)))
		})
	}
}
func uid(r *http.Request) string { v, _ := r.Context().Value(keyUID).(string); return v }

type H struct{ svc *Svc }

func (h *H) health(w http.ResponseWriter, r *http.Request) {
	if err := h.svc.db.pool.Ping(r.Context()); err != nil {
		fail(w, "db unhealthy", 503)
		return
	}
	ok(w, map[string]string{"status": "ok"})
}
func (h *H) register(w http.ResponseWriter, r *http.Request) {
	var b struct{ Name, Email, Password, Role string }
	if decode(r, &b) != nil || b.Name == "" || b.Email == "" || b.Password == "" {
		fail(w, "name, email, password required", 400)
		return
	}
	if len(b.Password) < 6 {
		fail(w, "password min 6 chars", 400)
		return
	}
	tok, user, err := h.svc.Register(r.Context(), b.Name, b.Email, b.Password, b.Role)
	if err != nil {
		fail(w, err.Error(), 409)
		return
	}
	created(w, map[string]any{"token": tok, "user": user})
}
func (h *H) login(w http.ResponseWriter, r *http.Request) {
	var b struct{ Email, Password string }
	if decode(r, &b) != nil || b.Email == "" || b.Password == "" {
		fail(w, "email, password required", 400)
		return
	}
	tok, user, err := h.svc.Login(r.Context(), b.Email, b.Password)
	if err != nil {
		fail(w, "invalid credentials", 401)
		return
	}
	ok(w, map[string]any{"token": tok, "user": user})
}
func (h *H) getMe(w http.ResponseWriter, r *http.Request) {
	u := h.svc.GetUser(r.Context(), uid(r), uid(r))
	if u == nil {
		fail(w, "not found", 404)
		return
	}
	ok(w, u)
}
func (h *H) updateMe(w http.ResponseWriter, r *http.Request) {
	var b map[string]any
	if decode(r, &b) != nil {
		fail(w, "invalid body", 400)
		return
	}
	if err := h.svc.UpdateProfile(r.Context(), uid(r), b); err != nil {
		fail(w, err.Error(), 400)
		return
	}
	ok(w, h.svc.GetUser(r.Context(), uid(r), uid(r)))
}
func (h *H) getUser(w http.ResponseWriter, r *http.Request) {
	id := mux.Vars(r)["id"]
	var u *User
	// Try UUID first, then username
	if len(id) == 36 {
		u = h.svc.GetUser(r.Context(), id, uid(r))
	}
	if u == nil {
		u = h.svc.GetUserByUsername(r.Context(), id, uid(r))
	}
	if u == nil {
		fail(w, "not found", 404)
		return
	}
	ok(w, u)
}
func (h *H) searchUsers(w http.ResponseWriter, r *http.Request) {
	users, err := h.svc.SearchUsers(r.Context(), qs(r, "q", ""), qs(r, "role", ""), uid(r))
	if err != nil {
		fail(w, "search failed", 500)
		return
	}
	ok(w, users)
}
func (h *H) toggleFollow(w http.ResponseWriter, r *http.Request) {
	following, pending, err := h.svc.ToggleFollow(r.Context(), uid(r), mux.Vars(r)["id"])
	if err != nil {
		fail(w, err.Error(), 400)
		return
	}
	target := h.svc.GetUser(r.Context(), mux.Vars(r)["id"], uid(r))
	fc := 0
	if target != nil {
		fc = target.FollowersCount
	}
	ok(w, map[string]any{"following": following, "pending": pending, "followers_count": fc})
}
func (h *H) pendingFollowRequests(w http.ResponseWriter, r *http.Request) {
	reqs, err := h.svc.PendingFollowRequests(r.Context(), uid(r))
	if err != nil {
		fail(w, "failed", 500)
		return
	}
	ok(w, reqs)
}
func (h *H) handleFollowRequest(w http.ResponseWriter, r *http.Request) {
	var b struct{ Action string }
	if decode(r, &b) != nil || b.Action == "" {
		fail(w, "action required", 400)
		return
	}
	if err := h.svc.HandleFollowRequest(r.Context(), uid(r), mux.Vars(r)["id"], b.Action); err != nil {
		fail(w, err.Error(), 400)
		return
	}
	msgOK(w, "updated")
}
func (h *H) followers(w http.ResponseWriter, r *http.Request) {
	users, _ := h.svc.Followers(r.Context(), mux.Vars(r)["id"], uid(r))
	ok(w, users)
}
func (h *H) following(w http.ResponseWriter, r *http.Request) {
	users, _ := h.svc.Following(r.Context(), mux.Vars(r)["id"], uid(r))
	ok(w, users)
}
func (h *H) userPosts(w http.ResponseWriter, r *http.Request) {
	posts, _ := h.svc.UserPosts(r.Context(), mux.Vars(r)["id"], uid(r), qi(r, "page", 1), qi(r, "limit", 20))
	ok(w, posts)
}
func (h *H) createPost(w http.ResponseWriter, r *http.Request) {
	var b Post
	if decode(r, &b) != nil || b.Content == "" {
		fail(w, "content required", 400)
		return
	}
	b.UserID = uid(r)
	if b.Type == "" {
		b.Type = "post"
	}
	p, err := h.svc.CreatePost(r.Context(), &b)
	if err != nil {
		fail(w, "failed", 500)
		return
	}
	created(w, p)
}
func (h *H) getFeed(w http.ResponseWriter, r *http.Request) {
	posts, _ := h.svc.Feed(r.Context(), uid(r), qi(r, "page", 1), qi(r, "limit", 20))
	ok(w, posts)
}
func (h *H) getExplore(w http.ResponseWriter, r *http.Request) {
	var tags []string
	if ts := qs(r, "tags", ""); ts != "" {
		tags = strings.Split(ts, ",")
	}
	posts, _ := h.svc.Explore(r.Context(), uid(r), qs(r, "type", ""), tags, qi(r, "page", 1), qi(r, "limit", 20))
	ok(w, posts)
}
func (h *H) getPost(w http.ResponseWriter, r *http.Request) {
	p, err := h.svc.GetPost(r.Context(), mux.Vars(r)["id"], uid(r))
	if err != nil {
		fail(w, "not found", 404)
		return
	}
	ok(w, p)
}
func (h *H) deletePost(w http.ResponseWriter, r *http.Request) {
	if err := h.svc.DeletePost(r.Context(), uid(r), mux.Vars(r)["id"]); err != nil {
		fail(w, err.Error(), 403)
		return
	}
	msgOK(w, "deleted")
}
func (h *H) likePost(w http.ResponseWriter, r *http.Request) {
	count, liked := h.svc.LikePost(r.Context(), uid(r), mux.Vars(r)["id"])
	ok(w, map[string]any{"likes_count": count, "liked": liked})
}
func (h *H) bookmarkPost(w http.ResponseWriter, r *http.Request) {
	b := h.svc.BookmarkPost(r.Context(), uid(r), mux.Vars(r)["id"])
	ok(w, map[string]bool{"bookmarked": b})
}
func (h *H) voteIdea(w http.ResponseWriter, r *http.Request) {
	var b struct {
		VoteType string `json:"vote_type"`
	}
	if decode(r, &b) != nil || b.VoteType == "" {
		fail(w, "vote_type required", 400)
		return
	}
	up, down, myVote, err := h.svc.VoteIdea(r.Context(), uid(r), mux.Vars(r)["id"], b.VoteType)
	if err != nil {
		fail(w, err.Error(), 400)
		return
	}
	ok(w, map[string]any{"up_votes": up, "down_votes": down, "my_vote": myVote})
}
func (h *H) getComments(w http.ResponseWriter, r *http.Request) {
	comments, _ := h.svc.PostComments(r.Context(), mux.Vars(r)["postId"], uid(r))
	ok(w, comments)
}
func (h *H) createComment(w http.ResponseWriter, r *http.Request) {
	var b Comment
	if decode(r, &b) != nil || b.Content == "" {
		fail(w, "content required", 400)
		return
	}
	b.UserID = uid(r)
	b.PostID = mux.Vars(r)["postId"]
	c, err := h.svc.CreateComment(r.Context(), &b)
	if err != nil {
		fail(w, "failed", 500)
		return
	}
	created(w, c)
}
func (h *H) listProjects(w http.ResponseWriter, r *http.Request) {
	projects, _ := h.svc.ListProjects(r.Context(), uid(r), qs(r, "stage", ""), qs(r, "industry", ""), qi(r, "page", 1), qi(r, "limit", 20))
	ok(w, projects)
}
func (h *H) createProject(w http.ResponseWriter, r *http.Request) {
	var b Project
	if decode(r, &b) != nil || b.Name == "" {
		fail(w, "name required", 400)
		return
	}
	b.OwnerID = uid(r)
	p, err := h.svc.CreateProject(r.Context(), &b)
	if err != nil {
		fail(w, "failed", 500)
		return
	}
	created(w, p)
}
func (h *H) getProject(w http.ResponseWriter, r *http.Request) {
	p, err := h.svc.GetProject(r.Context(), mux.Vars(r)["id"], uid(r))
	if err != nil {
		fail(w, "not found", 404)
		return
	}
	go h.svc.IncrViews(context.Background(), p.ID, uid(r))
	ok(w, p)
}
func (h *H) updateProject(w http.ResponseWriter, r *http.Request) {
	var b map[string]any
	if decode(r, &b) != nil {
		fail(w, "invalid body", 400)
		return
	}
	if err := h.svc.UpdateProject(r.Context(), uid(r), mux.Vars(r)["id"], b); err != nil {
		fail(w, err.Error(), 403)
		return
	}
	p, _ := h.svc.GetProject(r.Context(), mux.Vars(r)["id"], uid(r))
	ok(w, p)
}
func (h *H) upsertSection(w http.ResponseWriter, r *http.Request) {
	var b ProjectSection
	if decode(r, &b) != nil || b.Title == "" {
		fail(w, "title required", 400)
		return
	}
	b.ProjectID = mux.Vars(r)["projectId"]
	if id := mux.Vars(r)["id"]; id != "" {
		b.ID = id
	}
	sec, err := h.svc.UpsertSection(r.Context(), uid(r), &b)
	if err != nil {
		fail(w, err.Error(), 403)
		return
	}
	ok(w, sec)
}
func (h *H) deleteSection(w http.ResponseWriter, r *http.Request) {
	if err := h.svc.DeleteSection(r.Context(), uid(r), mux.Vars(r)["id"]); err != nil {
		fail(w, err.Error(), 403)
		return
	}
	msgOK(w, "deleted")
}
func (h *H) listProjectUpdates(w http.ResponseWriter, r *http.Request) {
	updates, err := h.svc.ProjectUpdatesList(r.Context(), mux.Vars(r)["projectId"])
	if err != nil {
		fail(w, "failed", 500)
		return
	}
	ok(w, updates)
}
func (h *H) createProjectUpdate(w http.ResponseWriter, r *http.Request) {
	var b ProjectUpdate
	if decode(r, &b) != nil || b.Title == "" {
		fail(w, "title required", 400)
		return
	}
	b.ProjectID = mux.Vars(r)["projectId"]
	u, err := h.svc.CreateProjectUpdate(r.Context(), uid(r), &b)
	if err != nil {
		fail(w, err.Error(), 403)
		return
	}
	created(w, u)
}
func (h *H) deleteProjectUpdate(w http.ResponseWriter, r *http.Request) {
	if err := h.svc.DeleteProjectUpdate(r.Context(), uid(r), mux.Vars(r)["updateId"]); err != nil {
		fail(w, err.Error(), 403)
		return
	}
	msgOK(w, "deleted")
}
func (h *H) addTeamMember(w http.ResponseWriter, r *http.Request) {
	var b TeamMember
	if decode(r, &b) != nil || b.Role == "" {
		fail(w, "role required", 400)
		return
	}
	b.ProjectID = mux.Vars(r)["projectId"]
	m, err := h.svc.AddTeamMember(r.Context(), uid(r), &b)
	if err != nil {
		fail(w, err.Error(), 400)
		return
	}
	created(w, m)
}
func (h *H) respondInvite(w http.ResponseWriter, r *http.Request) {
	var b struct{ Action string }
	if decode(r, &b) != nil || b.Action == "" {
		fail(w, "action required", 400)
		return
	}
	if err := h.svc.RespondToInvite(r.Context(), mux.Vars(r)["memberId"], uid(r), b.Action); err != nil {
		fail(w, err.Error(), 400)
		return
	}
	msgOK(w, "updated")
}
func (h *H) updateTeamMemberAdmin(w http.ResponseWriter, r *http.Request) {
	var b struct {
		IsAdmin bool `json:"is_admin"`
	}
	if decode(r, &b) != nil {
		fail(w, "invalid body", 400)
		return
	}
	if err := h.svc.UpdateTeamMemberAdmin(r.Context(), uid(r), mux.Vars(r)["memberId"], b.IsAdmin); err != nil {
		fail(w, err.Error(), 403)
		return
	}
	msgOK(w, "updated")
}
func (h *H) removeTeamMember(w http.ResponseWriter, r *http.Request) {
	if err := h.svc.RemoveTeamMember(r.Context(), uid(r), mux.Vars(r)["memberId"]); err != nil {
		fail(w, err.Error(), 403)
		return
	}
	msgOK(w, "removed")
}
func (h *H) submitJoinRequest(w http.ResponseWriter, r *http.Request) {
	var b struct{ Message, DesiredRole string }
	decode(r, &b)
	jr, err := h.svc.SubmitJoinRequest(r.Context(), uid(r), mux.Vars(r)["projectId"], b.Message, b.DesiredRole)
	if err != nil {
		fail(w, err.Error(), 400)
		return
	}
	created(w, jr)
}
func (h *H) listJoinRequests(w http.ResponseWriter, r *http.Request) {
	requests, err := h.svc.ListJoinRequests(r.Context(), uid(r), mux.Vars(r)["projectId"])
	if err != nil {
		fail(w, err.Error(), 403)
		return
	}
	ok(w, requests)
}
func (h *H) updateJoinRequest(w http.ResponseWriter, r *http.Request) {
	var b struct{ Status string }
	if decode(r, &b) != nil || b.Status == "" {
		fail(w, "status required", 400)
		return
	}
	if err := h.svc.UpdateJoinRequest(r.Context(), uid(r), mux.Vars(r)["reqId"], b.Status); err != nil {
		fail(w, err.Error(), 403)
		return
	}
	msgOK(w, "updated")
}
func (h *H) listTasks(w http.ResponseWriter, r *http.Request) {
	tasks, err := h.svc.ListTasks(r.Context(), mux.Vars(r)["projectId"], uid(r))
	if err != nil {
		fail(w, err.Error(), 500)
		return
	}
	ok(w, tasks)
}
func (h *H) createTask(w http.ResponseWriter, r *http.Request) {
	projectID := mux.Vars(r)["projectId"]
	if !h.svc.canManageProjectTasks(r.Context(), projectID, uid(r)) {
		fail(w, "only project admin can create tasks", 403)
		return
	}
	var b Task
	if decode(r, &b) != nil || b.Title == "" {
		fail(w, "title required", 400)
		return
	}
	b.ProjectID = projectID
	b.CreatedBy = uid(r)
	t, err := h.svc.CreateTask(r.Context(), &b)
	if err != nil {
		fail(w, err.Error(), 500)
		return
	}
	created(w, t)
}
func (h *H) updateTask(w http.ResponseWriter, r *http.Request) {
	var b map[string]any
	if decode(r, &b) != nil {
		fail(w, "invalid body", 400)
		return
	}
	t, err := h.svc.UpdateTask(r.Context(), mux.Vars(r)["id"], uid(r), b)
	if err != nil {
		fail(w, err.Error(), 400)
		return
	}
	ok(w, t)
}
func (h *H) deleteTask(w http.ResponseWriter, r *http.Request) {
	if err := h.svc.DeleteTask(r.Context(), uid(r), mux.Vars(r)["id"]); err != nil {
		fail(w, err.Error(), 403)
		return
	}
	msgOK(w, "deleted")
}
func (h *H) expressInterest(w http.ResponseWriter, r *http.Request) {
	var b struct{ Message, Amount string }
	decode(r, &b)
	i, err := h.svc.ExpressInterest(r.Context(), uid(r), mux.Vars(r)["projectId"], b.Message, b.Amount)
	if err != nil {
		fail(w, err.Error(), 400)
		return
	}
	created(w, i)
}
func (h *H) getInterests(w http.ResponseWriter, r *http.Request) {
	interests, err := h.svc.ProjectInterests(r.Context(), uid(r), mux.Vars(r)["projectId"])
	if err != nil {
		fail(w, err.Error(), 403)
		return
	}
	ok(w, interests)
}
func (h *H) updateInterest(w http.ResponseWriter, r *http.Request) {
	var b struct{ Status string }
	if decode(r, &b) != nil || b.Status == "" {
		fail(w, "status required", 400)
		return
	}
	if err := h.svc.UpdateInterestStatus(r.Context(), uid(r), mux.Vars(r)["interestId"], b.Status); err != nil {
		fail(w, err.Error(), 403)
		return
	}
	msgOK(w, "updated")
}
func (h *H) listConvs(w http.ResponseWriter, r *http.Request) {
	convs, _ := h.svc.ListConvs(r.Context(), uid(r))
	ok(w, convs)
}
func (h *H) openConv(w http.ResponseWriter, r *http.Request) {
	var b struct {
		UserID    string   `json:"user_id"`
		IsGroup   bool     `json:"is_group"`
		Name      string   `json:"name"`
		MemberIDs []string `json:"member_ids"`
	}
	if decode(r, &b) != nil {
		fail(w, "invalid body", 400)
		return
	}
	if b.IsGroup {
		conv, err := h.svc.CreateGroupConv(r.Context(), uid(r), b.Name, b.MemberIDs)
		if err != nil {
			fail(w, "failed", 500)
			return
		}
		ok(w, conv)
		return
	}
	if b.UserID == "" {
		fail(w, "user_id required", 400)
		return
	}
	conv, err := h.svc.GetOrCreateConv(r.Context(), uid(r), b.UserID)
	if err != nil {
		fail(w, "failed", 500)
		return
	}
	ok(w, conv)
}
func (h *H) renameGroup(w http.ResponseWriter, r *http.Request) {
	var b struct{ Name string }
	if decode(r, &b) != nil || b.Name == "" {
		fail(w, "name required", 400)
		return
	}
	if err := h.svc.RenameGroup(r.Context(), uid(r), mux.Vars(r)["id"], b.Name); err != nil {
		fail(w, err.Error(), 403)
		return
	}
	msgOK(w, "renamed")
}
func (h *H) addGroupMember(w http.ResponseWriter, r *http.Request) {
	var b struct {
		UserID string `json:"user_id"`
	}
	if decode(r, &b) != nil || b.UserID == "" {
		fail(w, "user_id required", 400)
		return
	}
	if err := h.svc.AddGroupMember(r.Context(), uid(r), mux.Vars(r)["id"], b.UserID); err != nil {
		fail(w, err.Error(), 403)
		return
	}
	msgOK(w, "added")
}
func (h *H) removeGroupMember(w http.ResponseWriter, r *http.Request) {
	if err := h.svc.RemoveGroupMember(r.Context(), uid(r), mux.Vars(r)["id"], mux.Vars(r)["userId"]); err != nil {
		fail(w, err.Error(), 403)
		return
	}
	msgOK(w, "removed")
}
func (h *H) projectChat(w http.ResponseWriter, r *http.Request) {
	conv, err := h.svc.GetOrCreateProjectChat(r.Context(), mux.Vars(r)["projectId"], uid(r))
	if err != nil {
		fail(w, err.Error(), 500)
		return
	}
	ok(w, conv)
}
func (h *H) getMessages(w http.ResponseWriter, r *http.Request) {
	msgs, err := h.svc.GetMessages(r.Context(), mux.Vars(r)["id"], uid(r), qi(r, "page", 1), qi(r, "limit", 60))
	if err != nil {
		fail(w, err.Error(), 403)
		return
	}
	ok(w, msgs)
}
func (h *H) sendMessage(w http.ResponseWriter, r *http.Request) {
	var b struct {
		Content string `json:"content"`
		MsgType string `json:"msg_type"`
	}
	if decode(r, &b) != nil || b.Content == "" {
		fail(w, "content required", 400)
		return
	}
	msg, err := h.svc.SendMessage(r.Context(), uid(r), mux.Vars(r)["id"], b.Content, b.MsgType)
	if err != nil {
		fail(w, err.Error(), 403)
		return
	}
	created(w, msg)
}
func (h *H) getNotifs(w http.ResponseWriter, r *http.Request) {
	notifs, unread, _ := h.svc.Notifications(r.Context(), uid(r), qi(r, "page", 1), qi(r, "limit", 30))
	ok(w, map[string]any{"notifications": notifs, "unread_count": unread})
}
func (h *H) markNotifs(w http.ResponseWriter, r *http.Request) {
	h.svc.MarkNotifsRead(r.Context(), uid(r))
	msgOK(w, "ok")
}
func (h *H) checkUsername(w http.ResponseWriter, r *http.Request) {
	username := mux.Vars(r)["username"]
	var exists bool
	h.svc.db.qrow(r.Context(), `SELECT EXISTS(SELECT 1 FROM users WHERE username=$1)`, username).Scan(&exists)
	ok(w, map[string]bool{"available": !exists})
}

var wsUpgrader = websocket.Upgrader{ReadBufferSize: 4096, WriteBufferSize: 4096, CheckOrigin: func(*http.Request) bool { return true }}

func (h *H) wsConnect(w http.ResponseWriter, r *http.Request) {
	claims, err := h.svc.auth.verify(r.URL.Query().Get("token"))
	if err != nil {
		http.Error(w, "unauthorized", 401)
		return
	}
	conn, err := wsUpgrader.Upgrade(w, r, nil)
	if err != nil {
		return
	}
	c := &wsClient{userID: claims.UserID, conn: conn, send: make(chan []byte, 256)}
	h.svc.hub.register <- c
	go c.writePump()
	conn.SetReadLimit(8192)
	conn.SetReadDeadline(time.Now().Add(60 * time.Second))
	conn.SetPongHandler(func(string) error { conn.SetReadDeadline(time.Now().Add(60 * time.Second)); return nil })
	defer func() { h.svc.hub.unregister <- c }()
	for {
		_, data, err := conn.ReadMessage()
		if err != nil {
			break
		}
		var evt map[string]any
		if json.Unmarshal(data, &evt) != nil {
			continue
		}
		switch evt["type"] {
		case "typing":
			if pl, ok2 := evt["payload"].(map[string]any); ok2 {
				if convID, _ := pl["conversation_id"].(string); convID != "" {
					h.svc.hub.broadcast(h.svc.convMemberIDs(r.Context(), convID), WSEvent{Type: "typing", Payload: map[string]string{"user_id": claims.UserID, "conversation_id": convID}})
				}
			}
		case "task_move":
			// Real-time task drag-drop
			if pl, ok2 := evt["payload"].(map[string]any); ok2 {
				taskID, _ := pl["task_id"].(string)
				newStatus, _ := pl["status"].(string)
				projectID, _ := pl["project_id"].(string)
				if taskID != "" && newStatus != "" && projectID != "" {
					b := map[string]any{"status": newStatus}
					if t, err := h.svc.UpdateTask(r.Context(), taskID, claims.UserID, b); err == nil && t != nil {
						memberIDs := h.svc.projectMemberIDs(r.Context(), projectID)
						h.svc.hub.broadcast(memberIDs, WSEvent{Type: "task_updated", Payload: t})
					}
				}
			}
		}
	}
}

func buildRouter(h *H, a *Auth) http.Handler {
	r := mux.NewRouter()
	r.Use(corsMiddleware, logMiddleware)
	r.PathPrefix("/").HandlerFunc(func(w http.ResponseWriter, r *http.Request) { w.WriteHeader(http.StatusNoContent) }).Methods(http.MethodOptions)
	r.HandleFunc("/health", h.health).Methods("GET")
	r.HandleFunc("/ws", h.wsConnect)
	api := r.PathPrefix("/api").Subrouter()
	api.HandleFunc("/auth/register", h.register).Methods("POST")
	api.HandleFunc("/auth/login", h.login).Methods("POST")
	api.HandleFunc("/username/{username}/check", h.checkUsername).Methods("GET")
	p := api.NewRoute().Subrouter()
	p.Use(authMiddleware(a))
	p.HandleFunc("/me", h.getMe).Methods("GET")
	p.HandleFunc("/me", h.updateMe).Methods("PUT", "PATCH")
	p.HandleFunc("/me/follow-requests", h.pendingFollowRequests).Methods("GET")
	p.HandleFunc("/me/follow-requests/{id}", h.handleFollowRequest).Methods("POST")
	p.HandleFunc("/users", h.searchUsers).Methods("GET")
	p.HandleFunc("/users/{id}", h.getUser).Methods("GET")
	p.HandleFunc("/users/{id}/follow", h.toggleFollow).Methods("POST", "DELETE")
	p.HandleFunc("/users/{id}/followers", h.followers).Methods("GET")
	p.HandleFunc("/users/{id}/following", h.following).Methods("GET")
	p.HandleFunc("/users/{id}/posts", h.userPosts).Methods("GET")
	p.HandleFunc("/feed", h.getFeed).Methods("GET")
	p.HandleFunc("/explore", h.getExplore).Methods("GET")
	p.HandleFunc("/posts", h.createPost).Methods("POST")
	p.HandleFunc("/posts/{id}", h.getPost).Methods("GET")
	p.HandleFunc("/posts/{id}", h.deletePost).Methods("DELETE")
	p.HandleFunc("/posts/{id}/like", h.likePost).Methods("POST")
	p.HandleFunc("/posts/{id}/bookmark", h.bookmarkPost).Methods("POST")
	p.HandleFunc("/posts/{id}/vote", h.voteIdea).Methods("POST")
	p.HandleFunc("/posts/{postId}/comments", h.getComments).Methods("GET")
	p.HandleFunc("/posts/{postId}/comments", h.createComment).Methods("POST")
	p.HandleFunc("/projects", h.listProjects).Methods("GET")
	p.HandleFunc("/projects", h.createProject).Methods("POST")
	p.HandleFunc("/projects/{id}", h.getProject).Methods("GET")
	p.HandleFunc("/projects/{id}", h.updateProject).Methods("PUT", "PATCH")
	p.HandleFunc("/projects/{projectId}/sections", h.upsertSection).Methods("POST")
	p.HandleFunc("/projects/{projectId}/sections/{id}", h.upsertSection).Methods("PUT")
	p.HandleFunc("/sections/{id}", h.deleteSection).Methods("DELETE")
	p.HandleFunc("/projects/{projectId}/updates", h.listProjectUpdates).Methods("GET")
	p.HandleFunc("/projects/{projectId}/updates", h.createProjectUpdate).Methods("POST")
	p.HandleFunc("/projects/{projectId}/updates/{updateId}", h.deleteProjectUpdate).Methods("DELETE")
	p.HandleFunc("/projects/{projectId}/team", h.addTeamMember).Methods("POST")
	p.HandleFunc("/projects/{projectId}/team/{memberId}", h.removeTeamMember).Methods("DELETE")
	p.HandleFunc("/projects/{projectId}/team/{memberId}/admin", h.updateTeamMemberAdmin).Methods("PATCH")
	p.HandleFunc("/team-invites/{memberId}/respond", h.respondInvite).Methods("POST")
	p.HandleFunc("/projects/{projectId}/join", h.submitJoinRequest).Methods("POST")
	p.HandleFunc("/projects/{projectId}/join-requests", h.listJoinRequests).Methods("GET")
	p.HandleFunc("/join-requests/{reqId}", h.updateJoinRequest).Methods("PATCH")
	p.HandleFunc("/projects/{projectId}/tasks", h.listTasks).Methods("GET")
	p.HandleFunc("/projects/{projectId}/tasks", h.createTask).Methods("POST")
	p.HandleFunc("/tasks/{id}", h.updateTask).Methods("PATCH")
	p.HandleFunc("/tasks/{id}", h.deleteTask).Methods("DELETE")
	p.HandleFunc("/projects/{projectId}/interests", h.expressInterest).Methods("POST")
	p.HandleFunc("/projects/{projectId}/interests", h.getInterests).Methods("GET")
	p.HandleFunc("/interests/{interestId}", h.updateInterest).Methods("PATCH")
	p.HandleFunc("/projects/{projectId}/chat", h.projectChat).Methods("GET")
	p.HandleFunc("/conversations", h.listConvs).Methods("GET")
	p.HandleFunc("/conversations", h.openConv).Methods("POST")
	p.HandleFunc("/conversations/{id}/rename", h.renameGroup).Methods("PATCH")
	p.HandleFunc("/conversations/{id}/members", h.addGroupMember).Methods("POST")
	p.HandleFunc("/conversations/{id}/members/{userId}", h.removeGroupMember).Methods("DELETE")
	p.HandleFunc("/conversations/{id}/messages", h.getMessages).Methods("GET")
	p.HandleFunc("/conversations/{id}/messages", h.sendMessage).Methods("POST")
	p.HandleFunc("/notifications", h.getNotifs).Methods("GET")
	p.HandleFunc("/notifications/read", h.markNotifs).Methods("POST")
	return r
}

func main() {
	cfg := loadConfig()
	initLogger(cfg.Env)
	defer log.Sync()
	rand.Seed(time.Now().UnixNano())
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()
	database, err := newDB(ctx, cfg.DatabaseURL)
	if err != nil {
		log.Fatal("db init failed", zap.Error(err))
	}
	defer database.close()
	database.migrate(context.Background())
	hub := newHub()
	go hub.run()
	auth := newAuth(cfg.JWTSecret)
	svc := &Svc{db: database, auth: auth, hub: hub}
	bgCtx, bgCancel := context.WithCancel(context.Background())
	defer bgCancel()
	svc.startBackgroundJobs(bgCtx)
	handler := &H{svc: svc}
	router := buildRouter(handler, auth)
	srv := &http.Server{Addr: ":" + cfg.Port, Handler: router, ReadTimeout: 15 * time.Second, WriteTimeout: 15 * time.Second, IdleTimeout: 60 * time.Second}
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	go func() {
		log.Info("FounderLink API ready", zap.String("port", cfg.Port), zap.String("env", cfg.Env))
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatal("server error", zap.Error(err))
		}
	}()
	<-quit
	log.Info("shutting down…")
	shutCtx, shutCancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer shutCancel()
	srv.Shutdown(shutCtx)
	log.Info("stopped")
}

type wrappedWriter struct {
	http.ResponseWriter
}

// ✅ This is the key fix
func (w wrappedWriter) Hijack() (net.Conn, *bufio.ReadWriter, error) {
	return w.ResponseWriter.(http.Hijacker).Hijack()
}
