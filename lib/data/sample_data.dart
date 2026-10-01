import '../models/lesson.dart';

class SampleData {
  static const List<String> classes = [
    'Class 1',
    'Class 2',
    'Class 3',
    'Class 4',
    'Class 5',
  ];

  static const List<String> subjects = [
    'Hindi',
    'Mathematics',
    'Environmental Studies',
  ];

  static const List<String> languages = [
    'Hindi',
    'Ho',
    'Mundari',
    'Santali',
  ];

  static const List<Lesson> lessons = [
    Lesson(
      id: 'lesson_001',
      className: 'Class 1',
      subject: 'Hindi',
      chapter: 'Chapter 1',
      title: 'मेरा परिवार',
      hindiText:
          'मेरा परिवार छोटा और प्यारा है। मेरे परिवार में माता, पिता और बच्चे हैं।',
      translations: {
        'Ho': 'मेरा परिवार छोटा और प्यारा है।',
        'Mundari': 'मेरा परिवार छोटा और प्यारा है।',
        'Santali': 'मेरा परिवार छोटा और प्यारा है।',
      },
      imageAsset: 'assets/images/family.png',
      audioAsset: 'assets/audio/family.mp3',
    ),
    Lesson(
      id: 'lesson_002',
      className: 'Class 1',
      subject: 'Hindi',
      chapter: 'Chapter 2',
      title: 'रंग',
      hindiText:
          'लाल, नीला, पीला और हरा सुंदर रंग हैं। हमें अपने आसपास के रंगों को पहचानना चाहिए।',
      translations: {
        'Ho': 'लाल, नीला, पीला और हरा सुंदर रंग हैं।',
        'Mundari': 'लाल, नीला, पीला और हरा सुंदर रंग हैं।',
        'Santali': 'लाल, नीला, पीला और हरा सुंदर रंग हैं।',
      },
      imageAsset: 'assets/images/colors.png',
      audioAsset: 'assets/audio/colors.mp3',
    ),
    Lesson(
      id: 'lesson_003',
      className: 'Class 2',
      subject: 'Environmental Studies',
      chapter: 'Chapter 1',
      title: 'पेड़ और पौधे',
      hindiText:
          'पेड़ और पौधे हमें फल, फूल, छाया और स्वच्छ हवा देते हैं। हमें पेड़ों की रक्षा करनी चाहिए।',
      translations: {
        'Ho': 'पेड़ और पौधे हमें फल, फूल और स्वच्छ हवा देते हैं।',
        'Mundari': 'पेड़ और पौधे हमारे लिए उपयोगी हैं।',
        'Santali': 'पेड़ और पौधे हमें स्वच्छ हवा देते हैं।',
      },
      imageAsset: 'assets/images/tree.png',
      audioAsset: 'assets/audio/tree.mp3',
    ),
  ];

  static List<Lesson> getLessons({
    String? className,
    String? subject,
  }) {
    return lessons.where((lesson) {
      final classMatches =
          className == null || lesson.className == className;

      final subjectMatches =
          subject == null || lesson.subject == subject;

      return classMatches && subjectMatches;
    }).toList();
  }
}