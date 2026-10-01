import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_service.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() =>
      _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool isLoading = false;

  static const Color navy = Color(0xFF10263A);
  static const Color navyDark = Color(0xFF0A1A29);
  static const Color cream = Color(0xFFF4EBDD);
  static const Color creamLight = Color(0xFFFFF9F0);
  static const Color creamDark = Color(0xFFE8DCC9);
  static const Color terracotta = Color(0xFFC9683E);
  static const Color terracottaDark = Color(0xFFA94F2D);
  static const Color darkText = Color(0xFF172235);
  static const Color mutedText = Color(0xFF62645F);

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email);
  }

  Future<void> _createAccount() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty) {
      _showMessage('Please enter your email.');
      return;
    }

    if (!_isValidEmail(email)) {
      _showMessage(
        'Please enter a valid email address.',
      );
      return;
    }

    if (password.length < 6) {
      _showMessage(
        'Password must contain at least 6 characters.',
      );
      return;
    }

    if (password != confirmPassword) {
      _showMessage(
        'Passwords do not match.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await ApiService.register(
        name: email.split('@').first,
        email: email,
        password: password,
        role: 'teacher',
      );

      if (!mounted) return;

      _showMessage(
        'Account created successfully.',
        success: true,
      );

      await Future.delayed(
        const Duration(milliseconds: 700),
      );

      if (!mounted) return;

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      final message = e
          .toString()
          .replaceFirst('Exception: ', '');

      _showMessage(message);
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showMessage(
    String message, {
    bool success = false,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: success ? terracotta : navyDark,
        behavior: SnackBarBehavior.floating,
        content: Text(
          message,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _inputBorder({
    Color color = creamDark,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required bool obscure,
    required VoidCallback onToggle,
    required String hint,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.poppins(
        color: darkText,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(
          color: mutedText,
          fontSize: 15,
        ),
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: mutedText,
        ),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: mutedText,
          ),
        ),
        filled: true,
        fillColor: creamLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        border: _inputBorder(),
        enabledBorder: _inputBorder(),
        focusedBorder: _inputBorder(
          color: terracotta,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: GoogleFonts.poppins(
        color: darkText,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: 'Enter your email',
        hintStyle: GoogleFonts.poppins(
          color: mutedText,
          fontSize: 15,
        ),
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: mutedText,
        ),
        filled: true,
        fillColor: creamLight,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 20,
        ),
        border: _inputBorder(),
        enabledBorder: _inputBorder(),
        focusedBorder: _inputBorder(
          color: terracotta,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: darkText,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navy,
      appBar: AppBar(
        backgroundColor: navy,
        foregroundColor: cream,
        elevation: 0,
        title: Text(
          'Create Account',
          style: GoogleFonts.dmSerifDisplay(
            color: cream,
            fontSize: 25,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 600,
              ),
              child: Container(
                padding: const EdgeInsets.all(26),
                decoration: BoxDecoration(
                  color: cream,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.22),
                      blurRadius: 30,
                      offset: const Offset(0, 15),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: terracotta.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.person_add_alt_1_rounded,
                          color: terracotta,
                          size: 38,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    Center(
                      child: Text(
                        'Create your account',
                        style: GoogleFonts.dmSerifDisplay(
                          color: darkText,
                          fontSize: 30,
                        ),
                      ),
                    ),

                    const SizedBox(height: 7),

                    Center(
                      child: Text(
                        'Join AksharaaSetu and start learning.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          color: mutedText,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    _label('Email address'),

                    const SizedBox(height: 9),

                    _emailField(),

                    const SizedBox(height: 22),

                    _label('Password'),

                    const SizedBox(height: 9),

                    _passwordField(
                      controller: passwordController,
                      obscure: obscurePassword,
                      onToggle: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                      hint: 'Create a password',
                    ),

                    const SizedBox(height: 22),

                    _label('Confirm password'),

                    const SizedBox(height: 9),

                    _passwordField(
                      controller: confirmPasswordController,
                      obscure: obscureConfirmPassword,
                      onToggle: () {
                        setState(() {
                          obscureConfirmPassword =
                              !obscureConfirmPassword;
                        });
                      },
                      hint: 'Confirm your password',
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _createAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: terracotta,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              terracotta.withValues(alpha: 0.5),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                'Create Account',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    Center(
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () => Navigator.pop(context),
                        child: Text(
                          'Already have an account? Sign in',
                          style: GoogleFonts.poppins(
                            color: terracottaDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}