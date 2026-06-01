# Admin Operations Guide

This guide documents the administrative CRUD operations for managing blog posts in AndyPortfolio.

## Authentication

Admin operations are protected by a header-based token check. All write operations (Create, Update, Delete) and certain read operations (New, Edit forms) require the `X-Blog-Admin-Token` header.

- **Header Name:** `X-Blog-Admin-Token`
- **Environment Variable:** `BLOG_ADMIN_TOKEN` (must be set on the server)

If the token is missing, incorrect, or the `BLOG_ADMIN_TOKEN` is not configured on the server, the application returns `404 Not Found` for protected routes.

## Local Development Assumptions

The following examples assume the application is running locally at `http://127.0.0.1:3000`.
For these examples, assume the server was started with `BLOG_ADMIN_TOKEN=secret-token`.

## Operations

### 1. List Blogs

Returns a list of all blog posts. This operation is publicly accessible.

```bash
curl -i http://127.0.0.1:3000/blogs.json
```

### 2. Get Blog

Returns a single blog post. This operation is publicly accessible.

```bash
curl -i http://127.0.0.1:3000/blogs/<id>.json
```

### 3. Create Blog

Creates a new blog post. Requires admin token.

```bash
curl -i -X POST http://127.0.0.1:3000/blogs.json \
  -H "X-Blog-Admin-Token: secret-token" \
  -H "Content-Type: application/json" \
  -d '{
    "blog": {
      "title": "New Blog Post",
      "body": "This is the content of the blog post."
    }
  }'
```

### 4. Update Blog

Updates an existing blog post. Requires admin token.

```bash
curl -i -X PATCH http://127.0.0.1:3000/blogs/<id>.json \
  -H "X-Blog-Admin-Token: secret-token" \
  -H "Content-Type: application/json" \
  -d '{
    "blog": {
      "title": "Updated Blog Post Title",
      "body": "Updated content."
    }
  }'
```

### 5. Delete Blog

Deletes a blog post. Requires admin token.

```bash
curl -i -X DELETE http://127.0.0.1:3000/blogs/<id>.json \
  -H "X-Blog-Admin-Token: secret-token"
```
