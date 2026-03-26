import http from 'k6/http';
import { check, sleep } from 'k6';

export let options = {
  vus: 500, // virtual users
  duration: '30s',
};

export default function () {
  let res = http.get('http://localhost:8080/health');

  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 200ms': (r) => r.timings.duration < 200,
  });

  sleep(1);
}