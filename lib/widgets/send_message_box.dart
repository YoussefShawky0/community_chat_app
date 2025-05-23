import 'package:chat_app/constants.dart';
import 'package:flutter/material.dart';

class SendMessageBox extends StatelessWidget {
  const SendMessageBox({super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.send, color: kPrimaryColor),
        ),
        hintText: 'Type a message...',
        hintStyle: const TextStyle(color: kPrimaryColor, fontSize: 16),
        filled: true,
        fillColor: kBackgroundColor,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      ),
    );
  }
}
