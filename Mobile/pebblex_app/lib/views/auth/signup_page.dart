import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pebblex_app/views/auth/login_page.dart';
import 'package:pebblex_app/views/home/main_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;
  bool _isLoading = false;
  late final TapGestureRecognizer _loginRecognizer;

  // Constants for better maintainability
  static const double _fieldWidth = 350;
  static const double _topSpacing = 70;
  static const double _logoSpacing = 40;
  static const double _fieldSpacing = 15;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _loginRecognizer = TapGestureRecognizer()..onTap = _navigateToLogin;
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _loginRecognizer.dispose();
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      //signup logic here
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User registered successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => MainPage()));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Signup failed: ${e.toString()}'),
          backgroundColor: Colors.red,
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: _topSpacing),
                //  Add your app logo here
                // Image.asset('assets/images/logo.png', height: 100),
                const SizedBox(height: _logoSpacing),

                Text(
                  'SIGN UP',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),

                const SizedBox(height: 32),

                //Username Input Field
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: _fieldWidth),
                  child: TextFormField(
                    controller: _usernameController,
                    textInputAction: TextInputAction.next,
                    enabled: !_isLoading,
                    validator: _validateName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      hintText: 'Enter Your Username',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                SizedBox(height: _fieldSpacing),

                //Email Input Field
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _fieldWidth),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !_isLoading,
                    validator: _validateEmail,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter Your Email',
                      prefixIcon: Icon(Icons.email_rounded),
                    ),
                  ),
                ),
                SizedBox(height: _fieldSpacing),

                //Password Input Field
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: _fieldWidth),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _isPasswordHidden,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                    enabled: !_isLoading,
                    validator: _validatePassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter Your Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isPasswordHidden = !_isPasswordHidden;
                          });
                        },
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: _fieldSpacing),

                //Confirm Password Input Field
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: _fieldWidth),
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _isConfirmPasswordHidden,
                    textInputAction: TextInputAction.done,
                    enabled: !_isLoading,
                    onFieldSubmitted: (_) => _handleSignup(),
                    validator: _validateConfirmPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                      hintText: 'Enter Your Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordHidden =
                                !_isConfirmPasswordHidden;
                          });
                        },
                        icon: Icon(
                          _isConfirmPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                //SignUp Button
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _fieldWidth),
                  child: SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade400,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        disabledBackgroundColor: Colors.grey.shade400,
                      ),
                      onPressed: _isLoading ? null : _handleSignup,
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: 24),

                //Navigation to Login
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: _fieldWidth),
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account?",
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _isLoading
                                ? Colors.grey
                                : Colors.red.shade400,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: _isLoading ? null : _loginRecognizer,
                        ),
                      ],
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

  //validate email fromat
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address';
    }
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  //validate Name format
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please Enter a Username';
    }
    return null;
  }

  //validate password requirements
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  //validate confirm password
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    // ✅ CORRECT: Use .text directly (already a String)
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
