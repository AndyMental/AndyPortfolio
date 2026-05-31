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
| `curl -i http://127.0.0.1:3000/up` | `200 OK`; Render health check returns `OK`. |
| `curl -i http://127.0.0.1:3000/` | `200 OK`; public homepage serves the blogs index. |
| `curl -i http://127.0.0.1:3000/blogs` | `200 OK`; public blog list is readable. |
| `curl -i http://127.0.0.1:3000/blogs/new` | `404 Not Found`; anonymous write form is denied. |
| `curl -i -X POST http://127.0.0.1:3000/blogs -d 'blog[title]=x' -d 'blog[body]=y'` | `404 Not Found`; anonymous create is denied. |
| `curl -i -X DELETE http://127.0.0.1:3000/blogs/<existing-id>` | `404 Not Found`; anonymous delete is denied and the blog remains available. |

## Live URL

Replace `$DEPLOY_URL` with the value pinned by release-ops.

| Probe | Expected result |
| --- | --- |
| `curl -i "$DEPLOY_URL/up"` | `200 OK`; Render health check returns `OK`. |
| `curl -i "$DEPLOY_URL/"` | `200 OK`; public homepage serves the blogs index. |
| `curl -i "$DEPLOY_URL/blogs"` | `200 OK`; public blog list is readable. |
| `curl -i "$DEPLOY_URL/blogs/new"` | `404 Not Found`; anonymous write form is denied. |
| `curl -i -X POST "$DEPLOY_URL/blogs" -d 'blog[title]=x' -d 'blog[body]=y'` | `404 Not Found`; anonymous create is denied. |
| `curl -i -X DELETE "$DEPLOY_URL/blogs/<existing-id>"` | `404 Not Found`; anonymous delete is denied and the blog remains available. |
