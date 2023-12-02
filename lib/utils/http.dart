import 'dart:convert';
import 'package:holx/models/Products.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Chat.dart';
import '../models/ChatUserProduct.dart';

Future<String> fetchUsername(int userId) async {
  final authService = AuthService();
  final token = await authService.getToken();
  final response = await http.get(
    Uri.parse("https://holx-qmve.onrender.com/application/user/name/$userId/"),
    headers: {
      'Authorization': 'Token $token',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return data['username'];
  } else {
    throw Exception('Failed to fetch username');
  }
}

Future<String> fetchProductName(int productId) async {
  final authService = AuthService();
  final token = await authService.getToken();
  final response = await http.get(
    Uri.parse(
        "https://holx-qmve.onrender.com/application/product/name/$productId/"),
    headers: {
      'Authorization': 'Token $token',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return data['product_name'];
  } else {
    throw Exception('Failed to fetch product name');
  }
}

Future<List<Product>> fetchProducts() async {
  final authService = AuthService();
  final token = await authService.getToken();
  final response = await http.get(
    Uri.parse("https://holx-qmve.onrender.com/application/product/"),
    headers: {
      'Authorization': 'Token $token',
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
              result['image'],
              result['phone'],
              result['price'],
              result['user'],
            ))
        .toList();
  } else {
    throw Exception('Failed to load posts');
  }
}

Future<List<ChatMessage>> fetchChatMessages(
    int prodId, int senderId, int receiverId) async {
  final authService = AuthService();
  final token = await authService.getToken();
  final apiUrl =
      'https://holx-qmve.onrender.com/chat/product/$prodId/sender/$senderId/receiver/$receiverId/';
  print(token);
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Token $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map((e) => ChatMessage(
              e['sender'],
              e['receiver'],
              e['product'],
              e['message'],
              DateTime.parse(e['timestamp']),
            ))
        .toList();
  } else {
    throw Exception('Failed to load chat messages');
  }
}

Future<List<ChatUserProduct>> fetchChatMessagesByReceiverId() async {
  final authService = AuthService();
  final token = await authService.getToken();
  final Id = await authService.getId();
  final apiUrl = 'https://holx-qmve.onrender.com/chat/fetch/$Id/';
  final response = await http.get(
    Uri.parse(apiUrl),
    headers: {
      'Authorization': 'Token $token',
    },
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    return data
        .map(
          (e) => ChatUserProduct(e['sender_id'], e['product_id']),
        )
        .toList();
  } else {
    throw Exception('Failed to load chat messages');
  }
}

class AuthService {
  final String baseUrl = 'https://holx-qmve.onrender.com/authentication';

  Future<bool> registerUser(String username, String password) async {
    final url = Uri.parse('$baseUrl/register/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String errorMessage =
          responseData['error'] ?? 'Registration failed.';
      throw Exception(errorMessage);
    } else {
      throw Exception('Registration failed.');
    }
  }

  Future<String?> loginUser(String username, String password) async {
    final url = Uri.parse('$baseUrl/login/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String token = responseData['token'];
      final String userId = responseData['user_id'].toString();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setString('username', username);
      prefs.setString('user_id', userId);
      return token;
    } else {
      throw Exception('Login failed.');
    }
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<String?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('username');
    prefs.remove('user_id');
  }
}

Future<void> addProduct(
  String name,
  String address,
  String description,
  String imageUrl,
  String phone,
  String price,
) async {
  final authService = AuthService();
  final token = await authService.getToken();
  print(imageUrl);
  final apiUrl = 'https://holx-qmve.onrender.com/application/product/';
  final Map<String, dynamic> productData = {
    'name': name,
    'address': address,
    'description': description,
    'image': imageUrl,
    'phone': phone,
    'price': price,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(productData),
    );

    if (response.statusCode == 201) {
      print(jsonEncode(productData));
      print("Product added");
    } else {
      throw Exception('Failed to add the product.');
    }
  } catch (e) {
    print('Error adding product: $e');
    throw Exception('Failed to add the product.');
  }
}
