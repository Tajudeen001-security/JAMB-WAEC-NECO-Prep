import 'package:flutter/material.dart';
import '../config/api_config.dart';
import '../utils/constants.dart';
import 'jamb_mock_quiz_screen.dart';

/// JAMB-style mock: English is compulsory. User picks exactly 3 more subjects.
/// Then sits a timed multi-subject exam scored out of 400 (like real UTME).
class JambMockSetupScreen extends StatefulWidget {
  const JambMockSetupScreen({super.key});

  @override
  State<JambMockSetupScreen> createState() => _JambMockSetupScreenState();
}

class _JambMockSetupScreenState extends State<JambMockSetupScreen> {
  // English is always included
  final Set<String> _selected = {'english'};
  int _questionsPerSubject = 40; // 4 × 40 = 160 (close to real 180)
  bool _timed = true;

  static const int maxExtraSubjects = 3;

  List<String> get _otherSubjects =>
      supportedSubjects.where((s) => s != 'english').toList();

  void _toggle(String subject) {
    if (subject == 'english') return; // cannot deselect English
    setState(() {
      if (_selected.contains(subject)) {
        _selected.remove(subject);
      } else {
        if (_selected.length - 1 < maxExtraSubjects) {
          _selected.add(subject);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You can select only 3 additional subjects (English is compulsory).'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  bool get _canStart => _selected.length == 4; // English + 3

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JAMB Mock Exam'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: AppColors.primary.withOpacity(0.08),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Real JAMB Style',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• English Language is compulsory (always selected)\n'
                    '• Choose exactly 3 more subjects\n'
                    '• Timed exam (recommended)\n'
                    '• Score calculated out of 400 like the real UTME',
                    style: TextStyle(fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          const Text(
            'Compulsory Subject',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.lock, color: Colors.white, size: 18),
              ),
              title: const Text(
                'English Language',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text('Always included'),
              trailing: const Icon(Icons.check_circle, color: AppColors.success),
            ),
          ),
          const SizedBox(height: 20),

          Text(
            'Select 3 more subjects (${_selected.length - 1}/$maxExtraSubjects)',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 8),
          ..._otherSubjects.map((subject) {
            final name = subjectNames[subject] ?? subject;
            final selected = _selected.contains(subject);
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              color: selected ? AppColors.primary.withOpacity(0.08) : null,
              child: ListTile(
                onTap: () => _toggle(subject),
                leading: CircleAvatar(
                  backgroundColor: selected
                      ? AppColors.primary
                      : AppColors.primary.withOpacity(0.15),
                  child: Text(
                    name[0].toUpperCase(),
                    style: TextStyle(
                      color: selected ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  name,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                trailing: selected
                    ? const Icon(Icons.check_circle, color: AppColors.success)
                    : const Icon(Icons.circle_outlined, color: Colors.grey),
              ),
            );
          }),

          const SizedBox(height: 24),
          const Text(
            'Questions per subject',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [20, 30, 40, 45].map((c) {
              final selected = _questionsPerSubject == c;
              return ChoiceChip(
                label: Text('$c'),
                selected: selected,
                onSelected: (_) => setState(() => _questionsPerSubject = c),
                selectedColor: AppColors.primary.withOpacity(0.2),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Text(
            'Total questions: ${_questionsPerSubject * 4}  •  Max score: 400',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),

          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Enable Timer (recommended)'),
            subtitle: Text(_timed
                ? '2 hours total (like real JAMB)'
                : 'No time limit – study mode'),
            value: _timed,
            activeColor: AppColors.primary,
            onChanged: (v) => setState(() => _timed = v),
            contentPadding: EdgeInsets.zero,
          ),

          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _canStart
                  ? () {
                      final subjects = _selected.toList();
                      // Keep English first
                      subjects.remove('english');
                      subjects.insert(0, 'english');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => JambMockQuizScreen(
                            subjects: subjects,
                            questionsPerSubject: _questionsPerSubject,
                            timed: _timed,
                          ),
                        ),
                      );
                    }
                  : null,
              icon: const Icon(Icons.play_arrow),
              label: Text(
                _canStart
                    ? 'Start JAMB Mock'
                    : 'Select 3 more subjects',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
