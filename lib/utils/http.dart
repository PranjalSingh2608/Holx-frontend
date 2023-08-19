import 'dart:convert';
import 'package:holx/models/Products.dart';
import 'package:http/http.dart' as http;

Future<List<Product>> fetchProducts() async {
  final response = await http
      .get(Uri.parse("https://holx.onrender.com/application/product/"));
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
            result['user'],
            ))
        .toList();
  } else {
    throw Exception('Failed to load posts');
  }
}
