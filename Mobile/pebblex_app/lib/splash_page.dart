import 'package:flutter/material.dart';
import 'package:pebblex_app/core/resources/resource.dart';
import 'package:pebblex_app/core/services/secure_storage.dart';
import 'package:pebblex_app/views/auth/login_page.dart';
import 'package:pebblex_app/views/home/main_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final SecureStorageService _storageService = SecureStorageService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    final String? isLoggedIn = await _storageService.readValue('islogin');

    if (isLoggedIn == 'true') {
      if (!mounted) return;
      // if (role == 'ADMIN') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainPage()),
      );
      // } else if (role == 'USER') {
      //   Navigator.of(context).pushReplacement(
      //     MaterialPageRoute(builder: (context) => const UserMainpage()),
      //   );
      // } else {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Invalid user role'),
      //       backgroundColor: Colors.red,
      //     ),
      //   );
      // }
    } else {
      // User not logged in, navigate to login
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AppImage.splashImg, height: 180),

              SizedBox(height: 10),
              const SizedBox(height: 30),
              CircularProgressIndicator(color: Colors.black),
            ],
          ),
        ),
      ),
    );
  }
}
