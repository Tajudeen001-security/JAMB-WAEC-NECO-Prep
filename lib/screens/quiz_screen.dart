import 'dart:async';
import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/question.dart';
import '../services/aloc_api_service.dart';
import '../services/progress_service.dart';
import '../utils/constants.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String examType;
  final String subject;
  final int questionCount;
  final int? secondsPerQuestion;
  final String? year;

  const QuizScreen({
    super.key,
    required this.examType,
    required this.subject,
    required this.questionCount,
    this.secondsPerQuestion,
    this.year,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<Question> _questions = [];
  final Map<int, String> _answers = {};
  final Set<int> _flagged = {};
  int _currentIndex = 0;
  bool _loading = true;
  String? _error;

  Timer? _timer;
  int _remainingSeconds = 0;
  late final DateTime _startTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final qs = await AlocApiService().fetchQuestions(
        subject: widget.subject,
        type: widget.examType,
        year: widget.year,
        count: widget.questionCount,
      );

      if (qs.isEmpty) {
        setState(() {
          _error = 'No questions found. Try another subject or year.';
          _loading = false;
        });
        return;
      }

      setState(() {
        _questions = qs;
        _loading = false;
        if (widget.secondsPerQuestion != null) {
          _remainingSeconds = widget.secondsPerQuestion! * qs.length;
          _startTimer();
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load questions: $e';
        _loading = false;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remainingSeconds <= 0) {
        t.cancel();
        _submit();
        return;
      }
      setState(() => _remainingSeconds--);
    });
  }

  void _selectOption(String key) {
    setState(() => _answers[_currentIndex] = key);
  }

  void _toggleFlag() {
    setState(() {
      if (_flagged.contains(_currentIndex)) {
        _flagged.remove(_currentIndex);
      } else {
        _flagged.add(_currentIndex);
      }
    });
  }

  void _goTo(int index) {
    if (index >= 0 && index < _questions.length) {
      setState(() => _currentIndex = index);
    }
  }

  Future<void> _submit() async {
    _timer?.cancel();
    final duration = DateTime.now().difference(_startTime).inSeconds;

    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      final selected = _answers[i];
      if (selected != null && _questions[i].isCorrect(selected)) {
        score++;
      }
    }

    await ProgressService().saveResult(ProgressEntry(
      examType: widget.examType,
      subject: widget.subject,
      score: score,
      total: _questions.length,
      date: DateTime.now(),
      durationSeconds: duration,
    ));

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          questions: _questions,
          answers: _answers,
          score: score,
          durationSeconds: duration,
          examType: widget.examType,
          subject: widget.subject,
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loading...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                const SizedBox(height: 16),
                Text(_error!, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final q = _questions[_currentIndex];
    final selected = _answers[_currentIndex];
    final isFlagged = _flagged.contains(_currentIndex);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${subjectNames[widget.subject] ?? widget.subject}  ${_currentIndex + 1}/${_questions.length}',
        ),
        actions: [
          if (widget.secondsPerQuestion != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _remainingSeconds < 60
                        ? AppColors.error
                        : Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formatTime(_remainingSeconds),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Question navigator strip
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              itemCount: _questions.length,
              itemBuilder: (ctx, i) {
                final answered = _answers.containsKey(i);
                final flagged = _flagged.contains(i);
                final current = i == _currentIndex;
                return GestureDetector(
                  onTap: () => _goTo(i),
                  child: Container(
                    width: 36,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: current
                          ? AppColors.primary
                          : answered
                              ? AppColors.success.withOpacity(0.8)
                              : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                      border: flagged
                          ? Border.all(color: Colors.orange, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: TextStyle(
                          color: current || answered ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Question body
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (q.section != null && q.section!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        q.section!,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  Text(
                    q.question,
                    style: const TextStyle(
                      fontSize: 17,
                      height: 1.45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (q.examYear.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        '${q.examType.toUpperCase()} • ${q.examYear}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  ...q.optionKeys.map((key) {
                    final text = q.options[key] ?? '';
                    final isSelected = selected == key;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Material(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.12)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          onTap: () => _selectOption(key),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected
                                        ? AppColors.primary
                                        : Colors.grey.shade200,
                                  ),
                                  child: Center(
                                    child: Text(
                                      key.toUpperCase(),
                                      style: TextStyle(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    text,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // Bottom controls
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _toggleFlag,
                    icon: Icon(
                      isFlagged ? Icons.flag : Icons.flag_outlined,
                      color: isFlagged ? Colors.orange : null,
                    ),
                    tooltip: 'Flag for review',
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: _currentIndex > 0
                        ? () => _goTo(_currentIndex - 1)
                        : null,
                    child: const Text('Previous'),
                  ),
                  const SizedBox(width: 8),
                  if (_currentIndex < _questions.length - 1)
                    ElevatedButton(
                      onPressed: () => _goTo(_currentIndex + 1),
                      child: const Text('Next'),
                    )
                  else
                    ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                      ),
                      child: const Text('Submit'),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
