<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1.0"/>
<title>FounderLink — Where Founders Meet Capital</title>
<script src="https://cdn.tailwindcss.com"></script>
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
<script>tailwind.config={darkMode:'class',theme:{extend:{fontFamily:{display:['Syne','sans-serif'],body:['Outfit','sans-serif']}}}}</script>
<style>
:root{
  --bg:#f5f7fc;--bg2:#ffffff;--bg3:#f0f4fb;--bg4:#e6ecf7;
  --border:#e2e8f0;--border2:#cbd5e1;
  --accent:#4f46e5;--accent2:#6366f1;--accent3:#06b6d4;
  --gold:#f59e0b;--green:#10b981;--red:#ef4444;--orange:#f97316;--pink:#ec4899;--purple:#8b5cf6;
  --text:#0f172a;--text2:#475569;--text3:#94a3b8;
  --card:#ffffff;--card2:#f8fafc;
  --glow:rgba(79,70,229,.07);--glow2:rgba(79,70,229,.14);
  --shadow:0 1px 3px rgba(0,0,0,.06),0 1px 2px rgba(0,0,0,.04);
  --shadow2:0 4px 12px rgba(0,0,0,.07),0 2px 4px rgba(0,0,0,.04);
  --shadow3:0 20px 40px rgba(0,0,0,.09),0 8px 16px rgba(0,0,0,.05);
  --nav:60px;--sb:256px;--rp:278px;--r:14px;--r2:22px;
  --ff:'Syne',sans-serif;--fb:'Outfit',sans-serif;
  --tr:0.18s cubic-bezier(0.4,0,0.2,1);
}
html.dark{
  --bg:#060810;--bg2:#0b0e19;--bg3:#111624;--bg4:#171d2f;
  --border:#1c2235;--border2:#252d47;
  --accent:#6366f1;--accent2:#818cf8;
  --text:#e2e8f0;--text2:#8892b0;--text3:#475569;
  --card:#0c1019;--card2:#101524;
  --glow:rgba(99,102,241,.11);--glow2:rgba(99,102,241,.2);
  --shadow:0 1px 3px rgba(0,0,0,.4);
  --shadow2:0 4px 12px rgba(0,0,0,.4);
  --shadow3:0 20px 40px rgba(0,0,0,.6);
}
*,*::before,*::after{box-sizing:border-box;margin:0;padding:0;-webkit-font-smoothing:antialiased}
html{scroll-behavior:smooth}
body{font-family:var(--fb);background:var(--bg);color:var(--text);min-height:100vh;transition:background var(--tr),color var(--tr)}
a{text-decoration:none;color:inherit}img{max-width:100%}
::-webkit-scrollbar{width:5px;height:5px}::-webkit-scrollbar-track{background:transparent}::-webkit-scrollbar-thumb{background:var(--border2);border-radius:4px}::-webkit-scrollbar-thumb:hover{background:var(--accent2)}
@keyframes fadeUp{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:none}}
@keyframes fadeIn{from{opacity:0}to{opacity:1}}
@keyframes scaleIn{from{opacity:0;transform:scale(0.94)}to{opacity:1;transform:none}}
@keyframes spin{to{transform:rotate(360deg)}}
@keyframes pulse{0%,100%{opacity:1}50%{opacity:.4}}
@keyframes tIn{from{opacity:0;transform:translateX(20px) scale(0.95)}to{opacity:1;transform:none}}
@keyframes float{0%,100%{transform:translateY(0)}50%{transform:translateY(-22px)}}
@keyframes slideRight{from{transform:translateX(0)}to{transform:translateX(-50%)}}
@keyframes glow{0%,100%{box-shadow:0 0 6px 1px rgba(16,185,129,.5)}50%{box-shadow:0 0 14px 3px rgba(16,185,129,.8)}}
@keyframes shimmer{0%{background-position:-200% 0}100%{background-position:200% 0}}
.anim-float{animation:float 7s ease-in-out infinite}
.anim-float-slow{animation:float 9s ease-in-out infinite reverse}
.anim-fade-up{animation:fadeUp .25s ease both}
.anim-scale-in{animation:scaleIn .22s cubic-bezier(0.34,1.56,0.64,1) both}
.anim-pulse{animation:pulse 2s infinite}
.anim-ticker{animation:slideRight 22s linear infinite}
.hidden{display:none!important}.pointer{cursor:pointer}
.truncate{overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
.hero-gradient{background:radial-gradient(ellipse 80% 60% at 50% -10%,rgba(99,102,241,.22) 0%,transparent 70%),radial-gradient(ellipse 50% 40% at 80% 60%,rgba(16,185,129,.12) 0%,transparent 60%)}
html.dark .hero-gradient{background:radial-gradient(ellipse 80% 60% at 50% -10%,rgba(99,102,241,.35) 0%,transparent 70%)}
.grid-bg{background-image:linear-gradient(rgba(99,102,241,.08) 1px,transparent 1px),linear-gradient(90deg,rgba(99,102,241,.08) 1px,transparent 1px);background-size:60px 60px}
html.dark .grid-bg{background-image:linear-gradient(rgba(99,102,241,.15) 1px,transparent 1px),linear-gradient(90deg,rgba(99,102,241,.15) 1px,transparent 1px)}

/* ── AUTH ── */
#auth{display:none;background:var(--bg);min-height:100vh;align-items:center;justify-content:center;padding:20px;position:relative;overflow:hidden}
.auth-orb1{position:absolute;top:-80px;left:-80px;width:340px;height:340px;border-radius:50%;background:radial-gradient(circle,rgba(79,70,229,.22),transparent 70%);pointer-events:none;animation:float 7s ease-in-out infinite}
.auth-orb2{position:absolute;bottom:-100px;right:-60px;width:300px;height:300px;border-radius:50%;background:radial-gradient(circle,rgba(16,185,129,.18),transparent 70%);pointer-events:none;animation:float 9s ease-in-out infinite reverse}
.auth-box{background:var(--card);border:1.5px solid var(--border2);border-radius:var(--r2);padding:42px 38px;width:100%;max-width:480px;box-shadow:var(--shadow3);position:relative;z-index:1;animation:scaleIn .35s cubic-bezier(0.34,1.56,0.64,1) both}
.auth-tabs{display:flex;background:var(--bg3);border-radius:10px;padding:4px;margin-bottom:24px;gap:4px;border:1.5px solid var(--border)}
.auth-tab{flex:1;padding:9px;border-radius:7px;border:none;background:transparent;color:var(--text2);font-family:var(--fb);font-size:13px;font-weight:600;cursor:pointer;transition:var(--tr)}
.auth-tab.on{background:var(--card);color:var(--accent);box-shadow:var(--shadow)}

/* ── APP SHELL ── */
#app{display:none;flex-direction:column;min-height:100vh}
#app.on{display:flex}
#app-layout{display:flex;flex:1;max-width:1280px;margin:0 auto;width:100%;padding:20px 14px;gap:18px}

/* ── REUSABLE ── */
.card-base{background:var(--card);border:1.5px solid var(--border);border-radius:var(--r);box-shadow:var(--shadow);transition:border-color var(--tr),box-shadow var(--tr)}
.card-base:hover{border-color:var(--border2)}
.btn{display:inline-flex;align-items:center;justify-content:center;gap:6px;padding:9px 18px;border-radius:10px;border:none;font-family:var(--fb);font-size:13px;font-weight:600;cursor:pointer;transition:var(--tr);white-space:nowrap;position:relative;overflow:hidden}
.btn:active{transform:scale(0.98)}
.btn-p{background:var(--accent);color:#fff;box-shadow:0 4px 14px rgba(79,70,229,.3)}
.btn-p:hover{box-shadow:0 6px 20px rgba(79,70,229,.45);transform:translateY(-1px)}
.btn-g{background:var(--card);color:var(--text2);border:1.5px solid var(--border2);box-shadow:var(--shadow)}
.btn-g:hover{border-color:var(--accent);color:var(--accent);background:var(--glow)}
.btn-d{background:rgba(239,68,68,.1);color:var(--red);border:1.5px solid rgba(239,68,68,.2)}
.btn-d:hover{background:rgba(239,68,68,.2)}
.btn-success{background:rgba(16,185,129,.1);color:var(--green);border:1.5px solid rgba(16,185,129,.2)}
.btn-success:hover{background:rgba(16,185,129,.2)}
.btn-warn{background:rgba(245,158,11,.1);color:var(--gold);border:1.5px solid rgba(245,158,11,.2)}
.btn-warn:hover{background:rgba(245,158,11,.2)}
.btn-sm{padding:6px 12px;font-size:12px;border-radius:8px}
.btn-xs{padding:4px 9px;font-size:11px;border-radius:6px}
.btn-full{width:100%}
.btn-shine::after{content:'';position:absolute;top:-50%;left:-60%;width:40%;height:200%;background:rgba(255,255,255,.2);transform:skewX(-20deg);transition:.6s}
.btn-shine:hover::after{left:110%}
.follow-btn{padding:6px 14px;border-radius:20px;font-size:12px;font-weight:700;border:1.5px solid var(--accent);background:transparent;color:var(--accent);cursor:pointer;transition:var(--tr);font-family:var(--fb);white-space:nowrap}
.follow-btn:hover{background:var(--accent);color:#fff}
.follow-btn.following{background:transparent;color:var(--text2);border-color:var(--border2)}
.follow-btn.following:hover{border-color:var(--red);color:var(--red)}
.follow-btn.pending{color:var(--gold);border-color:var(--gold)}
.inp{width:100%;padding:10px 13px;background:var(--bg3);border:1.5px solid var(--border2);border-radius:10px;color:var(--text);font-family:var(--fb);font-size:13px;outline:none;transition:var(--tr)}
.inp:focus{border-color:var(--accent);background:var(--card);box-shadow:0 0 0 4px var(--glow2)}
.inp::placeholder{color:var(--text3)}
.inp-label{font-size:11px;color:var(--text2);font-weight:700;text-transform:uppercase;letter-spacing:.05em;margin-bottom:5px;display:block}
.fg{margin-bottom:14px}
select.inp{cursor:pointer}textarea.inp{resize:vertical;line-height:1.6}
.av{border-radius:50%;display:flex;align-items:center;justify-content:center;font-weight:700;color:#fff;flex-shrink:0;overflow:hidden}
.av img{width:100%;height:100%;object-fit:cover}
.av-xs{width:28px;height:28px;font-size:10px}.av-sm{width:36px;height:36px;font-size:13px}
.av-md{width:44px;height:44px;font-size:16px}.av-lg{width:64px;height:64px;font-size:22px}
.av-xl{width:88px;height:88px;font-size:32px}
.badge{padding:2px 8px;border-radius:20px;font-size:10px;font-weight:800;text-transform:uppercase;letter-spacing:.05em}
.badge-post{background:rgba(79,70,229,.12);color:var(--accent2)}.badge-idea{background:rgba(245,158,11,.15);color:var(--gold)}
.badge-article{background:rgba(6,182,212,.12);color:var(--accent3)}.badge-pitch{background:rgba(16,185,129,.12);color:var(--green)}
.badge-story{background:rgba(249,115,22,.12);color:var(--orange)}
.tag{padding:4px 10px;border-radius:20px;background:var(--bg3);border:1.5px solid var(--border2);color:var(--text2);font-size:12px;cursor:pointer;transition:var(--tr)}
.tag:hover{border-color:var(--accent);color:var(--accent);background:var(--glow)}
.chip{padding:4px 11px;border-radius:20px;font-size:11px;font-weight:600;background:var(--glow);color:var(--accent2);border:1.5px solid rgba(79,70,229,.2)}
.role-badge{padding:3px 8px;border-radius:18px;font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.04em}
.role-admin{background:rgba(239,68,68,.12);color:var(--red)}.role-founder{background:rgba(79,70,229,.12);color:var(--accent)}
.role-cofounder,.role-co-founder{background:rgba(99,102,241,.1);color:var(--accent2)}
.role-developer,.role-cto,.role-engineer{background:rgba(6,182,212,.12);color:var(--accent3)}
.role-designer{background:rgba(236,72,153,.12);color:var(--pink)}.role-marketer,.role-cmo{background:rgba(245,158,11,.12);color:var(--gold)}
.role-investor{background:rgba(16,185,129,.12);color:var(--green)}.role-advisor{background:rgba(249,115,22,.12);color:var(--orange)}

/* ── TOASTS ── */
#toasts{position:fixed;bottom:22px;right:22px;z-index:9999;display:flex;flex-direction:column;gap:7px}
.toast{padding:11px 16px;border-radius:12px;font-size:13px;font-weight:500;display:flex;align-items:center;gap:9px;max-width:320px;backdrop-filter:blur(20px);animation:tIn .28s cubic-bezier(0.34,1.56,0.64,1) both;box-shadow:var(--shadow3)}
.toast-s{background:rgba(16,185,129,.15);color:#10b981;border:1.5px solid rgba(16,185,129,.3)}
.toast-e{background:rgba(239,68,68,.15);color:#ef4444;border:1.5px solid rgba(239,68,68,.3)}
.toast-i{background:rgba(79,70,229,.12);color:var(--accent2);border:1.5px solid rgba(79,70,229,.25)}

/* ── NAV ── */
#appnav{height:var(--nav);background:rgba(247,248,252,.93);backdrop-filter:blur(24px);-webkit-backdrop-filter:blur(24px);border-bottom:1.5px solid var(--border);display:flex;align-items:center;padding:0 18px;gap:12px;position:sticky;top:0;z-index:300;transition:background var(--tr)}
html.dark #appnav{background:rgba(6,8,16,.93)}
.nav-logo{font-family:var(--ff);font-size:20px;font-weight:800;background:linear-gradient(135deg,var(--accent),var(--accent3));-webkit-background-clip:text;-webkit-text-fill-color:transparent;white-space:nowrap;cursor:pointer;letter-spacing:-.3px}
.nav-search{flex:1;max-width:360px;position:relative}
.nav-search input{width:100%;padding:9px 14px 9px 38px;background:var(--bg3);border:1.5px solid var(--border2);border-radius:24px;color:var(--text);font-family:var(--fb);font-size:13px;outline:none;transition:var(--tr)}
.nav-search input:focus{border-color:var(--accent);background:var(--card);box-shadow:0 0 0 4px var(--glow2)}
.nav-search input::placeholder{color:var(--text3)}
.nav-si{position:absolute;left:12px;top:50%;transform:translateY(-50%);color:var(--text3);font-size:14px;pointer-events:none}
.nav-acts{display:flex;align-items:center;gap:6px;margin-left:auto}
.nav-ico{width:38px;height:38px;border-radius:50%;background:var(--bg3);border:1.5px solid var(--border);display:flex;align-items:center;justify-content:center;cursor:pointer;color:var(--text2);font-size:15px;position:relative;transition:var(--tr)}
.nav-ico:hover{border-color:var(--accent);color:var(--accent);background:var(--glow)}
.nav-badge{position:absolute;top:-3px;right:-3px;background:var(--red);color:#fff;font-size:9px;font-weight:700;min-width:16px;height:16px;border-radius:8px;display:flex;align-items:center;justify-content:center;padding:0 3px;border:2px solid var(--bg)}
.ws-dot{width:8px;height:8px;border-radius:50%;background:var(--green);animation:glow 2s infinite;flex-shrink:0}
.ws-dot.offline{background:var(--text3);animation:none;box-shadow:none}

/* ── SIDEBAR ── */
#sidebar{width:var(--sb);flex-shrink:0;position:sticky;top:calc(var(--nav) + 20px);height:fit-content;display:flex;flex-direction:column;gap:10px}
.sb-profile{background:var(--card);border:1.5px solid var(--border);border-radius:var(--r);overflow:hidden;box-shadow:var(--shadow)}
.sb-cover{height:62px;background:linear-gradient(135deg,var(--accent),var(--pink),var(--accent3))}
.sb-av-row{padding:0 14px;margin-top:-22px;margin-bottom:10px;display:flex;align-items:flex-end}
.sb-av{width:44px;height:44px;border-radius:50%;border:3px solid var(--card);background:linear-gradient(135deg,var(--accent),var(--accent3));display:flex;align-items:center;justify-content:center;font-weight:700;font-size:16px;color:#fff;overflow:hidden;cursor:pointer}
.sb-av img{width:100%;height:100%;object-fit:cover}
.sb-info{padding:0 14px 14px}
.sb-name{font-family:var(--ff);font-size:14px;font-weight:700;cursor:pointer;transition:var(--tr)}
.sb-name:hover{color:var(--accent)}
.sb-username{font-size:11px;color:var(--text3);margin-top:1px}
.sb-role{font-size:12px;color:var(--text2);margin-top:2px}
.sb-stats{display:grid;grid-template-columns:1fr 1fr;border-top:1.5px solid var(--border);margin-top:10px}
.sb-stat{padding:10px;text-align:center;cursor:pointer;transition:var(--tr);border-right:1.5px solid var(--border)}
.sb-stat:last-child{border-right:none}.sb-stat:hover .sbn{color:var(--accent)}
.sbn{font-size:16px;font-weight:700;font-family:var(--ff);color:var(--text)}
.sbl{font-size:10px;color:var(--text3);font-weight:600;text-transform:uppercase;letter-spacing:.04em}
.nav-menu{background:var(--card);border:1.5px solid var(--border);border-radius:var(--r);overflow:hidden;box-shadow:var(--shadow)}
.ni{display:flex;align-items:center;gap:10px;padding:10px 14px;cursor:pointer;font-size:13px;font-weight:500;color:var(--text2);transition:var(--tr);border-left:3px solid transparent}
.ni:hover{background:var(--bg3);color:var(--text)}
.ni.on{color:var(--accent);background:var(--glow);border-left-color:var(--accent);font-weight:600}
.ni-ico{font-size:16px;width:20px;text-align:center}
.ni-badge{background:var(--red);color:#fff;font-size:9px;font-weight:700;min-width:16px;height:16px;border-radius:8px;display:flex;align-items:center;justify-content:center;padding:0 3px;margin-left:auto}

/* ── MAIN / RPANEL ── */
#main{flex:1;min-width:0}
#rpanel{width:var(--rp);flex-shrink:0;position:sticky;top:calc(var(--nav) + 20px);height:fit-content;display:flex;flex-direction:column;gap:10px}
.widget{background:var(--card);border:1.5px solid var(--border);border-radius:var(--r);box-shadow:var(--shadow)}
.widget-title{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;color:var(--text2);padding:11px 14px;border-bottom:1.5px solid var(--border)}
.widget-item{display:flex;align-items:center;gap:10px;padding:10px 12px;border-bottom:1.5px solid var(--border);transition:var(--tr);cursor:pointer}
.widget-item:last-child{border-bottom:none}.widget-item:hover{background:var(--bg3)}

/* ── POSTS ── */
.post{background:var(--card);border:1.5px solid var(--border);border-radius:var(--r);margin-bottom:12px;animation:fadeUp .25s ease both;transition:var(--tr);box-shadow:var(--shadow)}
.post:hover{border-color:var(--border2);box-shadow:var(--shadow2)}
.post-hd{padding:13px 16px 10px;display:flex;gap:10px;align-items:flex-start}
.post-meta{flex:1;min-width:0}.post-name{font-weight:600;font-size:13px;cursor:pointer;display:flex;align-items:center;gap:5px}
.post-name:hover{color:var(--accent)}.post-sub{font-size:11px;color:var(--text2);margin-top:1px}
.post-body{padding:0 16px 12px}
.post-title{font-family:var(--ff);font-size:17px;font-weight:700;margin-bottom:6px;line-height:1.3}
.post-txt{font-size:13px;color:var(--text2);line-height:1.7;white-space:pre-wrap}
.post-tags{display:flex;flex-wrap:wrap;gap:5px;padding:0 16px 10px}
.post-acts{padding:9px 16px;border-top:1.5px solid var(--border);display:flex;align-items:center;gap:2px}
.pa{display:flex;align-items:center;gap:5px;padding:6px 10px;border-radius:8px;background:transparent;border:none;color:var(--text2);font-size:12px;font-weight:500;cursor:pointer;font-family:var(--fb);transition:var(--tr)}
.pa:hover{background:var(--bg3);color:var(--text)}.pa.liked{color:var(--red)}.pa.bkd{color:var(--gold)}.pa-ico{font-size:14px}
.vote-bar{display:flex;gap:6px;align-items:center;margin-top:10px;padding-top:10px;border-top:1.5px solid var(--border)}
.vote-btn{display:flex;align-items:center;gap:5px;padding:5px 12px;border-radius:18px;border:1.5px solid var(--border2);background:transparent;color:var(--text2);font-size:12px;font-weight:600;cursor:pointer;font-family:var(--fb);transition:var(--tr)}
.vote-btn:hover{background:var(--bg3)}.vote-btn.up.active{background:rgba(16,185,129,.1);border-color:var(--green);color:var(--green)}
.vote-btn.down.active{background:rgba(239,68,68,.1);border-color:var(--red);color:var(--red)}
.vote-score{font-size:13px;font-weight:700;color:var(--text);padding:0 4px}
.composer{background:var(--card);border:1.5px solid var(--border);border-radius:var(--r);padding:14px 16px;margin-bottom:14px;box-shadow:var(--shadow)}
.comp-fake{flex:1;background:var(--bg3);border:1.5px solid var(--border2);border-radius:24px;padding:10px 18px;color:var(--text3);font-size:13px;cursor:pointer;transition:var(--tr)}
.comp-fake:hover{background:var(--bg2);border-color:var(--accent)}
.comp-btn{display:flex;align-items:center;gap:5px;padding:6px 12px;border-radius:18px;background:transparent;border:1.5px solid var(--border2);color:var(--text2);font-size:11px;font-weight:600;cursor:pointer;font-family:var(--fb);transition:var(--tr)}
.comp-btn:hover{border-color:var(--accent);color:var(--accent);background:var(--glow)}
.comp-ta{width:100%;min-height:120px;background:var(--bg3);border:1.5px solid var(--border2);border-radius:10px;padding:12px;color:var(--text);font-family:var(--fb);font-size:13px;outline:none;resize:vertical;line-height:1.65;transition:var(--tr)}
.comp-ta:focus{border-color:var(--accent);background:var(--card)}.comp-ta::placeholder{color:var(--text3)}
.live-banner{display:none;background:linear-gradient(135deg,var(--accent),var(--accent3));border-radius:10px;padding:10px 16px;margin-bottom:12px;cursor:pointer;font-size:13px;font-weight:600;color:#fff;align-items:center;gap:8px;animation:fadeUp .3s ease;box-shadow:0 4px 16px rgba(79,70,229,.3)}
.live-banner.show{display:flex}
.pt-btn{padding:6px 13px;border-radius:18px;font-size:11px;font-weight:700;border:1.5px solid var(--border2);background:transparent;color:var(--text2);cursor:pointer;font-family:var(--fb);transition:var(--tr)}
.pt-btn.on{border-color:var(--accent);color:var(--accent);background:var(--glow)}

/* ── PROJECTS ── */
.pj{background:var(--card);border:1.5px solid var(--border);border-radius:var(--r);overflow:hidden;cursor:pointer;transition:var(--tr);animation:fadeUp .25s ease both;box-shadow:var(--shadow)}
.pj:hover{border-color:var(--accent);transform:translateY(-3px);box-shadow:var(--shadow3)}
.pj-cover{height:128px;background:linear-gradient(135deg,var(--bg3),var(--bg4));position:relative;overflow:hidden;display:flex;align-items:center;justify-content:center;font-size:42px}
.pj-cover img{width:100%;height:100%;object-fit:cover;position:absolute;inset:0}
.pj-stage{position:absolute;top:8px;right:8px;padding:3px 9px;border-radius:20px;font-size:10px;font-weight:800;text-transform:uppercase;backdrop-filter:blur(10px);letter-spacing:.04em}
.st-idea{background:rgba(245,158,11,.25);color:var(--gold);border:1px solid rgba(245,158,11,.4)}
.st-mvp{background:rgba(6,182,212,.25);color:var(--accent3);border:1px solid rgba(6,182,212,.4)}
.st-seed{background:rgba(16,185,129,.25);color:var(--green);border:1px solid rgba(16,185,129,.4)}
.st-growth{background:rgba(79,70,229,.25);color:var(--accent2);border:1px solid rgba(79,70,229,.4)}
.st-scale{background:rgba(239,68,68,.25);color:var(--red);border:1px solid rgba(239,68,68,.4)}
.pj-logo{position:absolute;bottom:-15px;left:14px;width:38px;height:38px;border-radius:9px;border:2px solid var(--card);background:var(--bg2);display:flex;align-items:center;justify-content:center;font-size:16px;box-shadow:var(--shadow)}
.pj-body{padding:20px 14px 14px}.pj-name{font-family:var(--ff);font-size:16px;font-weight:700;margin-bottom:3px}
.pj-line{font-size:12px;color:var(--text2);margin-bottom:8px;line-height:1.4}
.pj-foot{display:flex;align-items:center;justify-content:space-between;padding-top:10px;border-top:1.5px solid var(--border)}
.pj-mi{background:var(--bg3);border-radius:8px;padding:2px 6px}
.progress-track{background:var(--bg3);border-radius:100px;height:8px;overflow:hidden;border:1px solid var(--border)}
.progress-fill{height:100%;border-radius:100px;background:linear-gradient(90deg,var(--accent),var(--accent3));transition:width .4s ease}

/* ── PROJECT WORKSPACE ── */
.pj-workspace{display:flex;flex-direction:column;min-height:calc(100vh - var(--nav));margin:-20px -14px}
.pj-topnav{background:var(--card);border-bottom:1.5px solid var(--border);padding:0 14px;display:flex;align-items:center;gap:2px;position:sticky;top:var(--nav);z-index:200;height:52px;box-shadow:var(--shadow);overflow-x:auto;flex-shrink:0}
.pj-topnav::-webkit-scrollbar{height:0}
.pj-topnav-logo{width:28px;height:28px;border-radius:7px;background:var(--bg3);display:flex;align-items:center;justify-content:center;font-size:14px;flex-shrink:0;border:1.5px solid var(--border);cursor:pointer}
.pj-topnav-name{font-family:var(--ff);font-size:14px;font-weight:700;white-space:nowrap;cursor:pointer;flex-shrink:0;padding:0 4px;color:var(--text2)}
.pj-topnav-name:hover{color:var(--accent)}
.pj-topnav-sep{color:var(--border2);flex-shrink:0;font-size:18px;padding:0 2px}
.pj-topnav-title{font-family:var(--ff);font-size:14px;font-weight:700;white-space:nowrap;flex-shrink:0;padding:0 6px}
.pj-sep-line{width:1px;height:22px;background:var(--border);margin:0 4px;flex-shrink:0}
.pj-nav-btn{padding:5px 11px;border-radius:8px;background:transparent;border:1px solid transparent;color:var(--text2);font-family:var(--fb);font-size:12px;font-weight:600;cursor:pointer;transition:var(--tr);display:flex;align-items:center;gap:4px;white-space:nowrap;flex-shrink:0}
.pj-nav-btn:hover{background:var(--bg3);color:var(--text)}
.pj-nav-btn.on{background:var(--glow);color:var(--accent);border-color:rgba(79,70,229,.2)}
.pj-content{flex:1;padding:20px 16px;overflow-x:hidden;min-height:0}
.sec-block{background:var(--bg3);border-radius:10px;padding:16px;margin-bottom:10px;border:1.5px solid var(--border)}
.sec-block h4{font-family:var(--ff);font-size:13px;font-weight:700;margin-bottom:7px;color:var(--accent2)}
.sec-block p{font-size:13px;color:var(--text2);line-height:1.65}
/* notes section style */
.sec-notes{border-color:rgba(245,158,11,.3);background:rgba(245,158,11,.05)}
.sec-notes h4{color:var(--gold)}
/* coming soon style */
.sec-coming-soon{border:1.5px solid rgba(139,92,246,.35);background:linear-gradient(135deg,rgba(139,92,246,.07),rgba(79,70,229,.04));position:relative;overflow:hidden}
.sec-coming-soon::after{content:'';position:absolute;inset:0;background:linear-gradient(90deg,transparent,rgba(139,92,246,.06),transparent);background-size:200% 100%;animation:shimmer 3s linear infinite}
.sec-coming-soon h4{color:#8b5cf6}

/* ── KANBAN ── */
.kanban{display:flex;gap:12px;overflow-x:auto;padding:4px 2px 20px;align-items:flex-start;scrollbar-width:thin}
.kb-col{width:258px;flex-shrink:0;background:var(--bg3);border-radius:12px;border:1.5px solid var(--border);display:flex;flex-direction:column;max-height:calc(100vh - 200px);transition:border-color var(--tr),background var(--tr)}
.kb-col.drag-over{background:var(--glow);border-color:var(--accent);box-shadow:0 0 0 2px rgba(79,70,229,.2)}
.kb-col-hd{padding:10px 12px;display:flex;align-items:center;justify-content:space-between;border-bottom:1.5px solid var(--border);flex-shrink:0}
.kb-col-title{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.06em;display:flex;align-items:center;gap:6px}
.kb-col-count{font-size:10px;font-weight:700;padding:2px 7px;border-radius:10px;background:var(--bg4);color:var(--text2)}
.kb-add-btn{width:24px;height:24px;border-radius:6px;background:transparent;border:none;color:var(--text3);font-size:18px;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:var(--tr);line-height:1}
.kb-add-btn:hover{background:var(--border);color:var(--accent)}
.kb-cards{flex:1;overflow-y:auto;padding:8px;display:flex;flex-direction:column;gap:7px;min-height:60px}
.kb-card{background:var(--card);border:1.5px solid var(--border);border-radius:9px;padding:10px 12px;cursor:grab;transition:var(--tr);animation:fadeIn .2s ease;border-left:3px solid transparent;user-select:none}
.kb-card:active{cursor:grabbing}
.kb-card:hover{box-shadow:var(--shadow2);border-color:var(--border2)}
.kb-card.dragging{opacity:.35;transform:scale(0.96);cursor:grabbing}
.kb-priority-low{border-left-color:var(--green)}.kb-priority-medium{border-left-color:var(--gold)}
.kb-priority-high{border-left-color:var(--orange)}.kb-priority-urgent{border-left-color:var(--red)}
.priority-dot{width:7px;height:7px;border-radius:50%;flex-shrink:0}
.priority-dot-low{background:var(--green)}.priority-dot-medium{background:var(--gold)}
.priority-dot-high{background:var(--orange)}.priority-dot-urgent{background:var(--red)}
.kb-tag{padding:2px 7px;border-radius:10px;font-size:10px;background:var(--bg3);color:var(--text2);border:1px solid var(--border)}
.kb-due{font-size:10px;color:var(--text3);display:flex;align-items:center;gap:3px}
.kb-due.overdue{color:var(--red)}.kb-assignee-av{width:22px;height:22px;border-radius:50%;background:var(--accent);display:flex;align-items:center;justify-content:center;font-size:9px;font-weight:700;color:#fff;flex-shrink:0;border:2px solid var(--card)}
/* task fullscreen */
.task-fs{position:fixed;inset:0;z-index:600;background:var(--bg);display:flex;flex-direction:column;overflow:hidden;animation:fadeIn .15s ease}
.task-fs-nav{padding:12px 20px;border-bottom:1.5px solid var(--border);display:flex;align-items:center;gap:10px;background:var(--card);flex-shrink:0}
.task-fs-body{flex:1;overflow:auto;padding:20px;display:flex;gap:16px}
.task-fs-main{flex:1;min-width:0}
.task-fs-side{width:260px;flex-shrink:0;display:flex;flex-direction:column;gap:10px}
.task-fs-field{background:var(--bg3);border:1.5px solid var(--border);border-radius:10px;padding:12px;font-size:13px;color:var(--text2)}
.task-fs-label{font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:var(--text3);margin-bottom:6px}

/* ── MESSAGES ── */
.msg-layout{display:flex;height:calc(100vh - var(--nav) - 56px);min-height:500px;border-radius:var(--r);overflow:hidden;border:1.5px solid var(--border);background:var(--card);box-shadow:var(--shadow2)}
.conv-panel{width:286px;flex-shrink:0;display:flex;flex-direction:column;border-right:1.5px solid var(--border)}
.conv-hd{padding:12px 14px;border-bottom:1.5px solid var(--border);font-family:var(--ff);font-size:14px;font-weight:700;display:flex;align-items:center;justify-content:space-between;background:var(--bg3)}
.conv-search{padding:7px 10px;border-bottom:1.5px solid var(--border)}
.conv-search input{width:100%;padding:7px 11px;background:var(--bg3);border:1.5px solid var(--border2);border-radius:18px;color:var(--text);font-size:12px;font-family:var(--fb);outline:none;transition:var(--tr)}
.conv-search input:focus{border-color:var(--accent)}
.conv-tabs{display:flex;border-bottom:1.5px solid var(--border)}
.conv-tab{flex:1;padding:8px 4px;font-size:10px;font-weight:700;cursor:pointer;color:var(--text2);background:transparent;border:none;font-family:var(--fb);text-transform:uppercase;letter-spacing:.04em;border-bottom:2px solid transparent;transition:var(--tr)}
.conv-tab.on{color:var(--accent);border-bottom-color:var(--accent);background:var(--glow)}
.conv-list{overflow-y:auto;flex:1}
.ci{padding:10px 12px;border-bottom:1.5px solid var(--border);cursor:pointer;display:flex;align-items:center;gap:9px;transition:var(--tr)}
.ci:hover,.ci.on{background:var(--bg3)}
.ci.on{background:var(--glow);border-left:3px solid var(--accent)}
.ci-info{flex:1;min-width:0}.ci-name{font-weight:600;font-size:12px}
.ci-last{font-size:11px;color:var(--text2);white-space:nowrap;overflow:hidden;text-overflow:ellipsis;margin-top:2px}
.ci-meta{display:flex;flex-direction:column;align-items:flex-end;gap:3px;flex-shrink:0}
.ci-time{font-size:10px;color:var(--text3)}
.ci-unread{background:var(--accent);color:#fff;font-size:9px;font-weight:700;min-width:16px;height:16px;border-radius:8px;display:flex;align-items:center;justify-content:center;padding:0 3px}
.chat-panel{flex:1;display:flex;flex-direction:column;min-width:0;background:var(--card2)}
.chat-hd{padding:11px 14px;border-bottom:1.5px solid var(--border);display:flex;align-items:center;gap:10px;background:var(--card);flex-shrink:0}
.chat-hd-btn{width:30px;height:30px;border-radius:8px;background:var(--bg3);border:1.5px solid var(--border);display:flex;align-items:center;justify-content:center;cursor:pointer;color:var(--text2);font-size:12px;transition:var(--tr)}
.chat-hd-btn:hover{border-color:var(--accent);color:var(--accent);background:var(--glow)}
.chat-msgs{flex:1;overflow-y:auto;padding:16px;display:flex;flex-direction:column;gap:3px}
.mb-wrap{display:flex;flex-direction:column}
.mb-wrap.me{align-items:flex-end}.mb-wrap.them{align-items:flex-start}
.mb{max-width:68%;padding:10px 14px;border-radius:16px;font-size:13px;line-height:1.55;animation:fadeUp .2s ease;word-break:break-word}
.mb.me{background:var(--accent);color:#fff;border-bottom-right-radius:4px}
.mb.them{background:var(--bg3);color:var(--text);border-bottom-left-radius:4px;border:1.5px solid var(--border)}
.mb-time{font-size:10px;color:var(--text3);margin-top:2px;padding:0 3px}
.date-divider{text-align:center;font-size:11px;color:var(--text3);padding:6px 0;font-weight:600}
.typing-ind{padding:0 16px 4px;font-size:11px;color:var(--text3);min-height:18px;flex-shrink:0}
.chat-in{padding:11px 13px;border-top:1.5px solid var(--border);display:flex;gap:8px;align-items:flex-end;background:var(--card);flex-shrink:0}
.chat-ta{flex:1;background:var(--bg3);border:1.5px solid var(--border2);border-radius:18px;padding:9px 14px;color:var(--text);font-family:var(--fb);font-size:13px;outline:none;resize:none;max-height:100px;line-height:1.5;transition:var(--tr)}
.chat-ta:focus{border-color:var(--accent);background:var(--card)}.chat-ta::placeholder{color:var(--text3)}
.chat-send{width:38px;height:38px;border-radius:50%;background:var(--accent);border:none;color:#fff;font-size:16px;cursor:pointer;flex-shrink:0;display:flex;align-items:center;justify-content:center;transition:var(--tr);box-shadow:0 4px 12px rgba(79,70,229,.3)}
.chat-send:hover{background:var(--accent2);transform:scale(1.07)}
.chat-empty{flex:1;display:flex;align-items:center;justify-content:center;flex-direction:column;gap:10px;color:var(--text3)}
.grp-manage{padding:12px 14px;border-top:1.5px solid var(--border);background:var(--bg3);flex-shrink:0}

/* ── NOTIFICATIONS ── */
.notif{display:flex;align-items:flex-start;gap:11px;padding:13px 16px;border-bottom:1.5px solid var(--border);transition:var(--tr);cursor:pointer}
.notif:hover{background:var(--bg3)}.notif.unread{background:rgba(79,70,229,.04)}
.notif-ic{width:38px;height:38px;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:16px;flex-shrink:0}
.n-like .notif-ic{background:rgba(239,68,68,.12);color:var(--red)}
.n-follow .notif-ic,.n-follow_request .notif-ic,.n-follow_accepted .notif-ic{background:rgba(79,70,229,.12);color:var(--accent2)}
.n-comment .notif-ic{background:rgba(6,182,212,.12);color:var(--accent3)}
.n-investor_interest .notif-ic{background:rgba(245,158,11,.12);color:var(--gold)}
.n-team_invite .notif-ic,.n-project_invite .notif-ic{background:rgba(16,185,129,.12);color:var(--green)}
.notif-msg{font-size:13px;color:var(--text2);line-height:1.4}.notif-msg strong{color:var(--text);font-weight:600}
.notif-time{font-size:11px;color:var(--text3);margin-top:3px}.udot{width:7px;height:7px;border-radius:50%;background:var(--accent);flex-shrink:0;margin-top:5px}

/* ── PROFILE ── */
.prof-cover{height:188px;border-radius:var(--r) var(--r) 0 0;background:linear-gradient(135deg,var(--accent),var(--pink),var(--accent3));position:relative;overflow:hidden}
.prof-cover img{width:100%;height:100%;object-fit:cover}
.prof-info{background:var(--card);border:1.5px solid var(--border);border-radius:0 0 var(--r) var(--r);padding:0 20px 20px;margin-bottom:14px;box-shadow:var(--shadow)}
.prof-av{width:82px;height:82px;border-radius:50%;border:4px solid var(--card);overflow:hidden;display:flex;align-items:center;justify-content:center;font-size:28px;font-weight:700;color:#fff}
.prof-av img{width:100%;height:100%;object-fit:cover}
.prof-name{font-family:var(--ff);font-size:22px;font-weight:800;letter-spacing:-.5px;display:flex;align-items:center;gap:7px}
.prof-hl{color:var(--text2);font-size:13px;margin:3px 0 8px}
.psn{font-family:var(--ff);font-size:20px;font-weight:700}.psl{font-size:11px;color:var(--text3);text-transform:uppercase;letter-spacing:.04em;margin-top:1px}
.skill{padding:4px 11px;border-radius:18px;font-size:11px;background:var(--bg3);border:1.5px solid var(--border2);color:var(--text2)}

/* ── MODAL ── */
.mo{position:fixed;inset:0;background:rgba(0,0,0,.55);backdrop-filter:blur(10px);z-index:1000;display:flex;align-items:center;justify-content:center;padding:16px;animation:fadeIn .18s ease}
.mo-box{background:var(--bg2);border:1.5px solid var(--border2);border-radius:var(--r2);width:100%;max-width:540px;max-height:92vh;overflow-y:auto;animation:scaleIn .22s cubic-bezier(0.34,1.56,0.64,1)}
.mo-box-lg{max-width:760px}
.mo-hd{padding:17px 22px;border-bottom:1.5px solid var(--border);display:flex;align-items:center;justify-content:space-between;position:sticky;top:0;background:var(--bg2);z-index:1}
.mo-title{font-family:var(--ff);font-size:16px;font-weight:700}
.mo-x{width:30px;height:30px;border-radius:50%;background:var(--bg3);border:none;color:var(--text2);font-size:16px;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:var(--tr)}
.mo-x:hover{background:var(--border2);color:var(--text)}.mo-b{padding:22px}
.mo-f{padding:13px 22px;border-top:1.5px solid var(--border);display:flex;justify-content:flex-end;gap:8px;position:sticky;bottom:0;background:var(--bg2)}

/* ── MISC ── */
.loader{display:flex;align-items:center;justify-content:center;padding:44px}
.spin{width:28px;height:28px;border-radius:50%;border:3px solid var(--border2);border-top-color:var(--accent);animation:spin .65s linear infinite}
.empty{text-align:center;padding:46px 20px;color:var(--text3)}.empty-ico{font-size:46px;margin-bottom:10px;opacity:.3}
.empty-t{font-size:14px;color:var(--text2);margin-bottom:5px;font-weight:500}.empty-s{font-size:12px}
.pg-hd{display:flex;align-items:center;justify-content:space-between;margin-bottom:15px;flex-wrap:wrap;gap:8px}
.pg-title{font-family:var(--ff);font-size:20px;font-weight:800;letter-spacing:-.3px}
.divider{font-size:11px;font-weight:700;text-transform:uppercase;letter-spacing:.05em;color:var(--text3);padding:8px 0;margin:4px 0}
.tabs{display:flex;border-bottom:1.5px solid var(--border);margin-bottom:14px;overflow-x:auto}
.tab{padding:9px 14px;font-size:12px;font-weight:600;border:none;background:transparent;color:var(--text2);cursor:pointer;border-bottom:2px solid transparent;white-space:nowrap;font-family:var(--fb);transition:var(--tr)}
.tab:hover{color:var(--text)}.tab.on{color:var(--accent);border-bottom-color:var(--accent)}
.filters{display:flex;flex-wrap:wrap;gap:6px;padding:10px 14px;background:var(--card);border:1.5px solid var(--border);border-radius:var(--r);margin-bottom:12px;box-shadow:var(--shadow)}
.fc{padding:5px 12px;border-radius:18px;background:var(--bg3);border:1.5px solid var(--border2);color:var(--text2);font-size:11px;font-weight:600;cursor:pointer;font-family:var(--fb);transition:var(--tr)}
.fc:hover,.fc.on{border-color:var(--accent);color:var(--accent);background:var(--glow)}
.uc{display:flex;align-items:center;gap:10px;padding:12px 14px;border-bottom:1.5px solid var(--border);transition:var(--tr)}
.uc:last-child{border-bottom:none}.uc:hover{background:var(--bg3)}
.uc-info{flex:1;min-width:0}.uc-name{font-weight:600;font-size:13px;cursor:pointer;transition:var(--tr)}
.uc-name:hover{color:var(--accent)}.uc-sub{font-size:11px;color:var(--text2);margin-top:1px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}
.team-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(138px,1fr));gap:10px}
.tm-card{background:var(--bg3);border-radius:10px;padding:14px;text-align:center;border:1.5px solid var(--border);transition:var(--tr)}
.tm-card:hover{border-color:var(--accent);background:var(--glow)}
.tm-av{width:46px;height:46px;border-radius:50%;background:linear-gradient(135deg,var(--accent),var(--accent2));display:flex;align-items:center;justify-content:center;font-size:16px;font-weight:700;color:#fff;margin:0 auto 8px}
.tm-name{font-size:12px;font-weight:600}.tm-eq{font-size:10px;color:var(--gold);margin-top:3px;font-weight:600}
.interest-st{padding:3px 9px;border-radius:18px;font-size:10px;font-weight:700;text-transform:uppercase;letter-spacing:.04em}
.ist-pending{background:rgba(245,158,11,.15);color:var(--gold)}.ist-accepted{background:rgba(16,185,129,.15);color:var(--green)}.ist-declined{background:rgba(239,68,68,.15);color:var(--red)}
.jr-badge-pending{background:rgba(245,158,11,.15);color:var(--gold);padding:3px 9px;border-radius:18px;font-size:10px;font-weight:700;text-transform:uppercase}
.jr-badge-accepted{background:rgba(16,185,129,.15);color:var(--green);padding:3px 9px;border-radius:18px;font-size:10px;font-weight:700;text-transform:uppercase}
.jr-badge-declined,.jr-badge-rejected{background:rgba(239,68,68,.15);color:var(--red);padding:3px 9px;border-radius:18px;font-size:10px;font-weight:700;text-transform:uppercase}
.admin-crown{display:inline-flex;align-items:center;gap:3px;padding:2px 7px;border-radius:10px;background:rgba(245,158,11,.15);color:var(--gold);font-size:10px;font-weight:700;border:1px solid rgba(245,158,11,.25)}
.lock-screen{display:flex;flex-direction:column;align-items:center;justify-content:center;padding:56px 24px;text-align:center;background:var(--card);border-radius:var(--r);border:1.5px dashed var(--border2)}
.pricing-card{background:var(--card);border:1.5px solid var(--border);border-radius:var(--r);padding:20px;text-align:center;transition:var(--tr)}
.pricing-card.featured{border-color:var(--accent);background:linear-gradient(135deg,rgba(79,70,229,.06),rgba(6,182,212,.04));box-shadow:0 0 0 2px rgba(79,70,229,.1)}

/* ── LANDING NAV ── */
.landing-nav{position:sticky;top:0;z-index:100;height:60px;display:flex;align-items:center;padding:0 24px;gap:16px;background:rgba(247,248,252,.92);backdrop-filter:blur(20px);border-bottom:1.5px solid var(--border)}
html.dark .landing-nav{background:rgba(6,8,16,.92)}
.ticker{white-space:nowrap}

/* ── MOBILE NAV ── */
#mobile-nav{display:none;position:fixed;bottom:0;left:0;right:0;background:rgba(247,248,252,.96);backdrop-filter:blur(24px);border-top:1.5px solid var(--border);z-index:300;padding:5px 0;box-shadow:0 -4px 20px rgba(0,0,0,.06)}
html.dark #mobile-nav{background:rgba(6,8,16,.96)}
.mn-items{display:flex;justify-content:space-around}
.mn-item{display:flex;flex-direction:column;align-items:center;gap:2px;padding:5px 8px;cursor:pointer;color:var(--text3);font-size:9px;font-weight:600;text-transform:uppercase;letter-spacing:.04em;transition:var(--tr)}
.mn-ico{font-size:18px}.mn-item.on{color:var(--accent)}

/* ── UPDATE / COMING SOON CARDS ── */
.update-card{background:var(--bg3);border:1.5px solid var(--border);border-radius:12px;padding:14px;margin-bottom:10px}
.update-card-soon{border-color:rgba(139,92,246,.35);background:linear-gradient(135deg,rgba(139,92,246,.08),rgba(79,70,229,.04));position:relative;overflow:hidden}
.update-card-soon::before{content:'✨ Coming Soon';position:absolute;top:8px;right:10px;font-size:10px;font-weight:700;color:#8b5cf6;background:rgba(139,92,246,.15);padding:2px 8px;border-radius:20px;border:1px solid rgba(139,92,246,.25)}

@media(max-width:1100px){#rpanel{display:none}}
@media(max-width:780px){
  #sidebar{display:none}
  #app-layout{padding:10px 8px}
  #mobile-nav{display:block}
  body{padding-bottom:68px}
  .auth-box{padding:28px 20px}
  .msg-layout{flex-direction:column;height:auto;max-height:calc(100vh - 140px)}
  .conv-panel{width:100%;max-height:200px;border-right:none;border-bottom:1.5px solid var(--border)}
  .kanban{padding-bottom:20px}
  .kb-col{width:242px}
  .task-fs-body{flex-direction:column}
  .task-fs-side{width:100%}
  .pj-topnav{gap:0;padding:0 6px}
}
</style>
</head>
<body>
<div id="toasts"></div>
<div id="modal"></div>

<!-- ══ LANDING ══ -->
<div id="landing" style="display:none;min-height:100vh;background:var(--bg);overflow:hidden">
  <div style="position:fixed;inset:0;pointer-events:none" class="hero-gradient"></div>
  <div style="position:fixed;inset:0;pointer-events:none;opacity:.5" class="grid-bg"></div>
  <div style="position:fixed;top:10%;left:5%;width:320px;height:320px;border-radius:50%;background:rgba(99,102,241,.15);filter:blur(80px);pointer-events:none" class="anim-float"></div>
  <div style="position:fixed;bottom:10%;right:5%;width:280px;height:280px;border-radius:50%;background:rgba(16,185,129,.12);filter:blur(80px);pointer-events:none" class="anim-float-slow"></div>
  <nav class="landing-nav">
    <div style="font-family:var(--ff);font-size:20px;font-weight:800;background:linear-gradient(135deg,var(--accent),var(--accent3));-webkit-background-clip:text;-webkit-text-fill-color:transparent">⚡ FounderLink</div>
    <div style="display:flex;gap:8px;margin-left:auto;align-items:center">
      <button onclick="toggleTheme()" class="theme-btn nav-ico">🌙</button>
      <button class="btn btn-g btn-sm" onclick="showSection('auth');authTab('login')">Sign In</button>
      <button class="btn btn-p btn-sm btn-shine" onclick="showSection('auth');authTab('register')">Get Started →</button>
    </div>
  </nav>
  <section style="max-width:960px;margin:0 auto;padding:90px 24px 70px;text-align:center;position:relative;z-index:1">
    <div style="display:inline-flex;align-items:center;gap:7px;background:var(--card);border:1.5px solid var(--border);border-radius:20px;padding:6px 16px;font-size:12px;font-weight:600;color:var(--text2);margin-bottom:30px;box-shadow:var(--shadow);animation:fadeUp .5s ease both"><span style="width:7px;height:7px;border-radius:50%;background:var(--green);display:inline-block" class="anim-pulse"></span>Trusted by <strong style="color:var(--accent)">12,000+ founders</strong> worldwide</div>
    <h1 style="font-family:var(--ff);font-size:clamp(2.8rem,8vw,5.5rem);font-weight:800;line-height:1.04;letter-spacing:-.04em;margin-bottom:22px;animation:fadeUp .5s .1s ease both">Where <span style="background:linear-gradient(135deg,var(--accent),#8b5cf6,var(--accent3));-webkit-background-clip:text;-webkit-text-fill-color:transparent">Founders</span><br/>Meet <span style="background:linear-gradient(135deg,var(--gold),var(--orange));-webkit-background-clip:text;-webkit-text-fill-color:transparent">Capital</span></h1>
    <p style="font-size:1.15rem;color:var(--text2);max-width:580px;margin:0 auto 38px;line-height:1.7;animation:fadeUp .5s .2s ease both">The all-in-one platform to launch your startup, find co-founders, connect with investors, and build in public.</p>
    <div style="display:flex;gap:12px;justify-content:center;flex-wrap:wrap;animation:fadeUp .5s .3s ease both">
      <button class="btn btn-p btn-shine" style="font-size:15px;padding:14px 30px;border-radius:14px;box-shadow:0 8px 24px rgba(79,70,229,.35)" onclick="showSection('auth');authTab('register')">🚀 Start Building Free</button>
      <button class="btn btn-g" style="font-size:15px;padding:14px 30px;border-radius:14px" onclick="showSection('auth');authTab('register')">💼 I'm an Investor</button>
    </div>
    <div style="display:flex;flex-wrap:wrap;justify-content:center;gap:40px;margin-top:56px;animation:fadeUp .5s .4s ease both">
      <div style="text-align:center"><div style="font-family:var(--ff);font-size:2.4rem;font-weight:800;background:linear-gradient(135deg,var(--accent),var(--accent2));-webkit-background-clip:text;-webkit-text-fill-color:transparent">12K+</div><div style="font-size:11px;color:var(--text2);font-weight:700;text-transform:uppercase;letter-spacing:.06em;margin-top:3px">Founders</div></div>
      <div style="text-align:center"><div style="font-family:var(--ff);font-size:2.4rem;font-weight:800;background:linear-gradient(135deg,var(--green),#34d399);-webkit-background-clip:text;-webkit-text-fill-color:transparent">2.4K+</div><div style="font-size:11px;color:var(--text2);font-weight:700;text-transform:uppercase;letter-spacing:.06em;margin-top:3px">Investors</div></div>
      <div style="text-align:center"><div style="font-family:var(--ff);font-size:2.4rem;font-weight:800;background:linear-gradient(135deg,var(--gold),var(--orange));-webkit-background-clip:text;-webkit-text-fill-color:transparent">$48M+</div><div style="font-size:11px;color:var(--text2);font-weight:700;text-transform:uppercase;letter-spacing:.06em;margin-top:3px">Raised</div></div>
      <div style="text-align:center"><div style="font-family:var(--ff);font-size:2.4rem;font-weight:800;background:linear-gradient(135deg,var(--pink),#f43f5e);-webkit-background-clip:text;-webkit-text-fill-color:transparent">1.8K+</div><div style="font-size:11px;color:var(--text2);font-weight:700;text-transform:uppercase;letter-spacing:.06em;margin-top:3px">Projects</div></div>
    </div>
  </section>
  <div style="overflow:hidden;padding:14px 0;background:rgba(79,70,229,.05);border-top:1.5px solid rgba(79,70,229,.15);border-bottom:1.5px solid rgba(79,70,229,.15)">
    <div style="display:flex" class="anim-ticker">
      <div class="ticker" style="display:flex;align-items:center;gap:24px;padding:0 12px;font-size:12px;font-weight:600;color:var(--text2)"><span>🚀 Launch Projects</span><span style="color:var(--accent2)">✦</span><span>💼 Connect Investors</span><span style="color:var(--accent2)">✦</span><span>💡 Ideas Market</span><span style="color:var(--accent2)">✦</span><span>👥 Build Teams</span><span style="color:var(--accent2)">✦</span><span>💬 Real-time Chat</span><span style="color:var(--accent2)">✦</span><span>✅ Kanban Tasks</span><span style="color:var(--accent2)">✦</span><span>📊 Track Progress</span><span style="color:var(--accent2)">✦</span><span>🌍 Global Network</span><span style="color:var(--accent2)">✦</span></div>
      <div class="ticker" aria-hidden="true" style="display:flex;align-items:center;gap:24px;padding:0 12px;font-size:12px;font-weight:600;color:var(--text2)"><span>🚀 Launch Projects</span><span style="color:var(--accent2)">✦</span><span>💼 Connect Investors</span><span style="color:var(--accent2)">✦</span><span>💡 Ideas Market</span><span style="color:var(--accent2)">✦</span><span>👥 Build Teams</span><span style="color:var(--accent2)">✦</span><span>💬 Real-time Chat</span><span style="color:var(--accent2)">✦</span><span>✅ Kanban Tasks</span><span style="color:var(--accent2)">✦</span><span>📊 Track Progress</span><span style="color:var(--accent2)">✦</span><span>🌍 Global Network</span><span style="color:var(--accent2)">✦</span></div>
    </div>
  </div>
  <footer style="text-align:center;padding:28px 20px;border-top:1.5px solid var(--border);color:var(--text3);font-size:12px;background:var(--card)">
    <div style="font-family:var(--ff);font-size:17px;font-weight:700;background:linear-gradient(135deg,var(--accent),var(--accent3));-webkit-background-clip:text;-webkit-text-fill-color:transparent;margin-bottom:8px">⚡ FounderLink</div>
    Built for builders, by builders · © 2025
  </footer>
</div>

<!-- ══ AUTH ══ -->
<div id="auth">
  <div class="auth-orb1"></div><div class="auth-orb2"></div>
  <div class="auth-box">
    <div style="text-align:center;margin-bottom:26px">
      <div style="font-family:var(--ff);font-size:26px;font-weight:800;background:linear-gradient(135deg,var(--accent),var(--accent3));-webkit-background-clip:text;-webkit-text-fill-color:transparent;letter-spacing:-.5px">⚡ FounderLink</div>
      <div style="font-size:13px;color:var(--text2);margin-top:5px">Where Founders Meet Capital</div>
    </div>
    <div class="auth-tabs">
      <button class="auth-tab on" onclick="authTab('login')">Sign In</button>
      <button class="auth-tab" onclick="authTab('register')">Join Free</button>
    </div>
    <div id="form-login">
      <div class="fg"><label class="inp-label">Email</label><input class="inp" id="l-email" type="email" placeholder="you@startup.com" onkeydown="if(event.key==='Enter')doLogin()"/></div>
      <div class="fg"><label class="inp-label">Password</label><input class="inp" id="l-pass" type="password" placeholder="••••••••" onkeydown="if(event.key==='Enter')doLogin()"/></div>
      <button class="btn btn-p btn-full" onclick="doLogin()" style="margin-top:6px">Sign In →</button>
      <div style="text-align:center;margin-top:14px;font-size:12px;color:var(--text2)">No account? <span style="color:var(--accent);cursor:pointer;font-weight:600" onclick="authTab('register')">Join free →</span></div>
    </div>
    <div id="form-reg" class="hidden">
      <div class="fg"><label class="inp-label">Full Name</label><input class="inp" id="r-name" placeholder="Your name"/></div>
      <div class="fg"><label class="inp-label">Email</label><input class="inp" id="r-email" type="email" placeholder="you@startup.com"/></div>
      <div class="fg"><label class="inp-label">Password</label><input class="inp" id="r-pass" type="password" placeholder="Min 6 characters"/></div>
      <div class="fg"><label class="inp-label">I am a…</label>
        <select class="inp" id="r-role">
          <option value="founder">🚀 Founder</option><option value="co-founder">🤝 Co-Founder</option>
          <option value="investor">💼 Investor</option><option value="developer">⚙️ Developer</option>
          <option value="designer">🎨 Designer</option><option value="marketer">📣 Marketer</option>
          <option value="advisor">🧠 Advisor</option>
        </select>
      </div>
      <button class="btn btn-p btn-full" onclick="doRegister()" style="margin-top:6px">Create Account →</button>
      <div style="text-align:center;margin-top:14px;font-size:12px;color:var(--text2)">Member? <span style="color:var(--accent);cursor:pointer;font-weight:600" onclick="authTab('login')">Sign in →</span></div>
    </div>
    <div style="display:flex;justify-content:space-between;align-items:center;margin-top:18px;padding-top:14px;border-top:1.5px solid var(--border)">
      <span style="font-size:12px;color:var(--accent);cursor:pointer" onclick="showSection('landing')">← Back</span>
      <button onclick="toggleTheme()" class="theme-btn nav-ico" style="font-size:16px;width:34px;height:34px">🌙</button>
    </div>
  </div>
</div>

<!-- ══ APP ══ -->
<div id="app">
  <nav id="appnav">
    <div class="nav-logo" onclick="go('feed')">⚡ FounderLink</div>
    <div class="nav-search">
      <span class="nav-si">🔍</span>
      <input id="gsearch" placeholder="Search people, projects, ideas…" oninput="onSearch(this.value)" onkeydown="if(event.key==='Enter'&&this.value)go('search:'+this.value)"/>
    </div>
    <div class="nav-acts">
      <div class="ws-dot offline" id="ws-dot" title="Connecting…"></div>
      <div class="nav-ico" onclick="go('notifications')" title="Notifications">🔔<span id="nb" class="nav-badge hidden">0</span></div>
      <div class="nav-ico" onclick="go('messages')" title="Messages">💬</div>
      <button onclick="toggleTheme()" class="theme-btn nav-ico" title="Theme">🌙</button>
      <div id="nav-av" class="av av-sm pointer" onclick="go('profile:me')" style="border:2px solid var(--border2)"></div>
    </div>
  </nav>
  <div id="app-layout">
    <aside id="sidebar">
      <div class="sb-profile">
        <div class="sb-cover"></div>
        <div class="sb-av-row"><div id="sb-av" class="sb-av" onclick="go('profile:me')"></div></div>
        <div class="sb-info">
          <div class="sb-name" id="sb-name" onclick="go('profile:me')"></div>
          <div class="sb-username" id="sb-username"></div>
          <div class="sb-role" id="sb-role"></div>
        </div>
        <div class="sb-stats">
          <div class="sb-stat" onclick="go('profile:me')"><div class="sbn" id="sb-fc">0</div><div class="sbl">Followers</div></div>
          <div class="sb-stat" onclick="go('profile:me')"><div class="sbn" id="sb-fg">0</div><div class="sbl">Following</div></div>
        </div>
      </div>
      <nav class="nav-menu">
        <div class="ni on" data-p="feed" onclick="go('feed')"><span class="ni-ico">🏠</span> Feed</div>
        <div class="ni" data-p="explore" onclick="go('explore')"><span class="ni-ico">🔭</span> Explore</div>
        <div class="ni" data-p="ideas" onclick="go('ideas')"><span class="ni-ico">💡</span> Ideas</div>
        <div class="ni" data-p="projects" onclick="go('projects')"><span class="ni-ico">🚀</span> Projects</div>
        <div class="ni" data-p="search" onclick="go('search')"><span class="ni-ico">👥</span> People</div>
        <div class="ni" data-p="messages" onclick="go('messages')"><span class="ni-ico">💬</span> Messages</div>
        <div class="ni" data-p="notifications" onclick="go('notifications')"><span class="ni-ico">🔔</span> Notifications<span id="sb-nb" class="ni-badge hidden">0</span></div>
        <div class="ni" data-p="myspace" onclick="go('myspace')"><span class="ni-ico">⭐</span> My Space</div>
        <div class="ni" onclick="logout()" style="margin-top:4px;border-top:1.5px solid var(--border)"><span class="ni-ico">🚪</span> Logout</div>
      </nav>
    </aside>
    <main id="main"></main>
    <aside id="rpanel">
      <div class="widget">
        <div class="widget-title" style="display:flex;align-items:center;justify-content:space-between">💬 Messages<span style="font-size:11px;color:var(--accent);cursor:pointer;font-weight:600" onclick="go('messages')">View all →</span></div>
        <div id="conv-widget-list"><div style="padding:14px;text-align:center;color:var(--text3);font-size:12px">No messages yet</div></div>
        <div style="padding:10px 14px;border-top:1.5px solid var(--border)"><button class="btn btn-g btn-full btn-sm" onclick="go('messages')">Open Messages</button></div>
      </div>
      <div class="widget">
        <div class="widget-title">👥 Suggested</div>
        <div id="suggested"></div>
        <div style="padding:10px 14px;border-top:1.5px solid var(--border)"><button class="btn btn-g btn-full btn-sm" onclick="go('search')">Find More →</button></div>
      </div>
      <div class="widget">
        <div class="widget-title">🔥 Trending</div>
        <div style="padding:12px 14px;display:flex;flex-wrap:wrap;gap:5px">
          <span class="tag" onclick="go('explore')">#buildinpublic</span><span class="tag">#saas</span><span class="tag">#ai</span><span class="tag">#startup</span><span class="tag">#seed</span><span class="tag">#founder</span><span class="tag">#vc</span>
        </div>
      </div>
    </aside>
  </div>
  <nav id="mobile-nav">
    <div class="mn-items">
      <div class="mn-item on" data-p="feed" onclick="go('feed')"><span class="mn-ico">🏠</span>Feed</div>
      <div class="mn-item" data-p="explore" onclick="go('explore')"><span class="mn-ico">🔭</span>Explore</div>
      <div class="mn-item" data-p="projects" onclick="go('projects')"><span class="mn-ico">🚀</span>Projects</div>
      <div class="mn-item" data-p="messages" onclick="go('messages')"><span class="mn-ico">💬</span>Chat</div>
      <div class="mn-item" data-p="myspace" onclick="go('myspace')"><span class="mn-ico">⭐</span>Me</div>
    </div>
  </nav>
</div>

<script>
/* ════════════════════ FounderLink App JS ════════════════════ */
const API='http://localhost:8080/api';
const WS_BASE='ws://localhost:8080/ws';

const S={
  token:localStorage.getItem('fl_token'),
  me:null, page:'feed',
  ws:null, wsRetry:0,
  feedPosts:[], feedPage:1, feedLoading:false,
  pendingPosts:[], notifCount:0,
  activeConv:null,
  followState:JSON.parse(localStorage.getItem('fl_follows')||'{}'),
  pinnedMsgs:JSON.parse(localStorage.getItem('fl_pins')||'{}'),
  allConvs:[],
  _pjId:null, _pjOwnerId:null, _pjIsMember:false, _pjIsAdmin:false,
  _currentProjectId:null, _currentProjectTab:'overview',
  _dragTask:null, _kanbanTasks:[],
};

/* ── THEME ── */
let _theme=localStorage.getItem('fl_theme')||'light';
function applyTheme(t){_theme=t;document.documentElement.classList.toggle('dark',t==='dark');localStorage.setItem('fl_theme',t);const i=t==='dark'?'☀️':'🌙';document.querySelectorAll('.theme-btn').forEach(b=>b.textContent=i);}
function toggleTheme(){applyTheme(_theme==='dark'?'light':'dark');}
applyTheme(_theme);

/* ── API ── */
async function api(method,path,body){
  const h={'Content-Type':'application/json'};
  if(S.token)h['Authorization']='Bearer '+S.token;
  const r=await fetch(API+path,{method,headers:h,body:body?JSON.stringify(body):undefined});
  const d=await r.json();
  if(!r.ok)throw new Error(d.error||'Request failed');
  return d;
}
const GET=p=>api('GET',p);
const POST=(p,b)=>api('POST',p,b);
const PUT=(p,b)=>api('PUT',p,b);
const PATCH=(p,b)=>api('PATCH',p,b);
const DELETE=p=>api('DELETE',p);

/* ── UTILS ── */
const esc=s=>String(s||'').replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;').replace(/"/g,'&quot;');
const ago=d=>{const s=Math.floor((Date.now()-new Date(d))/1000);if(s<60)return'just now';if(s<3600)return Math.floor(s/60)+'m';if(s<86400)return Math.floor(s/3600)+'h';return Math.floor(s/86400)+'d';};
const ini=n=>(n||'?').split(' ').slice(0,2).map(w=>w[0]||'').join('').toUpperCase()||'?';
const stageEm=s=>({idea:'💡',mvp:'🛠️',seed:'🌱',growth:'📈',scale:'🦄'}[s]||'🚀');
const spin=()=>`<div class="loader"><div class="spin"></div></div>`;
const empt=(ico,t,s,btn='')=>`<div class="empty"><div class="empty-ico">${ico}</div><div class="empty-t">${t}</div><div class="empty-s">${s}</div>${btn}</div>`;
const AV_COLORS=[['#4f46e5','#818cf8'],['#06b6d4','#0ea5e9'],['#10b981','#34d399'],['#f59e0b','#f97316'],['#ec4899','#f43f5e'],['#8b5cf6','#a78bfa']];
function avatarGrad(id=''){let h=0;for(let i=0;i<id.length;i++)h=(h*31+id.charCodeAt(i))%AV_COLORS.length;return `linear-gradient(135deg,${AV_COLORS[h][0]},${AV_COLORS[h][1]})`;}
function avHTML(u,cls='av-md'){const g=avatarGrad(u?.id||u?.name||'');if(u?.avatar)return`<div class="av ${cls}" style="background:${g}"><img src="${esc(u.avatar)}" alt="" onerror="this.parentNode.textContent='${ini(u?.name)}'"/></div>`;return`<div class="av ${cls}" style="background:${g}">${ini(u?.name)}</div>`;}

/* ── FOLLOW STATE ── */
function getFollowState(uid){return S.followState[uid]||false;}
function setFollowState(uid,v){S.followState[uid]=v;localStorage.setItem('fl_follows',JSON.stringify(S.followState));}
function syncFollowStates(users){users.forEach(u=>{if(u.id&&u.id!==S.me?.id&&typeof u.is_following==='boolean')setFollowState(u.id,u.is_following);});}

/* ── TOAST ── */
function toast(msg,type='i'){
  const icons={s:'✅',e:'❌',i:'ℹ️'};const cls={s:'toast-s',e:'toast-e',i:'toast-i'};
  const el=document.createElement('div');el.className=`toast ${cls[type]||'toast-i'}`;
  el.innerHTML=`<span>${icons[type]||'ℹ️'}</span><span>${esc(msg)}</span>`;
  document.getElementById('toasts').appendChild(el);
  setTimeout(()=>{el.style.transition='.3s';el.style.opacity='0';el.style.transform='translateX(20px)';setTimeout(()=>el.remove(),300);},3200);
}

/* ── AUTH ── */
function authTab(t){
  document.querySelectorAll('.auth-tab').forEach((el,i)=>el.classList.toggle('on',i===(t==='login'?0:1)));
  document.getElementById('form-login')?.classList.toggle('hidden',t!=='login');
  document.getElementById('form-reg')?.classList.toggle('hidden',t!=='register');
}
async function doLogin(){
  const email=document.getElementById('l-email')?.value.trim();const password=document.getElementById('l-pass')?.value;
  if(!email||!password)return toast('Email and password required','e');
  try{const d=await POST('/auth/login',{email,password});S.token=d.token;localStorage.setItem('fl_token',d.token);await boot(d.user);}catch(e){toast(e.message,'e');}
}
async function doRegister(){
  const name=document.getElementById('r-name')?.value.trim();const email=document.getElementById('r-email')?.value.trim();
  const password=document.getElementById('r-pass')?.value;const role=document.getElementById('r-role')?.value;
  if(!name||!email||!password)return toast('All fields required','e');
  if(password.length<6)return toast('Password min 6 chars','e');
  try{const d=await POST('/auth/register',{name,email,password,role});S.token=d.token;localStorage.setItem('fl_token',d.token);await boot(d.user);}catch(e){toast(e.message,'e');}
}
function logout(){localStorage.removeItem('fl_token');S.token=null;S.me=null;S.followState={};localStorage.removeItem('fl_follows');if(S.ws)S.ws.close();document.getElementById('app')?.classList.remove('on');showSection('landing');toast('Signed out','i');}
function showSection(s){
  ['landing','auth','app'].forEach(id=>{const el=document.getElementById(id);if(!el)return;
    if(id==='app')el.classList.toggle('on',s==='app');else el.style.display=s===id?(id==='auth'?'flex':'block'):'none';});
}

/* ── BOOT ── */
async function boot(user){
  S.me=user;showSection('app');updateSidebar();connectWS();loadSuggested();loadNotifCount();loadConvWidget();go('feed');
  toast(`Welcome back, ${user.name.split(' ')[0]}! 👋`,'s');
}
function updateSidebar(){
  const u=S.me;if(!u)return;
  ['sb-av','nav-av'].forEach(id=>{const el=document.getElementById(id);if(!el)return;el.style.background=avatarGrad(u.id);el.innerHTML=u.avatar?`<img src="${esc(u.avatar)}" alt="" onerror="this.parentNode.textContent='${ini(u.name)}'"/>`:ini(u.name);});
  const n=document.getElementById('sb-name');if(n)n.textContent=u.name;
  const un=document.getElementById('sb-username');if(un)un.textContent=u.username?'@'+u.username:'';
  const r=document.getElementById('sb-role');if(r)r.textContent=(u.role||'').charAt(0).toUpperCase()+(u.role||'').slice(1);
  const fc=document.getElementById('sb-fc');if(fc)fc.textContent=u.followers_count||0;
  const fg=document.getElementById('sb-fg');if(fg)fg.textContent=u.following_count||0;
}

/* ── WEBSOCKET ── */
function connectWS(){
  if(!S.token)return;
  const ws=new WebSocket(`${WS_BASE}?token=${S.token}`);S.ws=ws;
  ws.onopen=()=>{S.wsRetry=0;const d=document.getElementById('ws-dot');if(d){d.classList.remove('offline');d.title='Live';}};
  ws.onmessage=e=>{try{onWS(JSON.parse(e.data));}catch{}};
  ws.onclose=()=>{const d=document.getElementById('ws-dot');if(d){d.classList.add('offline');d.title='Reconnecting…';}S.wsRetry=Math.min(S.wsRetry+1,6);setTimeout(connectWS,2000*S.wsRetry);};
  ws.onerror=()=>ws.close();
}
function sendWS(evt){if(S.ws?.readyState===1)S.ws.send(JSON.stringify(evt));}
function onWS(evt){
  switch(evt.type){
    case'new_post':{
      const post=evt.payload;if(!post||post.user_id===S.me?.id)break;
      if(getFollowState(post.user_id)){S.notifCount++;updateNB();}
      if(S.page==='feed'){S.pendingPosts.unshift(post);showLiveBanner();}
      break;
    }
    case'new_message':{
      const msg=evt.payload;const cid=msg?.conversation_id;if(!cid)break;
      if(S.page==='messages'&&S.activeConv===cid){appendBubble(msg);}
      else if(msg.sender_id!==S.me?.id){toast(`💬 ${msg.sender?.name||'Someone'}: ${(msg.content||'').slice(0,50)}`,'i');S.notifCount++;updateNB();}
      loadConvWidget();break;
    }
    case'notification':{
      S.notifCount++;updateNB();
      const n=evt.payload;
      if(n?.type==='project_invite'){toast(`🎉 You got a project invitation! ${n.message||''}`,'i');}
      else{toast('🔔 '+(n?.message||'New notification'),'i');}
      // If on notifications page, refresh
      if(S.page==='notifications')renderNotifications();
      break;
    }
    case'typing':{
      const{conversation_id:cid,user_id:uid2}=evt.payload||{};
      if(S.page==='messages'&&S.activeConv===cid&&uid2!==S.me?.id)showTyping();
      break;
    }
    case'task_created':{
      const t=evt.payload;if(!t)break;
      S._kanbanTasks=S._kanbanTasks.filter(x=>x.id!==t.id);S._kanbanTasks.push(t);
      if(S.page==='project'&&S._currentProjectTab==='tasks'){
        const cards=document.getElementById('kbc-cards-'+t.status);
        if(cards&&!document.getElementById('kbc-'+t.id)){cards.insertAdjacentHTML('beforeend',kbCardHTML(t));const cnt=document.getElementById('kbc-count-'+t.status);if(cnt)cnt.textContent=cards.querySelectorAll('.kb-card').length;}
      }
      break;
    }
    case'task_updated':{
      const t=evt.payload;if(!t)break;
      const idx=S._kanbanTasks.findIndex(x=>x.id===t.id);if(idx>=0)S._kanbanTasks[idx]=t;
      if(S.page==='project'&&S._currentProjectTab==='tasks'){
        const oldEl=document.getElementById('kbc-'+t.id);
        if(oldEl){oldEl.outerHTML=kbCardHTML(t);}
        // move to correct column if status changed
        const cardEl=document.getElementById('kbc-'+t.id);
        const targetCol=document.getElementById('kbc-cards-'+t.status);
        if(cardEl&&targetCol&&cardEl.parentElement!==targetCol){targetCol.appendChild(cardEl);}
        KANBAN_COLS.forEach(c=>{const cnt=document.getElementById('kbc-count-'+c.id);if(cnt)cnt.textContent=document.getElementById('kbc-cards-'+c.id)?.querySelectorAll('.kb-card').length||0;});
      }
      break;
    }
    case'task_deleted':{
      const{id:tid}=evt.payload||{};if(!tid)break;
      S._kanbanTasks=S._kanbanTasks.filter(x=>x.id!==tid);
      document.getElementById('kbc-'+tid)?.remove();
      KANBAN_COLS.forEach(c=>{const cnt=document.getElementById('kbc-count-'+c.id);if(cnt)cnt.textContent=document.getElementById('kbc-cards-'+c.id)?.querySelectorAll('.kb-card').length||0;});
      break;
    }
  }
}

/* ── LIVE BANNER ── */
function showLiveBanner(){const b=document.getElementById('live-banner');if(!b)return;b.classList.add('show');b.innerHTML=`⚡ ${S.pendingPosts.length} new post${S.pendingPosts.length>1?'s':''} — click to load`;}
function flushPending(){const list=document.getElementById('feed-list');if(!list)return;S.pendingPosts.forEach(p=>list.insertAdjacentHTML('afterbegin',postHTML(p)));S.pendingPosts=[];const b=document.getElementById('live-banner');if(b)b.classList.remove('show');}

/* ── ROUTER ── */
function go(page){
  const[base,...rest]=String(page||'feed').split(':');const param=rest.join(':');
  S.page=base;
  document.querySelectorAll('[data-p]').forEach(el=>el.classList.toggle('on',el.dataset.p===base));
  document.getElementById('main').innerHTML=spin();
  switch(base){
    case'feed':renderFeed();break;
    case'explore':renderExplore();break;
    case'ideas':renderIdeas();break;
    case'projects':renderProjects();break;
    case'search':renderPeople(param);break;
    case'messages':renderMessages(param);break;
    case'notifications':renderNotifications();break;
    case'profile':renderProfile(param==='me'?S.me?.id:param);break;
    case'myspace':renderMySpace();break;
    case'post':renderPostDetail(param);break;
    case'project':renderProjectWorkspace(param);break;
    case'new-project':renderNewProject();break;
    default:renderFeed();
  }
}

/* ═══════════════════════════════════════════
   FEED
═══════════════════════════════════════════ */
async function renderFeed(){
  S.pendingPosts=[];S.feedPosts=[];S.feedPage=1;
  document.getElementById('main').innerHTML=`
    <div class="live-banner" id="live-banner" onclick="flushPending()"></div>
    <div class="composer">
      <div style="display:flex;gap:10px;align-items:center;margin-bottom:10px">
        ${avHTML(S.me,'av-md')}
        <div class="comp-fake" onclick="openPostModal()">What's on your mind, ${esc((S.me?.name||'').split(' ')[0])}?</div>
      </div>
      <div style="display:flex;gap:6px;flex-wrap:wrap">
        <button class="comp-btn" onclick="openPostModal('article')">📄 Article</button>
        <button class="comp-btn" onclick="openPostModal('idea')">💡 Idea</button>
        <button class="comp-btn" onclick="openPostModal('pitch')">🎯 Pitch</button>
        <button class="comp-btn" onclick="openPostModal('story')">✨ Story</button>
        <button class="comp-btn" onclick="go('new-project')">🚀 Project</button>
      </div>
    </div>
    <div id="feed-list">${spin()}</div>
    <div id="feed-more" style="text-align:center;padding:14px;display:none"><button class="btn btn-g" onclick="loadMoreFeed()">Load more</button></div>`;
  await loadFeed();
}
async function loadFeed(){
  if(S.feedLoading)return;S.feedLoading=true;
  try{
    const posts=await GET(`/feed?page=${S.feedPage}&limit=15`);
    S.feedPosts=[...S.feedPosts,...posts];
    const el=document.getElementById('feed-list');if(!el)return;
    if(!S.feedPosts.length){el.innerHTML=empt('🌱','Your feed is empty','Follow people to see posts here',`<button class="btn btn-p" style="margin-top:12px" onclick="go('search')">Find People</button>`);}
    else{el.innerHTML=S.feedPosts.map(p=>postHTML(p)).join('');}
    syncFollowStates(S.feedPosts.map(p=>p.author).filter(Boolean));
    const more=document.getElementById('feed-more');if(more)more.style.display=posts.length>=15?'block':'none';
  }catch{toast('Failed to load feed','e');}
  S.feedLoading=false;
}
async function loadMoreFeed(){S.feedPage++;await loadFeed();}

/* ── POST HTML ── */
function postHTML(p,showFull=false){
  const au=p.author||{};const long=(p.content||'').length>320&&!showFull;
  const tags=(p.tags||[]).map(t=>`<span class="tag">#${esc(t)}</span>`).join('');
  const typeBadge=p.type&&p.type!=='post'?`<span class="badge badge-${esc(p.type)}">${esc(p.type)}</span>`:'';
  const isMe=S.me&&p.user_id===S.me.id;const isIdea=p.type==='idea';
  const voteScore=(p.up_votes||0)-(p.down_votes||0);
  return`<div class="post" id="post-${p.id}">
    <div class="post-hd">
      <div style="cursor:pointer;flex-shrink:0" onclick="go('profile:${p.user_id}')">${avHTML(au,'av-md')}</div>
      <div class="post-meta">
        <div class="post-name" onclick="go('profile:${p.user_id}')">${esc(au.name||'Unknown')}${au.is_verified?' <span style="color:var(--accent3);font-size:11px" title="Verified">✓</span>':''}</div>
        <div class="post-sub">${au.username?`<span style="color:var(--text3)">@${esc(au.username)}</span> · `:''} ${esc(au.headline||au.role||'')} · ${ago(p.created_at)}</div>
      </div>
      <div style="display:flex;align-items:center;gap:6px;margin-left:auto">${typeBadge}${isMe?`<button class="btn btn-xs btn-d" onclick="delPost('${p.id}')">🗑️</button>`:''}</div>
    </div>
    <div class="post-body">
      ${p.title?`<div class="post-title">${esc(p.title)}</div>`:''}
      <div class="post-txt" id="pt-${p.id}" style="${long?'display:-webkit-box;-webkit-line-clamp:4;-webkit-box-orient:vertical;overflow:hidden':''}">${esc(p.content)}</div>
      ${long?`<span style="color:var(--accent);font-size:12px;cursor:pointer;margin-top:4px;display:inline-block" onclick="expandPost('${p.id}')">Read more →</span>`:''}
      ${p.media_url?`<img src="${esc(p.media_url)}" style="width:100%;border-radius:10px;margin-top:8px;max-height:280px;object-fit:cover" alt="" onerror="this.style.display='none'"/>`:''}
    </div>
    ${tags?`<div class="post-tags">${tags}</div>`:''}
    ${isIdea?`<div style="padding:0 16px 10px">
      <div class="vote-bar">
        <button class="vote-btn up${p.my_vote==='up'?' active':''}" id="vup-${p.id}" onclick="voteIdea('${p.id}','up')">▲ <span id="vu-${p.id}">${p.up_votes||0}</span></button>
        <span class="vote-score" id="vs-${p.id}" style="color:${voteScore>0?'var(--green)':voteScore<0?'var(--red)':'var(--text2)'}">Score: ${voteScore}</span>
        <button class="vote-btn down${p.my_vote==='down'?' active':''}" id="vdn-${p.id}" onclick="voteIdea('${p.id}','down')">▼ <span id="vd-${p.id}">${p.down_votes||0}</span></button>
        ${S.me&&p.user_id!==S.me.id?`<button class="btn btn-sm" style="background:rgba(245,158,11,.1);color:var(--gold);border:1.5px solid rgba(245,158,11,.25);margin-left:auto" onclick="markIdeaInterested('${p.id}',this)">💡 I'm Interested</button>`:''}
      </div>
    </div>`:''}
    <div class="post-acts">
      <button class="pa${p.is_liked?' liked':''}" onclick="likePost('${p.id}',this)"><span class="pa-ico">${p.is_liked?'❤️':'🤍'}</span><span id="lc-${p.id}">${p.likes_count||0}</span></button>
      <button class="pa" onclick="go('post:${p.id}')"><span class="pa-ico">💬</span>${p.comments_count||0}</button>
      <button class="pa${p.is_bookmarked?' bkd':''}" onclick="bkPost('${p.id}',this)"><span class="pa-ico">${p.is_bookmarked?'🔖':'📌'}</span></button>
      ${!isMe?`<button class="pa" style="margin-left:auto" onclick="openDM('${p.user_id}')"><span class="pa-ico">💬</span>Message</button>`:''}
    </div>
  </div>`;
}
function expandPost(id){const el=document.getElementById('pt-'+id);if(el){el.style.cssText='';el.nextElementSibling?.remove();}}
async function likePost(id,btn){
  try{const d=await POST(`/posts/${id}/like`);btn.querySelector('.pa-ico').textContent=d.liked?'❤️':'🤍';document.getElementById('lc-'+id).textContent=d.likes_count;btn.classList.toggle('liked',d.liked);}catch(e){toast(e.message,'e');}
}
async function bkPost(id,btn){
  try{const d=await POST(`/posts/${id}/bookmark`);btn.querySelector('.pa-ico').textContent=d.bookmarked?'🔖':'📌';btn.classList.toggle('bkd',d.bookmarked);toast(d.bookmarked?'Bookmarked ✓':'Removed','s');}catch(e){toast(e.message,'e');}
}
async function delPost(id){
  if(!confirm('Delete this post?'))return;
  try{await DELETE(`/posts/${id}`);document.getElementById('post-'+id)?.remove();toast('Deleted','s');}catch(e){toast(e.message,'e');}
}
async function voteIdea(postId,voteType){
  try{
    const d=await POST(`/posts/${postId}/vote`,{vote_type:voteType});
    document.getElementById('vu-'+postId).textContent=d.up_votes;
    document.getElementById('vd-'+postId).textContent=d.down_votes;
    const score=d.up_votes-d.down_votes;
    const scoreEl=document.getElementById('vs-'+postId);
    if(scoreEl){scoreEl.textContent=`Score: ${score}`;scoreEl.style.color=score>0?'var(--green)':score<0?'var(--red)':'var(--text2)';}
    document.getElementById('vup-'+postId)?.classList.toggle('active',d.my_vote==='up');
    document.getElementById('vdn-'+postId)?.classList.toggle('active',d.my_vote==='down');
  }catch(e){toast(e.message,'e');}
}
async function markIdeaInterested(postId,btn){
  try{await POST(`/posts/${postId}/like`);btn.style.background='rgba(245,158,11,.2)';btn.textContent='✓ Interested!';btn.disabled=true;toast('Interest sent! 💡','s');}catch(e){toast(e.message,'e');}
}

/* ── POST COMPOSER ── */
function openPostModal(type='post'){
  const types=['post','article','idea','story','pitch'];const labels={post:'💬 Post',article:'📄 Article',idea:'💡 Idea',story:'✨ Story',pitch:'🎯 Pitch'};
  modal('Share something',`
    <div style="display:flex;gap:5px;flex-wrap:wrap;margin-bottom:14px">${types.map(t=>`<button class="pt-btn${t===type?' on':''}" onclick="selType(this)">${labels[t]}</button>`).join('')}</div>
    <div class="fg"><input class="inp" id="pc-title" placeholder="Title (optional)"/></div>
    <div class="fg"><textarea class="comp-ta" id="pc-content" placeholder="What's on your mind?" style="min-height:130px"></textarea></div>
    <div class="fg"><input class="inp" id="pc-tags" placeholder="Tags: saas, ai, startup (comma separated)"/></div>
    <div class="fg"><input class="inp" id="pc-media" placeholder="Image URL (optional)"/></div>
  `,[{l:'Post',cls:'btn-p',fn:'submitPost'}]);
}
function selType(btn){document.querySelectorAll('.pt-btn').forEach(b=>b.classList.remove('on'));btn.classList.add('on');}
async function submitPost(){
  const content=document.getElementById('pc-content')?.value?.trim();if(!content)return toast('Write something first','e');
  const btn=document.querySelector('.pt-btn.on');
  const typeMap={'💬 Post':'post','📄 Article':'article','💡 Idea':'idea','✨ Story':'story','🎯 Pitch':'pitch'};
  const type=typeMap[btn?.textContent?.trim()]||'post';
  const title=document.getElementById('pc-title')?.value?.trim();
  const tagsRaw=document.getElementById('pc-tags')?.value?.trim();
  const tags=tagsRaw?tagsRaw.split(',').map(t=>t.trim()).filter(Boolean):[];
  const media_url=document.getElementById('pc-media')?.value?.trim();
  try{const post=await POST('/posts',{content,type,title,tags,media_url});closeModal();toast('Posted! 🎉','s');const fl=document.getElementById('feed-list');if(fl)fl.insertAdjacentHTML('afterbegin',postHTML(post));}catch(e){toast(e.message,'e');}
}

/* ═══════════════════════════════════════════
   EXPLORE
═══════════════════════════════════════════ */
let _exType='',_exPage=1;
async function renderExplore(){
  _exType='';_exPage=1;
  document.getElementById('main').innerHTML=`
    <div class="pg-hd"><h2 class="pg-title">🔭 Explore</h2></div>
    <div class="filters">${['','post','article','idea','story','pitch'].map(t=>`<button class="fc${!t?' on':''}" onclick="setExType(this,'${t}')">${t||'✨ All'}</button>`).join('')}</div>
    <div id="ex-list">${spin()}</div>`;
  await loadExplore();
}
function setExType(btn,t){document.querySelectorAll('.fc').forEach(b=>b.classList.remove('on'));btn.classList.add('on');_exType=t;_exPage=1;document.getElementById('ex-list').innerHTML=spin();loadExplore();}
async function loadExplore(){
  try{const posts=await GET(`/explore?type=${_exType}&page=${_exPage}&limit=20`);const el=document.getElementById('ex-list');if(!el)return;if(!posts.length){el.innerHTML=empt('🔭','Nothing here yet','');return;}if(_exPage===1)el.innerHTML=posts.map(p=>postHTML(p)).join('');else posts.forEach(p=>el.insertAdjacentHTML('beforeend',postHTML(p)));}catch{}
}

/* ═══════════════════════════════════════════
   IDEAS
═══════════════════════════════════════════ */
async function renderIdeas(){
  document.getElementById('main').innerHTML=`
    <div class="pg-hd"><h2 class="pg-title">💡 Ideas Marketplace</h2><button class="btn btn-p btn-sm" onclick="openPostModal('idea')">+ Share Idea</button></div>
    <div style="background:rgba(245,158,11,.07);border:1.5px solid rgba(245,158,11,.2);border-radius:var(--r);padding:12px 16px;margin-bottom:14px;font-size:13px;color:var(--text2)">💡 Share early ideas, vote up/down, find co-builders.</div>
    <div id="ideas-list">${spin()}</div>`;
  try{const posts=await GET('/explore?type=idea&page=1&limit=30');const el=document.getElementById('ideas-list');if(!el)return;
    if(!posts.length){el.innerHTML=empt('💡','No ideas yet','',`<button class="btn btn-p" style="margin-top:10px" onclick="openPostModal('idea')">Share an Idea</button>`);return;}
    el.innerHTML=posts.map(p=>postHTML(p)).join('');}catch{}
}

/* ═══════════════════════════════════════════
   POST DETAIL
═══════════════════════════════════════════ */
async function renderPostDetail(postId){
  const m=document.getElementById('main');
  try{
    const[post,comments]=await Promise.all([GET(`/posts/${postId}`),GET(`/posts/${postId}/comments`)]);
    m.innerHTML=`<button class="btn btn-g btn-sm" onclick="history.go(-1)" style="margin-bottom:12px">← Back</button>${postHTML(post,true)}
    <div class="card-base" style="margin-top:10px">
      <div style="padding:13px 16px;border-bottom:1.5px solid var(--border)"><span style="font-family:var(--ff);font-size:14px;font-weight:700">💬 Comments (${post.comments_count||0})</span></div>
      <div style="padding:16px">
        <div id="cmts-list">${(comments||[]).map(c=>cmtHTML(c)).join('')||empt('💬','No comments yet','')}</div>
        <div style="display:flex;gap:8px;align-items:center;margin-top:14px">${avHTML(S.me,'av-sm')}<input class="inp" style="flex:1" id="cmt-input" placeholder="Add a comment…" onkeydown="if(event.key==='Enter')submitCmt('${postId}')"/><button class="btn btn-p btn-sm" onclick="submitCmt('${postId}')">Post</button></div>
      </div>
    </div>`;
  }catch{m.innerHTML=empt('❌','Post not found','');}
}
function cmtHTML(c){
  const au=c.author||{};
  const replies=(c.replies||[]).map(r=>`<div style="display:flex;gap:9px;margin-left:36px;margin-top:8px">${avHTML(r.author,'av-sm')}<div style="background:var(--bg3);border-radius:0 10px 10px 10px;padding:9px 12px;flex:1;border:1.5px solid var(--border)"><div style="font-size:12px;font-weight:600;cursor:pointer" onclick="go('profile:${r.user_id}')">${esc(r.author?.name||'')}</div><div style="font-size:12px;color:var(--text2);line-height:1.5">${esc(r.content)}</div></div></div>`).join('');
  return`<div style="display:flex;gap:9px;margin-bottom:14px"><div onclick="go('profile:${c.user_id}')" style="cursor:pointer;flex-shrink:0">${avHTML(au,'av-sm')}</div><div style="flex:1"><div style="background:var(--bg3);border-radius:0 10px 10px 10px;padding:9px 12px;border:1.5px solid var(--border)"><div style="font-size:12px;font-weight:600;cursor:pointer" onclick="go('profile:${c.user_id}')">${esc(au.name||'')}</div><div style="font-size:12px;color:var(--text2);line-height:1.5">${esc(c.content)}</div></div><div style="font-size:10px;color:var(--text3);padding:3px 4px">${ago(c.created_at)}</div>${replies}</div></div>`;
}
async function submitCmt(postId){const inp=document.getElementById('cmt-input');const content=inp?.value?.trim();if(!content)return;try{const c=await POST(`/posts/${postId}/comments`,{content});document.getElementById('cmts-list').insertAdjacentHTML('beforeend',cmtHTML(c));inp.value='';}catch(e){toast(e.message,'e');}}

/* ═══════════════════════════════════════════
   PROJECTS LIST
═══════════════════════════════════════════ */
let _pjStage='';
async function renderProjects(){
  _pjStage='';
  document.getElementById('main').innerHTML=`
    <div class="pg-hd"><h2 class="pg-title">🚀 Projects</h2><button class="btn btn-p btn-sm" onclick="go('new-project')">+ New Project</button></div>
    <div class="filters">${['','idea','mvp','seed','growth','scale'].map(s=>`<button class="fc${!s?' on':''}" onclick="setPjStage(this,'${s}')">${s?stageEm(s)+' '+s[0].toUpperCase()+s.slice(1):'✨ All'}</button>`).join('')}</div>
    <div id="pj-grid">${spin()}</div>`;
  await loadProjects();
}
function setPjStage(btn,s){document.querySelectorAll('.fc').forEach(b=>b.classList.remove('on'));btn.classList.add('on');_pjStage=s;document.getElementById('pj-grid').innerHTML=spin();loadProjects();}
async function loadProjects(){
  try{const pjs=await GET(`/projects?stage=${_pjStage}&page=1&limit=24`);const el=document.getElementById('pj-grid');if(!el)return;
    if(!pjs.length){el.innerHTML=empt('🚀','No projects yet','',`<button class="btn btn-p" style="margin-top:12px" onclick="go('new-project')">Launch Project</button>`);return;}
    el.innerHTML=`<div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(268px,1fr));gap:14px">${pjs.map(p=>pjHTML(p)).join('')}</div>`;}catch{toast('Failed','e');}
}
function pjHTML(p){
  const seeking=(p.seeking||[]).map(s=>`<span class="chip">${esc(s)}</span>`).join('');const ow=p.owner||{};
  return`<div class="pj" onclick="go('project:${p.id}')">
    <div class="pj-cover">${p.cover?`<img src="${esc(p.cover)}" alt=""/>`:stageEm(p.stage)}
      <span class="pj-stage st-${p.stage||'idea'}">${stageEm(p.stage)} ${p.stage||'idea'}</span>
      <div class="pj-logo">${p.logo?`<img src="${esc(p.logo)}" style="width:100%;height:100%;object-fit:cover;border-radius:7px" alt=""/>`:((p.name||'?')[0].toUpperCase())}</div>
    </div>
    <div class="pj-body">
      <div class="pj-name">${esc(p.name)}</div>
      <div class="pj-line">${esc(p.tagline||p.description?.slice(0,80)||'')}</div>
      <div style="display:flex;flex-wrap:wrap;gap:6px;margin-bottom:8px">
        ${p.industry?`<span class="pj-mi" style="font-size:11px;color:var(--text2)">🏭 ${esc(p.industry)}</span>`:''}
        <span style="font-size:11px;color:var(--text2)">👁️ ${p.views||0}</span>
        <span style="font-size:11px;color:var(--gold)">⭐ ${p.interested_count||0}</span>
        ${p.is_paid?`<span class="chip" style="background:rgba(16,185,129,.1);color:var(--green);border-color:rgba(16,185,129,.2)">💰 ${esc(p.price)}</span>`:''}
      </div>
      ${seeking?`<div style="display:flex;flex-wrap:wrap;gap:4px;margin-bottom:8px">${seeking}</div>`:''}
      ${p.progress_percent>0?`<div style="margin-bottom:8px"><div style="font-size:10px;color:var(--text3);margin-bottom:3px">Progress: ${p.progress_percent}%</div><div class="progress-track"><div class="progress-fill" style="width:${p.progress_percent}%"></div></div></div>`:''}
      <div class="pj-foot">
        <div style="display:flex;align-items:center;gap:5px;font-size:11px;color:var(--text2)">${avHTML(ow,'av-xs')} ${esc(ow.name||'')}</div>
        ${p.funding_needed?`<span style="font-size:11px;color:var(--gold);font-weight:700">💰 ${esc(p.funding_needed)}</span>`:''}
      </div>
    </div>
  </div>`;
}

/* ═══════════════════════════════════════════
   PROJECT WORKSPACE
═══════════════════════════════════════════ */
async function renderProjectWorkspace(id){
  S._currentProjectId=id;
  const m=document.getElementById('main');
  try{
    const p=await GET(`/projects/${id}`);
    const isOwner=S.me&&p.owner_id===S.me.id;
    const isMember=isOwner||(p.team_members||[]).some(tm=>tm.user_id===S.me?.id&&tm.status==='accepted');
    const isAdmin=isOwner||(p.team_members||[]).some(tm=>tm.user_id===S.me?.id&&tm.status==='accepted'&&tm.is_admin);
    S._pjId=id;S._pjOwnerId=p.owner_id;S._pjIsMember=isMember;S._pjIsAdmin=isAdmin;

    m.innerHTML=`<div class="pj-workspace">
      <div class="pj-topnav">
        <div class="pj-topnav-logo" onclick="go('projects')" title="All Projects">${stageEm(p.stage)}</div>
        <div class="pj-topnav-name" onclick="go('projects')">Projects</div>
        <span class="pj-topnav-sep">/</span>
        <div class="pj-topnav-title">${esc(p.name)}</div>
        <div class="pj-sep-line"></div>
        <button class="pj-nav-btn on" id="pjn-overview" onclick="pjTab('overview','${id}',this)">📋 Overview</button>
        ${isMember?`<button class="pj-nav-btn" id="pjn-tasks" onclick="pjTab('tasks','${id}',this)">✅ Tasks</button>`:''}
        <button class="pj-nav-btn" id="pjn-team" onclick="pjTab('team','${id}',this)">👥 Team</button>
        <button class="pj-nav-btn" id="pjn-updates" onclick="pjTab('updates','${id}',this)">🗒️ Updates</button>
        ${isMember?`<button class="pj-nav-btn" id="pjn-chat" onclick="pjTab('chat','${id}',this)">💬 Chat</button>`:''}
        ${isMember?`<button class="pj-nav-btn" id="pjn-notes" onclick="pjTab('notes','${id}',this)">📝 Notes</button>`:''}
        ${isOwner?`<button class="pj-nav-btn" id="pjn-investors" onclick="pjTab('investors','${id}',this)">💼 Investors</button>`:''}
        ${isOwner?`<button class="pj-nav-btn" id="pjn-joinreqs" onclick="pjTab('joinreqs','${id}',this)">📥 Requests</button>`:''}
        ${isOwner?`<button class="pj-nav-btn" id="pjn-settings" onclick="pjTab('settings','${id}',this)">⚙️ Settings</button>`:''}
        <div style="margin-left:auto;display:flex;gap:6px;flex-shrink:0;padding-right:4px">
          ${!isOwner?`<button class="btn btn-p btn-sm" onclick="expressInterest('${id}')">💼 Invest/Join</button>`:''}
          ${!isMember?`<button class="btn btn-g btn-sm" onclick="openJoinRequestModal('${id}')">📥 Join</button>`:''}
          ${!isOwner?`<button class="btn btn-g btn-sm" onclick="openDM('${p.owner_id}')">💬 Message</button>`:''}
        </div>
      </div>
      <div id="pj-ws-content" class="pj-content"></div>
    </div>`;
    renderPjOverview(p,isOwner,isMember,isAdmin);
  }catch(e){m.innerHTML=empt('❌','Project not found','');}
}

function pjTab(tab,id,btn){
  document.querySelectorAll('.pj-nav-btn').forEach(b=>b.classList.remove('on'));
  if(btn)btn.classList.add('on');
  S._currentProjectTab=tab;
  const el=document.getElementById('pj-ws-content');if(!el)return;
  el.innerHTML=spin();
  switch(tab){
    case'overview':GET(`/projects/${id}`).then(p=>renderPjOverview(p,S.me&&p.owner_id===S.me.id,S._pjIsMember,S._pjIsAdmin)).catch(()=>{});break;
    case'tasks':renderKanban(id);break;
    case'team':renderTeamTab(id);break;
    case'chat':renderProjectChat(id);break;
    case'notes':renderNotesTab(id);break;
    case'updates':renderUpdatesTab(id);break;
    case'investors':renderInvestorsTab(id);break;
    case'joinreqs':renderJoinRequests(id);break;
    case'settings':GET(`/projects/${id}`).then(p=>renderSettingsTab(p)).catch(()=>{});break;
  }
}

/* ── OVERVIEW ── */
function renderPjOverview(p,isOwner,isMember,isAdmin){
  const el=document.getElementById('pj-ws-content');if(!el)return;
  const seeking=(p.seeking||[]).map(s=>`<span class="chip">${esc(s)}</span>`).join('');
  const sections=(p.sections||[]).filter(s=>s.section_type!=='notes').map(s=>sectionBlockHTML(s,isOwner)).join('');
  const updates=(p.updates||[]).slice(0,3);
  el.innerHTML=`
    <div style="display:grid;grid-template-columns:1fr 296px;gap:16px;align-items:start">
      <div>
        <div style="height:180px;border-radius:var(--r);background:linear-gradient(135deg,var(--accent),var(--pink),var(--accent3));overflow:hidden;display:flex;align-items:center;justify-content:center;font-size:60px;position:relative;margin-bottom:16px">
          ${p.cover?`<img src="${esc(p.cover)}" style="width:100%;height:100%;object-fit:cover;position:absolute;inset:0" alt=""/>`:stageEm(p.stage)}
        </div>
        <div style="display:flex;gap:8px;align-items:center;margin-bottom:10px;flex-wrap:wrap">
          <span class="pj-stage st-${p.stage||'idea'}" style="position:static">${stageEm(p.stage)} ${esc(p.stage)}</span>
          ${p.industry?`<span style="font-size:12px;color:var(--text2)">🏭 ${esc(p.industry)}</span>`:''}
          ${p.is_paid?`<span class="chip" style="background:rgba(16,185,129,.1);color:var(--green);border-color:rgba(16,185,129,.2)">💰 ${esc(p.price)}</span>`:''}
          ${!p.is_published?`<span class="chip" style="background:rgba(245,158,11,.1);color:var(--gold)">Draft</span>`:''}
        </div>
        <h1 style="font-family:var(--ff);font-size:24px;font-weight:800;margin-bottom:6px">${esc(p.name)}</h1>
        <p style="color:var(--text2);font-size:14px;max-width:560px;line-height:1.55;margin-bottom:14px">${esc(p.tagline)}</p>
        ${p.progress_percent>0?`<div style="margin-bottom:16px"><div style="display:flex;justify-content:space-between;font-size:12px;color:var(--text2);margin-bottom:6px"><span>${esc(p.progress_stage||'Progress')}</span><span><strong>${p.progress_percent}%</strong></span></div><div class="progress-track"><div class="progress-fill" style="width:${p.progress_percent}%"></div></div>${p.progress_notes?`<div style="font-size:11px;color:var(--text3);margin-top:4px">${esc(p.progress_notes)}</div>`:''}</div>`:''}
        ${seeking?`<div style="margin-bottom:16px"><div style="font-size:11px;font-weight:700;text-transform:uppercase;color:var(--text3);margin-bottom:6px">Looking For</div><div style="display:flex;flex-wrap:wrap;gap:5px">${seeking}</div></div>`:''}
        ${p.description?`<div class="sec-block"><h4>📝 About</h4><p>${esc(p.description)}</p></div>`:''}
        ${sections}
        ${updates.length?`<div style="margin-top:16px"><div style="font-size:11px;font-weight:700;text-transform:uppercase;color:var(--text3);margin-bottom:8px">Recent Updates</div>${updates.map(u=>updateCardHTML(u,false)).join('')}<button class="btn btn-g btn-sm" onclick="pjTab('updates','${p.id}',document.getElementById('pjn-updates'))">View all →</button></div>`:''}
        ${isOwner?`<button class="btn btn-g btn-sm" style="margin-top:10px" onclick="openAddSection('${p.id}')">+ Add Section</button>`:''}
      </div>
      <div style="display:flex;flex-direction:column;gap:12px">
        <div class="card-base" style="padding:14px">
          <div style="display:grid;grid-template-columns:1fr 1fr;gap:4px">
            <div style="text-align:center;padding:8px"><div style="font-family:var(--ff);font-size:20px;font-weight:700">${p.views||0}</div><div style="font-size:10px;color:var(--text2);text-transform:uppercase;letter-spacing:.04em">Views</div></div>
            <div style="text-align:center;padding:8px"><div style="font-family:var(--ff);font-size:20px;font-weight:700;color:var(--gold)">${p.interested_count||0}</div><div style="font-size:10px;color:var(--text2);text-transform:uppercase;letter-spacing:.04em">Interested</div></div>
          </div>
          ${p.funding_needed?`<div style="text-align:center;padding:6px 0;border-top:1.5px solid var(--border);margin-top:6px"><div style="font-size:14px;font-weight:700;color:var(--green)">💰 ${esc(p.funding_needed)}</div><div style="font-size:10px;color:var(--text3)">Seeking</div></div>`:''}
          ${p.equity_offer?`<div style="text-align:center;padding:6px 0;border-top:1.5px solid var(--border)"><div style="font-size:14px;font-weight:700;color:var(--accent2)">${esc(p.equity_offer)}</div><div style="font-size:10px;color:var(--text3)">Equity</div></div>`:''}
          ${p.website?`<a href="${esc(p.website)}" target="_blank" class="btn btn-g btn-full btn-sm" style="margin-top:10px">🌐 Website</a>`:''}
        </div>
        ${p.is_paid?`<div class="pricing-card featured"><div style="font-size:11px;font-weight:700;text-transform:uppercase;color:var(--accent);margin-bottom:6px">Pricing</div><div style="font-family:var(--ff);font-size:24px;font-weight:800;color:var(--accent)">${esc(p.price)}</div>${p.pricing_description?`<div style="font-size:12px;color:var(--text2);margin-top:6px;line-height:1.5">${esc(p.pricing_description)}</div>`:''}<button class="btn btn-p btn-full btn-sm" style="margin-top:12px" onclick="expressInterest('${p.id}')">💰 Get Access</button></div>`:''}
        <div class="card-base" style="padding:14px">
          <div style="font-size:11px;font-weight:700;text-transform:uppercase;color:var(--text3);margin-bottom:8px">Founder</div>
          <div style="display:flex;align-items:center;gap:8px;cursor:pointer" onclick="go('profile:${p.owner?.id||p.owner_id}')">
            ${avHTML(p.owner,'av-sm')}<div><div style="font-weight:600;font-size:13px">${esc(p.owner?.name||'')}</div>${p.owner?.username?`<div style="font-size:11px;color:var(--text3)">@${esc(p.owner.username)}</div>`:''}</div>
          </div>
        </div>
        ${(p.team_members||[]).filter(t=>t.status==='accepted').length?`<div class="card-base" style="padding:14px"><div style="font-size:11px;font-weight:700;text-transform:uppercase;color:var(--text3);margin-bottom:8px">Team</div>${p.team_members.filter(t=>t.status==='accepted').slice(0,4).map(tm=>`<div style="display:flex;align-items:center;gap:7px;margin-bottom:7px"><div class="av av-xs" style="background:${avatarGrad(tm.id)}">${(tm.name||'?')[0].toUpperCase()}</div><div><div style="font-size:12px;font-weight:600">${esc(tm.name)}</div><span class="role-badge role-${(tm.role||'').toLowerCase().replace(/[^a-z]/g,'')}">${esc(tm.role)}</span>${tm.is_admin?`<span class="admin-crown" style="margin-left:4px">👑 Admin</span>`:''}</div></div>`).join('')}</div>`:''}
      </div>
    </div>`;
}

function sectionBlockHTML(s,isOwner){
  if(s.section_type==='notes')return''; // notes shown separately
  const cls=s.section_type==='coming_soon'?'sec-block sec-coming-soon':'sec-block';
  const ico=s.section_type==='coming_soon'?'🔮 ':s.section_type==='notes'?'📝 ':'';
  return`<div class="${cls}"><h4>${ico}${esc(s.title)}</h4><p style="white-space:pre-wrap">${esc(s.content)}</p>${isOwner?`<div style="margin-top:8px;display:flex;gap:6px"><button class="btn btn-xs btn-d" onclick="delSection('${s.id}')">🗑️ Delete</button></div>`:''}</div>`;
}

/* ── KANBAN BOARD ── */
const KANBAN_COLS=[
  {id:'backlog',label:'📋 Backlog',color:'var(--text3)'},
  {id:'todo',label:'📌 To Do',color:'var(--accent2)'},
  {id:'inprogress',label:'⚡ In Progress',color:'var(--accent3)'},
  {id:'review',label:'👀 Review',color:'var(--gold)'},
  {id:'done',label:'✅ Done',color:'var(--green)'},
  {id:'blocked',label:'🚫 Blocked',color:'var(--red)'},
];

async function renderKanban(projectId){
  const el=document.getElementById('pj-ws-content');if(!el)return;
  el.innerHTML=spin();
  if(!S._pjIsMember){el.innerHTML=empt('🔒','Members Only','Only project team members can view tasks.');return;}
  try{
    const tasks=await GET(`/projects/${projectId}/tasks`);
    S._kanbanTasks=tasks;
    el.innerHTML=`
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:14px;flex-wrap:wrap;gap:8px">
        <div>
          <h3 style="font-family:var(--ff);font-size:16px;font-weight:700">📋 Tasks <span style="font-size:13px;color:var(--text3);font-weight:400">(${tasks.length})</span></h3>
          <div style="font-size:11px;color:var(--text3);margin-top:2px">Drag cards between columns to update status</div>
        </div>
        <div style="display:flex;gap:6px">
          <button class="btn btn-g btn-sm" onclick="openTaskFullscreen('${projectId}')">⛶ Full View</button>
          ${S._pjIsAdmin?`<button class="btn btn-p btn-sm" onclick="openAddTaskModal('${projectId}')">+ Add Task</button>`:''}
        </div>
      </div>
      <div class="kanban" id="kanban-board">
        ${KANBAN_COLS.map(col=>{
          const colTasks=tasks.filter(t=>t.status===col.id);
          return`<div class="kb-col" id="kbc-${col.id}" data-status="${col.id}"
            ondragover="kbDragOver(event,this)" ondrop="kbDrop(event,'${col.id}','${projectId}')"
            ondragleave="this.classList.remove('drag-over')">
            <div class="kb-col-hd">
              <div class="kb-col-title"><span style="color:${col.color};font-size:13px">●</span><span>${col.label}</span><span class="kb-col-count" id="kbc-count-${col.id}">${colTasks.length}</span></div>
              ${S._pjIsAdmin?`<button class="kb-add-btn" onclick="openAddTaskModal('${projectId}','${col.id}')" title="Add task">+</button>`:''}
            </div>
            <div class="kb-cards" id="kbc-cards-${col.id}">${colTasks.map(t=>kbCardHTML(t)).join('')}</div>
          </div>`;
        }).join('')}
      </div>`;
  }catch(e){el.innerHTML=empt('❌','Failed to load tasks',e.message);}
}

function kbCardHTML(t){
  const pColor={'low':'var(--green)','medium':'var(--gold)','high':'var(--orange)','urgent':'var(--red)'}[t.priority||'medium'];
  const dueTxt=t.due_date?new Date(t.due_date).toLocaleDateString('en',{month:'short',day:'numeric'}):'';
  const isOverdue=t.due_date&&new Date(t.due_date)<new Date()&&t.status!=='done';
  const tags=(t.tags||[]).map(g=>`<span class="kb-tag">${esc(g)}</span>`).join('');
  return`<div class="kb-card kb-priority-${t.priority||'medium'}" draggable="true" id="kbc-${t.id}" data-task-id="${t.id}"
    ondragstart="kbDragStart(event,'${t.id}')"
    ondragend="this.classList.remove('dragging')"
    onclick="openTaskDetail('${t.id}','${S._currentProjectId}')">
    <div style="font-size:13px;font-weight:600;line-height:1.4;margin-bottom:6px">${esc(t.title)}</div>
    ${tags?`<div style="display:flex;flex-wrap:wrap;gap:3px;margin-bottom:6px">${tags}</div>`:''}
    <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:4px">
      <div style="display:flex;align-items:center;gap:5px">
        <div class="priority-dot priority-dot-${t.priority||'medium'}"></div>
        ${dueTxt?`<span class="kb-due${isOverdue?' overdue':''}">📅 ${dueTxt}</span>`:''}
      </div>
      ${t.assignee?`<div class="kb-assignee-av" title="${esc(t.assignee.name||'')}" style="background:${avatarGrad(t.assignee.id||'')}">${ini(t.assignee.name)}</div>`:`<div class="kb-assignee-av" style="background:var(--border2);color:var(--text3)">?</div>`}
    </div>
  </div>`;
}

function kbDragStart(e,taskId){
  S._dragTask=taskId;
  document.getElementById('kbc-'+taskId)?.classList.add('dragging');
  e.dataTransfer.setData('text/plain',taskId);
}
function kbDragOver(e,col){e.preventDefault();col.classList.add('drag-over');}
async function kbDrop(e,newStatus,projectId){
  e.preventDefault();
  const col=e.currentTarget;col.classList.remove('drag-over');
  const taskId=S._dragTask;if(!taskId)return;S._dragTask=null;
  const t=S._kanbanTasks.find(x=>x.id===taskId);
  if(!t||t.status===newStatus)return;
  // optimistic UI move
  const cardEl=document.getElementById('kbc-'+taskId);
  const targetCards=document.getElementById('kbc-cards-'+newStatus);
  if(cardEl&&targetCards){targetCards.appendChild(cardEl);}
  KANBAN_COLS.forEach(c=>{const cnt=document.getElementById('kbc-count-'+c.id);if(cnt)cnt.textContent=document.getElementById('kbc-cards-'+c.id)?.querySelectorAll('.kb-card').length||0;});
  try{
    // Use WS for real-time sync across all team members
    sendWS({type:'task_move',payload:{task_id:taskId,status:newStatus,project_id:projectId}});
    t.status=newStatus;
    toast('Task moved ✓','s');
  }catch{toast('Update failed','e');}
}

function openTaskFullscreen(projectId){
  const el=document.createElement('div');el.className='task-fs';el.id='task-fs-overlay';
  el.innerHTML=`
    <div class="task-fs-nav">
      <button class="btn btn-g btn-sm" onclick="document.getElementById('task-fs-overlay').remove()">✕ Close</button>
      <span style="font-family:var(--ff);font-size:14px;font-weight:700">📋 Full Task View — ${esc(S._kanbanTasks[0]?.project_id?'Project Tasks':'')}</span>
      ${S._pjIsAdmin?`<button class="btn btn-p btn-sm" style="margin-left:auto" onclick="openAddTaskModal('${projectId}')">+ Add Task</button>`:''}
    </div>
    <div id="task-fs-kanban" style="padding:16px;overflow:auto;flex:1">
      <div class="kanban">
        ${KANBAN_COLS.map(col=>{
          const colTasks=S._kanbanTasks.filter(t=>t.status===col.id);
          return`<div class="kb-col" id="fsbc-${col.id}" data-status="${col.id}"
            ondragover="kbDragOver(event,this)" ondrop="kbDrop(event,'${col.id}','${projectId}')"
            ondragleave="this.classList.remove('drag-over')">
            <div class="kb-col-hd">
              <div class="kb-col-title"><span style="color:${col.color};font-size:13px">●</span><span>${col.label}</span><span class="kb-col-count" id="fsbc-count-${col.id}">${colTasks.length}</span></div>
              ${S._pjIsAdmin?`<button class="kb-add-btn" onclick="openAddTaskModal('${projectId}','${col.id}')">+</button>`:''}
            </div>
            <div class="kb-cards" id="fsbc-cards-${col.id}" style="max-height:calc(100vh - 160px)">${colTasks.map(t=>kbCardHTML(t)).join('')}</div>
          </div>`;
        }).join('')}
      </div>
    </div>`;
  document.body.appendChild(el);
}

function openAddTaskModal(projectId,defaultStatus='backlog'){
  GET(`/projects/${projectId}`).then(p=>{
    const members=(p.team_members||[]).filter(m=>m.status==='accepted');
    modal('Add Task',`
      <div class="fg"><label class="inp-label">Title *</label><input class="inp" id="task-t" placeholder="What needs to be done?"/></div>
      <div class="fg"><label class="inp-label">Description</label><textarea class="inp" id="task-desc" style="min-height:70px;resize:vertical" placeholder="Optional details…"></textarea></div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
        <div class="fg"><label class="inp-label">Status</label><select class="inp" id="task-s">${KANBAN_COLS.map(c=>`<option value="${c.id}"${c.id===defaultStatus?' selected':''}>${c.label}</option>`).join('')}</select></div>
        <div class="fg"><label class="inp-label">Priority</label><select class="inp" id="task-p"><option value="low">🟢 Low</option><option value="medium" selected>🟡 Medium</option><option value="high">🟠 High</option><option value="urgent">🔴 Urgent</option></select></div>
      </div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
        <div class="fg"><label class="inp-label">Assignee</label><select class="inp" id="task-a"><option value="">Unassigned</option>${members.map(m=>`<option value="${m.user_id||''}">${esc(m.name)} (${esc(m.role)})</option>`).join('')}</select></div>
        <div class="fg"><label class="inp-label">Due Date</label><input class="inp" id="task-d" type="date"/></div>
      </div>
      <div class="fg"><label class="inp-label">Tags (comma separated)</label><input class="inp" id="task-tags" placeholder="frontend, bug, feature"/></div>
    `,[{l:'Add Task',cls:'btn-p',fn:`_addTask_${projectId}`}]);
    window[`_addTask_${projectId}`]=async()=>{
      const title=document.getElementById('task-t')?.value?.trim();if(!title)return toast('Title required','e');
      const tagsRaw=document.getElementById('task-tags')?.value?.trim();
      const tags=tagsRaw?tagsRaw.split(',').map(t=>t.trim()).filter(Boolean):[];
      const assignee_id=document.getElementById('task-a')?.value||null;
      const due_date=document.getElementById('task-d')?.value||null;
      try{await POST(`/projects/${projectId}/tasks`,{title,description:document.getElementById('task-desc')?.value?.trim(),status:document.getElementById('task-s')?.value||'backlog',priority:document.getElementById('task-p')?.value||'medium',assignee_id,due_date,tags});closeModal();toast('Task added ✓','s');}
      catch(e){toast(e.message,'e');}
    };
  }).catch(()=>toast('Could not load project','e'));
}

function openTaskDetail(taskId,projectId){
  const t=S._kanbanTasks.find(x=>x.id===taskId);if(!t)return;
  modal(`📋 ${esc(t.title)}`,`
    <div style="font-size:13px;color:var(--text2);line-height:1.65;margin-bottom:14px;white-space:pre-wrap">${esc(t.description||'No description')}</div>
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:10px;font-size:12px;color:var(--text2);margin-bottom:14px">
      <div><strong>Status:</strong> ${t.status}</div>
      <div><strong>Priority:</strong> <span style="color:${{low:'var(--green)',medium:'var(--gold)',high:'var(--orange)',urgent:'var(--red)'}[t.priority]||'var(--text)'}">${t.priority}</span></div>
      <div><strong>Assigned:</strong> ${t.assignee?.name||'Unassigned'}</div>
      <div><strong>Due:</strong> ${t.due_date||'–'}</div>
      <div style="grid-column:span 2"><strong>Tags:</strong> ${(t.tags||[]).map(g=>`<span class="kb-tag" style="display:inline-block">${esc(g)}</span>`).join(' ')||'None'}</div>
    </div>
    ${S._pjIsAdmin?`<div style="padding-top:12px;border-top:1.5px solid var(--border)"><div class="inp-label">Move to column</div><div style="display:flex;flex-wrap:wrap;gap:6px;margin-top:6px">${KANBAN_COLS.map(c=>`<button class="fc${t.status===c.id?' on':''}" onclick="_mvTask('${t.id}','${c.id}','${projectId}')">${c.label}</button>`).join('')}</div>
    <div style="margin-top:10px;display:flex;gap:6px">
      <button class="btn btn-xs btn-d" onclick="if(confirm('Delete?')){closeModal();_delTask('${t.id}','${projectId}')}">🗑️ Delete</button>
    </div></div>`:''}
  `,[]);
}
window._mvTask=async(taskId,newStatus,projectId)=>{
  try{sendWS({type:'task_move',payload:{task_id:taskId,status:newStatus,project_id:projectId}});closeModal();toast('Moved','s');}catch(e){toast(e.message,'e');}
};
window._delTask=async(taskId,projectId)=>{
  try{await DELETE(`/tasks/${taskId}`);toast('Deleted','s');}catch(e){toast(e.message,'e');}
};

/* ── TEAM TAB ── */
async function renderTeamTab(projectId){
  const el=document.getElementById('pj-ws-content');if(!el)return;el.innerHTML=spin();
  try{
    const p=await GET(`/projects/${projectId}`);
    const isOwner=S.me&&p.owner_id===S.me.id;
    const members=p.team_members||[];
    const pending=members.filter(m=>m.status==='pending');
    const accepted=members.filter(m=>m.status==='accepted');
    el.innerHTML=`
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;flex-wrap:wrap;gap:8px">
        <h3 style="font-family:var(--ff);font-size:16px;font-weight:700">👥 Team (${accepted.length+1} members)</h3>
        ${isOwner?`<div style="display:flex;gap:6px"><button class="btn btn-p btn-sm" onclick="openAddTMFromUsers('${projectId}')">+ Add Member</button></div>`:''}
      </div>
      ${pending.length?`<div style="background:rgba(245,158,11,.07);border:1.5px solid rgba(245,158,11,.2);border-radius:10px;padding:12px 14px;margin-bottom:14px">
        <div style="font-size:12px;font-weight:700;color:var(--gold);margin-bottom:8px">⏳ Pending Invites (${pending.length}) — auto-reject after 7 days</div>
        ${pending.map(tm=>`<div style="display:flex;align-items:center;gap:8px;padding:6px 0;border-bottom:1px solid rgba(245,158,11,.15)">
          <div class="av av-xs" style="background:${avatarGrad(tm.id)}">${(tm.name||'?')[0].toUpperCase()}</div>
          <div style="flex:1"><div style="font-size:12px;font-weight:600">${esc(tm.name)}</div><span class="role-badge role-${(tm.role||'').toLowerCase().replace(/[^a-z]/g,'')}">${esc(tm.role)}</span></div>
          <span class="jr-badge-pending">pending</span>
          ${isOwner?`<button class="btn btn-xs btn-d" onclick="removeTM('${projectId}','${tm.id}')">✕</button>`:''}
        </div>`).join('')}
      </div>`:''}
      <div class="team-grid">
        <div class="tm-card">
          <div class="tm-av" style="background:${avatarGrad(p.owner?.id||'')};cursor:pointer" onclick="go('profile:${p.owner?.id||p.owner_id}')">
            ${p.owner?.avatar?`<img src="${esc(p.owner.avatar)}" style="width:100%;height:100%;object-fit:cover" alt=""/>`:ini(p.owner?.name)}
          </div>
          <div class="tm-name" style="cursor:pointer" onclick="go('profile:${p.owner?.id||p.owner_id}')">${esc(p.owner?.name||'')}</div>
          ${p.owner?.username?`<div style="font-size:10px;color:var(--text3)">@${esc(p.owner.username)}</div>`:''}
          <span class="role-badge role-founder" style="margin-top:4px">Founder</span>
          <span class="admin-crown" style="margin-top:4px">👑 Owner</span>
        </div>
        ${accepted.map(tm=>`<div class="tm-card">
          <div class="tm-av" style="background:${avatarGrad(tm.id)};cursor:${tm.user_id?'pointer':''}" onclick="${tm.user_id?`go('profile:${tm.user_id}')`:''}">${(tm.name||'?')[0].toUpperCase()}</div>
          <div class="tm-name" style="${tm.user_id?'cursor:pointer':''}" onclick="${tm.user_id?`go('profile:${tm.user_id}')`:'void 0'}">${esc(tm.name)}</div>
          ${tm.user_id?`<div style="font-size:10px;color:var(--text3)">via platform</div>`:'<div style="font-size:10px;color:var(--text3)">external</div>'}
          <span class="role-badge role-${(tm.role||'').toLowerCase().replace(/[^a-z]/g,'')}" style="margin-top:4px">${esc(tm.role)}</span>
          ${tm.equity?`<div class="tm-eq">⚖️ ${esc(tm.equity)}</div>`:''}
          ${tm.is_admin?`<span class="admin-crown" style="margin-top:4px">👑 Admin</span>`:''}
          ${isOwner?`<div style="display:flex;gap:4px;margin-top:8px;justify-content:center;flex-wrap:wrap">
            ${!tm.is_admin?`<button class="btn btn-xs btn-warn" onclick="toggleAdmin('${projectId}','${tm.id}',true)">Make Admin</button>`:`<button class="btn btn-xs btn-g" onclick="toggleAdmin('${projectId}','${tm.id}',false)">Remove Admin</button>`}
            <button class="btn btn-xs btn-d" onclick="removeTM('${projectId}','${tm.id}')">Remove</button>
          </div>`:''}
        </div>`).join('')}
      </div>`;
  }catch{el.innerHTML=empt('❌','Failed to load','');}
}
async function toggleAdmin(pjId,memberId,val){try{await PATCH(`/projects/${pjId}/team/${memberId}/admin`,{is_admin:val});toast(val?'Admin granted 👑':'Admin removed','s');renderTeamTab(pjId);}catch(e){toast(e.message,'e');}}
async function removeTM(pjId,memberId){if(!confirm('Remove this team member?'))return;try{await DELETE(`/projects/${pjId}/team/${memberId}`);toast('Removed','s');renderTeamTab(pjId);}catch(e){toast(e.message,'e');}}
function openAddTMFromUsers(pjId){
  modal('Add Team Member',`
    <p style="font-size:13px;color:var(--text2);margin-bottom:14px">Search for a user on the platform to add to your team. They will receive an invite notification and have 7 days to accept.</p>
    <div class="fg"><label class="inp-label">Search User</label><input class="inp" id="tm-search" placeholder="Search by name or @username…" oninput="searchTMUsers(this.value,'${pjId}')"/></div>
    <div id="tm-search-results" style="max-height:200px;overflow-y:auto;border:1.5px solid var(--border);border-radius:10px;margin-bottom:10px"></div>
    <div id="tm-selected" style="padding:8px 0;display:none"><div style="font-size:11px;color:var(--text3);margin-bottom:6px">Selected user:</div><div id="tm-sel-user"></div></div>
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
      <div class="fg"><label class="inp-label">Role *</label><select class="inp" id="tm-r"><option value="Co-Founder">🤝 Co-Founder</option><option value="CTO">⚙️ CTO</option><option value="Developer">💻 Developer</option><option value="Designer">🎨 Designer</option><option value="CMO">📣 CMO</option><option value="Marketer">📣 Marketer</option><option value="Investor">💼 Investor</option><option value="Advisor">🧠 Advisor</option></select></div>
      <div class="fg"><label class="inp-label">Equity</label><input class="inp" id="tm-e" placeholder="10%"/></div>
    </div>
    <label style="display:flex;align-items:center;gap:8px;cursor:pointer;font-size:13px"><input type="checkbox" id="tm-admin" style="width:15px;height:15px"/> Grant Admin Access</label>
  `,[{l:'Send Invite',cls:'btn-p',fn:`_addTM_${pjId}`}]);
  window._selectedTMUserId=null;
  window._selectedTMName='';
  window[`_addTM_${pjId}`]=async()=>{
    const role=document.getElementById('tm-r')?.value;if(!role)return toast('Role required','e');
    const is_admin=document.getElementById('tm-admin')?.checked;
    const equity=document.getElementById('tm-e')?.value?.trim();
    const user_id=window._selectedTMUserId||null;
    const name=window._selectedTMName||'Team Member';
    try{await POST(`/projects/${pjId}/team`,{user_id,name,role,equity,is_admin});closeModal();toast('Invite sent! They have 7 days to accept 📨','s');renderTeamTab(pjId);}
    catch(e){toast(e.message,'e');}
  };
}
let _tmSearchDebounce;
async function searchTMUsers(q,pjId){
  clearTimeout(_tmSearchDebounce);
  const el=document.getElementById('tm-search-results');if(!el)return;
  if(q.length<2){el.innerHTML='';return;}
  _tmSearchDebounce=setTimeout(async()=>{
    try{
      const users=await GET(`/users?q=${encodeURIComponent(q)}`);
      if(!el)return;
      const me=S.me?.id;
      el.innerHTML=users.filter(u=>u.id!==me).slice(0,6).map(u=>`<div style="display:flex;align-items:center;gap:8px;padding:9px 12px;cursor:pointer;border-bottom:1.5px solid var(--border);transition:var(--tr)" onmouseover="this.style.background='var(--bg3)'" onmouseout="this.style.background=''" onclick="_selectTM('${u.id}','${esc(u.name).replace(/'/g,"\\'")}',this)">
        ${avHTML(u,'av-xs')}<div><div style="font-size:12px;font-weight:600">${esc(u.name)}</div>${u.username?`<div style="font-size:11px;color:var(--text3)">@${esc(u.username)}</div>`:''}</div>
      </div>`).join('')||'<div style="padding:12px;font-size:12px;color:var(--text3)">No users found</div>';
    }catch{}
  },300);
}
window._selectTM=(uid,name,el)=>{
  window._selectedTMUserId=uid;window._selectedTMName=name;
  document.getElementById('tm-search-results').innerHTML='';
  document.getElementById('tm-search').value=name;
  const sel=document.getElementById('tm-selected');if(sel)sel.style.display='block';
  const su=document.getElementById('tm-sel-user');if(su)su.innerHTML=`<span style="font-size:13px;font-weight:600;color:var(--accent)">✓ ${esc(name)}</span>`;
};

/* ── PROJECT CHAT ── */
async function renderProjectChat(projectId){
  const el=document.getElementById('pj-ws-content');if(!el)return;el.innerHTML=spin();
  try{
    const conv=await GET(`/projects/${projectId}/chat`);
    S.activeConv=conv.id;
    el.innerHTML=`<div style="height:calc(100vh - 200px);display:flex;flex-direction:column;border:1.5px solid var(--border);border-radius:var(--r);overflow:hidden;background:var(--card)">
      <div class="chat-hd">
        <div style="font-size:18px">👥</div>
        <div style="flex:1"><div style="font-weight:600;font-size:13px">${esc(conv.name||'Team Chat')}</div><div style="font-size:11px;color:var(--text2)">${conv.members?.length||0} members · private team channel</div></div>
        <div class="chat-hd-btn" onclick="openGroupSettings('${conv.id}')">⚙️</div>
      </div>
      <div class="chat-msgs" id="chat-msgs-${conv.id}"></div>
      <div class="typing-ind" id="typing-ind"></div>
      <div class="chat-in">
        <textarea class="chat-ta" id="chat-ta" placeholder="Message the team… (Enter to send)" rows="1"
          onkeydown="if(event.key==='Enter'&&!event.shiftKey){event.preventDefault();sendMsg('${conv.id}')}"
          oninput="autoResizeTA(this);sendTypingEvt('${conv.id}')"></textarea>
        <button class="chat-send" onclick="sendMsg('${conv.id}')">➤</button>
      </div>
    </div>`;
    await loadAndRenderMessages(conv.id);
  }catch(e){el.innerHTML=empt('💬','Could not load chat','');}
}

/* ── NOTES TAB ── */
async function renderNotesTab(projectId){
  const el=document.getElementById('pj-ws-content');if(!el)return;el.innerHTML=spin();
  try{
    const p=await GET(`/projects/${projectId}`);
    const noteSections=(p.sections||[]).filter(s=>s.section_type==='notes');
    const isAdmin=S._pjIsAdmin;
    el.innerHTML=`
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;flex-wrap:wrap;gap:8px">
        <div>
          <h3 style="font-family:var(--ff);font-size:16px;font-weight:700">📝 Project Notes</h3>
          <div style="font-size:11px;color:var(--text3);margin-top:2px">Store project documents, notes, and important data</div>
        </div>
        ${isAdmin?`<button class="btn btn-p btn-sm" onclick="openAddSection('${projectId}','notes')">+ Add Note</button>`:''}
      </div>
      ${!noteSections.length?empt('📝','No notes yet','Start documenting your project here',isAdmin?`<button class="btn btn-p" style="margin-top:12px" onclick="openAddSection('${projectId}','notes')">Add First Note</button>`:''):''}
      ${noteSections.map(s=>`<div class="sec-block sec-notes" style="margin-bottom:14px">
        <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:8px">
          <h4 style="font-size:14px">📝 ${esc(s.title)}</h4>
          ${isAdmin?`<div style="display:flex;gap:5px"><button class="btn btn-xs btn-d" onclick="delSection('${s.id}')">🗑️</button></div>`:''}
        </div>
        <div style="font-size:13px;color:var(--text2);line-height:1.65;white-space:pre-wrap">${esc(s.content)}</div>
        <div style="font-size:10px;color:var(--text3);margin-top:8px">${ago(s.created_at)}</div>
      </div>`).join('')}`;
  }catch{el.innerHTML=empt('❌','Failed to load','');}
}

/* ── UPDATES / COMING SOON TAB ── */
async function renderUpdatesTab(projectId){
  const el=document.getElementById('pj-ws-content');if(!el)return;el.innerHTML=spin();
  try{
    const updates=await GET(`/projects/${projectId}/updates`);
    const isOwner=S._pjOwnerId===S.me?.id;
    el.innerHTML=`
      <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:16px;flex-wrap:wrap;gap:8px">
        <div>
          <h3 style="font-family:var(--ff);font-size:16px;font-weight:700">🗒️ Updates & Coming Soon</h3>
          <div style="font-size:11px;color:var(--text3);margin-top:2px">Project announcements and upcoming features</div>
        </div>
        ${isOwner?`<div style="display:flex;gap:6px">
          <button class="btn btn-g btn-sm" onclick="openAddUpdate('${projectId}',false)">+ Update</button>
          <button class="btn btn-warn btn-sm" onclick="openAddUpdate('${projectId}',true)">✨ Coming Soon</button>
        </div>`:''}
      </div>
      ${!updates.length?empt('🗒️','No updates yet','',isOwner?`<button class="btn btn-p" style="margin-top:12px" onclick="openAddUpdate('${projectId}',false)">Post First Update</button>`:''):''}
      ${updates.map(u=>updateCardHTML(u,isOwner)).join('')}`;
  }catch{el.innerHTML=empt('❌','Failed to load','');}
}

function updateCardHTML(u,showDelete){
  const isCS=u.is_coming_soon;
  return`<div class="update-card${isCS?' update-card-soon':''}" style="margin-bottom:12px">
    <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:8px">
      <div>
        <div style="font-weight:700;font-size:14px">${isCS?'🔮 ':''} ${esc(u.title)}</div>
        ${u.release_date?`<div style="font-size:11px;color:var(--purple);margin-top:2px">📅 Target: ${u.release_date}</div>`:''}
      </div>
      <div style="display:flex;align-items:center;gap:6px">
        <div style="font-size:11px;color:var(--text3)">${ago(u.created_at)}</div>
        ${showDelete?`<button class="btn btn-xs btn-d" onclick="deleteUpdate('${u.id}','${u.project_id}')">🗑️</button>`:''}
      </div>
    </div>
    ${u.content?`<div style="font-size:13px;color:var(--text2);line-height:1.6;white-space:pre-wrap">${esc(u.content)}</div>`:''}
  </div>`;
}

function openAddUpdate(projectId,isComingSoon){
  modal(isComingSoon?'✨ Add Coming Soon':'📢 Post Update',`
    <div class="fg"><label class="inp-label">Title *</label><input class="inp" id="upd-title" placeholder="${isComingSoon?'Feature name or announcement':'Update headline'}"/></div>
    <div class="fg"><label class="inp-label">Description</label><textarea class="inp" id="upd-content" style="min-height:80px;resize:vertical" placeholder="${isComingSoon?'What are you building next?':'What happened?'}"></textarea></div>
    ${isComingSoon?`<div class="fg"><label class="inp-label">Target Release Date (optional)</label><input class="inp" id="upd-date" type="date"/></div>`:''}
  `,[{l:isComingSoon?'Add Coming Soon':'Post Update',cls:'btn-p',fn:`_addUpdate_${projectId}`}]);
  window[`_addUpdate_${projectId}`]=async()=>{
    const title=document.getElementById('upd-title')?.value?.trim();if(!title)return toast('Title required','e');
    const content=document.getElementById('upd-content')?.value?.trim();
    const release_date=document.getElementById('upd-date')?.value||null;
    try{await POST(`/projects/${projectId}/updates`,{title,content,is_coming_soon:isComingSoon,release_date});closeModal();toast(isComingSoon?'Coming soon added ✨':'Update posted ✓','s');renderUpdatesTab(projectId);}
    catch(e){toast(e.message,'e');}
  };
}
async function deleteUpdate(updateId,projectId){
  if(!confirm('Delete this update?'))return;
  try{await DELETE(`/projects/${projectId}/updates/${updateId}`);toast('Deleted','s');renderUpdatesTab(projectId);}catch(e){toast(e.message,'e');}
}

/* ── INVESTORS TAB ── */
async function renderInvestorsTab(projectId){
  const el=document.getElementById('pj-ws-content');if(!el)return;el.innerHTML=spin();
  try{
    const items=await GET(`/projects/${projectId}/interests`);
    el.innerHTML=`<h3 style="font-family:var(--ff);font-size:16px;font-weight:700;margin-bottom:14px">💼 Investor Interest (${items.length})</h3>`;
    if(!items.length){el.innerHTML+=empt('💼','No investor interest yet','Share your project!');return;}
    el.innerHTML+=`<div class="card-base">${items.map(i=>`<div class="uc">
      <div onclick="go('profile:${i.investor_id}')" style="cursor:pointer">${avHTML(i.investor,'av-md')}</div>
      <div class="uc-info">
        <div class="uc-name" onclick="go('profile:${i.investor_id}')">${esc(i.investor?.name||'Unknown')}</div>
        <div class="uc-sub">${esc((i.message||'').slice(0,70))}</div>
        ${i.amount?`<div style="font-size:11px;color:var(--gold)">💰 ${esc(i.amount)}</div>`:''}
      </div>
      <div style="display:flex;flex-direction:column;gap:5px;align-items:flex-end">
        <span class="interest-st ist-${i.status}">${i.status}</span>
        ${i.status==='pending'?`<div style="display:flex;gap:4px"><button class="btn btn-xs btn-success" onclick="setInterest('${i.id}','accepted','${projectId}')">✓</button><button class="btn btn-xs btn-d" onclick="setInterest('${i.id}','declined','${projectId}')">✗</button></div>`:''}
      </div>
    </div>`).join('')}</div>`;
  }catch{el.innerHTML=empt('❌','Failed to load','');}
}
async function setInterest(id,status,projectId){try{await PATCH(`/interests/${id}`,{status});toast('Updated','s');renderInvestorsTab(projectId);}catch(e){toast(e.message,'e');}}

/* ── JOIN REQUESTS TAB ── */
async function renderJoinRequests(projectId){
  const el=document.getElementById('pj-ws-content');if(!el)return;el.innerHTML=spin();
  try{
    const reqs=await GET(`/projects/${projectId}/join-requests`);
    el.innerHTML=`<h3 style="font-family:var(--ff);font-size:16px;font-weight:700;margin-bottom:14px">📥 Join Requests (${reqs.length})</h3>
    <div class="card-base">${reqs.length?reqs.map(jr=>`<div class="uc">
      <div onclick="go('profile:${jr.user_id}')" style="cursor:pointer">${avHTML(jr.user,'av-md')}</div>
      <div class="uc-info">
        <div class="uc-name" onclick="go('profile:${jr.user_id}')">${esc(jr.user?.name||'Unknown')}</div>
        <div class="uc-sub">${esc(jr.desired_role||'')} — ${esc((jr.message||'').slice(0,60))}</div>
      </div>
      <div style="display:flex;flex-direction:column;gap:5px;align-items:flex-end">
        <span class="jr-badge-${jr.status}">${jr.status}</span>
        ${jr.status==='pending'?`<div style="display:flex;gap:4px">
          <button class="btn btn-xs btn-success" onclick="updateJR('${jr.id}','accepted','${projectId}')">✓ Accept</button>
          <button class="btn btn-xs btn-d" onclick="updateJR('${jr.id}','declined','${projectId}')">✗ Decline</button>
        </div>`:''}
      </div>
    </div>`).join(''):`<div style="padding:20px;text-align:center;color:var(--text3);font-size:13px">No join requests yet.</div>`}</div>`;
  }catch{el.innerHTML=empt('❌','Failed to load','');}
}
async function updateJR(reqId,status,projectId){try{await PATCH(`/join-requests/${reqId}`,{status});toast(status==='accepted'?'Member added! 🎉':'Declined','s');renderJoinRequests(projectId);}catch(e){toast(e.message,'e');}}

/* ── SETTINGS TAB ── */
function renderSettingsTab(p){
  const el=document.getElementById('pj-ws-content');if(!el)return;
  el.innerHTML=`
    <h3 style="font-family:var(--ff);font-size:16px;font-weight:700;margin-bottom:16px">⚙️ Project Settings</h3>
    <div class="card-base" style="padding:18px;margin-bottom:14px">
      <div style="font-family:var(--ff);font-size:14px;font-weight:700;margin-bottom:14px">Basic Info</div>
      <div class="fg"><label class="inp-label">Project Name</label><input class="inp" id="ep-n" value="${esc(p.name||'')}"/></div>
      <div class="fg"><label class="inp-label">Tagline</label><input class="inp" id="ep-tl" value="${esc(p.tagline||'')}"/></div>
      <div class="fg"><label class="inp-label">Description</label><textarea class="inp" id="ep-desc" style="min-height:80px;resize:vertical">${esc(p.description||'')}</textarea></div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
        <div class="fg"><label class="inp-label">Stage</label><select class="inp" id="ep-stage"><option value="idea">💡 Idea</option><option value="mvp">🛠️ MVP</option><option value="seed">🌱 Seed</option><option value="growth">📈 Growth</option><option value="scale">🦄 Scale</option></select></div>
        <div class="fg"><label class="inp-label">Industry</label><input class="inp" id="ep-ind" value="${esc(p.industry||'')}"/></div>
      </div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
        <div class="fg"><label class="inp-label">Funding Needed</label><input class="inp" id="ep-fn" value="${esc(p.funding_needed||'')}"/></div>
        <div class="fg"><label class="inp-label">Equity Offer</label><input class="inp" id="ep-eq" value="${esc(p.equity_offer||'')}"/></div>
      </div>
      <div class="fg" style="display:flex;align-items:center;gap:8px">
        <input type="checkbox" id="ep-ispaid" ${p.is_paid?'checked':''} style="width:16px;height:16px;cursor:pointer"/>
        <label style="font-size:13px;font-weight:500;cursor:pointer" for="ep-ispaid">This project has pricing / is a paid product</label>
      </div>
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
        <div class="fg"><label class="inp-label">Price</label><input class="inp" id="ep-price" value="${esc(p.price||'')}" placeholder="$29/mo…"/></div>
        <div class="fg"><label class="inp-label">Published</label><select class="inp" id="ep-pub"><option value="true">✅ Published</option><option value="false">📝 Draft</option></select></div>
      </div>
      <div class="fg"><label class="inp-label">Pricing Description</label><textarea class="inp" id="ep-pdesc" style="min-height:60px;resize:vertical">${esc(p.pricing_description||'')}</textarea></div>
    </div>
    <div class="card-base" style="padding:18px;margin-bottom:14px">
      <div style="font-family:var(--ff);font-size:14px;font-weight:700;margin-bottom:14px">📊 Progress</div>
      <div class="fg"><label class="inp-label">Progress % (0–100)</label><input class="inp" id="ep-prog" type="number" min="0" max="100" value="${p.progress_percent||0}"/></div>
      <div class="fg"><label class="inp-label">Stage Label</label><input class="inp" id="ep-pstage" value="${esc(p.progress_stage||'')}"/></div>
      <div class="fg"><label class="inp-label">Progress Notes</label><textarea class="inp" id="ep-pnotes" style="min-height:60px;resize:vertical">${esc(p.progress_notes||'')}</textarea></div>
    </div>
    <button class="btn btn-p" onclick="_saveSettings('${p.id}')">💾 Save Changes</button>`;
  document.getElementById('ep-stage').value=p.stage||'idea';
  document.getElementById('ep-pub').value=String(p.is_published!==false);
  window._saveSettings=async(id)=>{
    const is_paid=document.getElementById('ep-ispaid')?.checked;
    const prog=parseInt(document.getElementById('ep-prog')?.value)||0;
    try{await PATCH(`/projects/${id}`,{name:document.getElementById('ep-n')?.value?.trim(),tagline:document.getElementById('ep-tl')?.value?.trim(),description:document.getElementById('ep-desc')?.value?.trim(),stage:document.getElementById('ep-stage')?.value,industry:document.getElementById('ep-ind')?.value?.trim(),funding_needed:document.getElementById('ep-fn')?.value?.trim(),equity_offer:document.getElementById('ep-eq')?.value?.trim(),is_published:document.getElementById('ep-pub')?.value==='true',price:document.getElementById('ep-price')?.value?.trim(),is_paid,pricing_description:document.getElementById('ep-pdesc')?.value?.trim(),progress_percent:prog,progress_stage:document.getElementById('ep-pstage')?.value?.trim(),progress_notes:document.getElementById('ep-pnotes')?.value?.trim()});toast('Saved! ✓','s');}catch(e){toast(e.message,'e');}
  };
}

/* ── SECTIONS ── */
function openAddSection(pjId,forcedType=''){
  modal('Add Section',`
    <div class="fg"><label class="inp-label">Title *</label><input class="inp" id="sec-t" placeholder="Problem, Solution, Market…"/></div>
    <div class="fg"><label class="inp-label">Type</label>
      <select class="inp" id="sec-type">
        <option value="info"${forcedType==='info'||!forcedType?' selected':''}>📄 Info Section</option>
        <option value="notes"${forcedType==='notes'?' selected':''}>📝 Notes (team only)</option>
        <option value="coming_soon"${forcedType==='coming_soon'?' selected':''}>✨ Coming Soon</option>
      </select>
    </div>
    <div class="fg"><label class="inp-label">Content</label><textarea class="inp" id="sec-c" style="min-height:90px;resize:vertical" placeholder="Describe this section…"></textarea></div>
  `,[{l:'Add',cls:'btn-p',fn:`_addSec_${pjId}`}]);
  if(forcedType)document.getElementById('sec-type').value=forcedType;
  window[`_addSec_${pjId}`]=async()=>{
    const title=document.getElementById('sec-t')?.value?.trim();if(!title)return toast('Title required','e');
    const section_type=document.getElementById('sec-type')?.value||'info';
    try{await POST(`/projects/${pjId}/sections`,{title,content:document.getElementById('sec-c')?.value?.trim(),section_type,order_index:0});closeModal();toast('Section added','s');go('project:'+pjId);}catch(e){toast(e.message,'e');}
  };
}
async function delSection(id){if(!confirm('Delete?'))return;try{await DELETE(`/sections/${id}`);toast('Deleted','s');if(S._pjId)go('project:'+S._pjId);}catch(e){toast(e.message,'e');}}

/* ── NEW PROJECT ── */
function renderNewProject(){
  document.getElementById('main').innerHTML=`
    <button class="btn btn-g btn-sm" onclick="go('projects')" style="margin-bottom:14px">← Back</button>
    <div class="card-base">
      <div style="padding:14px 18px;border-bottom:1.5px solid var(--border)"><span style="font-family:var(--ff);font-size:14px;font-weight:700">🚀 Launch a Project</span></div>
      <div style="padding:18px;display:flex;flex-direction:column;gap:4px">
        <div class="fg"><label class="inp-label">Project Name *</label><input class="inp" id="np-n" placeholder="My Startup"/></div>
        <div class="fg"><label class="inp-label">Tagline *</label><input class="inp" id="np-tl" placeholder="One sentence that captures your idea"/></div>
        <div class="fg"><label class="inp-label">Description</label><textarea class="inp" id="np-d" style="min-height:80px;resize:vertical" placeholder="What are you building and why?"></textarea></div>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
          <div class="fg"><label class="inp-label">Stage</label><select class="inp" id="np-st"><option value="idea">💡 Idea</option><option value="mvp">🛠️ MVP</option><option value="seed">🌱 Seed</option><option value="growth">📈 Growth</option><option value="scale">🦄 Scale</option></select></div>
          <div class="fg"><label class="inp-label">Industry</label><input class="inp" id="np-in" placeholder="SaaS, FinTech…"/></div>
        </div>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
          <div class="fg"><label class="inp-label">Funding Needed</label><input class="inp" id="np-fn" placeholder="$500K"/></div>
          <div class="fg"><label class="inp-label">Equity Offer</label><input class="inp" id="np-eq" placeholder="10%"/></div>
        </div>
        <div class="fg">
          <label style="display:flex;align-items:center;gap:6px;cursor:pointer;font-size:13px;font-weight:500;margin-bottom:8px"><input type="checkbox" id="np-ispaid" style="width:16px;height:16px;cursor:pointer"/> This is a paid product</label>
          <input class="inp" id="np-price" placeholder="Price: $29/mo, $499 one-time, Free…"/>
        </div>
        <div class="fg"><label class="inp-label">Looking For (comma separated)</label><input class="inp" id="np-sk" placeholder="Co-founder, Engineer, Designer, Investor"/></div>
        <div class="fg"><label class="inp-label">Website</label><input class="inp" id="np-ws" placeholder="https://"/></div>
        <button class="btn btn-p" onclick="submitNewProject()" style="align-self:flex-start;margin-top:6px">🚀 Launch Project</button>
      </div>
    </div>`;
}
async function submitNewProject(){
  const name=document.getElementById('np-n')?.value?.trim();if(!name)return toast('Project name required','e');
  const skRaw=document.getElementById('np-sk')?.value?.trim();
  const is_paid=document.getElementById('np-ispaid')?.checked;
  try{const p=await POST('/projects',{name,tagline:document.getElementById('np-tl')?.value?.trim(),description:document.getElementById('np-d')?.value?.trim(),stage:document.getElementById('np-st')?.value,industry:document.getElementById('np-in')?.value?.trim(),funding_needed:document.getElementById('np-fn')?.value?.trim(),equity_offer:document.getElementById('np-eq')?.value?.trim(),price:document.getElementById('np-price')?.value?.trim(),is_paid,seeking:skRaw?skRaw.split(',').map(s=>s.trim()).filter(Boolean):[],website:document.getElementById('np-ws')?.value?.trim()});toast('Project launched! 🚀','s');go('project:'+p.id);}catch(e){toast(e.message,'e');}
}

/* ── JOIN REQUEST ── */
function openJoinRequestModal(projectId){
  modal('📥 Request to Join',`
    <p style="font-size:13px;color:var(--text2);margin-bottom:14px">Tell the founder why you want to join and what role you're looking for.</p>
    <div class="fg"><label class="inp-label">Desired Role *</label>
      <select class="inp" id="jr-role"><option value="Co-Founder">🤝 Co-Founder</option><option value="CTO">⚙️ CTO</option><option value="Developer">💻 Developer</option><option value="Designer">🎨 Designer</option><option value="CMO">📣 CMO</option><option value="Marketer">📣 Marketer</option><option value="Advisor">🧠 Advisor</option><option value="Investor">💼 Investor</option></select>
    </div>
    <div class="fg"><label class="inp-label">Message *</label><textarea class="inp" id="jr-msg" style="min-height:90px;resize:vertical" placeholder="Why do you want to join? What skills do you bring?"></textarea></div>
  `,[{l:'Send Request',cls:'btn-p',fn:`_sendJR_${projectId}`}]);
  window[`_sendJR_${projectId}`]=async()=>{
    const message=document.getElementById('jr-msg')?.value?.trim();const desired_role=document.getElementById('jr-role')?.value;
    if(!message)return toast('Please add a message','e');
    try{await POST(`/projects/${projectId}/join`,{message,desired_role});closeModal();toast('Join request sent! 📥','s');}catch(e){toast(e.message,'e');}
  };
}

/* ── EXPRESS INTEREST ── */
async function expressInterest(pjId){
  modal('💼 Express Interest',`
    <p style="color:var(--text2);font-size:13px;margin-bottom:14px">Tell the founder why you're interested.</p>
    <div class="fg"><label class="inp-label">Message</label><textarea class="inp" id="ei-msg" style="min-height:80px;resize:vertical" placeholder="I'm excited about this because…"></textarea></div>
    <div class="fg"><label class="inp-label">Investment Amount</label><input class="inp" id="ei-amt" placeholder="$50K – $500K"/></div>
  `,[{l:'Send Interest',cls:'btn-p',fn:`_sendInterest_${pjId}`}]);
  window[`_sendInterest_${pjId}`]=async()=>{try{await POST(`/projects/${pjId}/interests`,{message:document.getElementById('ei-msg')?.value?.trim(),amount:document.getElementById('ei-amt')?.value?.trim()});closeModal();toast('Interest sent! 🎉','s');}catch(e){toast(e.message,'e');}};
}

/* ═══════════════════════════════════════════
   PEOPLE / SEARCH
═══════════════════════════════════════════ */
let _pRole='';
async function renderPeople(q){
  _pRole='';
  document.getElementById('main').innerHTML=`
    <div class="pg-hd"><h2 class="pg-title">👥 Find People</h2></div>
    <div class="card-base" style="margin-bottom:12px;padding:14px">
      <div style="display:flex;gap:8px">
        <input class="inp" style="flex:1" id="p-search" placeholder="Search by name, @username, headline…" value="${esc(q||'')}" oninput="debounceSearch(this.value)" onkeydown="if(event.key==='Enter')searchPeople(this.value)"/>
        <button class="btn btn-p" onclick="searchPeople(document.getElementById('p-search').value)">Search</button>
      </div>
    </div>
    <div class="filters">${['','founder','investor','developer','designer','marketer','advisor'].map(r=>`<button class="fc${!r?' on':''}" onclick="setPRole(this,'${r}')">${r||'✨ All'}</button>`).join('')}</div>
    <div class="card-base" id="people-list">${spin()}</div>`;
  searchPeople(q||'');
}
function setPRole(btn,r){document.querySelectorAll('.fc').forEach(b=>b.classList.remove('on'));btn.classList.add('on');_pRole=r;searchPeople(document.getElementById('p-search')?.value||'');}
let _pDebounce;
function debounceSearch(q){clearTimeout(_pDebounce);_pDebounce=setTimeout(()=>searchPeople(q),400);}
async function searchPeople(q){
  try{const users=await GET(`/users?q=${encodeURIComponent(q||'')}&role=${_pRole}`);syncFollowStates(users);const el=document.getElementById('people-list');if(!el)return;if(!users.length){el.innerHTML=empt('👥','No people found','');return;}el.innerHTML=users.map(u=>ucHTML(u)).join('');}catch{}
}
function ucHTML(u){
  const isMe=S.me&&u.id===S.me.id;
  const isFollowing=u.is_following!==undefined?u.is_following:getFollowState(u.id);
  const isPending=u.follow_pending;
  const isPrivate=!u.is_public;
  return`<div class="uc">
    <div onclick="go('profile:${u.id}')" style="cursor:pointer">${avHTML(u,'av-md')}</div>
    <div class="uc-info">
      <div class="uc-name" onclick="go('profile:${u.id}')">${esc(u.name)} ${isPrivate?'🔒':''}</div>
      <div class="uc-sub">${u.username?`<span style="color:var(--text3)">@${esc(u.username)}</span> · `:''} ${esc(u.headline||u.role||'')}</div>
    </div>
    <div style="display:flex;flex-direction:column;gap:5px;align-items:flex-end">
      ${!isMe?`<button class="follow-btn${isFollowing?' following':isPending?' pending':''}" id="fb-${u.id}" onclick="toggleFollow('${u.id}',this)">${isFollowing?'Following':isPending?'Requested':'Follow'}</button>`:'<span class="chip">You</span>'}
      ${!isMe?`<button class="btn btn-xs btn-g" onclick="openDM('${u.id}')">💬 DM</button>`:''}
    </div>
  </div>`;
}
async function toggleFollow(userId,btn){
  if(btn.disabled)return;btn.disabled=true;
  const wasFollowing=btn.classList.contains('following');
  const wasPending=btn.classList.contains('pending');
  try{
    const d=await POST(`/users/${userId}/follow`);
    const nowFollowing=d.following;const nowPending=d.pending;
    btn.textContent=nowFollowing?'Following':nowPending?'Requested':'Follow';
    btn.classList.toggle('following',nowFollowing);
    btn.classList.toggle('pending',nowPending);
    setFollowState(userId,nowFollowing);
    if(S.me){
      if(nowFollowing&&!wasFollowing)S.me.following_count=(S.me.following_count||0)+1;
      else if(!nowFollowing&&wasFollowing)S.me.following_count=Math.max((S.me.following_count||1)-1,0);
      const el=document.getElementById('sb-fg');if(el)el.textContent=S.me.following_count;
    }
    if(nowPending)toast('Follow request sent 📬','i');
    document.querySelectorAll(`#fb-${userId}`).forEach(b=>{if(b!==btn){b.textContent=nowFollowing?'Following':nowPending?'Requested':'Follow';b.classList.toggle('following',nowFollowing);b.classList.toggle('pending',nowPending);}});
  }catch(e){btn.textContent=wasFollowing?'Following':wasPending?'Requested':'Follow';btn.classList.toggle('following',wasFollowing);btn.classList.toggle('pending',wasPending);toast(e.message,'e');}
  btn.disabled=false;
}

/* ═══════════════════════════════════════════
   MY SPACE
═══════════════════════════════════════════ */
async function renderMySpace(){
  document.getElementById('main').innerHTML=`
    <div class="pg-hd"><h2 class="pg-title">⭐ My Space</h2></div>
    <div class="tabs">
      <button class="tab on" onclick="myTab(this,'my-posts')">📝 Posts</button>
      <button class="tab" onclick="myTab(this,'my-projects');loadMyProjects()">🚀 Projects</button>
      <button class="tab" onclick="myTab(this,'my-ideas');loadMyIdeas()">💡 Ideas</button>
      <button class="tab" onclick="myTab(this,'my-invites');loadMyInvites()">📨 Invites</button>
    </div>
    <div id="my-posts">${spin()}</div>
    <div id="my-projects" class="hidden">${spin()}</div>
    <div id="my-ideas" class="hidden">${spin()}</div>
    <div id="my-invites" class="hidden">${spin()}</div>`;
  try{const posts=await GET(`/users/${S.me.id}/posts?page=1&limit=20`);const el=document.getElementById('my-posts');if(!el)return;el.innerHTML=posts.length?posts.map(p=>postHTML(p)).join(''):empt('📝','No posts yet','',`<button class="btn btn-p" style="margin-top:10px" onclick="openPostModal()">Write a Post</button>`);}catch{}
}
function myTab(btn,id){document.querySelectorAll('.tab').forEach(b=>b.classList.remove('on'));btn.classList.add('on');['my-posts','my-projects','my-ideas','my-invites'].forEach(t=>{const el=document.getElementById(t);if(el)el.classList.toggle('hidden',t!==id);});}
async function loadMyProjects(){const el=document.getElementById('my-projects');if(!el)return;try{const all=await GET('/projects?page=1&limit=50');const mine=all.filter(p=>p.owner_id===S.me?.id);el.innerHTML=mine.length?`<div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(260px,1fr));gap:12px">${mine.map(p=>pjHTML(p)).join('')}</div>`:empt('🚀','No projects yet','',`<button class="btn btn-p" style="margin-top:10px" onclick="go('new-project')">Launch Project</button>`);}catch{}}
async function loadMyIdeas(){const el=document.getElementById('my-ideas');if(!el)return;try{const posts=await GET(`/users/${S.me.id}/posts?page=1&limit=50`);const ideas=posts.filter(p=>p.type==='idea');el.innerHTML=ideas.length?ideas.map(p=>postHTML(p)).join(''):empt('💡','No ideas shared yet','',`<button class="btn btn-p" style="margin-top:10px" onclick="openPostModal('idea')">Share an Idea</button>`);}catch{}}
async function loadMyInvites(){
  const el=document.getElementById('my-invites');if(!el)return;
  el.innerHTML=spin();
  try{
    // Get projects where user is pending team member
    const all=await GET('/projects?page=1&limit=50');
    let pendingInvites=[];
    for(const p of all){
      const members=p.team_members||[];
      const myInvite=members.find(m=>m.user_id===S.me?.id&&m.status==='pending');
      if(myInvite)pendingInvites.push({project:p,invite:myInvite});
    }
    if(!pendingInvites.length){el.innerHTML=empt('📨','No pending invites','');return;}
    el.innerHTML=`<div style="margin-bottom:10px;font-size:13px;color:var(--text2)">You have ${pendingInvites.length} pending project invitation${pendingInvites.length>1?'s':''}. They expire after 7 days.</div>`+
    pendingInvites.map(({project:p,invite:inv})=>`<div class="card-base" style="padding:14px;margin-bottom:10px;display:flex;align-items:center;gap:12px">
      <div style="font-size:24px">${stageEm(p.stage)}</div>
      <div style="flex:1">
        <div style="font-family:var(--ff);font-size:15px;font-weight:700;cursor:pointer" onclick="go('project:${p.id}')">${esc(p.name)}</div>
        <div style="font-size:12px;color:var(--text2)">Role: <strong>${esc(inv.role)}</strong>${inv.equity?` · Equity: ${esc(inv.equity)}`:''}</div>
        <div style="font-size:11px;color:var(--text3);margin-top:2px">From: ${esc(p.owner?.name||'')} · Expires: ${inv.invite_expires_at?new Date(inv.invite_expires_at).toLocaleDateString():''}</div>
      </div>
      <div style="display:flex;gap:6px;flex-shrink:0">
        <button class="btn btn-success btn-sm" onclick="respondInvite('${inv.id}','accept',this.closest('.card-base'))">✓ Accept</button>
        <button class="btn btn-d btn-sm" onclick="respondInvite('${inv.id}','decline',this.closest('.card-base'))">✗ Decline</button>
      </div>
    </div>`).join('');
  }catch{el.innerHTML=empt('❌','Failed to load','');}
}
async function respondInvite(memberId,action,card){
  try{await POST(`/team-invites/${memberId}/respond`,{action});toast(action==='accept'?'Joined! 🎉':'Declined','s');card?.remove();}catch(e){toast(e.message,'e');}
}

/* ═══════════════════════════════════════════
   PROFILE
═══════════════════════════════════════════ */
async function renderProfile(userId){
  const m=document.getElementById('main');
  try{
    const[user,posts]=await Promise.all([GET(`/users/${userId}`),GET(`/users/${userId}/posts?page=1&limit=15`)]);
    const isMe=S.me&&user.id===S.me.id;syncFollowStates([user]);
    const isFollowing=user.is_following!==undefined?user.is_following:getFollowState(userId);
    const isPending=user.follow_pending;
    const isPrivate=!user.is_public;
    const skills=(user.skills||[]).map(s=>`<span class="skill">${esc(s)}</span>`).join('');
    m.innerHTML=`
      <div class="prof-cover">${user.cover_image?`<img src="${esc(user.cover_image)}" alt=""/>`:''}</div>
      <div class="prof-info">
        <div style="display:flex;align-items:flex-end;justify-content:space-between;margin-top:-38px;margin-bottom:14px;flex-wrap:wrap;gap:8px">
          <div class="prof-av" style="background:${avatarGrad(user.id)}">${user.avatar?`<img src="${esc(user.avatar)}" alt=""/>`:ini(user.name)}</div>
          <div style="display:flex;gap:8px;flex-wrap:wrap">
            ${isMe?`<button class="btn btn-g btn-sm" onclick="openEditProfile()">✏️ Edit Profile</button>`:''}
            ${!isMe?`<button class="follow-btn${isFollowing?' following':isPending?' pending':''}" id="fb-${user.id}" onclick="toggleFollow('${user.id}',this)">${isFollowing?'Following':isPending?'Requested':'Follow'}</button>`:''}
            ${!isMe?`<button class="btn btn-g btn-sm" onclick="openDM('${user.id}')">💬 Message</button>`:''}
            ${isMe&&isPrivate?`<span style="font-size:12px;color:var(--text3);display:flex;align-items:center;gap:4px">🔒 Private</span>`:''}
            ${isMe&&!isPrivate?`<span style="font-size:12px;color:var(--green);display:flex;align-items:center;gap:4px">🌍 Public</span>`:''}
          </div>
        </div>
        <div class="prof-name">${esc(user.name)}${user.is_verified?' <span style="color:var(--accent3);font-size:16px" title="Verified">✓</span>':''}</div>
        ${user.username?`<div style="font-size:13px;color:var(--text3);margin-bottom:4px">@${esc(user.username)}</div>`:''}
        <div class="prof-hl">${esc(user.headline||user.role||'')}</div>
        <div style="display:flex;flex-wrap:wrap;gap:12px;font-size:12px;color:var(--text2);margin-top:6px">
          ${user.location?`<span>📍 ${esc(user.location)}</span>`:''}
          ${user.website?`<a href="${esc(user.website)}" target="_blank" style="color:var(--accent)">🌐 Website</a>`:''}
        </div>
        ${user.bio?`<p style="font-size:13px;color:var(--text2);margin-top:11px;line-height:1.65">${esc(user.bio)}</p>`:''}
        ${skills?`<div style="display:flex;flex-wrap:wrap;gap:5px;margin-top:10px">${skills}</div>`:''}
        <div style="display:flex;gap:24px;margin-top:14px;padding-top:14px;border-top:1.5px solid var(--border)">
          <div style="cursor:pointer" onclick="showFollowersList('${userId}','followers')"><div class="psn">${user.followers_count||0}</div><div class="psl">Followers</div></div>
          <div style="cursor:pointer" onclick="showFollowersList('${userId}','following')"><div class="psn">${user.following_count||0}</div><div class="psl">Following</div></div>
          <div><div class="psn">${posts.length||0}</div><div class="psl">Posts</div></div>
        </div>
      </div>
      ${isPrivate&&!isFollowing&&!isMe?`<div class="lock-screen"><div style="font-size:48px;margin-bottom:12px">🔒</div><div style="font-family:var(--ff);font-size:18px;font-weight:700;margin-bottom:6px">Private Account</div><div style="font-size:13px;color:var(--text2)">Follow this account to see their posts.</div></div>`:
      `<div class="tabs"><button class="tab on" onclick="profTab(this,'pft-posts')">Posts</button><button class="tab" onclick="profTab(this,'pft-about')">About</button></div>
      <div id="pft-posts">${posts.length?posts.map(p=>postHTML(p)).join(''):empt('📝','No posts yet','')}</div>
      <div id="pft-about" class="hidden"><div class="card-base" style="padding:18px">
        ${user.bio?`<div style="margin-bottom:14px"><div class="divider">About</div><p style="font-size:13px;color:var(--text2);line-height:1.65">${esc(user.bio)}</p></div>`:''}
        ${user.looking_for?`<div style="margin-bottom:14px"><div class="divider">Looking For</div><p style="font-size:13px;color:var(--text2)">${esc(user.looking_for)}</p></div>`:''}
        ${skills?`<div><div class="divider">Skills</div><div style="display:flex;flex-wrap:wrap;gap:5px">${skills}</div></div>`:''}
      </div></div>`}`;
  }catch{m.innerHTML=empt('❌','User not found','');}
}
function profTab(btn,id){document.querySelectorAll('.tab').forEach(b=>b.classList.remove('on'));btn.classList.add('on');['pft-posts','pft-about'].forEach(t=>{const el=document.getElementById(t);if(el)el.classList.toggle('hidden',t!==id);});}
async function showFollowersList(userId,type){try{const users=await GET(`/users/${userId}/${type}`);syncFollowStates(users);modal(type[0].toUpperCase()+type.slice(1),`<div>${users.length?users.map(u=>ucHTML(u)).join(''):empt('👥','No one here yet','')}</div>`,[]);}catch{}}

/* ── EDIT PROFILE ── */
async function openEditProfile(){
  const u=S.me;
  modal('Edit Profile',`
    <div class="fg"><label class="inp-label">Name</label><input class="inp" id="ep-name" value="${esc(u.name||'')}"/></div>
    <div class="fg">
      <label class="inp-label">Username</label>
      <div style="position:relative"><span style="position:absolute;left:12px;top:50%;transform:translateY(-50%);color:var(--text3);font-size:13px">@</span>
      <input class="inp" id="ep-uname" style="padding-left:26px" value="${esc(u.username||'')}" oninput="checkUsernameAvail(this.value)"/></div>
      <div id="uname-status" style="font-size:11px;margin-top:4px"></div>
    </div>
    <div class="fg"><label class="inp-label">Headline</label><input class="inp" id="ep-hl" value="${esc(u.headline||'')}"/></div>
    <div class="fg"><label class="inp-label">Bio</label><textarea class="inp" id="ep-bio" style="min-height:80px;resize:vertical">${esc(u.bio||'')}</textarea></div>
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px">
      <div class="fg"><label class="inp-label">Role</label><select class="inp" id="ep-role">${['founder','investor','developer','designer','marketer','advisor'].map(r=>`<option value="${r}"${u.role===r?' selected':''}>${r}</option>`).join('')}</select></div>
      <div class="fg"><label class="inp-label">Location</label><input class="inp" id="ep-loc" value="${esc(u.location||'')}"/></div>
    </div>
    <div class="fg"><label class="inp-label">Website</label><input class="inp" id="ep-ws" value="${esc(u.website||'')}"/></div>
    <div class="fg"><label class="inp-label">Skills (comma separated)</label><input class="inp" id="ep-sk" value="${esc((u.skills||[]).join(', '))}"/></div>
    <div class="fg"><label class="inp-label">Looking For</label><input class="inp" id="ep-lf" value="${esc(u.looking_for||'')}"/></div>
    <div class="fg" style="display:flex;align-items:center;gap:8px">
      <input type="checkbox" id="ep-public" ${u.is_public!==false?'checked':''} style="width:16px;height:16px;cursor:pointer"/>
      <label style="font-size:13px;cursor:pointer" for="ep-public">Public account (followers require approval if unchecked)</label>
    </div>
  `,[{l:'Save',cls:'btn-p',fn:'_saveProfile'}]);
  window._saveProfile=async()=>{
    const skRaw=document.getElementById('ep-sk')?.value?.trim();
    const skills=skRaw?skRaw.split(',').map(s=>s.trim()).filter(Boolean):undefined;
    const is_public=document.getElementById('ep-public')?.checked;
    try{const user=await PUT('/me',{name:document.getElementById('ep-name')?.value?.trim()||undefined,username:document.getElementById('ep-uname')?.value?.trim()||undefined,headline:document.getElementById('ep-hl')?.value?.trim()||undefined,bio:document.getElementById('ep-bio')?.value?.trim()||undefined,role:document.getElementById('ep-role')?.value||undefined,location:document.getElementById('ep-loc')?.value?.trim()||undefined,website:document.getElementById('ep-ws')?.value?.trim()||undefined,skills,looking_for:document.getElementById('ep-lf')?.value?.trim()||undefined,is_public});S.me=user;updateSidebar();closeModal();toast('Profile updated! ✓','s');go('profile:me');}catch(e){toast(e.message,'e');}
  };
}
let _unCheckTimer;
async function checkUsernameAvail(val){
  clearTimeout(_unCheckTimer);const el=document.getElementById('uname-status');if(!el)return;
  if(!val||val===S.me?.username){el.innerHTML='';return;}
  el.innerHTML=`<span style="color:var(--text3)">Checking…</span>`;
  _unCheckTimer=setTimeout(async()=>{
    try{const d=await fetch(`${API}/username/${encodeURIComponent(val)}/check`).then(r=>r.json());
      el.innerHTML=d.available?`<span style="color:var(--green)">✓ Available</span>`:`<span style="color:var(--red)">✗ Taken</span>`;
    }catch{el.innerHTML='';}
  },500);
}

/* ═══════════════════════════════════════════
   MESSAGES
═══════════════════════════════════════════ */
async function renderMessages(openId){
  document.getElementById('main').innerHTML=`
    <div class="pg-hd"><h2 class="pg-title">💬 Messages</h2></div>
    <div class="msg-layout">
      <div class="conv-panel">
        <div class="conv-hd">Chats
          <div style="display:flex;gap:4px">
            <button class="btn btn-xs btn-g" onclick="newDMModal()">+ DM</button>
            <button class="btn btn-xs btn-g" onclick="newGroupModal()">👥 Group</button>
          </div>
        </div>
        <div class="conv-search"><input placeholder="Search conversations…" oninput="filterConvs(this.value)"/></div>
        <div class="conv-tabs">
          <button class="conv-tab on" onclick="setConvMode(this,'all')">All</button>
          <button class="conv-tab" onclick="setConvMode(this,'personal')">Direct</button>
          <button class="conv-tab" onclick="setConvMode(this,'groups')">Groups</button>
        </div>
        <div class="conv-list" id="conv-list">${spin()}</div>
      </div>
      <div class="chat-panel" id="chat-panel">
        <div class="chat-empty"><div style="font-size:48px;opacity:.2">💬</div><div style="color:var(--text2);font-size:14px;margin-top:8px">Select a conversation</div></div>
      </div>
    </div>`;
  await loadConvs();
  if(openId)setTimeout(()=>openConv(openId),300);
}
async function loadConvs(){try{S.allConvs=await GET('/conversations');renderConvList(S.allConvs);}catch{}}
function setConvMode(btn,mode){
  document.querySelectorAll('.conv-tab').forEach(b=>b.classList.remove('on'));btn.classList.add('on');
  let f=S.allConvs;
  if(mode==='personal')f=S.allConvs.filter(c=>!c.is_group);
  else if(mode==='groups')f=S.allConvs.filter(c=>c.is_group);
  renderConvList(f);
}
function filterConvs(q){
  const f=S.allConvs.filter(c=>{const other=(c.members||[]).find(m=>m.id!==S.me?.id)||{};const name=c.is_group?c.name:other.name;return!q||(name||'').toLowerCase().includes(q.toLowerCase());});renderConvList(f);
}
function renderConvList(convs){
  const el=document.getElementById('conv-list');if(!el)return;
  if(!convs.length){el.innerHTML=`<div style="padding:20px;text-align:center;color:var(--text3);font-size:13px">No conversations yet.</div>`;return;}
  el.innerHTML=convs.map(c=>ciHTML(c)).join('');
}
function ciHTML(c){
  const other=c.is_group?{name:c.name}:((c.members||[]).find(m=>m.id!==S.me?.id)||c.members?.[0]||{});
  const lm=c.last_message;
  return`<div class="ci" id="ci-${c.id}" onclick="openConv('${c.id}')">
    ${c.is_group?`<div class="av av-sm" style="background:linear-gradient(135deg,var(--accent),var(--accent3));flex-shrink:0">👥</div>`:avHTML(other,'av-sm')}
    <div class="ci-info">
      <div class="ci-name">${esc(c.is_group?c.name:(other.name||'Chat'))} ${c.is_group?'<span style="font-size:9px;color:var(--text3);background:var(--bg3);padding:1px 5px;border-radius:8px">GROUP</span>':''}</div>
      <div class="ci-last">${lm?esc((lm.content||'').slice(0,38)):''}</div>
    </div>
    <div class="ci-meta"><div class="ci-time">${lm?ago(lm.created_at):''}</div>${c.unread_count>0?`<div class="ci-unread">${c.unread_count}</div>`:''}</div>
  </div>`;
}
async function openConv(convId){
  S.activeConv=convId;
  document.querySelectorAll('.ci').forEach(el=>el.classList.toggle('on',el.id===`ci-${convId}`));
  const ci=document.getElementById('ci-'+convId);if(ci){const ud=ci.querySelector('.ci-unread');if(ud)ud.remove();}
  const conv=S.allConvs.find(c=>c.id===convId);
  const other=conv?(!conv.is_group?(conv.members||[]).find(m=>m.id!==S.me?.id)||{}:{name:conv.name}):{};
  const pinned=S.pinnedMsgs[convId]||null;
  const panel=document.getElementById('chat-panel');if(!panel)return;
  panel.innerHTML=`
    <div class="chat-hd">
      <div style="cursor:pointer;flex-shrink:0">${conv?.is_group?`<div class="av av-sm" style="background:linear-gradient(135deg,var(--accent),var(--accent3))">👥</div>`:avHTML(other,'av-sm')}</div>
      <div style="flex:1;min-width:0"><div style="font-weight:600;font-size:13px;truncate">${esc(conv?.is_group?conv.name:other.name||'Chat')}</div><div style="font-size:11px;color:var(--green)">● Active</div></div>
      <div style="display:flex;gap:5px">
        ${conv?.is_group?`<div class="chat-hd-btn" onclick="openGroupSettings('${convId}')" title="Group Settings">⚙️</div>`:''}
        ${!conv?.is_group?`<div class="chat-hd-btn" onclick="go('profile:${other.id||''}')" title="View Profile">👤</div>`:''}
      </div>
    </div>
    ${pinned?`<div class="pinned-bar">📌 <strong>Pinned:</strong> ${esc((pinned.content||'').slice(0,60))}</div>`:''}
    <div class="chat-msgs" id="chat-msgs-${convId}"></div>
    <div class="typing-ind" id="typing-ind"></div>
    <div class="chat-in">
      <textarea class="chat-ta" id="chat-ta" placeholder="Message… (Enter to send)" rows="1"
        onkeydown="if(event.key==='Enter'&&!event.shiftKey){event.preventDefault();sendMsg('${convId}')}"
        oninput="autoResizeTA(this);sendTypingEvt('${convId}')"></textarea>
      <button class="chat-send" onclick="sendMsg('${convId}')">➤</button>
    </div>`;
  await loadAndRenderMessages(convId);
}

async function loadAndRenderMessages(convId){
  try{
    const msgs=await GET(`/conversations/${convId}/messages?page=1&limit=60`);
    const container=document.getElementById(`chat-msgs-${convId}`);if(!container)return;
    let lastDate='';
    [...msgs].reverse().forEach(msg=>{const d=new Date(msg.created_at).toLocaleDateString();if(d!==lastDate){container.insertAdjacentHTML('beforeend',`<div class="date-divider">${d}</div>`);lastDate=d;}container.insertAdjacentHTML('beforeend',bubbleHTML(msg,convId));});
    container.scrollTop=container.scrollHeight;
  }catch{}
}

function autoResizeTA(el){el.style.height='auto';el.style.height=Math.min(el.scrollHeight,100)+'px';}
function bubbleHTML(m,convId=''){
  const isMe=m.sender_id===S.me?.id;const isPinned=S.pinnedMsgs[convId]?.id===m.id;
  return`<div class="mb-wrap ${isMe?'me':'them'}" id="mbw-${m.id}">
    ${!isMe&&m.sender?`<div style="font-size:10px;color:var(--text3);margin-bottom:2px;padding:0 3px">${esc(m.sender?.name||'')}</div>`:''}
    <div class="mb ${isMe?'me':'them'}${isPinned?' outline outline-2 outline-[var(--gold)]':''}" id="mb-${m.id}"
      oncontextmenu="showMsgMenu(event,'${m.id}','${convId}','${(m.content||'').replace(/'/g,"\\'").replace(/\n/g,' ').slice(0,80)}',${isMe})">
      ${esc(m.content)}
    </div>
    <div class="mb-time">${ago(m.created_at)}${isPinned?' 📌':''}</div>
  </div>`;
}
function showMsgMenu(e,msgId,convId,content,isMe){
  e.preventDefault();document.getElementById('msg-ctx')?.remove();
  const menu=document.createElement('div');menu.id='msg-ctx';
  menu.style.cssText=`position:fixed;top:${e.clientY}px;left:${e.clientX}px;z-index:999;background:var(--card);border:1.5px solid var(--border2);border-radius:10px;padding:6px;box-shadow:var(--shadow3);min-width:140px`;
  menu.innerHTML=`<div onclick="pinMsg('${convId}','${msgId}','${content}')" style="padding:8px 12px;cursor:pointer;font-size:13px;border-radius:7px;transition:.15s" onmouseover="this.style.background='var(--bg3)'" onmouseout="this.style.background=''">📌 Pin</div>
    ${isMe?`<div onclick="document.getElementById('mbw-${msgId}').remove();document.getElementById('msg-ctx').remove()" style="padding:8px 12px;cursor:pointer;font-size:13px;border-radius:7px;color:var(--red)" onmouseover="this.style.background='var(--bg3)'" onmouseout="this.style.background=''">🗑️ Delete</div>`:''}
    <div onclick="navigator.clipboard.writeText('${content}').then(()=>toast('Copied','s'));document.getElementById('msg-ctx').remove()" style="padding:8px 12px;cursor:pointer;font-size:13px;border-radius:7px" onmouseover="this.style.background='var(--bg3)'" onmouseout="this.style.background=''">📋 Copy</div>`;
  document.body.appendChild(menu);setTimeout(()=>document.addEventListener('click',()=>menu.remove(),{once:true}),10);
}
function appendBubble(m){const c=document.getElementById(`chat-msgs-${m.conversation_id}`);if(!c)return;c.insertAdjacentHTML('beforeend',bubbleHTML(m,m.conversation_id));c.scrollTop=c.scrollHeight;}
function pinMsg(convId,msgId,content){S.pinnedMsgs[convId]={id:msgId,content};localStorage.setItem('fl_pins',JSON.stringify(S.pinnedMsgs));toast('Pinned 📌','s');const pbar=document.querySelector('.pinned-bar');if(pbar){pbar.innerHTML=`📌 <strong>Pinned:</strong> ${esc(content.slice(0,60))}`;}else{const chatHD=document.querySelector('.chat-hd');chatHD?.insertAdjacentHTML('afterend',`<div class="pinned-bar">📌 <strong>Pinned:</strong> ${esc(content.slice(0,60))}</div>`);}}
async function sendMsg(convId){
  if(!convId)convId=S.activeConv;if(!convId)return;
  const ta=document.getElementById('chat-ta');const content=ta?.value?.trim();if(!content)return;
  ta.value='';ta.style.height='auto';
  try{const msg=await POST(`/conversations/${convId}/messages`,{content});appendBubble(msg);loadConvWidget();}catch(e){toast(e.message,'e');}
}
let _typTimer;
function sendTypingEvt(convId){clearTimeout(_typTimer);_typTimer=setTimeout(()=>sendWS({type:'typing',payload:{conversation_id:convId}}),400);}
let _typHide;
function showTyping(){const el=document.getElementById('typing-ind');if(!el)return;el.textContent='typing…';clearTimeout(_typHide);_typHide=setTimeout(()=>{if(el)el.textContent='';},2500);}

async function openDM(userId){
  try{const conv=await POST('/conversations',{user_id:userId});S.allConvs=await GET('/conversations');if(S.page==='messages'){renderConvList(S.allConvs);openConv(conv.id);}else{go('messages:'+conv.id);}}catch(e){toast(e.message,'e');}
}
function newDMModal(){
  modal('New Message',`<div class="fg"><label class="inp-label">Find person</label><input class="inp" id="dm-q" placeholder="Name, @username…" oninput="dmSearch(this.value)"/></div><div id="dm-results" style="max-height:280px;overflow-y:auto"></div>`,[]);
}
function newGroupModal(){
  modal('New Group',`
    <div class="fg"><label class="inp-label">Group Name *</label><input class="inp" id="grp-name" placeholder="Team Chat, Project Alpha…"/></div>
    <div class="fg"><label class="inp-label">Add Members</label><input class="inp" id="grp-q" placeholder="Search by name…" oninput="grpSearch(this.value)"/></div>
    <div id="grp-results" style="max-height:200px;overflow-y:auto;border:1.5px solid var(--border);border-radius:8px;margin-bottom:8px"></div>
    <div id="grp-selected" style="display:flex;flex-wrap:wrap;gap:5px;min-height:28px"></div>
  `,[{l:'Create Group',cls:'btn-p',fn:'_createGroup'}]);
  window._grpMembers=[];
  window._createGroup=async()=>{
    const name=document.getElementById('grp-name')?.value?.trim();if(!name)return toast('Group name required','e');
    if(!window._grpMembers.length)return toast('Add at least one member','e');
    try{const conv=await POST('/conversations',{is_group:true,name,member_ids:window._grpMembers});closeModal();S.allConvs=await GET('/conversations');if(S.page==='messages'){renderConvList(S.allConvs);openConv(conv.id);}else{go('messages:'+conv.id);}toast('Group created! 🎉','s');}
    catch(e){toast(e.message,'e');}
  };
}
async function grpSearch(q){
  if(q.length<2)return;
  try{const users=await GET(`/users?q=${encodeURIComponent(q)}`);const el=document.getElementById('grp-results');if(!el)return;
    el.innerHTML=users.filter(u=>u.id!==S.me?.id&&!window._grpMembers.includes(u.id)).slice(0,5).map(u=>`<div style="display:flex;align-items:center;gap:8px;padding:8px 10px;cursor:pointer;border-bottom:1.5px solid var(--border);transition:.15s" onmouseover="this.style.background='var(--bg3)'" onmouseout="this.style.background=''" onclick="_addGrpMember('${u.id}','${esc(u.name).replace(/'/g,"\\'")}',this)">${avHTML(u,'av-xs')}<div style="font-size:12px;font-weight:600">${esc(u.name)}</div><span style="font-size:11px;color:var(--accent);margin-left:auto">+ Add</span></div>`).join('')||'<div style="padding:10px;font-size:12px;color:var(--text3)">No users found</div>';
  }catch{}
}
window._addGrpMember=(uid,name,el)=>{
  if(window._grpMembers.includes(uid))return;
  window._grpMembers.push(uid);el.style.opacity='.4';el.style.pointerEvents='none';
  const sel=document.getElementById('grp-selected');
  if(sel)sel.insertAdjacentHTML('beforeend',`<span style="background:var(--glow);color:var(--accent);font-size:11px;padding:3px 10px;border-radius:20px;border:1.5px solid rgba(79,70,229,.2)">${esc(name)} <span style="cursor:pointer;margin-left:4px" onclick="window._grpMembers=window._grpMembers.filter(x=>x!=='${uid}');this.parentNode.remove()">✕</span></span>`);
};
let _dmDebounce;
async function dmSearch(q){clearTimeout(_dmDebounce);_dmDebounce=setTimeout(async()=>{if(q.length<2)return;try{const users=await GET(`/users?q=${encodeURIComponent(q)}`);const el=document.getElementById('dm-results');if(!el)return;el.innerHTML=users.filter(u=>u.id!==S.me?.id).slice(0,6).map(u=>`<div class="uc" onclick="closeModal();openDM('${u.id}')">${avHTML(u,'av-sm')}<div class="uc-info"><div class="uc-name">${esc(u.name)}</div><div class="uc-sub">${esc(u.role||'')}</div></div><span style="font-size:12px;color:var(--accent)">Chat →</span></div>`).join('');}catch{}},300);}

/* ── GROUP SETTINGS ── */
function openGroupSettings(convId){
  const conv=S.allConvs.find(c=>c.id===convId);if(!conv)return;
  const meIsAdmin=(conv.members||[]).find(m=>m.id===S.me?.id)?.is_admin;
  modal('⚙️ Group Settings',`
    ${meIsAdmin?`<div class="fg"><label class="inp-label">Group Name</label>
      <div style="display:flex;gap:8px"><input class="inp" id="grp-new-name" value="${esc(conv.name||'')}"/><button class="btn btn-p btn-sm" onclick="_renameGrp('${convId}')">Rename</button></div>
    </div><div style="padding-top:12px;border-top:1.5px solid var(--border);margin-top:4px"><label class="inp-label">Add Member</label><div style="display:flex;gap:8px"><input class="inp" id="grp-add-q" placeholder="Search…" oninput="grpAddSearch(this.value)"/></div><div id="grp-add-results" style="max-height:160px;overflow-y:auto;border:1.5px solid var(--border);border-radius:8px;margin-top:8px"></div></div>`:''}
    <div style="padding-top:12px;border-top:1.5px solid var(--border);margin-top:10px"><div class="inp-label">Members (${conv.members?.length||0})</div><div style="max-height:180px;overflow-y:auto">${(conv.members||[]).map(m=>`<div style="display:flex;align-items:center;gap:8px;padding:8px 0">${avHTML(m,'av-xs')}<div style="flex:1"><div style="font-size:12px;font-weight:600">${esc(m.name)}</div>${m.is_admin?`<span class="admin-crown">👑 Admin</span>`:''}</div>${meIsAdmin&&m.id!==S.me?.id?`<button class="btn btn-xs btn-d" onclick="_removeGrpMember('${convId}','${m.id}')">✕</button>`:''}</div>`).join('')}</div></div>
  `,[]);
  window._renameGrp=async(cid)=>{const n=document.getElementById('grp-new-name')?.value?.trim();if(!n)return toast('Name required','e');try{await PATCH(`/conversations/${cid}/rename`,{name:n});toast('Renamed ✓','s');S.allConvs=await GET('/conversations');renderConvList(S.allConvs);}catch(e){toast(e.message,'e');}};
  window._removeGrpMember=async(cid,uid)=>{try{await DELETE(`/conversations/${cid}/members/${uid}`);toast('Removed','s');S.allConvs=await GET('/conversations');renderConvList(S.allConvs);closeModal();}catch(e){toast(e.message,'e');}};
}
async function grpAddSearch(q){
  if(q.length<2)return;
  const conv=S.allConvs.find(c=>c.id===S.activeConv);
  try{const users=await GET(`/users?q=${encodeURIComponent(q)}`);const el=document.getElementById('grp-add-results');if(!el)return;
    const memberIds=(conv?.members||[]).map(m=>m.id);
    el.innerHTML=users.filter(u=>u.id!==S.me?.id&&!memberIds.includes(u.id)).slice(0,5).map(u=>`<div style="display:flex;align-items:center;gap:8px;padding:8px 10px;cursor:pointer;border-bottom:1.5px solid var(--border);transition:.15s" onmouseover="this.style.background='var(--bg3)'" onmouseout="this.style.background=''" onclick="_addToGrp('${S.activeConv}','${u.id}',this)">${avHTML(u,'av-xs')}<div style="font-size:12px;font-weight:600">${esc(u.name)}</div><span style="font-size:11px;color:var(--accent);margin-left:auto">+ Add</span></div>`).join('')||'<div style="padding:10px;font-size:12px;color:var(--text3)">No users found</div>';
  }catch{}
}
window._addToGrp=async(convId,uid,el)=>{
  try{await POST(`/conversations/${convId}/members`,{user_id:uid});toast('Member added ✓','s');el.style.opacity='.4';el.style.pointerEvents='none';S.allConvs=await GET('/conversations');}catch(e){toast(e.message,'e');}
};

/* ── CONV WIDGET ── */
async function loadConvWidget(){
  const el=document.getElementById('conv-widget-list');if(!el)return;
  try{const convs=await GET('/conversations');if(!convs.length){el.innerHTML='<div style="padding:12px 14px;font-size:12px;color:var(--text3)">No messages yet</div>';return;}
    el.innerHTML=convs.slice(0,5).map(c=>{
      const other=c.is_group?{name:c.name}:((c.members||[]).find(m=>m.id!==S.me?.id)||c.members?.[0]||{});
      const lm=c.last_message;
      return`<div class="widget-item" onclick="go('messages:${c.id}')">
        ${c.is_group?`<div class="av av-xs" style="background:linear-gradient(135deg,var(--accent),var(--accent3))">👥</div>`:avHTML(other,'av-xs')}
        <div style="flex:1;min-width:0"><div style="font-size:12px;font-weight:600;truncate">${esc(other.name||'Chat')}</div><div style="font-size:11px;color:var(--text2);white-space:nowrap;overflow:hidden;text-overflow:ellipsis">${lm?esc((lm.content||'').slice(0,30)):''}</div></div>
        ${c.unread_count>0?`<span style="background:var(--accent);color:#fff;font-size:9px;font-weight:700;min-width:16px;height:16px;border-radius:8px;display:flex;align-items:center;justify-content:center;padding:0 3px">${c.unread_count}</span>`:'<div style="font-size:10px;color:var(--text3)">'+(lm?ago(lm.created_at):'')+'</div>'}
      </div>`;
    }).join('');}catch{}
}

/* ═══════════════════════════════════════════
   NOTIFICATIONS
═══════════════════════════════════════════ */
async function renderNotifications(){
  const m=document.getElementById('main');
  m.innerHTML=`<div class="pg-hd"><h2 class="pg-title">🔔 Notifications</h2><button class="btn btn-g btn-sm" onclick="markAllRead()">Mark all read</button></div>
  <div class="card-base" id="notif-list">${spin()}</div>`;
  try{
    const d=await GET('/notifications?page=1&limit=50');
    S.notifCount=0;updateNB();
    const el=document.getElementById('notif-list');if(!el)return;
    const notifs=d.notifications||[];
    if(!notifs.length){el.innerHTML=empt('🔔','All caught up!','No new notifications');return;}
    el.innerHTML=notifs.map(n=>notifHTML(n)).join('');
  }catch{}
}
function notifHTML(n){
  const icons={like:'❤️',follow:'👤',follow_request:'📬',follow_accepted:'✓',comment:'💬',investor_interest:'💼',team_invite:'👥',project_invite:'🎉',message:'💬',new_post:'📝'};
  const isInvite=n.type==='project_invite'||n.type==='team_invite';
  const isFollowReq=n.type==='follow_request';
  return`<div class="notif n-${n.type}${n.read?'':' unread'}" onclick="handleNotifClick('${n.ref_id||''}','${n.ref_type||''}')">
    <div class="notif-ic">${icons[n.type]||'🔔'}</div>
    <div style="flex:1">
      <div class="notif-msg"><strong>${esc(n.actor?.name||'Someone')}</strong> ${esc(n.message)}</div>
      <div class="notif-time">${ago(n.created_at)}</div>
      ${isInvite?`<div style="display:flex;gap:6px;margin-top:7px"><button class="btn btn-xs btn-success" onclick="event.stopPropagation();respondInviteNotif('${n.ref_id}','accept',this)">✓ Accept</button><button class="btn btn-xs btn-d" onclick="event.stopPropagation();respondInviteNotif('${n.ref_id}','decline',this)">✗ Decline</button></div>`:''}
      ${isFollowReq?`<div style="display:flex;gap:6px;margin-top:7px"><button class="btn btn-xs btn-success" onclick="event.stopPropagation();handleFollowReqNotif('${n.actor?.id}','accept',this)">✓ Accept</button><button class="btn btn-xs btn-d" onclick="event.stopPropagation();handleFollowReqNotif('${n.actor?.id}','decline',this)">✗ Decline</button></div>`:''}
    </div>
    ${!n.read?'<div class="udot"></div>':''}
  </div>`;
}
async function respondInviteNotif(memberId,action,btn){
  try{await POST(`/team-invites/${memberId}/respond`,{action});toast(action==='accept'?'Joined! 🎉':'Declined','s');btn.closest('[style*="display:flex"]')?.remove();}catch(e){toast(e.message,'e');}
}
async function handleFollowReqNotif(requesterId,action,btn){
  try{await POST(`/me/follow-requests/${requesterId}`,{action});toast(action==='accept'?'Follow accepted ✓':'Declined','s');btn.closest('[style*="display:flex"]')?.remove();}catch(e){toast(e.message,'e');}
}
function handleNotifClick(refId,refType){if(!refId)return;if(refType==='post')go('post:'+refId);else if(refType==='project')go('project:'+refId);else if(refType==='user')go('profile:'+refId);}
async function markAllRead(){try{await POST('/notifications/read');S.notifCount=0;updateNB();renderNotifications();}catch{}}
function updateNB(){
  const b=document.getElementById('nb');if(!b)return;
  b.textContent=S.notifCount>9?'9+':S.notifCount;
  b.classList.toggle('hidden',S.notifCount===0);
  const sbnb=document.getElementById('sb-nb');if(sbnb){sbnb.textContent=S.notifCount;sbnb.classList.toggle('hidden',S.notifCount===0);}
}
async function loadNotifCount(){
  try{const d=await GET('/notifications?page=1&limit=1');S.notifCount=d.unread_count||0;updateNB();}catch{}
}

/* ── SUGGESTED ── */
async function loadSuggested(){
  try{
    const users=await GET('/users?page=1&limit=8');syncFollowStates(users);
    const el=document.getElementById('suggested');if(!el)return;
    const list=users.filter(u=>u.id!==S.me?.id).slice(0,5);
    if(!list.length){el.innerHTML='';return;}
    el.innerHTML=list.map(u=>{
      const isFollowing=u.is_following!==undefined?u.is_following:getFollowState(u.id);
      return`<div class="widget-item">${avHTML(u,'av-sm')}<div class="uc-info"><div style="font-size:12px;font-weight:600;cursor:pointer" onclick="go('profile:${u.id}')">${esc(u.name)}</div><div style="font-size:11px;color:var(--text2)">${esc(u.role||'')}</div></div>
      <button class="follow-btn${isFollowing?' following':''}" id="sfb-${u.id}" onclick="toggleFollow('${u.id}',this)" style="font-size:11px;padding:4px 9px">${isFollowing?'Following':'Follow'}</button></div>`;
    }).join('');
  }catch{}
}

/* ── GLOBAL SEARCH ── */
let _gsDebounce;
function onSearch(q){clearTimeout(_gsDebounce);if(q.length>1)_gsDebounce=setTimeout(()=>go('search:'+q),400);}

/* ── MODAL ── */
function modal(title,body,actions=[]){
  const acts=actions.map(a=>`<button class="btn ${a.cls}" onclick="window['${a.fn}']()">${a.l}</button>`).join('');
  document.getElementById('modal').innerHTML=`<div class="mo" onclick="if(event.target===this)closeModal()"><div class="mo-box"><div class="mo-hd"><div class="mo-title">${esc(title)}</div><button class="mo-x" onclick="closeModal()">✕</button></div><div class="mo-b">${body}</div>${actions.length?`<div class="mo-f"><button class="btn btn-g" onclick="closeModal()">Cancel</button>${acts}</div>`:''}</div></div>`;
}
function closeModal(){document.getElementById('modal').innerHTML='';}

/* ── KEYBOARD SHORTCUTS ── */
document.addEventListener('keydown',e=>{
  if(e.key==='Escape'){closeModal();document.getElementById('task-fs-overlay')?.remove();}
  if(e.key==='/'&&!['INPUT','TEXTAREA','SELECT'].includes(e.target.tagName)){e.preventDefault();document.getElementById('gsearch')?.focus();}
});

/* ── INIT ── */
(async()=>{
  if(S.token){
    try{const u=await GET('/me');await boot(u);}
    catch{localStorage.removeItem('fl_token');S.token=null;showSection('landing');}
  }else{showSection('landing');}
})();
</script>
</body>
</html>