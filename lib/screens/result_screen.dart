import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../models/question.dart';
import '../utils/constants.dart';

class ResultScreen extends StatelessWidget {
  final List<Question> questions;
  final Map<int, String> answers;
  final int score;
  final int durationSeconds;
  final String examType;
  final String subject;

  const ResultScreen({
    super.key,
    required this.questions,
    required this.answers,
    required this.score,
    required this.durationSeconds,
    required this.examType,
    required this.subject,
  });

  double get percentage => questions.isEmpty ? 0 : (score / questions.length) * 100;

  String get grade {
    if (percentage >= 70) return 'Excellent';
    if (percentage >= 50) return 'Good';
    if (percentage >= 40) return 'Fair';
    return 'Needs Improvement';
  }

  Color get gradeColor {
    if (percentage >= 70) return AppColors.success;
    if (percentage >= 50) return Colors.blue;
    if (percentage >= 40) return Colors.orange;
    return AppColors.error;
  }

  String _formatDuration(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m}m ${s}s';
  }

  @override
  Widget build(BuildContext context) {
    final subjectName = subjectNames[subject] ?? subject;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Score card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    '$score / ${questions.length}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: gradeColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: gradeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      grade,
                      style: TextStyle(
                        color: gradeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _Stat(label: 'Subject', value: subjectName),
                      _Stat(label: 'Time', value: _formatDuration(durationSeconds)),
                      _Stat(
                        label: 'Exam',
                        value: examTypes[examType] ?? examType,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Review Answers',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...List.generate(questions.length, (i) {
            final q = questions[i];
            final selected = answers[i];
            final correct = selected != null && q.isCorrect(selected);
            final answered = selected != null;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: !answered
                      ? Colors.grey
                      : correct
                          ? AppColors.success
                          : AppColors.error,
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
                title: Text(
                  q.question,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14),
                ),
                subtitle: Text(
                  !answered
                      ? 'Not answered'
                      : correct
                          ? 'Correct'
                          : 'Wrong • Correct: ${q.answer.toUpperCase()}',
                  style: TextStyle(
                    color: !answered
                        ? Colors.grey
                        : correct
                            ? AppColors.success
                            : AppColors.error,
                    fontSize: 12,
                  ),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...q.optionKeys.map((key) {
                          final isCorrectOpt = key == q.answer;
                          final isSelected = key == selected;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Row(
                              children: [
                                Icon(
                                  isCorrectOpt
                                      ? Icons.check_circle
                                      : isSelected
                                          ? Icons.cancel
                                          : Icons.circle_outlined,
                                  size: 18,
                                  color: isCorrectOpt
                                      ? AppColors.success
                                      : isSelected
                                          ? AppColors.error
                                          : Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${key.toUpperCase()}. ${q.options[key]}',
                                    style: TextStyle(
                                      fontWeight: isCorrectOpt || isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        if (q.solution != null && q.solution!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Explanation: ${q.solution}',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('Back to Home'),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
