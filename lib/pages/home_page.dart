import 'package:chat_app/constants.dart';
import 'package:chat_app/widgets/send_message_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String id = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(kLogo, width: 30, height: 30),
            const SizedBox(width: 10),
            const Text(
              'Scholar Chat',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Pacifico',
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) {
                return ChatBubble(
                  clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
                  alignment: Alignment.topLeft,
                  margin: const EdgeInsets.only(top: 20, right: 50, left: 5),
                  backGroundColor: kBackgroundColor,
                  child: const Text(
                    "Kapkan, I'm fine. How about you? What are you doing today? Are you free to meet up? I have some questions to ask you about the project.",
                    style: TextStyle(color: Colors.black),
                  ),
                );
              },
            ),
          ),
          SendMessageBox(),
        ],
      ),
    );
  }
}

