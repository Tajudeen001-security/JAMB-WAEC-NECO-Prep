import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/premium.dart';

class PremiumService {
  static const adminEmail = 'gbadamositajudeenwan@gmail.com';
  static const _codesKey = 'jri_activation_codes';
  static const _entitlementKey = 'jri_entitlement';

  Future<String> _deviceId() async {
    final p = await SharedPreferences.getInstance();
    var id = p.getString('jri_installation_id');
    if (id == null) {
      final r = Random.secure();
      id = List.generate(32, (_) => r.nextInt(16).toRadixString(16)).join();
      await p.setString('jri_installation_id', id);
    }
    return id;
  }

  String _makeCode(Random r) {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    return List.generate(16, (_) => chars[r.nextInt(chars.length)]).join();
  }

  /// Creates a private local inventory for testing/admin builds.
  /// Production activation inventory should be generated and stored server-side.
  Future<int> generateCodes({int count = 5000}) async {
    final p = await SharedPreferences.getInstance();
    final existing = (p.getStringList(_codesKey) ?? <String>[]).toSet();
    final r = Random.secure();
    while (existing.length < count) existing.add(_makeCode(r));
    await p.setStringList(_codesKey, existing.toList());
    return existing.length;
  }

  Future<bool> activate(String rawCode, PremiumPlan plan, PremiumDuration duration) async {
    final p = await SharedPreferences.getInstance();
    final codes = p.getStringList(_codesKey) ?? <String>[];
    final code = rawCode.trim().toUpperCase();
    if (!codes.contains(code)) return false;
    codes.remove(code);
    await p.setStringList(_codesKey, codes);

    final days = duration == PremiumDuration.week
        ? 7
        : duration == PremiumDuration.month ? 30 : 365;
    final expires = DateTime.now().add(Duration(days: days));
    await p.setString(_entitlementKey, jsonEncode({
      'plan': plan.name,
      'expires': expires.toIso8601String(),
      'device': await _deviceId(),
    }));
    return true;
  }

  Future<bool> hasAccess(String feature) async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_entitlementKey);
    if (raw == null) return false;
    final e = jsonDecode(raw) as Map<String, dynamic>;
    final expires = DateTime.tryParse(e['expires']?.toString() ?? '');
    if (expires == null || expires.isBefore(DateTime.now())) return false;
    final plan = e['plan']?.toString() ?? '';
    if (plan == PremiumPlan.allAccess.name) return true;
    if (plan == PremiumPlan.jambWaec.name) {
      return feature == 'jamb' || feature == 'waec';
    }
    return feature == 'jamb' && plan == PremiumPlan.jamb.name;
  }

  Future<Map<String, dynamic>?> entitlement() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_entitlementKey);
    return raw == null ? null : jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<int> remainingCodeCount() async {
    final p = await SharedPreferences.getInstance();
    return (p.getStringList(_codesKey) ?? <String>[]).length;
  }
}
