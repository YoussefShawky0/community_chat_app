import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/send_message_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const String id = 'HomePage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();
  final CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollection,
  );

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _scrollToLatestMessage() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients &&
          scrollController.position.maxScrollExtent > 0) {
        scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _extractUsername(String email) {
    if (email.contains('@')) {
      return email.split('@').first;
    }
    return email;
  }

  @override
  Widget build(BuildContext context) {
    final String? email = ModalRoute.of(context)?.settings.arguments as String?;

    if (email == null || email.isEmpty) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text(
                'Error: No user email found',
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              kLogo,
              width: 40,
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.chat, color: Colors.white, size: 40);
              },
            ),
            const SizedBox(width: 5),
            const Text(
              'Community Chat',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Pacifico',
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) {
              if (value == 'logout') {
                _showLogoutDialog(context);
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Logout'),
                      ],
                    ),
                  ),
                ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: messages.orderBy(kCreatedAt, descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading messages: ${snapshot.error}',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            );
          }

          List<Message> messageList = [];
          try {
            for (var doc in snapshot.data!.docs) {
              messageList.add(Message.fromJson(doc));
            }
          } catch (e) {
            return Center(
              child: Text(
                'Error parsing messages: $e',
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  kBackgroundImage,
                  fit: BoxFit.cover,
                  color: kPrimaryColor,
                  colorBlendMode: BlendMode.overlay,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: kPrimaryColor.withOpacity(0.1));
                  },
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      itemBuilder: (context, index) {
                        final message = messageList[index];
                        final isMyMessage = message.id == email;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment:
                                isMyMessage
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                            children: [
                              if (!isMyMessage && message.id.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    bottom: 4,
                                  ),
                                  child: Text(
                                    _extractUsername(message.id),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ChatBubble(
                                clipper: ChatBubbleClipper4(
                                  type:
                                      isMyMessage
                                          ? BubbleType.sendBubble
                                          : BubbleType.receiverBubble,
                                ),
                                alignment:
                                    isMyMessage
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                margin: EdgeInsets.only(
                                  left: isMyMessage ? 40 : 0,
                                  right: isMyMessage ? 0 : 40,
                                ),
                                backGroundColor:
                                    isMyMessage
                                        ? kPrimaryColor
                                        : Colors.grey[200]!,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  child: Text(
                                    message.message,
                                    style: TextStyle(
                                      color:
                                          isMyMessage
                                              ? Colors.white
                                              : Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SendMessageBox(
                    messages: messages,
                    onMessageSent: _scrollToLatestMessage,
                    email: email,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Logout', style: TextStyle(color: kPrimaryColor)),
            content: Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel', style: TextStyle(color: kPrimaryColor)),
              ),
              TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text('Logout', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
    );
  }
}
