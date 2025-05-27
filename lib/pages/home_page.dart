import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/send_message_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  static const String id = 'HomePage';

  final CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToLatestMessage() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? email = ModalRoute.of(context)?.settings.arguments as String?;
    return StreamBuilder<QuerySnapshot>(
      stream: widget.messages.orderBy(kCreatedAt, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messageList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messageList.add(Message.fromJson(snapshot.data!.docs[i]));
          }

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              title: Center(
                child: Row(
                  children: [
                    Image.asset(kLogo, width: 50, height: 50),
                    const SizedBox(width: 5),
                    const Text(
                      'Community Chat',
                      style: TextStyle(
                        fontSize: 22,
                        fontFamily: 'Pacifico',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              backgroundColor: kPrimaryColor,
            ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    kBackgroundImage,
                    fit: BoxFit.cover,
                    color: kPrimaryColor,
                    colorBlendMode: BlendMode.overlay,
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: messageList.length,
                        reverse: true,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          if (messageList[index].id == email) {
                            return ChatBubble(
                              clipper: ChatBubbleClipper4(
                                type: BubbleType.sendBubble,
                              ),
                              alignment: Alignment.centerRight,
                              margin: const EdgeInsets.only(top: 10, right: 5),
                              backGroundColor: kPrimaryColor,
                              child: Text(
                                messageList[index].message,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            );
                          } else {
                            return ChatBubble(
                              clipper: ChatBubbleClipper4(
                                type: BubbleType.receiverBubble,
                              ),
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(top: 10, left: 5),
                              backGroundColor: kBackgroundColor,
                              child: Text(
                                messageList[index].message,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                                textDirection: TextDirection.ltr,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    SendMessageBox(
                      messages: widget.messages,
                      onMessageSent: _scrollToLatestMessage,
                      email: email ?? '',
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          );
        } else {
          return const Center(child: Text("something went wrong"));
        }
      },
    );
  }
}
