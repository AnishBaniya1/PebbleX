import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pebblex_app/providers/auth_provider.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int maxLines;
  final bool obscureText;
  final Widget? suffixIcon;
  final VoidCallback? onFieldSubmitted;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.maxLines = 1,
    this.obscureText = false,
    this.suffixIcon,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    final isTablet = size.width >= 600 && size.width < 1024;

    // Responsive values
    final fontSize = isSmallScreen ? 14.0 : (isTablet ? 15.0 : 16.0);
    final iconSize = isSmallScreen ? 20.0 : (isTablet ? 22.0 : 24.0);
    final borderRadius = isSmallScreen ? 10.0 : 12.0;
    final horizontalPadding = isSmallScreen ? 12.0 : 16.0;
    final verticalPadding = isSmallScreen ? 14.0 : 18.0;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return TextFormField(
          controller: controller,
          enabled: !authProvider.isLoading,
          validator: validator,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          maxLines: maxLines,
          obscureText: obscureText,
          onFieldSubmitted: onFieldSubmitted != null
              ? (_) => onFieldSubmitted!()
              : null,
          style: TextStyle(fontSize: fontSize),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontSize: fontSize),
            hintText: hint,
            hintStyle: TextStyle(fontSize: fontSize - 1),
            prefixIcon: Icon(icon, color: Colors.blue.shade700, size: iconSize),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: Colors.blue.shade700,
                width: isSmallScreen ? 1.5 : 2.0,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: Colors.red.shade400),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: Colors.red.shade400,
                width: isSmallScreen ? 1.5 : 2.0,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
          ),
        );
      },
    );
  }
}
