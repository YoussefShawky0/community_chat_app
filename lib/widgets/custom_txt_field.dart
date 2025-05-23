import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  const CustomFormTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.onChanged,
  });
  final String? hintText;
  final String? labelText;
  final Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
      onChanged: onChanged,
      style: TextStyle(color: Colors.white),
      obscureText: labelText == 'Password' ? true : false,
      decoration: InputDecoration(
        label: Text(labelText ?? ''),
        labelStyle: TextStyle(color: Colors.white),
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}
