# Lynn Conway Memorial Scholarship

A website honoring the legacy of Lynn Conway (1938–2024), trailblazing computer scientist and advocate for LGBTQ+ inclusion in STEM.

This scholarship is awarded to members of the University of Michigan chapter of oSTEM (Out in Science, Technology, Engineering, and Mathematics).

## Local Development

To run this site locally:

```bash
bundle install
bundle exec jekyll serve
```

Then visit `http://localhost:4000`

## Deployment

This site is hosted on GitHub Pages and automatically deploys when changes are pushed to the main branch.

## HLS Video

The homepage features an HLS adaptive bitrate video player. The HLS segments are not checked into git — they must be regenerated from the source video and uploaded to the CDN.

To regenerate all HLS files (requires `ffmpeg`):

```bash
./scripts/transcode-hls.sh /path/to/conway.mp4
```

This produces `hls/conway.m3u8` (the master playlist) and per-tier directories with segments:

```
hls/
├── conway.m3u8
├── 0/          # 1080p @ 5000k (skipped if source ≤ 720p)
├── 1/          # 720p  @ 2800k
└── 2/          # 480p  @ 1400k
```

Upload the `hls/` directory to the CDN (Cloudflare R2) after regenerating.

### Media Storage

Video files are too large for Git. Source and generated files are stored on Cloudflare R2 in the `conway-scholarship-media` bucket:

- `conway-source.mp4` — Original source video (1080p, ~608MB)
- `hls/` — Generated HLS segments and playlists

The R2 bucket is managed via the [Cloudflare dashboard](https://dash.cloudflare.com). To regenerate HLS from the source, download `conway-source.mp4` from R2 and run the transcode script above.

## Structure

- `index.html` - Main content page
- `_layouts/default.html` - Page template
- `assets/css/style.css` - Styles
- `_config.yml` - Jekyll configuration
- `scripts/transcode-hls.sh` - HLS transcoding script
