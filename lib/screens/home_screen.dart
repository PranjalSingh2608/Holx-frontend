// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holx/models/Products.dart';
import 'package:holx/screens/product_detail_screen.dart';
import 'package:holx/utils/http.dart';

import '../models/ChatUserProduct.dart';
import 'chat_thread_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> products;
  late List<ChatUserProduct> chatUserProducts=[];
  @override
  void initState() {
    super.initState();
    products = fetchProducts();
    fetchChatMessagesByReceiverId().then((chatUserProducts) {
      setState(() {
        this.chatUserProducts = chatUserProducts;
      });
    });
  }
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('HolX'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              try {
                await authService.logout();
                Navigator.of(context).pushReplacementNamed('/login');
              } catch (e) {
                print('Logout error: $e');
              }
            },
          ),
        ],
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
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        // Divider(height: 60, thickness: 10, color: Colors.grey)
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0.1,
                          mainAxisSpacing: 0.1),
                      itemCount: productList.length,
                      itemBuilder: (context, index) {
                        final prod = productList[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetail(prod: prod)));
                          },
                          child: Container(
                            height: 300,
                            child: Card(
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              color: Theme.of(context).backgroundColor,
                              elevation: 3,
                              margin: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                                side: BorderSide(
                                    width: 1.3, color: Color(0xff333333)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1.5,
                                    child: Image.network(prod.imageUrl,
                                        fit: BoxFit.contain),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        prod.name,
                                        style: GoogleFonts.raleway(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff333333),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(
              child: Text('No Data available'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ChatThread(chatUserProducts: chatUserProducts)),
          );
        },
        child: Icon(Icons.chat),
        backgroundColor: Color(0xff3EB489),
      ),
    );
  }
}
