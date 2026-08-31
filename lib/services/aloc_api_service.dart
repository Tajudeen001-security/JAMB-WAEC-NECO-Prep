import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../data/sample_questions.dart';
import '../models/question.dart';

class AlocApiService {
  static final AlocApiService _instance = AlocApiService._internal();
  factory AlocApiService() => _instance;
  AlocApiService._internal();

  final Map<String, List<Question>> _cache = {};

  Future<List<Question>> fetchQuestions({
    required String subject,
    String? type,
    String? year,
    int count = 20,
  }) async {
    final cacheKey = '$subject-${type ?? 'any'}-${year ?? 'any'}';
    if (_cache.containsKey(cacheKey) && _cache[cacheKey]!.isNotEmpty) {
      final cached = List<Question>.from(_cache[cacheKey]!);
      cached.shuffle();
      return cached.take(count).toList();
    }

    // Always merge with our large offline bank so users never see empty sets
    final offline = getSampleQuestionsFor(subject, type: type, count: count);

    if (alocAccessToken == 'YOUR_ALOC_TOKEN_HERE' || alocAccessToken.isEmpty) {
      return offline;
    }

    try {
      final queryParams = <String, String>{'subject': subject};
      if (type != null && type.isNotEmpty) queryParams['type'] = type;
      if (year != null && year.isNotEmpty) queryParams['year'] = year;

      final uri = Uri.parse('$alocBaseUrl/m').replace(queryParameters: queryParams);

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'AccessToken': alocAccessToken,
        },
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        List<Question> questions = [];

        if (body is Map && body['data'] != null) {
          final data = body['data'];
          if (data is List) {
            for (final item in data) {
              if (item is Map<String, dynamic>) {
                questions.add(Question.fromJson(item, subject));
              }
            }
          } else if (data is Map<String, dynamic>) {
            questions.add(Question.fromJson(data, subject));
          }
        }

        if (questions.isNotEmpty) {
          _cache[cacheKey] = questions;
          // Prefer API results but keep offline as fallback if needed
          questions.shuffle();
          return questions.take(count).toList();
        }
      }

      return await _fetchMultipleSingles(subject, type, year, count, offline);
    } catch (e) {
      print('ALOC API error: $e');
      return offline;
    }
  }

  Future<List<Question>> _fetchMultipleSingles(
    String subject,
    String? type,
    String? year,
    int count,
    List<Question> offlineFallback,
  ) async {
    final questions = <Question>[];
    final queryParams = <String, String>{'subject': subject, 'random': 'true'};
    if (type != null) queryParams['type'] = type;
    if (year != null) queryParams['year'] = year;

    for (int i = 0; i < count && i < 40; i++) {
      try {
        final uri = Uri.parse('$alocBaseUrl/q').replace(queryParameters: queryParams);
        final response = await http.get(
          uri,
          headers: {
            'Accept': 'application/json',
            'AccessToken': alocAccessToken,
          },
        ).timeout(const Duration(seconds: 8));

        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          if (body is Map && body['data'] != null && body['data'] is Map) {
            questions.add(Question.fromJson(body['data'], subject));
          }
        }
      } catch (_) {}
    }

    if (questions.isEmpty) return offlineFallback;
    questions.shuffle();
    return questions.take(count).toList();
  }
}
