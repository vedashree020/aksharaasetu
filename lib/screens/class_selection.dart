import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../models/app_user.dart';
import 'subject_selection.dart';

class ClassSelection extends StatelessWidget {
  final AppUser user;

  const ClassSelection({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creamLight,

      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 76,
        titleSpacing: 24,
        title: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: gold.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: gold.withValues(alpha: 0.35),
                ),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color: gold,
                size: 25,
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
                    letterSpacing: 0.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Teacher Learning Space',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFD7DFE6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: navy,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        decoration: BoxDecoration(
                          color: cream,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(
                          Icons.school_rounded,
                          size: 32,
                          color: terracotta,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose a Class',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'Select a class to explore subjects and lessons.',
                              style: TextStyle(
                                color: Color(0xFFD7DFE6),
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                const Text(
                  'Available Classes',
                  style: TextStyle(
                    color: darkText,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Choose the class for the lesson you want to teach.',
                  style: TextStyle(
                    color: mutedText,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(height: 20),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: SampleData.classes.length,
                  gridDelegate:
                      const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 360,
                    mainAxisExtent: 180,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                  ),
                  itemBuilder: (context, index) {
                    final className = SampleData.classes[index];

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(22),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SubjectSelection(
                                user: user,
                                className: className,
                              ),
                            ),
                          );
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            color: cream,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: creamDark,
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: navy.withValues(alpha: 0.07),
                                blurRadius: 14,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(22),
                            child: Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: terracotta.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Icon(
                                    Icons.school_rounded,
                                    size: 32,
                                    color: terracotta,
                                  ),
                                ),

                                const SizedBox(width: 18),

                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        className,
                                        style: const TextStyle(
                                          color: darkText,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      const Text(
                                        'View subjects',
                                        style: TextStyle(
                                          color: mutedText,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 14),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 13,
                                          vertical: 7,
                                        ),
                                        decoration: BoxDecoration(
                                          color: terracotta,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Open',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 6),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ],
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
                  },
                ),

                const SizedBox(height: 28),

                // Bottom information card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0E5D4),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: creamDark,
                    ),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: terracotta,
                        size: 25,
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'Choose a class to continue to subjects and lesson translation.',
                          style: TextStyle(
                            color: darkText,
                            fontSize: 14,
                            height: 1.4,
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