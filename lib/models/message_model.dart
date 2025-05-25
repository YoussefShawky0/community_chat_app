import 'package:chat_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String message;
  final String id;
  final DateTime createdAt;

  Message({required this.message, required this.id, required this.createdAt});

  factory Message.fromJson(jsonData) {
    return Message(
      message: jsonData[kMessage] as String? ?? '',
      id: jsonData[kSenderId] as String? ?? '',
      createdAt: (jsonData[kCreatedAt] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
