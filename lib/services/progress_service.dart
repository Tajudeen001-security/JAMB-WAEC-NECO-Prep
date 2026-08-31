import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressEntry {
  final String examType;
  final String subject;
  final int score;
  final int total;
  final DateTime date;
  final int durationSeconds;

  ProgressEntry({
    required this.examType,
    required this.subject,
    required this.score,
    required this.total,
    required this.date,
    required this.durationSeconds,
  });

  double get percentage => total == 0 ? 0 : (score / total) * 100;

  Map<String, dynamic> toJson() => {
        'examType': examType,
        'subject': subject,
        'score': score,
        'total': total,
        'date': date.toIso8601String(),
        'durationSeconds': durationSeconds,
      };

  factory ProgressEntry.fromJson(Map<String, dynamic> json) => ProgressEntry(
        examType: json['examType'] ?? '',
        subject: json['subject'] ?? '',
        score: json['score'] ?? 0,
        total: json['total'] ?? 0,
        date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
        durationSeconds: json['durationSeconds'] ?? 0,
      );
}

class ProgressService {
  static const _key = 'quiz_progress_history';

  Future<void> saveResult(ProgressEntry entry) async {
    final prefs = await SharedPreferences.getInstance();
    final list = await getHistory();
    list.insert(0, entry);
    // Keep last 100 results
    final trimmed = list.take(100).toList();
    final encoded = jsonEncode(trimmed.map((e) => e.toJson()).toList());
    await prefs.setString(_key, encoded);
  }

  Future<List<ProgressEntry>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final List decoded = jsonDecode(raw);
      return decoded.map((e) => ProgressEntry.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<Map<String, double>> getSubjectAverages() async {
    final history = await getHistory();
    final map = <String, List<double>>{};
    for (final e in history) {
      map.putIfAbsent(e.subject, () => []).add(e.percentage);
    }
    return map.map((k, v) => MapEntry(k, v.reduce((a, b) => a + b) / v.length));
  }
}
