class Question {
  final int id;
  final String question;
  final Map<String, String?> options;
  final String answer;
  final String? solution;
  final String examType;
  final String examYear;
  final String subject;
  final String? section;
  final String? image;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.answer,
    this.solution,
    required this.examType,
    required this.examYear,
    required this.subject,
    this.section,
    this.image,
  });

  factory Question.fromJson(Map<String, dynamic> json, String subject) {
    final optionMap = <String, String?>{};
    if (json['option'] != null) {
      final opt = json['option'] as Map<String, dynamic>;
      opt.forEach((key, value) {
        if (value != null && value.toString().trim().isNotEmpty) {
          optionMap[key.toLowerCase()] = value.toString().trim();
        }
      });
    }

    return Question(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      question: (json['question'] ?? '').toString().trim(),
      options: optionMap,
      answer: (json['answer'] ?? 'a').toString().toLowerCase().trim(),
      solution: json['solution']?.toString(),
      examType: (json['examtype'] ?? 'utme').toString().toLowerCase(),
      examYear: (json['examyear'] ?? '').toString(),
      subject: subject,
      section: json['section']?.toString(),
      image: json['image']?.toString(),
    );
  }

  List<String> get optionKeys => options.keys.toList()..sort();

  bool isCorrect(String selected) => selected.toLowerCase() == answer.toLowerCase();
}
