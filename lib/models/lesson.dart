class Lesson {
  final String id;
  final String className;
  final String subject;
  final String chapter;
  final String title;

  final String hindiText;

  final Map<String, String> translations;

  final String imageAsset;
  final String audioAsset;

  const Lesson({
    required this.id,
    required this.className,
    required this.subject,
    required this.chapter,
    required this.title,
    required this.hindiText,
    required this.translations,
    required this.imageAsset,
    required this.audioAsset,
  });

  String translationFor(String language) {
    return translations[language] ?? hindiText;
  }

  String textForLanguage(String language) {
    if (language == 'Hindi') {
      return hindiText;
    }

    return translations[language] ?? '';
  }
}