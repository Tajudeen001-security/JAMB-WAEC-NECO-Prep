import 'dart:async';
import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/question.dart';
import '../services/aloc_api_service.dart';
import '../services/progress_service.dart';
import '../utils/constants.dart';
import 'result_screen.dart';

/// Multi-subject JAMB-style quiz. Questions are interleaved or sequential by subject.
/// Final score is scaled to /400.
class JambMockQuizScreen extends StatefulWidget {
  final List<String> subjects; // English first
  final int questionsPerSubject;
  final bool timed;

  const JambMockQuizScreen({
    super.key,
    required this.subjects,
    required this.questionsPerSubject,
    required this.timed,
  });

  @override
  State<JambMockQuizScreen> createState() => _JambMockQuizScreenState();
}

class _JambMockQuizScreenState extends State<JambMockQuizScreen> {
  List<Question> _questions = [];
  final Map<int, String> _answers = {};
  final Set<int> _flagged = {};
  int _currentIndex = 0;
  bool _loading = true;
  String? _error;

  Timer? _timer;
  int _remainingSeconds = 0;
  late final DateTime _startTime;

  // Track per-subject score later
  final Map<String, int> _subjectCorrect = {};
  final Map<String, int> _subjectTotal = {};

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final all = <Question>[];
      for (final subject in widget.subjects) {
        final qs = await AlocApiService().fetchQuestions(
          subject: subject,
          type: 'utme',
          count: widget.questionsPerSubject,
        );
        all.addAll(qs);
        _subjectTotal[subject] = qs.length;
        _subjectCorrect[subject] = 0;
      }

      if (all.isEmpty) {
        setState(() {
          _error = 'Could not load questions. Check your internet or try again.';
          _loading = false;
        });
        return;
      }

      // Keep order: English block first, then other subjects (realistic)
      setState(() {
        _questions = all;
        _loading = false;
        if (widget.timed) {
          // Real JAMB is 2 hours
          _remainingSeconds = 2 * 60 * 60;
          _startTimer();
        }
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load: $e';
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

    int rawScore = 0;
    for (int i = 0; i < _questions.length; i++) {
      final selected = _answers[i];
      final q = _questions[i];
      if (selected != null && q.isCorrect(selected)) {
        rawScore++;
        _subjectCorrect[q.subject] = (_subjectCorrect[q.subject] ?? 0) + 1;
      }
    }

    // Scale to 400 like JAMB (each subject ~100 marks)
    final totalPossible = _questions.length;
    final scaledScore = totalPossible == 0
        ? 0
        : ((rawScore / totalPossible) * 400).round();

    // Save overall progress
    await ProgressService().saveResult(ProgressEntry(
      examType: 'utme',
      subject: 'JAMB Mock (${widget.subjects.map((s) => subjectNames[s] ?? s).join(", ")})',
      score: scaledScore,
      total: 400,
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
          score: rawScore,
          durationSeconds: duration,
          examType: 'utme',
          subject: 'JAMB Mock',
          // Extra info can be shown in result if we extend later
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    if (h > 0) {
      return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
    }
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
        appBar: AppBar(title: const Text('Loading JAMB Mock...')),
        body: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Fetching questions for all subjects...'),
            ],
          ),
        ),
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
    final subjectName = subjectNames[q.subject] ?? q.subject;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$subjectName  ${_currentIndex + 1}/${_questions.length}',
        ),
        actions: [
          if (widget.timed)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _remainingSeconds < 300
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
          // Subject progress strip
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            color: AppColors.primary.withOpacity(0.08),
            child: Text(
              'JAMB Mock • English compulsory • Score will be /400',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Question navigator
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

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subjectName,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 6),
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
