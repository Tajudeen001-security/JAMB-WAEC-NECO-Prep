class LitCharacter {
  final String name;
  final String role;
  const LitCharacter(this.name, this.role);
}

class LitQuestion {
  final String question;
  final Map<String, String> options;
  final String answer;
  final String? explanation;
  const LitQuestion({
    required this.question,
    required this.options,
    required this.answer,
    this.explanation,
  });
}

class LekkiContent {
  final String title;
  final String author;
  final String summary;
  final List<LitCharacter> characters;
  final List<String> themes;
  final List<LitQuestion> questions;

  const LekkiContent({
    required this.title,
    required this.author,
    required this.summary,
    required this.characters,
    required this.themes,
    required this.questions,
  });
}

/// Educational practice notes based on publicly discussed themes of the JAMB novel.
/// Always cross-check with the official printed text.
const lekkiHeadmasterContent = LekkiContent(
  title: 'The Lekki Headmaster',
  author: 'Kabir Alabi Garba',
  summary:
      'The novel follows Mr. Bepo Adewale (Adebepo), a dedicated principal of an elite school '
      'in Lekki, Lagos. After many years of service he faces intense pressure from his wife Seri '
      '(already living in the UK with their children) to japa — relocate abroad for better pay. '
      'Bepo loves his students and believes skilled Nigerians should help build the country. '
      'The story explores the emotional cost of migration, challenges in private education, '
      'integrity in leadership, and the tension between personal comfort and national service. '
      'Key settings include Stardom Schools in Lekki and the wider Lagos economic environment.',
  characters: [
    LitCharacter('Mr. Bepo Adewale (Adebepo)', 'Protagonist; principled principal / "Lekki Headmaster".'),
    LitCharacter('Seri Adewale', 'Bepo\'s wife; nurse in the UK who urges him to relocate.'),
    LitCharacter('Mrs. Ibidun Gloss', 'Managing Director figure connected with the school leadership/finances.'),
    LitCharacter('Mr. Fafore', 'Teacher character illustrating struggles of underpaid private-school staff.'),
    LitCharacter('Students & parents', 'Community that reflects class pressure, expectations and school culture.'),
  ],
  themes: [
    'The "Japa" (migration / brain-drain) syndrome',
    'Patriotism versus economic pressure',
    'Integrity and leadership in education',
    'Corruption and malpractice pressures in schools',
    'Class inequality and the cost of private education',
    'Family conflict and personal sacrifice',
  ],
  questions: [
    LitQuestion(
      question: 'Who is the protagonist of The Lekki Headmaster?',
      options: {
        'a': 'Mrs. Ibidun Gloss',
        'b': 'Mr. Bepo Adewale',
        'c': 'Mr. Fafore',
        'd': 'Chief David Aje',
      },
      answer: 'b',
      explanation: 'Bepo (Adebepo Adewale) is the central character and school principal.',
    ),
    LitQuestion(
      question: 'What major social trend does Seri largely represent in the novel?',
      options: {
        'a': 'Rural–urban migration only',
        'b': 'The pressure to relocate abroad ("Japa")',
        'c': 'Student cultism',
        'd': 'Traditional apprenticeship',
      },
      answer: 'b',
      explanation: 'Seri lives in the UK and pushes Bepo to join the family abroad.',
    ),
    LitQuestion(
      question: 'The school setting most closely associated with Bepo is in',
      options: {
        'a': 'Abuja',
        'b': 'Kano',
        'c': 'Lekki, Lagos',
        'd': 'Port Harcourt',
      },
      answer: 'c',
      explanation: 'The elite school environment is set in Lekki, Lagos.',
    ),
    LitQuestion(
      question: 'A central conflict in the novel is between',
      options: {
        'a': 'Farmers and herders',
        'b': 'Passion for teaching / service and pressure to emigrate',
        'c': 'Two rival football clubs',
        'd': 'Colonial officers and traders',
      },
      answer: 'b',
      explanation: 'Bepo is torn between remaining in Nigeria to teach and joining his family abroad.',
    ),
    LitQuestion(
      question: 'Which theme is most dominant in the novel?',
      options: {
        'a': 'Space exploration',
        'b': 'Migration (Japa) and patriotism',
        'c': 'Medieval warfare',
        'd': 'Deep-sea fishing',
      },
      answer: 'b',
      explanation: 'The Japa debate and loyalty to national development run through the story.',
    ),
    LitQuestion(
      question: 'Bepo\'s profession is best described as',
      options: {
        'a': 'Bank manager',
        'b': 'School principal / educator',
        'c': 'Oil engineer',
        'd': 'Political campaign manager',
      },
      answer: 'b',
    ),
    LitQuestion(
      question: 'The novel can help JAMB candidates mainly in',
      options: {
        'a': 'Further Mathematics only',
        'b': 'Use of English (prescribed reading text)',
        'c': 'Agricultural Science practicals',
        'd': 'Physical Education',
      },
      answer: 'b',
      explanation: 'It is the prescribed novel often tested under Use of English.',
    ),
    LitQuestion(
      question: 'Integrity in school leadership in the novel is shown when characters resist',
      options: {
        'a': 'All forms of technology',
        'b': 'Pressures such as malpractice, favouritism and easy money',
        'c': 'Sports competitions',
        'd': 'Parent–teacher meetings',
      },
      answer: 'b',
    ),
  ],
);
