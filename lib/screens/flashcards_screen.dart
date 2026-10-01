import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../theme/app_theme.dart';

class FlashcardsScreen extends StatefulWidget {
  final Lesson lesson;
  final String language;

  const FlashcardsScreen({
    super.key,
    required this.lesson,
    required this.language,
  });

  @override
  State<FlashcardsScreen> createState() =>
      _FlashcardsScreenState();
}

class _FlashcardsScreenState
    extends State<FlashcardsScreen> {
  late final List<_FlashcardData> cards;

  int currentIndex = 0;
  bool showAnswer = false;

  @override
  void initState() {
    super.initState();

    final translation =
        widget.lesson.translationFor(widget.language);

    cards = [
      _FlashcardData(
        question: 'परिवार',
        answer: translation.isEmpty
            ? 'Family'
            : translation,
      ),
      const _FlashcardData(
        question: 'माता',
        answer: 'Mother',
      ),
      const _FlashcardData(
        question: 'पिता',
        answer: 'Father',
      ),
      const _FlashcardData(
        question: 'बच्चे',
        answer: 'Children',
      ),
    ];
  }

  void _flipCard() {
    setState(() {
      showAnswer = !showAnswer;
    });
  }

  void _nextCard() {
    if (currentIndex < cards.length - 1) {
      setState(() {
        currentIndex++;
        showAnswer = false;
      });
    }
  }

  void _previousCard() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        showAnswer = false;
      });
    }
  }

  void _restartCards() {
    setState(() {
      currentIndex = 0;
      showAnswer = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final card = cards[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: Column(
              children: [
                Text(
                  'Learn Important Words',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the card to reveal the answer.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Text(
                      'Card ${currentIndex + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      ' / ${cards.length}',
                      style: const TextStyle(
                        color:
                            AppTheme.mutedTextColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                LinearProgressIndicator(
                  value:
                      (currentIndex + 1) / cards.length,
                  minHeight: 7,
                  borderRadius:
                      BorderRadius.circular(10),
                ),

                const SizedBox(height: 24),

                GestureDetector(
                  onTap: _flipCard,
                  child: AnimatedContainer(
                    duration:
                        const Duration(milliseconds: 250),
                    width: double.infinity,
                    constraints:
                        const BoxConstraints(
                      minHeight: 330,
                    ),
                    padding:
                        const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: showAnswer
                          ? AppTheme.primaryColor
                          : Colors.white,
                      borderRadius:
                          BorderRadius.circular(24),
                      border: Border.all(
                        color:
                            AppTheme.primaryColor,
                        width: 2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 12,
                          offset: Offset(0, 5),
                          color:
                              Color(0x18000000),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          showAnswer
                              ? Icons.translate_rounded
                              : Icons.style_rounded,
                          size: 50,
                          color: showAnswer
                              ? Colors.white
                              : AppTheme.primaryColor,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          showAnswer
                              ? 'Translation'
                              : 'Hindi Word',
                          style: TextStyle(
                            color: showAnswer
                                ? Colors.white70
                                : AppTheme.mutedTextColor,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          showAnswer
                              ? card.answer
                              : card.question,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: showAnswer
                                ? Colors.white
                                : AppTheme.textColor,
                            fontSize: 30,
                            fontWeight:
                                FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Tap to flip',
                          style: TextStyle(
                            color: showAnswer
                                ? Colors.white70
                                : AppTheme.mutedTextColor,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: currentIndex == 0
                            ? null
                            : _previousCard,
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                        ),
                        label: const Text('Previous'),
                        style:
                            OutlinedButton.styleFrom(
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
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            currentIndex ==
                                    cards.length - 1
                                ? _restartCards
                                : _nextCard,
                        icon: Icon(
                          currentIndex ==
                                  cards.length - 1
                              ? Icons
                                  .restart_alt_rounded
                              : Icons
                                  .arrow_forward_rounded,
                        ),
                        label: Text(
                          currentIndex ==
                                  cards.length - 1
                              ? 'Restart'
                              : 'Next',
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
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
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.offline_bolt_rounded,
                        color:
                            AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Flashcards are designed to '
                          'work offline using locally '
                          'stored lesson content.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                height: 1.5,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FlashcardData {
  final String question;
  final String answer;

  const _FlashcardData({
    required this.question,
    required this.answer,
  });
}