# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development

Jekyll static site. Local development:

```bash
bundle install
bundle exec jekyll serve
```

Site available at `http://localhost:4000`. No tests or linters are configured.

## Deployment

Push to `main` to deploy via GitHub Pages to `https://conwayscholarship.org`.

## Architecture

Single-page Jekyll site with sections (Legacy, Scholarship, Recipients, Donate) all in `index.html` using the `default` layout.

- `_layouts/default.html` — Full HTML shell with header, footer, and all JavaScript inline (theme toggle, mobile menu, smooth scroll). Theme system uses localStorage with `theme-light`/`theme-dark` classes on `<html>`, falling back to `prefers-color-scheme` for "auto" mode.
- `index.html` — Page content as HTML sections with Jekyll front matter. Biographical content uses footnote-style `<sup>` citations linking to external sources.
- `assets/css/style.css` — Styles using U-M brand colors with dark mode support via both `prefers-color-scheme` media queries and explicit theme classes.
- `_config.yml` — Uses `jekyll-seo-tag` plugin.

## Communication Style

### Question User Assertions
- When the user makes factual claims, politely verify or ask for sources rather than accepting them at face value
- If something seems inconsistent or potentially incorrect, ask clarifying questions
- Challenge assumptions constructively when appropriate
- Ask "Are you sure about X?" or "Can you point me to where that's documented?" when claims are uncertain

### Avoid Self-Congratulatory Language
- Do not use phrases like "Great research!", "Excellent work!", "Now I have great research", etc.
- Skip unnecessary commentary about your own process or performance
- Focus on the task and deliverables, not meta-commentary about how well things are going
- Be direct and matter-of-fact rather than self-praising

### General Guidelines
- Be concise and direct
- Ask questions when requirements are unclear rather than making assumptions
- If you notice potential issues or inconsistencies, raise them proactively
- Prioritize accuracy over speed

## Project Context

Website for the Lynn Conway Memorial Scholarship at the University of Michigan, awarded to members of the UM chapter of oSTEM (Out in Science, Technology, Engineering, and Mathematics). Lynn Conway (1938–2024) was a computer scientist, engineer, and transgender rights advocate.
