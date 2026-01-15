import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pebblex_app/providers/auth_provider.dart';
import 'package:pebblex_app/views/auth/signup_page.dart';
import 'package:pebblex_app/views/home/main_page.dart';
import 'package:pebblex_app/views/auth/widgets/customtextfield.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;
  late final TapGestureRecognizer _signUpRecognizer;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _signUpRecognizer = TapGestureRecognizer()..onTap = _navigateToSignUp;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _signUpRecognizer.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    final authProvider = context.read<AuthProvider>();

    try {
      await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login Successful'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login failed: ${authProvider.errorMessage ?? e.toString()}',
          ),
          backgroundColor: Colors.red,
        ),
      );
      log(authProvider.errorMessage ?? "");
    }
  }

  void _navigateToForgotPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Forgot Password - Coming Soon')),
    );
  }

  void _navigateToSignUp() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignupPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;

    // Responsive values
    final horizontalPadding = isSmallScreen ? 24.0 : size.width * 0.1;
    final verticalPadding = isSmallScreen ? 8.0 : 24.0;
    final fieldWidth = isSmallScreen ? double.infinity : 450.0;
    final cardPadding = isSmallScreen ? 24.0 : 32.0;
    final iconSize = isSmallScreen ? 50.0 : (isTablet ? 60.0 : 70.0);
    final iconPadding = isSmallScreen ? 16.0 : 20.0;
    final titleSize = isSmallScreen ? 28.0 : (isTablet ? 32.0 : 36.0);
    final subtitleSize = isSmallScreen ? 15.0 : 17.0;
    final linkFontSize = isSmallScreen ? 16.0 : 17.0;

    // Spacing
    final headerSpacing = size.height * 0.03;
    final subtitleSpacing = isSmallScreen ? 6.0 : 8.0;
    final fieldSpacing = isSmallScreen ? 18.0 : 20.0;
    final forgotPasswordSpacing = isSmallScreen ? 10.0 : 12.0;
    final buttonSpacing = isSmallScreen ? 20.0 : 24.0;
    final buttonHeight = isSmallScreen ? 52.0 : 56.0;
    final sectionSpacing = size.height * 0.04;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade700,
              Colors.blue.shade400,
              Colors.lightBlue.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Icon Section
                  Container(
                    padding: EdgeInsets.all(iconPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.lock_outline_rounded,
                      size: iconSize,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  SizedBox(height: headerSpacing),

                  // Welcome Text
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: subtitleSpacing),
                  Text(
                    'Sign in to continue',
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  SizedBox(height: sectionSpacing),

                  // Login Form Card
                  Container(
                    constraints: BoxConstraints(maxWidth: fieldWidth),
                    padding: EdgeInsets.all(cardPadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 30,
                          offset: Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Email Field
                          CustomTextField(
                            controller: _emailController,
                            label: 'Email',
                            hint: 'Enter your email',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: _validateEmail,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: fieldSpacing),

                          // Password Field
                          CustomTextField(
                            controller: _passwordController,
                            label: 'Password',
                            hint: 'Enter your password',
                            icon: Icons.lock_outline,
                            obscureText: _isPasswordHidden,
                            validator: _validatePassword,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: _handleLogin,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordHidden = !_isPasswordHidden;
                                });
                              },
                              icon: Icon(
                                _isPasswordHidden
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                          SizedBox(height: forgotPasswordSpacing),

                          // Forgot Password
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: authProvider.isLoading
                                      ? null
                                      : _navigateToForgotPassword,
                                  child: Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      fontSize: subtitleSize - 1,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(height: buttonSpacing),

                          // Login Button
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, child) {
                              return SizedBox(
                                height: buttonHeight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade700,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 4,
                                    shadowColor: Colors.blue.shade700
                                        .withValues(alpha: 0.5),
                                    disabledBackgroundColor:
                                        Colors.grey.shade400,
                                  ),
                                  onPressed: authProvider.isLoading
                                      ? null
                                      : _handleLogin,
                                  child: authProvider.isLoading
                                      ? SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2.5,
                                          ),
                                        )
                                      : Text(
                                          'LOGIN',
                                          style: TextStyle(
                                            fontSize: isSmallScreen ? 16 : 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 1.2,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: headerSpacing),

                  // Sign Up Link
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(
                            fontSize: linkFontSize,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                fontSize: linkFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: authProvider.isLoading
                                  ? null
                                  : _signUpRecognizer,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }
}
