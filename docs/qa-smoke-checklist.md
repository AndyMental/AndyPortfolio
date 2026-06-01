# QA Smoke Checklist

Run local probes before release and repeat the live probes after release-ops records
the Render service URL as `deploy_url`.

## Local

| Probe | Expected result |
| --- | --- |
| `bin/setup` | Dependencies install and the database prepares successfully. |
| `bin/rails test` | Rails Minitest suite passes. |
| `bin/rails test test/integration/` | Integration suite passes. |
| `bin/rails server` | App boots locally on the configured Rails port. |
| `curl -i http://127.0.0.1:3000/up` | `200 OK`; health check returns success without DB queries. |
| `curl -i http://127.0.0.1:3000/` | `200 OK`; public blog list is served at root. |
| `curl -i http://127.0.0.1:3000/blogs` | `200 OK`; public blog list is readable. |
| `curl -i http://127.0.0.1:3000/blogs/new` | `404 Not Found`; anonymous write form is denied. |
| `curl -i -X POST http://127.0.0.1:3000/blogs -d 'blog[title]=x' -d 'blog[body]=y'` | `404 Not Found`; anonymous create is denied. |
| `curl -i -X DELETE http://127.0.0.1:3000/blogs/<existing-id>` | `404 Not Found`; anonymous delete is denied and the blog remains available. |

## Live URL

Replace `$DEPLOY_URL` with the value pinned by release-ops.

| Probe | Expected result |
| --- | --- |
| `curl -i "$DEPLOY_URL/up"` | `200 OK`; health check returns success. |
| `curl -i "$DEPLOY_URL/"` | `200 OK`; public blog list is served at root. |
| `curl -i "$DEPLOY_URL/blogs"` | `200 OK`; public blog list is readable. |
| `curl -i "$DEPLOY_URL/blogs/new"` | `404 Not Found`; anonymous write form is denied. |
| `curl -i -X POST "$DEPLOY_URL/blogs" -d 'blog[title]=x' -d 'blog[body]=y'` | `404 Not Found`; anonymous create is denied. |
| `curl -i -X DELETE "$DEPLOY_URL/blogs/<existing-id>"` | `404 Not Found`; anonymous delete is denied and the blog remains available. |

## Extended route smoke (run after the minimum table is green)

The minimum table above is the must-pass set for Render's first deploy. The
checks below cover the remaining unauthenticated route surface so a regression
in any read path, admin gate, or static-file serving is caught before release.
All probes remain unauthenticated and require no `BLOG_ADMIN_TOKEN`.

| Probe | Expected result |
| --- | --- |
| `curl -i "$DEPLOY_URL/blogs/0"` | `404 Not Found`; unknown blog id returns Rails 404. |
| `curl -i "$DEPLOY_URL/blogs/<existing-id>/edit"` | `404 Not Found`; admin-gated edit form denied to anonymous. |
| `curl -i -X PATCH "$DEPLOY_URL/blogs/<existing-id>" -d 'blog[title]=x'` | `404 Not Found`; anonymous update denied (PATCH verb). |
| `curl -i -X PUT "$DEPLOY_URL/blogs/<existing-id>" -d 'blog[title]=x'` | `404 Not Found`; anonymous update denied (PUT verb). |
| `curl -i "$DEPLOY_URL/sitemap.xml"` | `200 OK`; `Content-Type: application/xml`; non-empty body. |
| `curl -i "$DEPLOY_URL/robots.txt"` | `200 OK`; `text/plain`; confirms `RAILS_SERVE_STATIC_FILES=1`. |
| `curl -i "$DEPLOY_URL/favicon.ico"` | `200 OK`; same static-file dependency. |
| `curl -i "$DEPLOY_URL/__does_not_exist__"` | `404 Not Found`; Rails routing fallback works, no 500. |
| `curl -I "$DEPLOY_URL/"` | `200 OK`; verifies Render HEAD health checks succeed. |
| `curl -I "$DEPLOY_URL/"` (inspect headers) | `Content-Type: text/html; charset=utf-8`; `X-Request-Id` header present. |

The same probes work locally against `http://127.0.0.1:3000`.

### Out of scope (admin or env-dependent)

- Authenticated happy-path (`X-Blog-Admin-Token` header): needs the secret pinned in Render env.
- TLS / HSTS assertions: `config.force_ssl` is not enabled in the app; Render terminates TLS at the edge.
- DB-state assertions beyond list/count: covered by `test/integration/blogs_index_test.rb` and `test/integration/blog_admin_gate_test.rb`.
