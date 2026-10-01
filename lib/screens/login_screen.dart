import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/app_user.dart';
import 'admin_dashboard.dart';
import 'create_account_screen.dart';
import 'forgot_password_screen.dart';
import 'teacher_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  bool isHindi = false;

  UserRole selectedRole = UserRole.teacher;

  final Color navy = const Color(0xFF10263A);
  final Color cream = const Color(0xFFF4EBDD);
  final Color terracotta = const Color(0xFFC9683E);
  final Color gold = const Color(0xFFD9A84E);
  final Color darkText = const Color(0xFF172235);
  final Color mutedText = const Color(0xFF62645F);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage(
        isHindi
            ? 'कृपया ईमेल और पासवर्ड दर्ज करें।'
            : 'Please enter your email and password.',
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showMessage(
        isHindi
            ? 'कृपया सही ईमेल दर्ज करें।'
            : 'Please enter a valid email address.',
      );
      return;
    }

    if (password.length < 6) {
      _showMessage(
        isHindi
            ? 'पासवर्ड कम से कम 6 अक्षरों का होना चाहिए।'
            : 'Password must contain at least 6 characters.',
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Temporary local login.
    // Real backend email/password verification will be connected later.
    await Future.delayed(
      const Duration(milliseconds: 600),
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    final user = AppUser(
      name: email.split('@').first,
      role: selectedRole,
    );

    if (selectedRole == UserRole.admin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AdminDashboard(user: user),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => TeacherDashboard(user: user),
        ),
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: navy,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openCreateAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CreateAccountScreen(),
      ),
    );
  }

  void _openForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ForgotPasswordScreen(),
      ),
    );
  }

  Widget _buildLanguageSwitch() {
    return Align(
      alignment: Alignment.topRight,
      child: TextButton.icon(
        onPressed: () {
          setState(() {
            isHindi = !isHindi;
          });
        },
        icon: Icon(
          Icons.language,
          color: navy,
          size: 19,
        ),
        label: Text(
          isHindi ? 'English' : 'हिन्दी',
          style: GoogleFonts.poppins(
            color: navy,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildBrand() {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: navy,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: navy.withValues(alpha: 0.18),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.menu_book_rounded,
            color: gold,
            size: 40,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'AksharaaSetu',
          style: GoogleFonts.playfairDisplay(
            color: navy,
            fontSize: 31,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isHindi
              ? 'मातृभाषा से सीखने का पुल'
              : 'A bridge to learning through mother tongue',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: mutedText,
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRoleSection(bool tablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isHindi ? 'उपयोगकर्ता प्रकार' : 'User type',
          style: GoogleFonts.poppins(
            color: darkText,
            fontSize: tablet ? 15 : 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _roleCard(
                role: UserRole.teacher,
                icon: Icons.school_rounded,
                title: isHindi ? 'शिक्षक' : 'Teacher',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _roleCard(
                role: UserRole.admin,
                icon: Icons.admin_panel_settings_rounded,
                title: isHindi ? 'व्यवस्थापक' : 'Admin',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _roleCard({
    required UserRole role,
    required IconData icon,
    required String title,
  }) {
    final selected = selectedRole == role;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        decoration: BoxDecoration(
          color: selected
              ? terracotta.withValues(alpha: 0.10)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? terracotta : Colors.black12,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: selected ? terracotta : mutedText,
              size: 23,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  color: selected ? terracotta : darkText,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_circle_rounded,
                color: terracotta,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool password = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: darkText,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: password ? _obscurePassword : false,
          keyboardType: password
              ? TextInputType.text
              : TextInputType.emailAddress,
          style: GoogleFonts.poppins(
            color: darkText,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(
              color: mutedText.withValues(alpha: 0.65),
              fontSize: 13,
            ),
            prefixIcon: Icon(
              icon,
              color: navy,
              size: 21,
            ),
            suffixIcon: password
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: mutedText,
                    ),
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.black.withValues(alpha: 0.08),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: terracotta,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _signIn,
        style: ElevatedButton.styleFrom(
          backgroundColor: navy,
          foregroundColor: Colors.white,
          disabledBackgroundColor: navy.withValues(alpha: 0.55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isHindi ? 'लॉगिन करें' : 'Sign in',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 9),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 20,
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.black.withValues(alpha: 0.10),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                isHindi ? 'या' : 'OR',
                style: GoogleFonts.poppins(
                  color: mutedText,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.black.withValues(alpha: 0.10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: OutlinedButton(
            onPressed: _openCreateAccount,
            style: OutlinedButton.styleFrom(
              foregroundColor: terracotta,
              side: BorderSide(
                color: terracotta.withValues(alpha: 0.7),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.person_add_alt_1_rounded,
                  size: 20,
                ),
                const SizedBox(width: 9),
                Text(
                  isHindi
                      ? 'नया खाता बनाएं'
                      : 'Create a new account',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForm(bool tablet) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        maxWidth: 520,
      ),
      padding: EdgeInsets.all(tablet ? 32 : 22),
      decoration: BoxDecoration(
        color: cream.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: navy.withValues(alpha: 0.10),
            blurRadius: 30,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isHindi ? 'स्वागत है' : 'Welcome back',
            style: GoogleFonts.playfairDisplay(
              color: navy,
              fontSize: tablet ? 29 : 25,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isHindi
                ? 'अपने AksharaaSetu खाते में प्रवेश करें।'
                : 'Sign in to continue your AksharaaSetu journey.',
            style: GoogleFonts.poppins(
              color: mutedText,
              fontSize: 12.5,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          _buildRoleSection(tablet),

          const SizedBox(height: 22),

          _buildInput(
            label: isHindi ? 'ईमेल' : 'Email',
            hint: isHindi ? 'अपना ईमेल दर्ज करें' : 'Enter your email',
            controller: _emailController,
            icon: Icons.email_outlined,
          ),

          const SizedBox(height: 17),

          _buildInput(
            label: isHindi ? 'पासवर्ड' : 'Password',
            hint: isHindi ? 'अपना पासवर्ड दर्ज करें' : 'Enter your password',
            controller: _passwordController,
            icon: Icons.lock_outline_rounded,
            password: true,
          ),

          const SizedBox(height: 8),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _openForgotPassword,
              child: Text(
                isHindi ? 'पासवर्ड भूल गए?' : 'Forgot password?',
                style: GoogleFonts.poppins(
                  color: terracotta,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          const SizedBox(height: 7),

          _buildLoginButton(),

          _buildCreateAccountButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final tablet = constraints.maxWidth >= 700;
            final wide = constraints.maxWidth >= 1050;

            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: tablet ? 42 : 20,
                  vertical: tablet ? 28 : 18,
                ),
                child: Column(
                  children: [
                    _buildLanguageSwitch(),

                    SizedBox(
                      height: tablet ? 18 : 8,
                    ),

                    if (wide)
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 1100,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: _buildBrand(),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: _buildForm(tablet),
                            ),
                          ],
                        ),
                      )
                    else
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 620,
                        ),
                        child: Column(
                          children: [
                            _buildBrand(),
                            const SizedBox(height: 30),
                            _buildForm(tablet),
                          ],
                        ),
                      ),

                    const SizedBox(height: 28),

                    Text(
                      isHindi
                          ? 'AksharaaSetu • मातृभाषा आधारित शिक्षा'
                          : 'AksharaaSetu • Mother-tongue based learning',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: mutedText,
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}