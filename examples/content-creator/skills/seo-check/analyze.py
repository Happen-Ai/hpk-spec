"""SEO-check skill — analyzes short-form script drafts."""
import re

AI_SLOP = [
    "in today's fast-paced world",
    "it's important to note",
    "furthermore",
    "moreover",
    "in conclusion",
    "delve into",
    "landscape of",
    "navigate the",
]

def analyze(text: str, platform: str = "instagram") -> dict:
    lines = [l.strip() for l in text.splitlines() if l.strip()]
    hook = lines[0] if lines else ""

    hook_strength = "strong" if len(hook.split()) <= 10 else "weak"
    slop_hits = [p for p in AI_SLOP if p in text.lower()]

    score = 100
    score -= 20 if hook_strength == "weak" else 0
    score -= 10 * len(slop_hits)
    score = max(0, score)

    words = re.findall(r"[a-zA-Z]+", text.lower())
    freq = {}
    for w in words:
        if len(w) > 4:
            freq[w] = freq.get(w, 0) + 1
    keywords = sorted(freq, key=freq.get, reverse=True)[:5]

    return {
        "score": score,
        "hook_strength": hook_strength,
        "keywords": keywords,
        "hashtags": [f"#{k}" for k in keywords[:3]],
        "notes": [f"AI-slop phrase detected: '{s}'" for s in slop_hits]
                 or ["No slop detected — clean draft."],
    }
