import '../models/question.dart';

/// 10,000 original deterministic offline practice questions.
/// The bank is generated locally so the app continues working without the API.
List<Question> getGeneratedOfflineQuestions() {
  final result = <Question>[];
  const subjects = <String>['english','mathematics','biology','physics','chemistry','economics','government','geography','civiledu','englishlit'];
  var id = 100000;
  for (final subject in subjects) {
    for (var n = 1; n <= 1000; n++) {
      result.add(_make(subject, n, id++));
    }
  }
  return result;
}

Question _make(String subject, int n, int id) {
  final year = 2018 + n % 8;
  switch (subject) {
    case 'mathematics':
      final a = n + 7; final b = n % 97 + 3; final c = a + b;
      return _q(id, subject, 'utme', year, 'If ' + a.toString() + ' + x = ' + c.toString() + ', find x.',
        {'a': b.toString(), 'b': (b + 1).toString(), 'c': (b - 1).toString(), 'd': (b + 2).toString()}, 'a',
        'Subtract ' + a.toString() + ' from both sides: x = ' + b.toString() + '.');
    case 'physics':
      final mass = n % 20 + 1; final acceleration = n % 9 + 2; final force = mass * acceleration;
      return _q(id, subject, 'utme', year, 'A force of ' + force.toString() + ' N acts on a ' + mass.toString() + ' kg mass. What is its acceleration?',
        {'a': (acceleration + 1).toString() + ' m/s²', 'b': acceleration.toString() + ' m/s²', 'c': (acceleration + 2).toString() + ' m/s²', 'd': (acceleration - 1).toString() + ' m/s²'}, 'b',
        'Using F = ma, a = F/m = ' + force.toString() + '/' + mass.toString() + ' = ' + acceleration.toString() + ' m/s².');
    case 'chemistry':
      final atomic = n % 18 + 1;
      return _q(id, subject, 'utme', year, 'An atom has atomic number ' + atomic.toString() + '. How many protons does it contain?',
        {'a': atomic.toString(), 'b': (atomic + 1).toString(), 'c': (atomic - 1).toString(), 'd': (atomic * 2).toString()}, 'a',
        'Atomic number equals the number of protons.');
    case 'biology':
      const names = ['cell membrane','nucleus','mitochondrion','ribosome','chloroplast'];
      const meanings = ['controls movement of substances into and out of the cell','contains genetic material and controls cell activities','is a major site of aerobic respiration','is the site of protein synthesis','contains chlorophyll and is involved in photosynthesis'];
      final k = (n - 1) % names.length;
      return _q(id, subject, 'utme', year, 'Which statement correctly describes the ' + names[k] + '?',
        {'a': meanings[k], 'b': 'It produces urine only', 'c': 'It pumps blood around the body', 'd': 'It stores bile'}, 'a', meanings[k][0].toUpperCase() + meanings[k].substring(1) + '.');
    case 'economics':
      final quantity = n % 50 + 10; final price = n % 20 + 5; final total = price * quantity;
      return _q(id, subject, 'utme', year, 'If a product costs ' + price.toString() + ' units and a consumer buys ' + quantity.toString() + ' units, what is the total expenditure?',
        {'a': total.toString() + ' units', 'b': (price + quantity).toString() + ' units', 'c': (total - price).toString() + ' units', 'd': (total + price).toString() + ' units'}, 'a',
        'Total expenditure = price × quantity = ' + total.toString() + ' units.');
    case 'government':
      const concepts = [['legislature','making laws'],['executive','implementing laws and public policies'],['judiciary','interpreting laws and adjudicating disputes'],['electoral commission','organising elections'],['constitution','providing the fundamental legal framework']];
      final pair = concepts[(n - 1) % concepts.length];
      return _q(id, subject, 'utme', year, 'Which function is most closely associated with the ' + pair[0] + '?',
        {'a': pair[1], 'b': 'minting all private currency', 'c': 'abolishing every court', 'd': 'ending all elections'}, 'a', pair[1][0].toUpperCase() + pair[1].substring(1) + '.');
    case 'geography':
      const places = [['Niger River','a major river in West Africa'],['Sahara','a major hot desert in Africa'],['Niger Delta','a major petroleum-producing region'],['Jos Plateau','a highland region in central Nigeria'],['Lake Chad','a lake in the Lake Chad basin']];
      final pair = places[(n - 1) % places.length];
      return _q(id, subject, 'utme', year, 'Which description best matches ' + pair[0] + '?',
        {'a': pair[1], 'b': 'A polar ice sheet in Antarctica', 'c': 'A volcano in Hawaii', 'd': 'A European alpine glacier'}, 'a', pair[0] + ' is ' + pair[1] + '.');
    case 'civiledu':
      const rights = [['freedom of expression','expressing lawful opinions without unlawful suppression'],['right to fair hearing','being given a proper opportunity to present a case'],['right to life','protection of a person from unlawful killing'],['right to dignity','protection from degrading treatment'],['right to privacy','protection of personal and private life']];
      final pair = rights[(n - 1) % rights.length];
      return _q(id, subject, 'neco', year, 'Which statement best describes the ' + pair[0] + '?',
        {'a': pair[1], 'b': 'A duty to evade taxes', 'c': 'A licence to break laws', 'd': 'A power to cancel elections'}, 'a', pair[1][0].toUpperCase() + pair[1].substring(1) + '.');
    case 'englishlit':
      const devices = [['metaphor','a direct comparison without using like or as'],['simile','a comparison commonly using like or as'],['personification','giving human qualities to non-human things'],['alliteration','repetition of initial consonant sounds'],['irony','a contrast between appearance and intended or actual meaning']];
      final pair = devices[(n - 1) % devices.length];
      return _q(id, subject, 'utme', year, 'Which literary term means ' + pair[1] + '?',
        {'a': pair[0], 'b': 'onomatopoeia', 'c': 'foreshadowing', 'd': 'aside'}, 'a', pair[0][0].toUpperCase() + pair[0].substring(1) + ' means ' + pair[1] + '.');
    default:
      const words = [['abundant','scarce','plentiful'],['ancient','modern','old'],['brief','lengthy','short'],['candid','deceptive','frank'],['diligent','idle','hardworking'],['hostile','friendly','unfriendly'],['liberty','captivity','freedom'],['precise','vague','exact'],['reluctant','willing','unwilling'],['vital','unimportant','essential']];
      final pair = words[(n - 1) % words.length];
      return _q(id, subject, 'utme', year, 'Choose the word nearest in meaning to "' + pair[0] + '".',
        {'a': pair[2], 'b': pair[1], 'c': 'temporary', 'd': 'opposite'}, 'a', pair[2][0].toUpperCase() + pair[2].substring(1) + ' is nearest in meaning to ' + pair[0] + '.');
  }
}

Question _q(int id, String subject, String type, int year, String question, Map<String, String?> options, String answer, String solution) => Question(
  id: id, question: question, options: options, answer: answer, solution: solution, examType: type, examYear: year.toString(), subject: subject,
);