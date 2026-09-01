#!/usr/bin/env python3
"""Generate HMAC-signed activation codes for JRI PREP.

Must match lib/services/premium_service.dart logic.
Keep this script and the generated list private (do not publish the full list).
"""
import hmac
import hashlib
import secrets
import argparse

SECRET = b"JRI-PREP-2026-Tajudeen-Activation-Key-v1"
ALPHABET = "ABCDEFGHJKLMNPQRSTUVWXYZ23456789"


def sig4(body: str) -> str:
    h = hmac.new(SECRET, body.encode(), hashlib.sha256).hexdigest()
    return "".join(ALPHABET[int(h[i : i + 2], 16) % len(ALPHABET)] for i in range(0, 8, 2))


def make_code(plan_key: str, dur_key: str) -> str:
    rnd = "".join(secrets.choice(ALPHABET) for _ in range(14))
    body = plan_key + dur_key + rnd  # 16
    raw = body + sig4(body)  # 20
    return "-".join(raw[i : i + 4] for i in range(0, 20, 4))


def verify(code: str) -> bool:
    raw = code.replace("-", "").upper()
    if len(raw) != 20:
        return False
    return raw[16:] == sig4(raw[:16])


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--count", type=int, default=5000)
    parser.add_argument("--out", default="activation_codes_5000.txt")
    args = parser.parse_args()

    mix = [
        ("J", "7"),
        ("J", "M"),
        ("J", "Y"),
        ("W", "7"),
        ("W", "M"),
        ("W", "Y"),
        ("A", "7"),
        ("A", "M"),
        ("A", "Y"),
    ]
    codes = []
    i = 0
    while len(codes) < args.count:
        p, d = mix[i % len(mix)]
        c = make_code(p, d)
        if c not in codes and verify(c):
            codes.append(c)
        i += 1

    with open(args.out, "w", encoding="utf-8") as f:
        f.write("\n".join(codes) + "\n")
    print(f"Wrote {len(codes)} codes to {args.out}")
    print("Plan keys: J=JAMB, W=JAMB+WAEC, A=ALL | Duration: 7=week, M=month, Y=year")


if __name__ == "__main__":
    main()
