import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../theme/app_theme.dart';

class EditTranslationScreen extends StatefulWidget {
  final Lesson lesson;
  final String language;
  final String initialTranslation;

  const EditTranslationScreen({
    super.key,
    required this.lesson,
    required this.language,
    required this.initialTranslation,
  });

  @override
  State<EditTranslationScreen> createState() =>
      _EditTranslationScreenState();
}

class _EditTranslationScreenState
    extends State<EditTranslationScreen> {
  late final TextEditingController translationController;

  @override
  void initState() {
    super.initState();

    translationController = TextEditingController(
      text: widget.initialTranslation,
    );
  }

  @override
  void dispose() {
    translationController.dispose();
    super.dispose();
  }

  void _saveTranslation() {
    final updatedText =
        translationController.text.trim();

    if (updatedText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Translation cannot be empty.',
          ),
        ),
      );
      return;
    }

    Navigator.pop(context, updatedText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Translation'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 850,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Teacher Review',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium,
                ),

                const SizedBox(height: 8),

                Text(
                  'Review and correct the AI-generated '
                  'translation before saving it.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),

                const SizedBox(height: 24),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.menu_book_rounded,
                              color:
                                  AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Hindi Source',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          widget.lesson.hindiText,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                height: 1.6,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.translate_rounded,
                              color:
                                  AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${widget.language} Translation',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium,
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        TextField(
                          controller:
                              translationController,
                          minLines: 6,
                          maxLines: 12,
                          textCapitalization:
                              TextCapitalization.sentences,
                          decoration:
                              const InputDecoration(
                            hintText:
                                'Enter corrected translation...',
                            alignLabelWithHint: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  padding:
                      const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.secondaryColor
                        .withValues(alpha: 0.10),
                    borderRadius:
                        BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.secondaryColor
                          .withValues(alpha: 0.25),
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color:
                            AppTheme.primaryColor,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Teacher corrections can be '
                          'stored locally and synchronized '
                          'when connectivity is available.',
                          style: TextStyle(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize:
                              const Size(
                            double.infinity,
                            52,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            _saveTranslation,
                        icon: const Icon(
                          Icons.save_rounded,
                        ),
                        label: const Text(
                          'Save Correction',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}