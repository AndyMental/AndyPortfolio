# Post-Owner-Merge Visual Smoke Checklist

Use this checklist after the owner-gated merge stacks for StreakBeacon and
AndyPortfolio land. It consolidates the separate smoke matrices from AND-6525
and AND-6529 so workers can validate the visible product surfaces once, without
duplicating product-code changes.

## Owner-Only Prerequisites

- StreakBeacon: owner merge or review-gate resolution for app PRs #81, #101,
  #102, and tests PR #34. If PR #103 from AND-6504 is included in the same
  release packet, merge it before import/export recovery checks.
- StreakBeacon: record the stable Vercel deploy URL before live black-box
  Playwright or manual live verification.
- AndyPortfolio: owner merge or ultrareview resolution for PRs #18, #52, #63,
  #66, #72, and #75.
- AndyPortfolio: record the Render deploy URL before live release checks.
- Do not run worker smoke checks against pre-merge branches unless a reviewer
  explicitly asks for branch QA.

## Worker-Executable Setup After Merge

### StreakBeacon

Use the commands documented by the relevant StreakBeacon PR handoffs and the
AND-6529 smoke-matrix result:

```sh
npm install
npm run lint
npm run preview:preflight
```

For tests that require a deployed app, set the recorded Vercel URL as the base
URL used by the StreakBeacon black-box test harness before running browser
checks.

### AndyPortfolio

Use the Rails commands documented by this repo's `AGENTS.md`:

```sh
bin/setup
bin/rails test
bin/rails test test/integration/
bin/rails server
```

If Ruby, Bundler, or PostgreSQL are unavailable in the worker runtime, record
that blocker verbatim and continue only with manual browser checks that do not
require a local boot.

## Priority 1: Release-Blocking Visual Checks

| Product | Source | Surface | Desktop and mobile expectation | States to cover | Worker check |
| --- | --- | --- | --- | --- | --- |
| StreakBeacon | PR #81 | Dashboard and Weekly Overview date-sensitive behavior | Today's cell, current week, and completion state are based on the real current date, not the old demo date. The weekly grid remains readable at mobile width and does not shift when today's state changes. | Empty active habits, active habits with open days, completed today, current-week refresh after toggling today. | Run `npm run preview:preflight`, then manually open the dashboard on desktop and mobile widths and toggle today's habit completion. |
| StreakBeacon | PR #34 | Weekly Overview Gherkin and smoke expectations | The 7-day overview shows active habits only, exposes open days, updates after today's completion changes, and provides understandable cell status labels for assistive tech. | No active habits, one active habit, open days, completed days, screen-reader labels. | Run the StreakBeacon test harness after merge; live browser validation waits for the recorded Vercel URL. |
| AndyPortfolio | PR #75 | Global stylesheet order | Simple.css and Prism load before the Rails app stylesheet, so local breadcrumb, nav, card, and footer overrides win. Desktop and mobile styles should match the intended app overrides instead of reverting to vendor defaults. | Public pages with nav/footer, blog index cards, blog detail breadcrumbs. | Run `bin/rails test test/integration/accessibility_smoke_test.rb` if available, then inspect `/`, `/blogs`, `/about`, and a blog detail page at desktop and mobile widths. |
| AndyPortfolio | PR #66 | Breadcrumbs and global navigation accessibility | Breadcrumb separators are visual only, current breadcrumb item and active global nav link expose `aria-current="page"`, and visible layout remains unchanged across desktop and mobile. | Root, `/about`, `/blogs`, blog detail, new/edit form when admin token is present. | Run `bin/rails test test/integration/accessibility_test.rb` if available, then inspect nav and breadcrumb states in the browser. |

## Priority 2: Core Product Surface Checks

| Product | Source | Surface | Desktop and mobile expectation | States to cover | Worker check |
| --- | --- | --- | --- | --- | --- |
| StreakBeacon | PR #101 | Dashboard habit search | The habit search input has a programmatic accessible name and still filters habits without visual layout regression. On mobile, the label remains available to assistive tech without crowding the toolbar. | Empty habit list, matching results, no results, keyboard focus. | Run `npm run preview:preflight`; manually verify search focus, filtering, and accessible-name evidence from the test output or browser accessibility tree. |
| StreakBeacon | PR #102 | Settings Paste JSON import textarea | The paste-import textarea has an explicit label/id association and keeps the existing import workflow. The settings panel remains usable on narrow screens. | Empty textarea, valid JSON import, invalid JSON error, disabled/submitting state if present. | Run `npm run lint` and `npm run preview:preflight`; manually open settings and exercise paste import success and error paths. |
| StreakBeacon | PR #103 / AND-6504, if merged in packet | Import, export, and reset recovery UI | Empty, success, and error messages for data controls are understandable and do not obscure primary settings actions on desktop or mobile. | No saved data, successful export, successful import, invalid import, reset confirmation/cancel. | Manually exercise settings data controls after PR #103 lands; do not duplicate this check if PR #103 is outside the release packet. |
| AndyPortfolio | PR #52 | Blog estimated reading time | Blog cards and show pages display estimated reading time near the blog metadata without breaking the card grid or detail page hierarchy. Text wraps cleanly on mobile. | Short post, long post, sanitized body content, blog index, blog detail. | Run `bin/rails test test/integration/blog_reading_time_test.rb` if available; manually inspect `/blogs` and one blog detail page. |
| AndyPortfolio | PR #72 | Active nav and social footer links | Header links show the active page consistently, Blog remains active for `/blogs` subpaths, and footer LinkedIn/GitHub links are visible, keyboard reachable, and open safely in new tabs. | Home, About, Blogs index, blog detail, mobile width, keyboard focus. | Run `bin/rails test test/integration/layout_links_test.rb` if available; manually inspect header/footer across public pages. |

## Priority 3: Admin and Edge-State Checks

| Product | Source | Surface | Desktop and mobile expectation | States to cover | Worker check |
| --- | --- | --- | --- | --- | --- |
| AndyPortfolio | PR #18 | Blog validation behavior | Blank or whitespace-only blog title/body submissions are rejected and the form remains readable with validation feedback. Anonymous visitors still cannot reach write routes. | Blank title, blank body, whitespace-only fields, valid blog, anonymous `/blogs/new`. | Run `bin/rails test test/models/blog_test.rb` and the integration suite if available; manually submit invalid admin forms with `BLOG_ADMIN_TOKEN` configured. |
| AndyPortfolio | PR #63 | Admin operations documentation | The admin guide matches the visible/admin route behavior and does not imply anonymous write access. | List, show, create, update, delete examples; missing token; valid token. | Review `docs/admin-operations.md` after merge against `config/routes.rb` and `BlogsController`; run the existing anonymous denial probes in `docs/qa-smoke-checklist.md`. |

## Final Pass

- Run the existing local and live probes in `docs/qa-smoke-checklist.md` for
  AndyPortfolio after the Render URL is recorded.
- Repeat desktop and mobile viewport checks for every route or panel above.
- Capture any mismatch as a new issue with the source PR number, route or panel,
  viewport, expected behavior, actual behavior, and whether the failure is local,
  live, or both.
