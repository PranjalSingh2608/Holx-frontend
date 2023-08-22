import 'dart:convert';
import 'package:holx/models/Products.dart';
import 'package:http/http.dart' as http;

Future<List<Product>> fetchProducts() async {
  final response = await http
      .get(Uri.parse("https://holx.onrender.com/application/product/"),headers: {
      'Authorization': 'Token cbe8eec9d8d9dc02d8855deb196227ec10a5870c',  // Add the token to the Authorization header
    },);
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final List<dynamic> results = data['results'];
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
