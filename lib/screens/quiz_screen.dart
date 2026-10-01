import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../theme/app_theme.dart';

class QuizScreen extends StatefulWidget {
  final Lesson lesson;
  final String language;

  const QuizScreen({
    super.key,
    required this.lesson,
    required this.language,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late final List<_QuizQuestion> questions;

  int currentIndex = 0;
  int score = 0;
  int? selectedAnswer;
  bool answered = false;

  @override
  void initState() {
    super.initState();

    questions = [
      const _QuizQuestion(
        question: 'मेरा परिवार कैसा है?',
        options: [
          'छोटा और प्यारा',
          'बहुत बड़ा',
          'बहुत दूर',
          'कोई परिवार नहीं',
        ],
        correctAnswer: 0,
      ),
      const _QuizQuestion(
        question: 'परिवार में कौन होते हैं?',
        options: [
          'केवल दोस्त',
          'माता, पिता और बच्चे',
          'केवल शिक्षक',
          'केवल पड़ोसी',
        ],
        correctAnswer: 1,
      ),
      const _QuizQuestion(
        question: 'हमें अपने परिवार के साथ कैसा व्यवहार करना चाहिए?',
        options: [
          'प्यार और सम्मान से',
          'गुस्से से',
          'उदासीनता से',
          'बिना बात किए',
        ],
        correctAnswer: 0,
      ),
    ];
  }

  void _selectAnswer(int index) {
    if (answered) return;

    setState(() {
      selectedAnswer = index;
      answered = true;

      if (index == questions[currentIndex].correctAnswer) {
        score++;
      }
    });
  }

  void _nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
        selectedAnswer = null;
        answered = false;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() {
    final percentage =
        ((score / questions.length) * 100).round();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Quiz Completed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.emoji_events_rounded,
                size: 64,
                color: AppTheme.secondaryColor,
              ),
              const SizedBox(height: 16),
              Text(
                '$score / ${questions.length}',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                '$percentage% Score',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium,
              ),
              const SizedBox(height: 12),
              Text(
                percentage >= 70
                    ? 'Good work! Keep learning.'
                    : 'Keep practicing and try again.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _restartQuiz();
              },
              child: const Text('Try Again'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _restartQuiz() {
    setState(() {
      currentIndex = 0;
      score = 0;
      selectedAnswer = null;
      answered = false;
    });
  }

  Color _optionColor(int index) {
    if (!answered) {
      return Colors.white;
    }

    final question = questions[currentIndex];

    if (index == question.correctAnswer) {
      return Colors.green.withValues(alpha: 0.10);
    }

    if (index == selectedAnswer) {
      return Colors.red.withValues(alpha: 0.10);
    }

    return Colors.white;
  }

  Color _optionBorderColor(int index) {
    if (!answered) {
      return const Color(0xFFE2E8F0);
    }

    final question = questions[currentIndex];

    if (index == question.correctAnswer) {
      return AppTheme.successColor;
    }

    if (index == selectedAnswer) {
      return Colors.red;
    }

    return const Color(0xFFE2E8F0);
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson Quiz'),
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
                  'Check Your Understanding',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '${widget.lesson.title} • ${widget.language}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),
                const SizedBox(height: 24),

                Row(
                  children: [
                    Text(
                      'Question ${currentIndex + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Score: $score',
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                LinearProgressIndicator(
                  value:
                      (currentIndex + 1) /
                          questions.length,
                  minHeight: 7,
                  borderRadius:
                      BorderRadius.circular(10),
                ),

                const SizedBox(height: 24),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.quiz_rounded,
                          size: 34,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          question.question,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                height: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                ...List.generate(
                  question.options.length,
                  (index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 12,
                      ),
                      child: _AnswerOption(
                        number: index + 1,
                        text: question.options[index],
                        backgroundColor:
                            _optionColor(index),
                        borderColor:
                            _optionBorderColor(index),
                        isCorrect: answered &&
                            index ==
                                question.correctAnswer,
                        isWrong: answered &&
                            index == selectedAnswer &&
                            index !=
                                question.correctAnswer,
                        onTap: () {
                          _selectAnswer(index);
                        },
                      ),
                    );
                  },
                ),

                if (answered) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: selectedAnswer ==
                              question.correctAnswer
                          ? Colors.green.withValues(
                              alpha: 0.08,
                            )
                          : Colors.red.withValues(
                              alpha: 0.08,
                            ),
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          selectedAnswer ==
                                  question.correctAnswer
                              ? Icons
                                  .check_circle_rounded
                              : Icons
                                  .info_outline_rounded,
                          color: selectedAnswer ==
                                  question.correctAnswer
                              ? AppTheme.successColor
                              : Colors.red,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            selectedAnswer ==
                                    question.correctAnswer
                                ? 'Correct answer! Well done.'
                                : 'Not quite. The highlighted '
                                  'green option is the correct answer.',
                            style: const TextStyle(
                              height: 1.5,
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 20),

                ElevatedButton.icon(
                  onPressed:
                      answered ? _nextQuestion : null,
                  icon: Icon(
                    currentIndex ==
                            questions.length - 1
                        ? Icons
                            .emoji_events_rounded
                        : Icons
                            .arrow_forward_rounded,
                  ),
                  label: Text(
                    currentIndex ==
                            questions.length - 1
                        ? 'Finish Quiz'
                        : 'Next Question',
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  width: double.infinity,
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
                        Icons.offline_bolt_rounded,
                        color:
                            AppTheme.primaryColor,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Quiz questions can be stored '
                          'locally so students can practice '
                          'without internet access.',
                          style: TextStyle(
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

class _AnswerOption extends StatelessWidget {
  final int number;
  final String text;
  final Color backgroundColor;
  final Color borderColor;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.number,
    required this.text,
    required this.backgroundColor,
    required this.borderColor,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration:
            const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isCorrect || isWrong ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isCorrect
                    ? AppTheme.successColor
                    : isWrong
                        ? Colors.red
                        : AppTheme.primaryColor
                            .withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: isCorrect
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                    )
                  : isWrong
                      ? const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                        )
                      : Text(
                          '$number',
                          style: const TextStyle(
                            color:
                                AppTheme.primaryColor,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswer;

  const _QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });
}