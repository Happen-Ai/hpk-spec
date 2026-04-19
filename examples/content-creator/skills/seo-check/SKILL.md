---
name: seo-check
description: Analyzes a draft for hook strength, keyword fit, and hashtag recommendations. Returns a score 0-100 and actionable notes.
version: 1.0.0
license: MIT
---

# SEO Check

Local skill. No API calls.

## Tools

### analyze
**Input:** `{text: string, platform: "instagram"|"tiktok"|"youtube-shorts"|"x"}`
**Output:**
```json
{
  "score": 87,
  "hook_strength": "strong",
  "keywords": ["creator", "algorithm", "growth"],
  "hashtags": ["#creatoreconomy", "#shorts", "#growthtips"],
  "notes": ["Hook lands in 1.2s — good", "Line 4 has filler: 'it's important to note'"]
}
```

## Implementation
See `analyze.py`. Pure Python, stdlib only.
