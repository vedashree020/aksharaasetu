import 'package:flutter/material.dart';

import '../models/app_user.dart';
import 'class_selection.dart';
import 'upload_lesson_screen.dart';

class TeacherDashboard extends StatelessWidget {
  final AppUser user;

  const TeacherDashboard({
    super.key,
    required this.user,
  });

  static const Color navy = Color(0xFF10263A);
  static const Color navyDark = Color(0xFF0A1A29);

  static const Color cream = Color(0xFFF4EBDD);
  static const Color creamLight = Color(0xFFFFF9F0);
  static const Color creamDark = Color(0xFFE8DCC9);

  static const Color terracotta = Color(0xFFC9683E);
  static const Color gold = Color(0xFFD9A84E);

  static const Color darkText = Color(0xFF172235);
  static const Color mutedText = Color(0xFF62645F);

  static const Color green = Color(0xFF4E8B62);
  static const Color blue = Color(0xFF527A9E);
  static const Color purple = Color(0xFF796A8D);

  void _openClasses(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ClassSelection(user: user),
      ),
    );
  }

  void _openUploadLesson(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const UploadLessonScreen(),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String title) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title is coming soon.'),
        backgroundColor: terracotta,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamLight,

      // ─────────────────────────────────────────────
      // APP BAR
      // ─────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 78,
        titleSpacing: 24,
        title: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(13),
                border: Border.all(
                  color: gold.withValues(alpha: 0.35),
                ),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: gold,
                size: 27,
              ),
            ),
            const SizedBox(width: 14),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AksharaaSetu',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Teacher Learning Space',
                  style: TextStyle(
                    color: Color(0xFFD7DFE6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 22),
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: cream.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: cream.withValues(alpha: 0.2),
              ),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.person_rounded,
                  size: 18,
                  color: gold,
                ),
                SizedBox(width: 7),
                Text(
                  'Teacher',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ─────────────────────────────────────────────
      // BODY
      // ─────────────────────────────────────────────
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1200,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ───────────────────────────────────
                // HERO
                // ───────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: navy,
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome to your\nTeacher Space',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 31,
                                height: 1.15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Hello, ${user.name}. Prepare lessons and make learning accessible in the child’s mother tongue.',
                              style: const TextStyle(
                                color: Color(0xFFD7DFE6),
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Start lesson button
                            ElevatedButton.icon(
                              onPressed: () => _openClasses(context),
                              icon: const Icon(
                                Icons.play_arrow_rounded,
                              ),
                              label: const Text(
                                'Start a Lesson',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: terracotta,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 22,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                                elevation: 0,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 30),

                      // Book illustration-style icon
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: cream.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: gold.withValues(alpha: 0.25),
                          ),
                        ),
                        child: const Icon(
                          Icons.auto_stories_rounded,
                          color: gold,
                          size: 78,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ───────────────────────────────────
                // STATS
                // ───────────────────────────────────
                const Text(
                  'Teaching Overview',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 16),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;

                    final cardWidth = width >= 900
                        ? (width - 48) / 4
                        : width >= 600
                            ? (width - 16) / 2
                            : width;

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _statCard(
                          width: cardWidth,
                          icon: Icons.menu_book_rounded,
                          value: '12',
                          label: 'Lessons',
                          color: terracotta,
                        ),
                        _statCard(
                          width: cardWidth,
                          icon: Icons.translate_rounded,
                          value: '02',
                          label: 'Languages',
                          color: blue,
                        ),
                        _statCard(
                          width: cardWidth,
                          icon: Icons.offline_bolt_rounded,
                          value: '08',
                          label: 'Offline Ready',
                          color: green,
                        ),
                        _statCard(
                          width: cardWidth,
                          icon: Icons.check_circle_rounded,
                          value: '96%',
                          label: 'Content Ready',
                          color: gold,
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 32),

                // ───────────────────────────────────
                // MAIN ACTIONS
                // ───────────────────────────────────
                const Text(
                  'Lesson Management',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 16),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;

                    final cardWidth = width >= 900
                        ? (width - 32) / 3
                        : width >= 600
                            ? (width - 16) / 2
                            : width;

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _actionCard(
                          width: cardWidth,
                          icon: Icons.upload_file_rounded,
                          title: 'Upload Lesson PDF',
                          subtitle:
                              'Upload your current syllabus or lesson.',
                          color: terracotta,
                          onTap: () => _openUploadLesson(context),
                        ),
                        _actionCard(
                          width: cardWidth,
                          icon: Icons.translate_rounded,
                          title: 'Translate a Lesson',
                          subtitle: 'Hindi ↔ Santali',
                          color: blue,
                          onTap: () => _openClasses(context),
                        ),
                        _actionCard(
                          width: cardWidth,
                          icon: Icons.library_books_rounded,
                          title: 'My Lessons',
                          subtitle: 'View prepared lessons',
                          color: green,
                          onTap: () => _showComingSoon(
                            context,
                            'My Lessons',
                          ),
                        ),
                        _actionCard(
                          width: cardWidth,
                          icon: Icons.cloud_download_rounded,
                          title: 'Offline Content',
                          subtitle: 'Manage downloaded lessons',
                          color: gold,
                          onTap: () => _showComingSoon(
                            context,
                            'Offline Content',
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 32),

                // ───────────────────────────────────
                // RECENT LESSONS
                // ───────────────────────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Lessons',
                      style: TextStyle(
                        color: darkText,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton(
                      onPressed: () => _showComingSoon(
                        context,
                        'All Lessons',
                      ),
                      child: const Text(
                        'View all',
                        style: TextStyle(
                          color: terracotta,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                _lessonCard(
                  title: 'Numbers Around Us',
                  subtitle: 'Class 1 • Mathematics',
                  language: 'Hindi → Santali',
                  icon: Icons.calculate_rounded,
                ),

                const SizedBox(height: 12),

                _lessonCard(
                  title: 'Our Environment',
                  subtitle: 'Class 1 • Environmental Studies',
                  language: 'Hindi → Santali',
                  icon: Icons.eco_rounded,
                ),

                const SizedBox(height: 32),

                // ───────────────────────────────────
                // TEACHING TOOLS
                // ───────────────────────────────────
                const Text(
                  'Teaching Tools',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 16),

                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;

                    final cardWidth = width >= 900
                        ? (width - 48) / 4
                        : width >= 600
                            ? (width - 16) / 2
                            : width;

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _toolCard(
                          width: cardWidth,
                          icon: Icons.volume_up_rounded,
                          title: 'Audio',
                          subtitle: 'AI lesson audio',
                          color: terracotta,
                          onTap: () => _showComingSoon(
                            context,
                            'Audio',
                          ),
                        ),
                        _toolCard(
                          width: cardWidth,
                          icon: Icons.record_voice_over_rounded,
                          title: 'Pronunciation',
                          subtitle: 'Voice correction',
                          color: blue,
                          onTap: () => _showComingSoon(
                            context,
                            'Pronunciation',
                          ),
                        ),
                        _toolCard(
                          width: cardWidth,
                          icon: Icons.style_rounded,
                          title: 'Flashcards',
                          subtitle: 'Visual learning cards',
                          color: purple,
                          onTap: () => _showComingSoon(
                            context,
                            'Flashcards',
                          ),
                        ),
                        _toolCard(
                          width: cardWidth,
                          icon: Icons.quiz_rounded,
                          title: 'Quiz',
                          subtitle: 'Practice questions',
                          color: green,
                          onTap: () => _showComingSoon(
                            context,
                            'Quiz',
                          ),
                        ),
                        _toolCard(
                          width: cardWidth,
                          icon: Icons.image_rounded,
                          title: 'Learning Images',
                          subtitle: 'AI-assisted visuals',
                          color: gold,
                          onTap: () => _showComingSoon(
                            context,
                            'Learning Images',
                          ),
                        ),
                        _toolCard(
                          width: cardWidth,
                          icon: Icons.description_rounded,
                          title: 'Worksheets',
                          subtitle: 'Practice material',
                          color: terracotta,
                          onTap: () => _showComingSoon(
                            context,
                            'Worksheets',
                          ),
                        ),
                        _toolCard(
                          width: cardWidth,
                          icon: Icons.edit_note_rounded,
                          title: 'Edit Translation',
                          subtitle: 'Review translated content',
                          color: blue,
                          onTap: () => _showComingSoon(
                            context,
                            'Edit Translation',
                          ),
                        ),
                        _toolCard(
                          width: cardWidth,
                          icon: Icons.video_library_rounded,
                          title: 'Video Learning',
                          subtitle: 'Lesson video tools',
                          color: purple,
                          onTap: () => _showComingSoon(
                            context,
                            'Video Learning',
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 32),

                // ───────────────────────────────────
                // OFFLINE FIRST
                // ───────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0E5D4),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: creamDark,
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.offline_bolt_rounded,
                        color: green,
                        size: 29,
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Offline-first learning',
                              style: TextStyle(
                                color: darkText,
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Prepared lessons, translated text and compressed audio can be stored locally for learning when internet connectivity is limited.',
                              style: TextStyle(
                                color: mutedText,
                                fontSize: 14,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // STAT CARD
  // ─────────────────────────────────────────────
  Widget _statCard({
    required double width,
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cream,
          borderRadius: BorderRadius.circular(19),
          border: Border.all(
            color: creamDark,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: color,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  label,
                  style: const TextStyle(
                    color: mutedText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // ACTION CARD
  // ─────────────────────────────────────────────
  Widget _actionCard({
    required double width,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Ink(
            padding: const EdgeInsets.all(21),
            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: creamDark,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 57,
                  height: 57,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 29,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: darkText,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: mutedText,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: mutedText,
                  size: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  // LESSON CARD
  // ─────────────────────────────────────────────
  Widget _lessonCard({
    required String title,
    required String subtitle,
    required String language,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: cream,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: creamDark,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: navy.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: navy,
              size: 27,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: mutedText,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 7,
            ),
            decoration: BoxDecoration(
              color: terracotta.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              language,
              style: const TextStyle(
                color: terracotta,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  // TOOL CARD
  // ─────────────────────────────────────────────
  Widget _toolCard({
    required double width,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Ink(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: creamDark,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: darkText,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: mutedText,
                          fontSize: 12,
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