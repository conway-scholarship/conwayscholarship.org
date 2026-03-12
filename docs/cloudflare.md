# Cloudflare Configuration

## Overview

Cloudflare manages DNS, TLS, and analytics for `conwayscholarship.org`. The site itself is hosted on GitHub Pages; Cloudflare proxies traffic to provide TLS termination, DDoS protection, caching, and privacy-respecting analytics.

- **Cloudflare Account ID**: `2c4c66b6d7b1af561415110b833a3768`
- **Dashboard**: https://dash.cloudflare.com

## DNS

| Type | Name | Content | Proxy |
|------|------|---------|-------|
| A | `@` | `185.199.108.153` | Proxied (orange cloud) |
| A | `@` | `185.199.109.153` | Proxied (orange cloud) |
| A | `@` | `185.199.110.153` | Proxied (orange cloud) |
| A | `@` | `185.199.111.153` | Proxied (orange cloud) |

These are GitHub Pages IP addresses. Traffic must be **proxied** (not DNS-only) for Cloudflare analytics and TLS to work.

`media.conwayscholarship.org` is configured separately as a custom domain for the R2 bucket (see [R2 Hosting](r2-hosting.md)).

## SSL/TLS

| Setting | Value | Why |
|---------|-------|-----|
| **SSL mode** | Full | Cloudflare connects to GitHub Pages over HTTPS. Do not use "Flexible" (causes redirect loops) or "Full (Strict)" (may fail on GitHub's shared certificates). |
| **Always Use HTTPS** | Disabled | GitHub Pages handles HTTP→HTTPS redirects. Enabling this on both sides can cause redirect loops. |
| **Edge Certificates** | Cloudflare-managed | Automatic — no action needed. |

## Analytics

Cloudflare Web Analytics is enabled via **Real User Measurements (RUM)**. Cloudflare automatically injects the analytics beacon script when traffic is proxied — no script tag in the site code is needed.

- **Dashboard**: Cloudflare dashboard → **Analytics & Logs → Web Analytics**
- **Data collected**: Page views, referrers, countries, device types, browser, page load performance
- **Privacy**: No cookies, no personal data, no cross-site tracking

If DNS is switched back to DNS-only (gray cloud), analytics will stop working.

## Optimization

| Setting | Value | Why |
|---------|-------|-----|
| **Auto Minify** (HTML/JS/CSS) | Not available | This option may not be present in all Cloudflare plans. If it appears in the future, keep it disabled — it can break inline JavaScript in `_layouts/default.html` (theme toggle, mobile menu, smooth scroll). |

## CORS

A CORS policy is configured on the R2 bucket (`conway-scholarship-media`) to allow the site to fetch HLS video segments. See [R2 Hosting](r2-hosting.md) for details.

Current policy:
```json
[
  {
    "AllowedOrigins": [
      "https://conwayscholarship.org",
      "http://conwayscholarship.org",
      "http://127.0.0.1:4000"
    ],
    "AllowedMethods": ["GET", "HEAD"],
    "AllowedHeaders": ["*"],
    "MaxAgeSeconds": 86400
  }
]
```

## Troubleshooting

### Site returns redirect loops (ERR_TOO_MANY_REDIRECTS)
- Check SSL mode is set to **Full** (not Flexible)
- Check **Always Use HTTPS** is disabled in Cloudflare
- Clear browser cache or test in incognito

### Video doesn't load (CORS errors)
- Verify the CORS policy on the R2 bucket includes the requesting origin
- Check that `media.conwayscholarship.org` custom domain is still active on the R2 bucket

### Analytics not showing data
- Confirm DNS records are set to **Proxied** (orange cloud)
- Data may take a few minutes to appear after initial setup

### GitHub Pages shows certificate errors
- This is expected when DNS is proxied — GitHub can't verify the domain the same way
- Cloudflare handles TLS; the GitHub Pages certificate status is not critical
- "Enforce HTTPS" in GitHub Pages settings may not be enableable while proxied; this is fine since Cloudflare enforces HTTPS instead
