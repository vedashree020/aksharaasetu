import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final bool isHindi;

  const ForgotPasswordScreen({
    super.key,
    this.isHindi = false,
  });

  @override
  State<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends State<ForgotPasswordScreen> {
  final TextEditingController emailController =
      TextEditingController();

  bool isLoading = false;

  static const Color primaryColor =
      Color(0xFF7C5CFF);

  static const Color secondaryColor =
      Color(0xFF4F8CFF);

  static const Color backgroundColor =
      Color(0xFF080B18);

  static const Color cardColor =
      Color(0xFF111729);

  static const Color surfaceColor =
      Color(0xFF0D1222);

  static const Color borderColor =
      Color(0xFF252D45);

  static const Color textColor =
      Color(0xFFF8FAFC);

  static const Color mutedColor =
      Color(0xFFA7B0C0);

  bool _isValidEmail(String email) {
    return RegExp(
      r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
    ).hasMatch(email);
  }

  void _sendResetLink() {
    final email = emailController.text.trim();

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter a valid email address.',
          ),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (!mounted) return;

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Password reset link will be sent here.',
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 520,
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                      ),
                      color: textColor,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          primaryColor,
                          secondaryColor,
                        ],
                      ),
                      borderRadius:
                          BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withValues(
                            alpha: 0.25,
                          ),
                          blurRadius: 25,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.lock_reset_rounded,
                      color: Colors.white,
                      size: 42,
                    ),
                  ),

                  const SizedBox(height: 28),

                  Text(
                    widget.isHindi
                        ? 'पासवर्ड रीसेट करें'
                        : 'Reset your password',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.spaceGrotesk(
                      color: textColor,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    widget.isHindi
                        ? 'अपना ईमेल दर्ज करें और हम आपको पासवर्ड रीसेट लिंक भेजेंगे।'
                        : 'Enter your email and we will send you a password reset link.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: mutedColor,
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 34),

                  Container(
                    padding: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius:
                          BorderRadius.circular(28),
                      border: Border.all(
                        color: borderColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.isHindi
                              ? 'ईमेल पता'
                              : 'Email address',
                          style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const SizedBox(height: 10),

                        TextField(
                          controller: emailController,
                          keyboardType:
                              TextInputType.emailAddress,
                          style: GoogleFonts.poppins(
                            color: textColor,
                            fontSize: 17,
                          ),
                          decoration: InputDecoration(
                            hintText: 'you@example.com',
                            hintStyle:
                                GoogleFonts.poppins(
                              color: mutedColor,
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: mutedColor,
                            ),
                            filled: true,
                            fillColor: surfaceColor,
                            contentPadding:
                                const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(17),
                              borderSide:
                                  const BorderSide(
                                color: borderColor,
                              ),
                            ),
                            enabledBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(17),
                              borderSide:
                                  const BorderSide(
                                color: borderColor,
                              ),
                            ),
                            focusedBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(17),
                              borderSide:
                                  const BorderSide(
                                color: primaryColor,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : _sendResetLink,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  primaryColor,
                              foregroundColor:
                                  Colors.white,
                              elevation: 0,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(17),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    widget.isHindi
                                        ? 'रीसेट लिंक भेजें'
                                        : 'Send reset link',
                                    style:
                                        GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      size: 19,
                    ),
                    label: Text(
                      widget.isHindi
                          ? 'लॉगिन पर वापस जाएं'
                          : 'Back to login',
                      style: GoogleFonts.poppins(
                        color: primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.security_rounded,
                        size: 16,
                        color: mutedColor,
                      ),
                      const SizedBox(width: 7),
                      Text(
                        widget.isHindi
                            ? 'आपकी जानकारी सुरक्षित है'
                            : 'Your information is secure',
                        style: GoogleFonts.poppins(
                          color: mutedColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}