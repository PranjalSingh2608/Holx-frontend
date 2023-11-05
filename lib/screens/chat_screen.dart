import 'dart:convert';
// import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:holx/models/Chat.dart';
// import 'package:intl/intl.dart';

import '../utils/http.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  final int receiver, prodId;
  const ChatPage({required this.receiver, required this.prodId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late Future<List<ChatMessage>> chatmessages;
  final authService = AuthService();
  late Future<List<ChatMessage>> chatmessagesowner;
  List<ChatMessage> allMessages = [];
  TextEditingController messageController = TextEditingController();
  late int ID;
  @override
  void initState() {
    super.initState();
    loadSenderIdFromSharedPreferences();
  }

  void loadSenderIdFromSharedPreferences() async {
    final authService = AuthService();
    final id = await authService.getId();
    print("sender id");
    print(id);
    if (id != null) {
      final senderId = int.parse(id);
      setState(() {
        ID = int.parse(id);
        chatmessages =
            fetchChatMessages(widget.prodId, senderId, widget.receiver);
        chatmessagesowner =
            fetchChatMessages(widget.prodId, widget.receiver, senderId);
      });

      chatmessages.then((toOwner) {
        chatmessagesowner.then((fromOwner) {
          setState(() {
            allMessages = [...toOwner, ...fromOwner];
            allMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
          });
        });
      });
    }
  }
  // IO.Socket? socket;
  // @override
  // void initState() {
  //   super.initState();
  //   connect();
  // }

  // void connect() {
  //   socket = IO.io("ws://127.0.0.1:8000/ws/chat/", <String, dynamic>{
  //     "transports": ["websocket"],
  //     "autoconnect": false,
  //   });
  //   socket?.onConnect((data) {
  //     print("Connected");
  //   });
  //   socket?.onConnectError((error) {
  //     print("Connection Error: $error");
  //   });
  //   socket?.connect();
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(widget.receiver.toString()),
        backgroundColor: Color(0xff3EB489),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: allMessages.length,
              itemBuilder: (context, index) {
                final message = allMessages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildMessage(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isSentByUser = (message.sender == ID);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 15, 10),
      child: Wrap(
        alignment: isSentByUser ? WrapAlignment.end : WrapAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
              color: isSentByUser ? Color(0xffe5ffea) : Color(0xffE4E6EB),
              borderRadius: isSentByUser
                  ? BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0),
                      bottomRight: Radius.circular(0.0),
                    )
                  : BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                      bottomLeft: Radius.circular(0.0),
                      bottomRight: Radius.circular(12.0),
                    ),
              border: Border.all(
                color: Colors.black, // Set the outline color here
                width: 1.0, // Set the outline width
              ),
            ),
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.sender.toString(),
                  textScaleFactor: 1.1,
                  style: TextStyle(
                      color: Colors.black.withOpacity(0.5), 
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                ),
                Text(
                  message.message,
                  textScaleFactor: 1.1,
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    message.timestamp.hour.toString() +
                        ':' +
                        message.timestamp.minute
                            .toString(), 
                    style: TextStyle(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
        border: Border.all(
          color: Color(0xff3EB489),
        ),
      ),
      margin: EdgeInsets.all(8), // Add margin to create spacing
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: InputDecoration.collapsed(
                hintText: 'Type a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _sendMessage();
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    print("sender id");
    print(ID);
    final token = await authService.getToken();
    final messageText = messageController.text.trim();
    if (messageText.isNotEmpty) {
      final receiverId = widget.receiver;

      final newMessage = {
        'sender': ID,
        'receiver': receiverId,
        'product': widget.prodId,
        'message': messageText,
        'timestamp': DateTime.now().toString(),
      };

      try {
        final response = await http.post(
          Uri.parse('https://holx-qmve.onrender.com/chat/create/'),
          headers: {
            'Authorization': 'Token $token',
            'Content-Type': 'application/json',
          },
          body: jsonEncode(newMessage),
        );
        print(widget.prodId);
        print(widget.receiver);
        if (response.statusCode == 201) {
          setState(() {
            chatmessages = fetchChatMessages(widget.prodId, ID, receiverId);
            messageController.clear();
          });
        } else {
          throw Exception('Failed to send message');
        }
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }
}
