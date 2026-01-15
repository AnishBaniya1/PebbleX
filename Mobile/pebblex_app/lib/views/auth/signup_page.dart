import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pebblex_app/providers/auth_provider.dart';
import 'package:pebblex_app/views/auth/login_page.dart';
import 'package:pebblex_app/views/auth/widgets/customtextfield.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;
  bool _isLoading = false;
  late final TapGestureRecognizer _loginRecognizer;
  late final TextEditingController _addressController;
  late final TextEditingController _phoneController;
  String? _selectedrole;

  final List<String> _userroles = ['supplier', 'vendor'];

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loginRecognizer = TapGestureRecognizer()..onTap = _navigateToLogin;
    _addressController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _loginRecognizer.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    final authProvider = context.read<AuthProvider>();

    try {
      await authProvider.register(
        name: _usernameController.text,
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: int.parse(_phoneController.text),
        address: _addressController.text,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('Account created successfully!'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(child: Text('Signup failed: ${e.toString()}')),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToLogin() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;

    // Responsive values
    final horizontalPadding = isSmallScreen ? 24.0 : size.width * 0.1;
    final fieldWidth = isSmallScreen ? double.infinity : 450.0;
    final cardPadding = isSmallScreen ? 24.0 : 32.0;
    final iconSize = isSmallScreen ? 40.0 : (isTablet ? 45.0 : 50.0);
    final iconPadding = isSmallScreen ? 12.0 : 16.0;
    final titleSize = isSmallScreen ? 26.0 : (isTablet ? 28.0 : 32.0);
    final subtitleSize = isSmallScreen ? 14.0 : 15.0;
    final linkFontSize = isSmallScreen ? 16.0 : 17.0;

    // Spacing
    final headerSpacing = size.height * 0.025;
    final fieldSpacing = isSmallScreen ? 14.0 : 16.0;
    final sectionSpacing = isSmallScreen ? 20.0 : 24.0;
    final buttonHeight = isSmallScreen ? 52.0 : 56.0;

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
                vertical: 24,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header Icon
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
                      Icons.person_add_rounded,
                      size: iconSize,
                      color: Colors.blue.shade700,
                    ),
                  ),
                  SizedBox(height: headerSpacing),

                  // Title
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: titleSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 8),

                  // Subtitle
                  Text(
                    'Sign up to get started',
                    style: TextStyle(
                      fontSize: subtitleSize,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                  SizedBox(height: size.height * 0.04),

                  // Form Card
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
                          // Username Field
                          CustomTextField(
                            controller: _usernameController,
                            label: 'Username',
                            hint: 'Enter your username',
                            icon: Icons.person_outline,
                            validator: _validateName,
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: fieldSpacing),

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
                            textInputAction: TextInputAction.next,
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
                          SizedBox(height: fieldSpacing),

                          // Phone Field
                          CustomTextField(
                            controller: _phoneController,
                            label: 'Phone Number',
                            hint: 'Enter your phone number',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter phone number';
                              }
                              if (value.length < 10) {
                                return 'Enter valid phone number';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: fieldSpacing),

                          // Address Field
                          CustomTextField(
                            controller: _addressController,
                            label: 'Address',
                            hint: 'Enter your address',
                            icon: Icons.location_on_outlined,
                            maxLines: 2,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter address';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.done,
                          ),
                          SizedBox(height: sectionSpacing),

                          // Sign Up Button
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
                                      : _handleSignup,
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
                                          'SIGN UP',
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
                  SizedBox(height: size.height * 0.03),

                  // Login Link
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: TextStyle(
                            fontSize: linkFontSize,
                            color: Colors.white,
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                fontSize: linkFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: authProvider.isLoading
                                  ? null
                                  : _loginRecognizer,
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

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter a Username';
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
