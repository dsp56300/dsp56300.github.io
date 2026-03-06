# Copilot Instructions

## Project Overview

Jekyll-based GitHub Pages site for **The Usual Suspects** (`theusualsuspects.io`) — a community project digitally preserving classic synthesizers through hardware-level DSP emulation. The site documents the [gearmulator](https://github.com/dsp56300/gearmulator) project (Motorola DSP563XX emulation powering Access Virus, Waldorf, Roland JP-8000, Nord Lead, etc. plugins).

## Build & Serve

```bash
bundle install
bundle exec jekyll serve    # local dev with live reload at http://localhost:4000
bundle exec jekyll build    # production build → _site/ (gitignored)
```

GitHub Pages builds and deploys automatically on push to the default branch.

## Architecture

### Navigation is centralized in `_config.yml`

All site navigation (header dropdowns and links) is defined in the `navigation:` array in `_config.yml`. `_layouts/default.html` renders it via a Liquid loop. To add a page to the nav, add an entry to `_config.yml` — no layout changes needed.

Divider lines in dropdown menus use `title: "──────────────"` (no `url:`). The `technical.md` hub page filters these out with `{% unless child.title contains "──" %}`.

### Two layouts

- **`_layouts/default.html`** — all regular pages; renders the nav, header, and `{{ content }}`
- **`_layouts/post.html`** — blog posts; wraps default, adds `<h1>`, formatted date, and optional tags

The only custom include is **`_includes/head-custom.html`** (currently just the favicon). Add any custom `<head>` content there.

### `builds/` caches GitHub Release data

`builds/` contains `versions.json` and per-release JSON files (`2.1.4.json`, etc.) fetched from the `dsp56300/gearmulator` GitHub API. The JS-driven downloads page at `builds/downloads.md` reads these cached files first, then falls back to the live API. When a new release ships, add `builds/<version>.json` and update `builds/versions.json`.

## Conventions

### Blog posts (`_posts/`)

- **Filename:** `YYYY-MM-DD-kebab-slug.md`
- **Front matter:**
  ```yaml
  ---
  title: "Post Title"
  date: 2025-01-15
  layout: post
  tags: [optional, tag, array]   # omit if no tags
  ---
  ```
- Post images go in `/images/posts/<slug>/` (slug = filename without date prefix)
- For posts that move to a permanent doc page, use `redirect_to: /docs/target` with `layout: default` and an explicit `permalink:`

### Regular pages (`docs/`, `technical/`, `downloads/`)

```yaml
---
title: "Page Title"
layout: default
permalink: /section/page-name
---
```

Place the file in the matching directory (`docs/page-name.md` → `permalink: /docs/page-name`). Then add an entry under the appropriate `children:` in `_config.yml`.

### Images

- Post images: `/images/posts/<post-slug>/filename.ext`
- Shared/page images: `/images/filename.ext`
- Reference with root-relative paths: `![alt](/images/posts/slug/image.png)`
