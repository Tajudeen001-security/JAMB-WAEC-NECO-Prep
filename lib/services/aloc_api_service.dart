import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
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

    if (alocAccessToken == 'YOUR_ALOC_TOKEN_HERE' || alocAccessToken.isEmpty) {
      return _getSampleQuestions(subject, count);
    }

    try {
      // Prefer the /m endpoint for multiple questions (up to 40)
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
          questions.shuffle();
          return questions.take(count).toList();
        }
      }

      // Fallback: try single question endpoint multiple times
      return await _fetchMultipleSingles(subject, type, year, count);
    } catch (e) {
      print('ALOC API error: $e');
      return _getSampleQuestions(subject, count);
    }
  }

  Future<List<Question>> _fetchMultipleSingles(
    String subject,
    String? type,
    String? year,
    int count,
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

    if (questions.isEmpty) return _getSampleQuestions(subject, count);
    return questions;
  }

  List<Question> _getSampleQuestions(String subject, int count) {
    // High-quality sample questions so the app works without a token
    final samples = <Question>[
      Question(
        id: 1,
        question: 'Which of the following is the capital of Nigeria?',
        options: {'a': 'Lagos', 'b': 'Abuja', 'c': 'Kano', 'd': 'Port Harcourt'},
        answer: 'b',
        solution: 'Abuja became the capital of Nigeria in 1991, replacing Lagos.',
        examType: 'utme',
        examYear: '2020',
        subject: subject,
      ),
      Question(
        id: 2,
        question: 'The process by which plants manufacture their food is called?',
        options: {'a': 'Respiration', 'b': 'Photosynthesis', 'c': 'Transpiration', 'd': 'Osmosis'},
        answer: 'b',
        solution: 'Photosynthesis is the process by which green plants use sunlight to synthesize foods from carbon dioxide and water.',
        examType: 'utme',
        examYear: '2019',
        subject: subject,
      ),
      Question(
        id: 3,
        question: 'Solve for x: 2x + 5 = 15',
        options: {'a': '5', 'b': '10', 'c': '7.5', 'd': '20'},
        answer: 'a',
        solution: '2x = 15 - 5 = 10 → x = 5',
        examType: 'utme',
        examYear: '2021',
        subject: subject,
      ),
      Question(
        id: 4,
        question: 'Which gas is most abundant in the Earth\'s atmosphere?',
        options: {'a': 'Oxygen', 'b': 'Carbon dioxide', 'c': 'Nitrogen', 'd': 'Hydrogen'},
        answer: 'c',
        solution: 'Nitrogen makes up about 78% of the Earth\'s atmosphere.',
        examType: 'wassce',
        examYear: '2018',
        subject: subject,
      ),
      Question(
        id: 5,
        question: 'The organelle responsible for protein synthesis is the?',
        options: {'a': 'Mitochondrion', 'b': 'Ribosome', 'c': 'Golgi apparatus', 'd': 'Lysosome'},
        answer: 'b',
        solution: 'Ribosomes are the sites of protein synthesis in the cell.',
        examType: 'neco',
        examYear: '2020',
        subject: subject,
      ),
      Question(
        id: 6,
        question: 'Which of these is a renewable source of energy?',
        options: {'a': 'Coal', 'b': 'Petroleum', 'c': 'Solar', 'd': 'Natural gas'},
        answer: 'c',
        solution: 'Solar energy is renewable because it comes from the sun which is constantly available.',
        examType: 'utme',
        examYear: '2022',
        subject: subject,
      ),
      Question(
        id: 7,
        question: 'The first military coup in Nigeria took place in?',
        options: {'a': '1960', 'b': '1966', 'c': '1975', 'd': '1983'},
        answer: 'b',
        solution: 'The first military coup in Nigeria occurred on 15 January 1966.',
        examType: 'utme',
        examYear: '2017',
        subject: subject,
      ),
      Question(
        id: 8,
        question: 'What is the SI unit of force?',
        options: {'a': 'Joule', 'b': 'Newton', 'c': 'Watt', 'd': 'Pascal'},
        answer: 'b',
        solution: 'Force is measured in Newtons (N) in the SI system.',
        examType: 'wassce',
        examYear: '2019',
        subject: subject,
      ),
      Question(
        id: 9,
        question: 'Which of the following is an example of a covalent compound?',
        options: {'a': 'NaCl', 'b': 'MgO', 'c': 'H2O', 'd': 'CaCl2'},
        answer: 'c',
        solution: 'Water (H2O) is formed by sharing of electrons between hydrogen and oxygen.',
        examType: 'utme',
        examYear: '2021',
        subject: subject,
      ),
      Question(
        id: 10,
        question: 'The Nigerian Civil War lasted from?',
        options: {'a': '1967-1970', 'b': '1966-1969', 'c': '1970-1973', 'd': '1960-1963'},
        answer: 'a',
        solution: 'The Nigerian Civil War (Biafran War) lasted from 6 July 1967 to 15 January 1970.',
        examType: 'neco',
        examYear: '2018',
        subject: subject,
      ),
    ];

    samples.shuffle();
    return samples.take(count.clamp(1, samples.length)).toList();
  }
}
