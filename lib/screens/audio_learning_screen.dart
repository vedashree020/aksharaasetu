import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../theme/app_theme.dart';

class AudioLearningScreen extends StatefulWidget {
  final Lesson lesson;
  final String language;
  final String text;

  const AudioLearningScreen({
    super.key,
    required this.lesson,
    required this.language,
    required this.text,
  });

  @override
  State<AudioLearningScreen> createState() =>
      _AudioLearningScreenState();
}

class _AudioLearningScreenState
    extends State<AudioLearningScreen> {
  bool isPlaying = false;
  double progress = 0.0;

  void _togglePlayback() {
    setState(() {
      isPlaying = !isPlaying;

      if (isPlaying) {
        progress = 0.35;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Learning'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 800,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'Listen & Learn',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Listen to the lesson pronunciation in '
                  '${widget.language}.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),

                const SizedBox(height: 24),

                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor
                                .withValues(alpha: 0.08),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.volume_up_rounded,
                            size: 48,
                            color:
                                AppTheme.primaryColor,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          widget.lesson.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge,
                        ),

                        const SizedBox(height: 6),

                        Text(
                          widget.language,
                          style: const TextStyle(
                            color:
                                AppTheme.secondaryColor,
                            fontWeight:
                                FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 24),

                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFF8F7F2,
                            ),
                            borderRadius:
                                BorderRadius.circular(
                              16,
                            ),
                          ),
                          child: Text(
                            widget.text,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  height: 1.6,
                                ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),

                        const SizedBox(height: 18),

                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  progress = 0.0;
                                });
                              },
                              icon: const Icon(
                                Icons.replay_rounded,
                              ),
                            ),
                            const SizedBox(width: 12),
                            FloatingActionButton.large(
                              onPressed:
                                  _togglePlayback,
                              backgroundColor:
                                  AppTheme.primaryColor,
                              foregroundColor:
                                  Colors.white,
                              child: Icon(
                                isPlaying
                                    ? Icons
                                        .pause_rounded
                                    : Icons
                                        .play_arrow_rounded,
                                size: 38,
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  progress = 1.0;
                                  isPlaying = false;
                                });
                              },
                              icon: const Icon(
                                Icons.stop_rounded,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Container(
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
                          'Prototype audio is represented '
                          'with an offline-ready player. '
                          'AI4Bharat TTS and pre-generated '
                          'audio can be connected here later.',
                          style: TextStyle(
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                  ),
                  label: const Text(
                    'Back to Translation',
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize:
                        const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(14),
                    ),
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