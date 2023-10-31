import 'dart:convert';
import 'package:holx/models/Products.dart';
import 'package:http/http.dart' as http;

import '../models/Chat.dart';

Future<List<Product>> fetchProducts() async {
  final response = await http.get(
    Uri.parse("https://holx-qmve.onrender.com/application/product/"),
    headers: {
      'Authorization': 'Token f4eec197591f21724719f6454f8dbef94d25b815',
    },
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> results = data as List;
    print(results);

    return results
        .map((result) => Product(
              result['id'],
              result['name'],
              result['address'],
              result['description'],
              result['image'] ?? "",
              result['phone'],
              result['price'],
              result['user'],
            ))
        .toList();
  } else {
    throw Exception('Failed to load posts');
  }
}

Future<List<ChatMessage>> fetchChatMessages(int prodId, int senderId, int receiverId) async {
  final apiUrl = 'https://holx-qmve.onrender.com/chat/product/$prodId/sender/$senderId/receiver/$receiverId/';
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Token f4eec197591f21724719f6454f8dbef94d25b815',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data.map((e) => ChatMessage(
      e['sender'],e['receiver'],e['product'],e['message'],DateTime.parse(e['timestamp']),
    )).toList();
  } else {
    throw Exception('Failed to load chat messages');
  }
}