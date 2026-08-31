import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../utils/constants.dart';
import 'quiz_screen.dart';

class SetupScreen extends StatefulWidget {
  final String examType;
  final String subject;

  const SetupScreen({
    super.key,
    required this.examType,
    required this.subject,
  });

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  int _questionCount = 20;
  int _secondsPerQuestion = 60;
  String? _selectedYear;
  bool _timed = true;

  final List<String> _years = [
    'Any',
    '2022', '2021', '2020', '2019', '2018',
    '2017', '2016', '2015', '2014', '2013',
    '2012', '2011', '2010', '2009', '2008',
    '2007', '2006', '2005', '2004', '2003',
    '2002', '2001',
  ];

  @override
  Widget build(BuildContext context) {
    final subjectName = subjectNames[widget.subject] ?? widget.subject;
    final examName = examTypes[widget.examType] ?? widget.examType;

    return Scaffold(
      appBar: AppBar(title: Text(subjectName)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            examName,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            subjectName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 28),

          // Number of questions
          const Text('Number of Questions', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: questionCounts.map((c) {
              final selected = _questionCount == c;
              return ChoiceChip(
                label: Text('$c'),
                selected: selected,
                onSelected: (_) => setState(() => _questionCount = c),
                selectedColor: AppColors.primary.withOpacity(0.2),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Timer toggle
          SwitchListTile(
            title: const Text('Enable Timer'),
            subtitle: Text(_timed
                ? '$_secondsPerQuestion seconds per question'
                : 'No time limit'),
            value: _timed,
            activeColor: AppColors.primary,
            onChanged: (v) => setState(() => _timed = v),
            contentPadding: EdgeInsets.zero,
          ),
          if (_timed) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: timePerQuestionOptions.map((s) {
                final selected = _secondsPerQuestion == s;
                return ChoiceChip(
                  label: Text('${s}s'),
                  selected: selected,
                  onSelected: (_) => setState(() => _secondsPerQuestion = s),
                  selectedColor: AppColors.primary.withOpacity(0.2),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 24),

          // Year filter
          const Text('Year (optional)', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedYear ?? 'Any',
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: _years
                .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                .toList(),
            onChanged: (v) => setState(() => _selectedYear = v == 'Any' ? null : v),
          ),
          const SizedBox(height: 40),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(
                      examType: widget.examType,
                      subject: widget.subject,
                      questionCount: _questionCount,
                      secondsPerQuestion: _timed ? _secondsPerQuestion : null,
                      year: _selectedYear,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Practice', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
