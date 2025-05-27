import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SendMessageBox extends StatefulWidget {
  const SendMessageBox({
    super.key,
    required this.messages,
    required this.onMessageSent,
    required this.email,
  });
  final CollectionReference messages;
  final VoidCallback? onMessageSent;
  final String email;

  @override
  State<SendMessageBox> createState() => _SendMessageBoxState();
}

class _SendMessageBoxState extends State<SendMessageBox> {
  final TextEditingController _controller = TextEditingController();
  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.messages.add({
        kMessage: text,
        kCreatedAt: DateTime.now(),
        kSenderId: widget.email,
      });
      _controller.clear();
      widget.onMessageSent!.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        onSubmitted: (_) => _sendMessage(),
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send, color: kPrimaryColor),
          ),
          hintText: 'Type a message...',
          hintStyle: const TextStyle(color: kPrimaryColor, fontSize: 16),
          filled: true,
          fillColor: kSendBoxColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: kPrimaryColor),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }
}
