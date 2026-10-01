import 'package:flutter/material.dart';

import '../models/lesson.dart';
import '../theme/app_theme.dart';

class PronunciationScreen extends StatefulWidget {
  final Lesson lesson;
  final String language;
  final String text;

  const PronunciationScreen({
    super.key,
    required this.lesson,
    required this.language,
    required this.text,
  });

  @override
  State<PronunciationScreen> createState() =>
      _PronunciationScreenState();
}

class _PronunciationScreenState
    extends State<PronunciationScreen> {
  bool isRecording = false;
  bool hasResult = false;

  double pronunciationScore = 0.0;

  void _toggleRecording() {
    setState(() {
      if (!isRecording) {
        isRecording = true;
        hasResult = false;
      } else {
        isRecording = false;
        hasResult = true;
        pronunciationScore = 86.0;
      }
    });
  }

  void _resetPractice() {
    setState(() {
      isRecording = false;
      hasResult = false;
      pronunciationScore = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pronunciation Practice'),
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
                  'Practice Speaking',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Listen, speak and improve pronunciation '
                  'in ${widget.language}.',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium,
                ),
                const SizedBox(height: 24),

                _buildLessonCard(context),

                const SizedBox(height: 20),

                _buildPracticeCard(context),

                if (hasResult) ...[
                  const SizedBox(height: 20),
                  _buildResultCard(context),
                ],

                const SizedBox(height: 20),

                _buildInfoCard(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor
                        .withValues(alpha: 0.08),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.record_voice_over_rounded,
                    color: AppTheme.primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.lesson.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.language,
                        style: const TextStyle(
                          color:
                              AppTheme.secondaryColor,
                          fontWeight:
                              FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F7F2),
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Text(
                widget.text.isEmpty
                    ? 'Practice text will appear here.'
                    : widget.text,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(
                      height: 1.7,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPracticeCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              isRecording
                  ? 'Listening...'
                  : 'Tap the microphone and speak',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              isRecording
                  ? 'Speak the displayed sentence clearly.'
                  : 'Try to pronounce the lesson text.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
            const SizedBox(height: 28),

            AnimatedContainer(
              duration:
                  const Duration(milliseconds: 250),
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: isRecording
                    ? AppTheme.secondaryColor
                        .withValues(alpha: 0.18)
                    : AppTheme.primaryColor
                        .withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isRecording
                      ? AppTheme.secondaryColor
                      : AppTheme.primaryColor,
                  width: 3,
                ),
              ),
              child: Icon(
                isRecording
                    ? Icons.mic_rounded
                    : Icons.mic_none_rounded,
                size: 58,
                color: isRecording
                    ? AppTheme.secondaryColor
                    : AppTheme.primaryColor,
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              onPressed: _toggleRecording,
              icon: Icon(
                isRecording
                    ? Icons.stop_rounded
                    : Icons.mic_rounded,
              ),
              label: Text(
                isRecording
                    ? 'Stop Recording'
                    : 'Start Practice',
              ),
              style: ElevatedButton.styleFrom(
                minimumSize:
                    const Size(double.infinity, 52),
              ),
            ),

            if (hasResult) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _resetPractice,
                icon: const Icon(
                  Icons.refresh_rounded,
                ),
                label: const Text(
                  'Practice Again',
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize:
                      const Size(double.infinity, 52),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.analytics_rounded,
                  color: AppTheme.primaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Practice Result',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 20),

            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: CircularProgressIndicator(
                      value:
                          pronunciationScore / 100,
                      strokeWidth: 10,
                      backgroundColor:
                          const Color(0xFFE2E8F0),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '${pronunciationScore.toInt()}%',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color:
                                  AppTheme.primaryColor,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                      ),
                      const Text(
                        'Score',
                        style: TextStyle(
                          color:
                              AppTheme.mutedTextColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green
                    .withValues(alpha: 0.08),
                borderRadius:
                    BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    color: AppTheme.successColor,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Good pronunciation! Keep practicing '
                      'to improve your accuracy.',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Container(
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
            color: AppTheme.primaryColor,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'The current prototype uses a simulated '
              'pronunciation score. Speech recognition, '
              'NLP analysis and pronunciation scoring '
              'will be connected in the AI integration phase.',
              style: TextStyle(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}