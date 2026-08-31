// Get a free Access Token by signing up at https://questions.aloc.com.ng
// Then paste it below.

const String alocAccessToken = 'YOUR_ALOC_TOKEN_HERE';

const String alocBaseUrl = 'https://questions.aloc.com.ng/api/v2';

/// Supported subjects from ALOC API
const List<String> supportedSubjects = [
  'english',
  'mathematics',
  'biology',
  'physics',
  'chemistry',
  'economics',
  'government',
  'englishlit',
  'geography',
  'commerce',
  'accounting',
  'crk',
  'irk',
  'civiledu',
  'history',
  'currentaffairs',
  'insurance',
];

/// Human-readable names
const Map<String, String> subjectNames = {
  'english': 'English Language',
  'mathematics': 'Mathematics',
  'biology': 'Biology',
  'physics': 'Physics',
  'chemistry': 'Chemistry',
  'economics': 'Economics',
  'government': 'Government',
  'englishlit': 'Literature in English',
  'geography': 'Geography',
  'commerce': 'Commerce',
  'accounting': 'Accounting',
  'crk': 'Christian Religious Knowledge',
  'irk': 'Islamic Religious Knowledge',
  'civiledu': 'Civic Education',
  'history': 'History',
  'currentaffairs': 'Current Affairs',
  'insurance': 'Insurance',
};

/// Exam types mapping (includes Post-UTME)
const Map<String, String> examTypes = {
  'utme': 'JAMB (UTME)',
  'wassce': 'WAEC (WASSCE)',
  'neco': 'NECO',
  'post-utme': 'Post-UTME',
};
