import 'package:flutter/material.dart';
import 'package:pebblex_app/views/home/main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //// Controllers for managing text input fields
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  //// Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // // State variables for UI behavior
  bool _isPasswordHidden = true; //Toggle password visibility.
  bool _isLoading = false; //Show loading spinner while login is processing.

  // Constants for better maintainability
  static const double _fieldWidth = 350;
  static const double _topSpacing = 70;
  static const double _logoSpacing = 40;
  static const double _fieldSpacing = 15;

  @override
  //Initializes controllers when the widget is created.
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  //Frees up memory by disposing controllers when widget is removed.
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Validate all form fields
    //_formKey.currentState - Accesses the current state of the Form widget
    //.validate() - Runs all validator functions in the form (calls _validateEmail and _validatePassword)
    if (!_formKey.currentState!.validate()) return;

    // Unfocus keyboard
    FocusScope.of(context).unfocus();
    //Show loading state
    setState(() => _isLoading = true);

    try {
      // TODO: Implement actual authentication logic here
      /*
      final response = await _firebaseService.login(
        emailAddress: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Check if widget is still mounted and authentication succeeded
      if (!mounted) return;

      if (response != null && response.user != null) {
        // Step 5: Retrieve and save user session
        await _sessionController.getUser();
        final savedName = SessionController.user?.name;
        
        // Create user model with authenticated data
        final userModel = UserModel(
          id: response.user?.uid,
          name: savedName,
          email: response.user?.email,
        );
        
        // Save user to session/local storage
        await _sessionController.saveUser(userModel);

        // Check mounted again before navigation
        if (!mounted) return;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login Successful'),
            backgroundColor: Colors.green,
          ),
        );

        // Step 6: Navigate to main page
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        // Handle case where response is null or user is null
        throw Exception('Authentication failed - Invalid credentials');
      }
      */

      await Future.delayed(const Duration(seconds: 2)); // Simulated API call

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      //// Always reset loading state
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  //// Navigate to forgot password page
  void _navigateToForgotPassword() {
    // TODO: Implement navigation to forgot password page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Forgot Password - Coming Soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //// SafeArea prevents overlap with system UI
      body: SafeArea(
        //prevents overflow
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            //Wraps input fields for validation.
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: _topSpacing),
                // TODO: Add your app logo here
                // Image.asset('assets/images/logo.png', height: 100),
                const SizedBox(height: _logoSpacing),

                Text(
                  'LOGIN',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                // Email Input Field
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _fieldWidth),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !_isLoading,
                    validator: _validateEmail,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                      hintText: 'Enter Your Email',
                      prefixIcon: Icon(Icons.email_rounded),
                    ),
                  ),
                ),
                const SizedBox(height: _fieldSpacing),

                // Password Input Field
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _fieldWidth),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _isPasswordHidden,
                    textInputAction: TextInputAction.done,
                    // is a property of TextFormField that controls whether the user can interact with the input field
                    enabled: !_isLoading,
                    //onFieldSubmitted is a callback function that gets triggered when the user presses the action button on the keyboard (in this case, the "Done" button).
                    onFieldSubmitted: (_) => _handleLogin(),
                    validator: _validatePassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
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
                const SizedBox(height: 16),

                // Forgot Password
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _fieldWidth),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: _isLoading ? null : _navigateToForgotPassword,
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Login Button
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _fieldWidth),
                  child: SizedBox(
                    width: double.infinity,
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
                      onPressed: _isLoading ? null : _handleLogin,
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
                              'LOGIN',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Sign Up Link (Optional)
                // TextButton(
                //   onPressed: _isLoading ? null : _navigateToSignUp,
                //   child: const Text("Don't have an account? Sign Up"),
                // ),
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
}
