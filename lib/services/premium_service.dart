import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/premium.dart';

/// Offline activation using HMAC-signed codes.
/// Admin generates codes with the same secret (see tools/generate_activation_codes.py).
/// Once activated, entitlement is bound to this installation and expires automatically.
class PremiumService {
  static const adminEmail = 'jrilicense@gmail.com';
  static const supportEmail = 'jrilicense@gmail.com';

  // Keep private. Used only to verify codes you issue after payment confirmation.
  static const _secret = 'JRI-PREP-2026-Tajudeen-Activation-Key-v1';
  static const _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  static const _entitlementKey = 'jri_entitlement';
  static const _usedCodesKey = 'jri_used_codes';
  static const _deviceKey = 'jri_installation_id';

  Future<String> deviceId() async {
    final p = await SharedPreferences.getInstance();
    var id = p.getString(_deviceKey);
    if (id == null || id.isEmpty) {
      final r = Random.secure();
      id = List.generate(32, (_) => r.nextInt(16).toRadixString(16)).join();
      await p.setString(_deviceKey, id);
    }
    return id;
  }

  String _sig4(String body) {
    final digest = Hmac(sha256, utf8.encode(_secret)).convert(utf8.encode(body));
    final hex = digest.toString();
    final buf = StringBuffer();
    for (var i = 0; i < 8; i += 2) {
      final v = int.parse(hex.substring(i, i + 2), radix: 16);
      buf.write(_alphabet[v % _alphabet.length]);
    }
    return buf.toString();
  }

  /// Validates format + HMAC signature. Returns plan/duration if valid.
  ({PremiumPlan plan, PremiumDuration duration})? parseSignedCode(String raw) {
    final code = raw.replaceAll('-', '').replaceAll(' ', '').toUpperCase();
    if (code.length != 20) return null;
    final body = code.substring(0, 16);
    final sig = code.substring(16);
    if (_sig4(body) != sig) return null;

    final planKey = body[0];
    final durKey = body[1];

    PremiumPlan? plan;
    if (planKey == 'J') {
      plan = PremiumPlan.jamb;
    } else if (planKey == 'W') {
      plan = PremiumPlan.jambWaec;
    } else if (planKey == 'A') {
      plan = PremiumPlan.allAccess;
    } else {
      return null;
    }

    PremiumDuration? duration;
    if (durKey == '7') {
      duration = PremiumDuration.week;
    } else if (durKey == 'M') {
      duration = PremiumDuration.month;
    } else if (durKey == 'Y') {
      duration = PremiumDuration.year;
    } else {
      return null;
    }

    return (plan: plan, duration: duration);
  }

  Future<bool> activate(String rawCode) async {
    final parsed = parseSignedCode(rawCode);
    if (parsed == null) return false;

    final normalized = rawCode.replaceAll('-', '').replaceAll(' ', '').toUpperCase();
    final p = await SharedPreferences.getInstance();
    final used = p.getStringList(_usedCodesKey) ?? <String>[];
    if (used.contains(normalized)) return false;

    final days = parsed.duration == PremiumDuration.week
        ? 7
        : parsed.duration == PremiumDuration.month
            ? 30
            : 365;

    final expires = DateTime.now().add(Duration(days: days));
    final device = await deviceId();

    used.add(normalized);
    await p.setStringList(_usedCodesKey, used);
    await p.setString(
      _entitlementKey,
      jsonEncode({
        'plan': parsed.plan.name,
        'duration': parsed.duration.name,
        'expires': expires.toIso8601String(),
        'device': device,
        'code': normalized,
        'activatedAt': DateTime.now().toIso8601String(),
      }),
    );
    return true;
  }

  Future<bool> hasAccess(String feature) async {
    final e = await entitlement();
    if (e == null) return false;
    final expires = DateTime.tryParse(e['expires']?.toString() ?? '');
    if (expires == null || expires.isBefore(DateTime.now())) return false;

    // Device binding: entitlement only valid on the device that activated it
    final bound = e['device']?.toString();
    final current = await deviceId();
    if (bound == null || bound != current) return false;

    final plan = e['plan']?.toString() ?? '';
    if (plan == PremiumPlan.allAccess.name) return true;
    if (plan == PremiumPlan.jambWaec.name) {
      return feature == 'jamb' || feature == 'waec' || feature == 'utme' || feature == 'wassce';
    }
    return (feature == 'jamb' || feature == 'utme') && plan == PremiumPlan.jamb.name;
  }

  Future<Map<String, dynamic>?> entitlement() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_entitlementKey);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<bool> isPremiumActive() async {
    final e = await entitlement();
    if (e == null) return false;
    final expires = DateTime.tryParse(e['expires']?.toString() ?? '');
    if (expires == null || expires.isBefore(DateTime.now())) return false;
    final bound = e['device']?.toString();
    final current = await deviceId();
    return bound != null && bound == current;
  }
}
