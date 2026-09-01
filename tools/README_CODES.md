# Activation codes (PRIVATE)

## Generate 5,000 codes on your computer

```bash
cd tools
python3 generate_activation_codes.py --count 5000 --out activation_codes_5000.txt
```

Keep `activation_codes_5000.txt` **only on your machine** (or private storage).  
Do **not** commit the full list to a public GitHub repo — anyone could unlock premium for free.

## Code meaning

Format: `XXXX-XXXX-XXXX-XXXX-XXXX` (20 characters)

- 1st letter after cleaning: **J** = JAMB only, **W** = JAMB+WAEC, **A** = ALL ACCESS  
- 2nd letter: **7** = 1 week, **M** = 1 month, **Y** = 1 year  
- Remaining characters: random + signature

The app verifies the signature offline and binds the code to that phone/installation.

## After a user pays

1. Confirm transfer to **9160654415** (OPay or Zenith) — **Gbadamosi Tajudeen Olajide**
2. User emails screenshot to **jrilicense@gmail.com** with name, phone/email, plan
3. Send **one unused code** matching the plan they paid for
4. Mark that code as used in your own spreadsheet so you do not resend it

## Test codes

Generate a few with the script for your own device testing. Do not share test codes publicly.
