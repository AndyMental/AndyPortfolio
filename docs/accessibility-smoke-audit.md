# Accessibility Smoke Audit Plan

This Rails app has no separate frontend package or browser automation harness.
Use the repo-local Rails integration path documented in `AGENTS.md`:

```sh
bin/rails test test/integration/accessibility_smoke_test.rb
bin/rails test test/integration/
```

## Public UI Surfaces

- `/` and `/blogs`: blog index, global header navigation, page heading, search form, empty-state status region, blog card links, footer.
- `/about`: static portfolio context page, global header navigation, page heading, body content, footer.
- `/blogs/:id`: blog detail page, breadcrumb navigation, page heading, body rendering, back link, footer.

## Admin-Gated UI Surfaces

These routes are user-facing once the `BLOG_ADMIN_TOKEN` header is present, so
they belong in the smoke audit even though anonymous visitors receive 404s.

- `/blogs/new`: blog creation form, title/body labels and fields, submit control, backlink.
- `/blogs/:id/edit`: blog editing form, title/body labels and fields, submit control, show/back links.
- `/blogs/:id`: admin-only edit and delete controls on the show page.

## Non-UI Public Endpoints

These should remain in smoke coverage for response shape and routing, but they
do not need visual accessibility assertions.

- `/up`: Render health check.
- `/sitemap.xml`: XML sitemap.
- `/robots.txt`: crawler directives.

## Lightweight Assertions

- Each HTML document declares `lang="en"` and a viewport meta tag.
- Public pages expose header navigation, a `main` landmark, footer content, and exactly one `h1`.
- Search input has an associated label and empty/no-result states use a live status region.
- Anonymous visitors do not see admin-only controls.
- Admin forms expose labels for title and body inputs.
- Non-UI endpoints return the expected status and media type.
