import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../data/lekki_headmaster.dart';

/// Study notes and practice questions for recommended literature texts,
/// focused on The Lekki Headmaster (current JAMB Use of English novel).
class LiteratureScreen extends StatelessWidget {
  const LiteratureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Literature & Novels')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Recommended reading',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            'Summaries and practice questions for arts / Use of English preparation.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          _BookCard(
            title: 'The Lekki Headmaster',
            author: 'Kabir Alabi Garba',
            tag: 'JAMB 2025/2026 novel',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LekkiHeadmasterScreen()),
              );
            },
          ),
          const SizedBox(height: 10),
          const _BookCard(
            title: 'Other African prose (revision)',
            author: 'Faceless • Second Class Citizen • etc.',
            tag: 'Background reading',
            onTap: null,
          ),
          const SizedBox(height: 10),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'Tip: JAMB often sets 10 Use-of-English questions from the '
                'prescribed novel. Know characters, themes, setting and key events.',
                style: TextStyle(height: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String tag;
  final VoidCallback? onTap;

  const _BookCard({
    required this.title,
    required this.author,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withOpacity(0.15),
          child: const Icon(Icons.menu_book, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('$author\n$tag'),
        isThreeLine: true,
        trailing: onTap == null ? null : const Icon(Icons.chevron_right),
      ),
    );
  }
}

class LekkiHeadmasterScreen extends StatelessWidget {
  const LekkiHeadmasterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = lekkiHeadmasterContent;
    return Scaffold(
      appBar: AppBar(title: const Text('The Lekki Headmaster')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(data.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text('By ${data.author}', style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          const Text('Short summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 6),
          Text(data.summary, style: const TextStyle(height: 1.45)),
          const SizedBox(height: 16),
          const Text('Main characters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...data.characters.map(
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('• ${c.name}: ${c.role}', style: const TextStyle(height: 1.35)),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Major themes', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...data.themes.map(
            (t) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text('• $t'),
            ),
          ),
          const SizedBox(height: 16),
          const Text('Practice questions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          ...data.questions.asMap().entries.map((e) {
            final i = e.key + 1;
            final q = e.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ExpansionTile(
                title: Text('$i. ${q.question}', style: const TextStyle(fontSize: 14)),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...q.options.entries.map(
                          (o) => Text('${o.key.toUpperCase()}. ${o.value}'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Answer: ${q.answer.toUpperCase()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.success,
                          ),
                        ),
                        if (q.explanation != null) ...[
                          const SizedBox(height: 4),
                          Text('Explanation: ${q.explanation}', style: TextStyle(color: AppColors.textSecondary)),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
