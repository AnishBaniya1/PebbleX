import 'package:flutter/material.dart';
import 'package:pebblex_app/providers/auth_provider.dart';
import 'package:pebblex_app/providers/cart_provider.dart';
import 'package:pebblex_app/providers/product_provider.dart';
import 'package:pebblex_app/splash_page.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(debugShowCheckedModeBanner: false, home: SplashPage()),
    );
  }
}
