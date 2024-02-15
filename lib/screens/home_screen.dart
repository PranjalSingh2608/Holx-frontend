import 'package:flutter/material.dart';
import 'package:holx/models/Products.dart';
import 'package:holx/screens/chat_screen.dart';
import 'package:holx/screens/product_detail_screen.dart';
import 'package:holx/utils/http.dart';

import '../models/ChatUserProduct.dart';
import '../utils/widgets.dart';
import 'chat_thread_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> products;
  late PageController _pageController;
  late List<ChatUserProduct> chatUserProducts = [];
  Product? currprod;
  @override
  void initState() {
    _pageController = PageController();
    super.initState();
    products = fetchProducts();
  }

  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HolX'),
        backgroundColor: Color(0xff3EB489),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: FutureBuilder(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xff3EB489),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final List<Product> productList = snapshot.data!;
            final int itemCount = productList.length;
            return PageView.builder(
              controller: _pageController,
              itemCount: itemCount + 2,
              itemBuilder: (context, index) {
                final int pageIndex = index % itemCount;
                final prod = productList[pageIndex];
                currprod = productList[pageIndex];
                return ProductDetail(prod: prod);
              },
              onPageChanged: (index) {
                print("Page changed to: $index");
                final int currentPageIndex = index % itemCount;
                if (currentPageIndex == 0) {
                  _pageController.jumpToPage(itemCount);
                } else if (currentPageIndex == itemCount + 1) {
                  _pageController.jumpToPage(1);
                }
              },
            );
          } else {
            return Center(
              child: Text('No Data available'),
            );
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
