import 'package:flutter/material.dart';

class CustomFormTextField extends StatefulWidget {
  const CustomFormTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.onChanged,
    this.controller,
    this.originalPasswordController,
  });

  final String? hintText;
  final String? labelText;
  final Function(String)? onChanged;
  final TextEditingController? controller;
  final TextEditingController? originalPasswordController;

  @override
  State<CustomFormTextField> createState() => _CustomFormTextFieldState();
}

class _CustomFormTextFieldState extends State<CustomFormTextField> {
  bool _obscureText = true;

  bool get isPasswordField =>
      widget.labelText?.toLowerCase().contains('password') ?? false;

  bool get isConfirmPasswordField =>
      widget.labelText?.toLowerCase() == 'confirm password';

  bool get isEmailField =>
      widget.labelText?.toLowerCase() == 'email';

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your ${widget.labelText?.toLowerCase() ?? 'field'}';
        }

        if (isEmailField && !_isValidEmail(value)) {
          return 'Please enter a valid email';
        }

        if (widget.labelText?.toLowerCase() == 'password') {
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
        }

        if (isConfirmPasswordField) {
          final originalPassword = widget.originalPasswordController?.text ?? '';
          if (value != originalPassword) {
            return 'Passwords do not match';
          }
        }

        return null;
      },
      onChanged: widget.onChanged,
      style: const TextStyle(color: Colors.white),
      obscureText: isPasswordField ? _obscureText : false,
      decoration: InputDecoration(
        label: Text(widget.labelText ?? ''),
        labelStyle: const TextStyle(color: Colors.white),
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        suffixIcon: isPasswordField
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }
}