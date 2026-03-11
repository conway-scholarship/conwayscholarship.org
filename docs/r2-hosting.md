# Cloudflare R2 Media Hosting

## Overview

Video files are hosted on Cloudflare R2 and served via a custom domain. R2 was chosen for its zero egress fees, which avoids surprise bills if video traffic spikes.

## Bucket

- **Bucket name**: `conway-scholarship-media`
- **Public domain**: `https://media.conwayscholarship.org`
- **Account ID**: `2c4c66b6d7b1af561415110b833a3768`
- **S3 endpoint**: `https://2c4c66b6d7b1af561415110b833a3768.r2.cloudflarestorage.com`

## Bucket Contents

| Path | Description |
|------|-------------|
| `conway-source.mp4` | Original source video (1080p, ~608MB) |
| `hls/conway.m3u8` | HLS master playlist |
| `hls/0/` | 1080p segments @ 5000k |
| `hls/1/` | 720p segments @ 2800k |
| `hls/2/` | 480p segments @ 1400k |

## Uploading

### HLS segments (< 300MB total per file)

```bash
wrangler r2 object put conway-scholarship-media/<path> --file=<local-file> --remote
```

Or sync the entire `hls/` directory using the AWS CLI:

```bash
aws s3 sync hls/ s3://conway-scholarship-media/hls/ \
  --endpoint-url https://2c4c66b6d7b1af561415110b833a3768.r2.cloudflarestorage.com \
  --profile r2
```

### Files over 300MB

Wrangler and the Cloudflare dashboard both have a 300MB upload limit. Use the AWS CLI instead, which handles multipart uploads automatically:

```bash
aws s3 cp <local-file> s3://conway-scholarship-media/<path> \
  --endpoint-url https://2c4c66b6d7b1af561415110b833a3768.r2.cloudflarestorage.com \
  --profile r2 \
  --content-type "video/mp4"
```

### AWS CLI setup for R2

Create an R2 API token in the Cloudflare dashboard under **R2 Object Storage → Manage R2 API Tokens**, then configure a profile:

```bash
aws configure set aws_access_key_id <ACCESS_KEY_ID> --profile r2
aws configure set aws_secret_access_key <SECRET_ACCESS_KEY> --profile r2
aws configure set region auto --profile r2
```

## Regenerating HLS

See `scripts/transcode-hls.sh`. To regenerate and re-upload from the source:

```bash
# Download source from R2
aws s3 cp s3://conway-scholarship-media/conway-source.mp4 conway-source.mp4 \
  --endpoint-url https://2c4c66b6d7b1af561415110b833a3768.r2.cloudflarestorage.com \
  --profile r2

# Transcode
./scripts/transcode-hls.sh conway-source.mp4

# Upload new segments
aws s3 sync hls/ s3://conway-scholarship-media/hls/ \
  --endpoint-url https://2c4c66b6d7b1af561415110b833a3768.r2.cloudflarestorage.com \
  --profile r2
```

## Custom Domain

The bucket is served publicly via `media.conwayscholarship.org`, configured in the Cloudflare dashboard under the bucket's **Settings → Custom Domains**. The domain must be proxied through Cloudflare (orange cloud) for this to work.
