// The browser calls /api/... on the Next.js server, which forwards to
// FastAPI on port 8000. One origin for the browser = no CORS setup, and
// the API address can change with the MB_API_URL environment variable.
const API = process.env.MB_API_URL || "http://127.0.0.1:8000";

export default {
  async rewrites() {
    return [{ source: "/api/:path*", destination: `${API}/api/:path*` }];
  },
};
