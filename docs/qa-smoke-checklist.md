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

## Visual UI

Run these against local desktop and mobile viewports before release, then repeat
against the live URL after release.

| Surface | State to check | Expected result |
| --- | --- | --- |
| `/` and `/blogs` | Populated blog index | Header navigation, breadcrumbs, search form, blog cards, RSS link, and footer render without overlap or horizontal scrolling. |
| `/blogs` | Empty database | Empty-state status region renders with "No posts yet" and preserves the surrounding layout. |
| `/blogs?q=<missing-term>` | No search results | Search input preserves the query, Clear link is visible, and the empty-state status region renders without shifting the header/footer. |
| `/about` | Static page | About copy and Focus Areas list render under a single page heading with the global header/footer. |
| `/blogs/<existing-id>` | Public blog detail | Breadcrumbs, title, rendered body content, and Back to blogs link are readable; anonymous visitors do not see edit/delete controls. |
| `/blogs/<existing-id>` with `X-Blog-Admin-Token` | Admin detail controls | Edit link and delete button are visible and do not crowd the public back link on desktop or mobile. |
| `/blogs/new` with `X-Blog-Admin-Token` | New blog form | Title/body labels and fields, submit control, and Back to blogs link are visible and aligned. |
| `/blogs/<existing-id>/edit` with `X-Blog-Admin-Token` | Edit blog form | Title/body labels and fields, submit control, Show this blog link, and Back to blogs link are visible and aligned. |
| `/blogs/new` or `/blogs/<existing-id>/edit` with `X-Blog-Admin-Token` | Form validation errors after blank submit | Error summary appears above the fields and remains readable on desktop and mobile. |

This app is server-rendered with no checked-in async loading UI; there is no
source-backed loading-state visual check to run.

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
