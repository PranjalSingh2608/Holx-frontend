import 'package:flutter/material.dart';
import 'package:holx/screens/chat_screen.dart';

import '../models/ChatUserProduct.dart';

class ChatThread extends StatelessWidget {
  final List<ChatUserProduct> chatUserProducts;

  const ChatThread({required this.chatUserProducts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Received Chats'),
        backgroundColor: Color(0xff3EB489),
      ),
      body: ListView.builder(
        itemCount: chatUserProducts.length,
        itemBuilder: (context, index) {
          final chat = chatUserProducts[index];
          return Card(
            color: Color(0xffe5ffea),
            elevation: 4,
            margin: EdgeInsets.fromLTRB(15, 15, 15, 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiver: chat.sender_id,
                      prodId: chat.product_id,
                      // prodName: chat.product_name,
                      // receiverName: chat.sender_name,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Product: ${chat.product_id}'),
                    Text('Sender ID: ${chat.sender_id}'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
