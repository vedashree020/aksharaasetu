import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../models/app_user.dart';
import '../models/lesson.dart';
import '../services/api_service.dart';
import '../services/tts_service.dart';
import '../theme/app_theme.dart';
import 'edit_translation_screen.dart';
import 'flashcards_screen.dart';
import 'quiz_screen.dart';

class TranslationWorkspace extends StatefulWidget {
  final AppUser user;
  final Lesson lesson;

  const TranslationWorkspace({
    super.key,
    required this.user,
    required this.lesson,
  });

  @override
  State<TranslationWorkspace> createState() =>
      _TranslationWorkspaceState();
}

class _TranslationWorkspaceState
    extends State<TranslationWorkspace> {
  final TextEditingController _textController =
      TextEditingController();

  final AudioRecorder _recorder = AudioRecorder();

  final TtsService _ttsService = TtsService.instance;

  bool isHindiToSantali = true;
  bool isRecording = false;
  bool isTranslating = false;
  bool isSpeechTranslating = false;
  bool isSpeaking = false;

  String detectedSpeech = '';
  String currentTranslation = '';

  String get sourceLanguage =>
      isHindiToSantali ? 'Hindi' : 'Santali';

  String get targetLanguage =>
      isHindiToSantali ? 'Santali' : 'Hindi';

  String get sourceApiLanguage =>
      isHindiToSantali ? 'hindi' : 'santali';

  String get targetApiLanguage =>
      isHindiToSantali ? 'santali' : 'hindi';

  String get targetTtsLanguage =>
      isHindiToSantali ? 'hi-IN' : 'sat-IN';

  @override
  void dispose() {
    _textController.dispose();
    _recorder.dispose();
    _ttsService.stop();
    super.dispose();
  }

  void _switchLanguages() {
    setState(() {
      isHindiToSantali = !isHindiToSantali;
      detectedSpeech = '';
      currentTranslation = '';
      _textController.clear();
    });
  }

  // ==========================================================
  // TEXT -> TEXT
  // ==========================================================

  Future<void> _translateText() async {
    final text = _textController.text.trim();

    if (text.isEmpty) {
      _showMessage(
        'Please enter some $sourceLanguage text.',
      );
      return;
    }

    setState(() {
      isTranslating = true;
      currentTranslation = '';
    });

    try {
      final result = await ApiService.translate(
        sourceLanguage: sourceApiLanguage,
        targetLanguage: targetApiLanguage,

        // IMPORTANT:
        // Backend TranslationMode expects "text".
        mode: 'text',

        text: text,
        lessonId: widget.lesson.id,
      );

      final translatedText =
          result['translated_text'] ??
          result['translation'] ??
          '';

      if (translatedText.toString().trim().isEmpty) {
        throw Exception(
          result['message'] ??
              'Translation result was empty.',
        );
      }

      if (!mounted) return;

      setState(() {
        currentTranslation =
            translatedText.toString();
      });
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Translation failed: ${e.toString()}',
      );
    } finally {
      if (mounted) {
        setState(() {
          isTranslating = false;
        });
      }
    }
  }

  // ==========================================================
  // TEXT -> SPEECH
  // ==========================================================

  Future<void> _speakTranslation() async {
    final text = currentTranslation.trim();

    if (text.isEmpty) {
      _showMessage(
        'Translate some text first.',
      );
      return;
    }

    if (isSpeaking) {
      await _ttsService.stop();

      if (mounted) {
        setState(() {
          isSpeaking = false;
        });
      }

      return;
    }

    setState(() {
      isSpeaking = true;
    });

    try {
      final spoken = await _ttsService.speak(
        text: text,
        language: targetTtsLanguage,
      );

      if (!mounted) return;

      if (!spoken) {
        setState(() {
          isSpeaking = false;
        });

        _showMessage(
          '$targetLanguage speech is not available '
          'in the installed device TTS engine.',
        );

        return;
      }

      _showMessage(
        'Playing $targetLanguage audio...',
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSpeaking = false;
      });

      _showMessage(
        'Could not play audio.',
      );
    }
  }

  // ==========================================================
  // SPEECH RECORDING
  // ==========================================================

  Future<void> _startRecording() async {
    try {
      final hasPermission =
          await _recorder.hasPermission();

      if (!hasPermission) {
        _showMessage(
          'Microphone permission is required.',
        );
        return;
      }

      final directory =
          await getTemporaryDirectory();

      final filePath =
          '${directory.path}/aksharaa_recording.wav';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.wav,
          sampleRate: 16000,
          numChannels: 1,
        ),
        path: filePath,
      );

      if (!mounted) return;

      setState(() {
        isRecording = true;
        detectedSpeech = '';
        currentTranslation = '';
      });
    } catch (e) {
      _showMessage(
        'Could not start microphone.',
      );
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _recorder.stop();

      if (!mounted) return;

      setState(() {
        isRecording = false;
      });

      if (path == null || path.isEmpty) {
        _showMessage(
          'No audio was recorded.',
        );
        return;
      }

      final audioFile = File(path);

      if (!await audioFile.exists()) {
        _showMessage(
          'Recorded audio file was not found.',
        );
        return;
      }

      await _translateSpeech(audioFile);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isRecording = false;
      });

      _showMessage(
        'Could not process the recording.',
      );
    }
  }

  // ==========================================================
  // SPEECH -> TEXT -> TRANSLATION
  // ==========================================================

  Future<void> _translateSpeech(
    File audioFile,
  ) async {
    setState(() {
      isSpeechTranslating = true;
      detectedSpeech = '';
      currentTranslation = '';
    });

    try {
      final result =
          await ApiService.speechToSpeech(
        audioFile: audioFile,
        sourceLanguage: sourceApiLanguage,
        targetLanguage: targetApiLanguage,
      );

      final sourceText =
          result['source_text'] ??
          result['detected_text'] ??
          '';

      final translatedText =
          result['translated_text'] ??
          result['translation'] ??
          '';

      if (translatedText.toString().trim().isEmpty) {
        throw Exception(
          result['message'] ??
              'Translation result was empty.',
        );
      }

      if (!mounted) return;

      setState(() {
        detectedSpeech =
            sourceText.toString();

        currentTranslation =
            translatedText.toString();
      });
    } catch (e) {
      if (!mounted) return;

      _showMessage(
        'Speech translation failed: '
        '${e.toString()}',
      );
    } finally {
      if (mounted) {
        setState(() {
          isSpeechTranslating = false;
        });
      }
    }
  }

  // ==========================================================
  // UI HELPERS
  // ==========================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.cream,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal:
                    constraints.maxWidth > 900
                        ? 48
                        : 20,
                vertical: 24,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(
                    maxWidth: 1100,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.stretch,
                    children: [
                      _buildLessonHeader(),
                      const SizedBox(height: 20),
                      _buildLanguageBanner(),
                      const SizedBox(height: 24),
                      _buildTextTranslationCard(),
                      const SizedBox(height: 24),
                      _buildSpeechCard(),
                      const SizedBox(height: 24),
                      if (detectedSpeech.isNotEmpty)
                        _buildDetectedSpeechCard(),
                      if (detectedSpeech.isNotEmpty)
                        const SizedBox(height: 20),
                      if (currentTranslation.isNotEmpty)
                        _buildTranslationResultCard(),
                      if (currentTranslation.isNotEmpty)
                        const SizedBox(height: 24),
                      _buildMainActions(),
                      const SizedBox(height: 30),
                      _buildLearningTools(),
                      const SizedBox(height: 24),
                      _buildOfflineBanner(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.navy,
      foregroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 20,
      title: const Text(
        'AksharaaSetu',
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Padding(
          padding:
              const EdgeInsets.only(right: 16),
          child: Center(
            child: Text(
              widget.user.name,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLessonHeader() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              AppTheme.gold.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppTheme.terracotta
                  .withValues(alpha: 0.12),
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: AppTheme.terracotta,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  widget.lesson.title,
                  style: const TextStyle(
                    color: AppTheme.darkText,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Class ${widget.lesson.className} • '
                  '${widget.lesson.subject}',
                  style: const TextStyle(
                    color: AppTheme.mutedText,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppTheme.navy,
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact =
              constraints.maxWidth < 520;

          if (compact) {
            return Column(
              children: [
                _languageLabel(
                  sourceLanguage,
                  Icons.input_rounded,
                ),
                const SizedBox(height: 12),
                _switchButton(),
                const SizedBox(height: 12),
                _languageLabel(
                  targetLanguage,
                  Icons.output_rounded,
                ),
              ],
            );
          }

          return Row(
            children: [
              Expanded(
                child: _languageLabel(
                  sourceLanguage,
                  Icons.input_rounded,
                ),
              ),
              _switchButton(),
              Expanded(
                child: Align(
                  alignment:
                      Alignment.centerRight,
                  child: _languageLabel(
                    targetLanguage,
                    Icons.output_rounded,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _languageLabel(
    String language,
    IconData icon,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: AppTheme.gold,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          language,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _switchButton() {
    return InkWell(
      onTap: _switchLanguages,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.swap_horiz_rounded,
              color: AppTheme.navy,
              size: 22,
            ),
            SizedBox(width: 6),
            Text(
              'Switch',
              style: TextStyle(
                color: AppTheme.navy,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextTranslationCard() {
    return _card(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            icon: Icons.translate_rounded,
            title: 'Translate Text',
            subtitle:
                'Enter text in $sourceLanguage',
          ),
          const SizedBox(height: 18),
          TextField(
            controller: _textController,
            maxLines: 6,
            decoration: InputDecoration(
              hintText:
                  'Type $sourceLanguage text here...',
              filled: true,
              fillColor: AppTheme.cream,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.all(18),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed:
                  isTranslating
                      ? null
                      : _translateText,
              icon: isTranslating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                          CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.translate_rounded,
                    ),
              label: Text(
                isTranslating
                    ? 'Translating...'
                    : 'Translate to $targetLanguage',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeechCard() {
    return _card(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          _sectionTitle(
            icon: Icons.mic_rounded,
            title: 'Speak to Translate',
            subtitle:
                'Speak in $sourceLanguage',
          ),
          const SizedBox(height: 22),
          Center(
            child: GestureDetector(
              onTap: isSpeechTranslating
                  ? null
                  : isRecording
                      ? _stopRecording
                      : _startRecording,
              child: AnimatedContainer(
                duration:
                    const Duration(milliseconds: 250),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRecording
                      ? AppTheme.terracotta
                      : AppTheme.navy,
                  boxShadow: [
                    BoxShadow(
                      color: (isRecording
                              ? AppTheme.terracotta
                              : AppTheme.navy)
                          .withValues(alpha: 0.25),
                      blurRadius: 22,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: isSpeechTranslating
                    ? const Padding(
                        padding: EdgeInsets.all(30),
                        child:
                            CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : Icon(
                        isRecording
                            ? Icons.stop_rounded
                            : Icons.mic_rounded,
                        color: Colors.white,
                        size: 44,
                      ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Center(
            child: Text(
              isSpeechTranslating
                  ? 'Processing speech...'
                  : isRecording
                      ? 'Tap to stop recording'
                      : 'Tap the microphone to speak',
              style: const TextStyle(
                color: AppTheme.mutedText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '$sourceLanguage → $targetLanguage',
              style: const TextStyle(
                color: AppTheme.terracotta,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectedSpeechCard() {
    return _resultCard(
      icon: Icons.record_voice_over_rounded,
      title: 'Detected Speech',
      text: detectedSpeech,
      iconColor: AppTheme.navy,
    );
  }

  Widget _buildTranslationResultCard() {
    return _resultCard(
      icon: Icons.translate_rounded,
      title: 'Translation',
      text: currentTranslation,
      iconColor: AppTheme.terracotta,
      showEditButton: true,
    );
  }

  Widget _resultCard({
    required IconData icon,
    required String title,
    required String text,
    required Color iconColor,
    bool showEditButton = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              iconColor.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor
                      .withValues(alpha: 0.10),
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.darkText,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (showEditButton)
                IconButton(
                  tooltip: 'Edit translation',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            EditTranslationScreen(
                          lesson: widget.lesson,
                          initialTranslation:
                              currentTranslation,
                          language:
                              targetLanguage,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.edit_rounded,
                    color: AppTheme.navy,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.cream,
              borderRadius:
                  BorderRadius.circular(14),
            ),
            child: SelectableText(
              text,
              style: const TextStyle(
                color: AppTheme.darkText,
                fontSize: 18,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainActions() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact =
            constraints.maxWidth < 600;

        final buttons = [
          _actionButton(
            icon: isSpeaking
                ? Icons.stop_circle_rounded
                : Icons.volume_up_rounded,
            title: isSpeaking
                ? 'Stop Audio'
                : 'Listen',
            subtitle: isSpeaking
                ? 'Playing...'
                : 'Listen to translation',
            onTap: _speakTranslation,
          ),
          _actionButton(
            icon:
                Icons.record_voice_over_rounded,
            title: 'Pronunciation',
            subtitle: 'Coming Soon',
            onTap: () {
              _showMessage(
                'Pronunciation correction is coming soon.',
              );
            },
          ),
        ];

        if (compact) {
          return Column(
            children: [
              buttons[0],
              const SizedBox(height: 12),
              buttons[1],
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: buttons[0]),
            const SizedBox(width: 14),
            Expanded(child: buttons[1]),
          ],
        );
      },
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color:
                AppTheme.navy.withValues(alpha: 0.10),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.navy
                    .withValues(alpha: 0.08),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.navy,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.darkText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppTheme.mutedText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningTools() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        const Text(
          'Learning Tools',
          style: TextStyle(
            color: AppTheme.darkText,
            fontSize: 21,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact =
                constraints.maxWidth < 650;

            final cards = [
              _toolCard(
                icon: Icons.headphones_rounded,
                title: 'Audio Learning',
                subtitle: 'Use Listen above',
                onTap: _speakTranslation,
              ),
              _toolCard(
                icon:
                    Icons.record_voice_over_rounded,
                title: 'Pronunciation',
                subtitle: 'Coming Soon',
                onTap: () {
                  _showMessage(
                    'Pronunciation correction is coming soon.',
                  );
                },
              ),
              _toolCard(
                icon: Icons.style_rounded,
                title: 'Flashcards',
                subtitle: 'Learn key words',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          FlashcardsScreen(
                        lesson: widget.lesson,
                        language: targetLanguage,
                      ),
                    ),
                  );
                },
              ),
              _toolCard(
                icon: Icons.quiz_rounded,
                title: 'Quiz',
                subtitle: 'Check understanding',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          QuizScreen(
                        lesson: widget.lesson,
                        language: targetLanguage,
                      ),
                    ),
                  );
                },
              ),
            ];

            if (compact) {
              return Column(
                children: cards
                    .map(
                      (card) => Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 12,
                        ),
                        child: card,
                      ),
                    )
                    .toList(),
              );
            }

            return GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.5,
              children: cards,
            );
          },
        ),
      ],
    );
  }

  Widget _toolCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color:
                AppTheme.navy.withValues(alpha: 0.10),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding:
                  const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: AppTheme.gold
                    .withValues(alpha: 0.14),
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: AppTheme.navy,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppTheme.darkText,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.mutedText,
                      fontSize: 12,
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

  Widget _buildOfflineBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            AppTheme.navy.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              AppTheme.navy.withValues(alpha: 0.10),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.offline_bolt_rounded,
            color: AppTheme.navy,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Offline-first learning is supported. '
              'AI translation and speech processing '
              'use the connected backend when available.',
              style: TextStyle(
                color: AppTheme.darkText,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Container(
          padding:
              const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppTheme.terracotta
                .withValues(alpha: 0.10),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppTheme.terracotta,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: AppTheme.darkText,
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppTheme.mutedText,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}