import 'package:flutter/material.dart';

class UploadLessonScreen extends StatefulWidget {
  const UploadLessonScreen({super.key});

  @override
  State<UploadLessonScreen> createState() => _UploadLessonScreenState();
}

class _UploadLessonScreenState extends State<UploadLessonScreen> {
  static const Color navy = Color(0xFF10263A);
  static const Color cream = Color(0xFFF4EBDD);
  static const Color creamLight = Color(0xFFFFF9F0);
  static const Color creamDark = Color(0xFFE8DCC9);
  static const Color terracotta = Color(0xFFC9683E);
  static const Color gold = Color(0xFFD9A84E);
  static const Color darkText = Color(0xFF172235);
  static const Color mutedText = Color(0xFF62645F);

  String? selectedClass;
  String? selectedSubject;
  String? selectedFileName;

  final List<String> classes = [
    'Class 1',
    'Class 2',
    'Class 3',
    'Class 4',
    'Class 5',
  ];

  final List<String> subjects = [
    'Mathematics',
    'Environmental Studies',
    'Hindi',
    'English',
  ];

  void _choosePdf() {
    // Demo file picker.
    // Real PDF picker/backend integration will be connected later.
    setState(() {
      selectedFileName = 'sample_lesson.pdf';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Demo PDF selected.'),
        backgroundColor: terracotta,
      ),
    );
  }

  void _uploadLesson() {
    if (selectedFileName == null) {
      _showMessage('Please select a PDF lesson first.');
      return;
    }

    if (selectedClass == null) {
      _showMessage('Please select a class.');
      return;
    }

    if (selectedSubject == null) {
      _showMessage('Please select a subject.');
      return;
    }

    _showMessage(
      'Lesson uploaded successfully. PDF processing will be connected next.',
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: terracotta,
      ),
    );
  }

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
        title: const Row(
          children: [
            Icon(
              Icons.menu_book_rounded,
              color: gold,
              size: 28,
            ),
            SizedBox(width: 12),
            Text(
              'Upload Lesson',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
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
                  child: const Row(
                    children: [
                      Icon(
                        Icons.picture_as_pdf_rounded,
                        color: gold,
                        size: 46,
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Upload a Lesson PDF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Upload your current lesson or syllabus for translation and learning preparation.',
                              style: TextStyle(
                                color: Color(0xFFD7DFE6),
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 26),

                // PDF upload area
                InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: _choosePdf,
                  child: Ink(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: cream,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: selectedFileName == null
                            ? creamDark
                            : terracotta,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            color: terracotta.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Icon(
                            Icons.upload_file_rounded,
                            size: 40,
                            color: terracotta,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Text(
                          selectedFileName ?? 'Select your lesson PDF',
                          style: const TextStyle(
                            color: darkText,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 7),

                        Text(
                          selectedFileName == null
                              ? 'Tap here to choose a PDF from your device'
                              : 'PDF selected successfully',
                          style: const TextStyle(
                            color: mutedText,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 18),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 11,
                          ),
                          decoration: BoxDecoration(
                            color: terracotta,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.folder_open_rounded,
                                color: Colors.white,
                                size: 19,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Choose PDF',
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
                  ),
                ),

                const SizedBox(height: 26),

                // Class and subject
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: cream,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: creamDark,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Lesson Details',
                        style: TextStyle(
                          color: darkText,
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 20),

                      DropdownButtonFormField<String>(
                        initialValue: selectedClass,
                        decoration: InputDecoration(
                          labelText: 'Select Class',
                          prefixIcon: const Icon(
                            Icons.school_rounded,
                            color: terracotta,
                          ),
                          filled: true,
                          fillColor: creamLight,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: creamDark,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: creamDark,
                            ),
                          ),
                        ),
                        items: classes.map((className) {
                          return DropdownMenuItem(
                            value: className,
                            child: Text(className),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedClass = value;
                          });
                        },
                      ),

                      const SizedBox(height: 18),

                      DropdownButtonFormField<String>(
                        initialValue: selectedSubject,
                        decoration: InputDecoration(
                          labelText: 'Select Subject',
                          prefixIcon: const Icon(
                            Icons.menu_book_rounded,
                            color: terracotta,
                          ),
                          filled: true,
                          fillColor: creamLight,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: creamDark,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: creamDark,
                            ),
                          ),
                        ),
                        items: subjects.map((subject) {
                          return DropdownMenuItem(
                            value: subject,
                            child: Text(subject),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedSubject = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // Processing information
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0E5D4),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: creamDark,
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: gold,
                        size: 25,
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'AksharaaSetu will process the lesson and prepare its content for Hindi ↔ Santali translation, audio generation and offline learning.',
                          style: TextStyle(
                            color: darkText,
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Upload button
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton.icon(
                    onPressed: _uploadLesson,
                    icon: const Icon(
                      Icons.cloud_upload_rounded,
                    ),
                    label: const Text(
                      'Upload & Prepare Lesson',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: terracotta,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
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