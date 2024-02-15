import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holx/models/Products.dart';
import 'package:holx/screens/chat_screen.dart';
import 'package:holx/utils/http.dart';

import '../models/ChatUserProduct.dart';
import '../utils/widgets.dart';
import 'chat_thread_screen.dart';

class ProductDetail extends StatefulWidget {
  final Product prod;
  const ProductDetail({required this.prod});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final AuthService authService = AuthService();
  late List<ChatUserProduct> chatUserProducts = [];
  @override
  void initState() {
    super.initState();
    fetchChatMessagesByReceiverId().then((chatUserProducts) {
      setState(() {
        this.chatUserProducts = chatUserProducts;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F4F4),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(width: 1.3, color: Color(0xff333333)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(widget.prod.imageUrl),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.7),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          widget.prod.name,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Description",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        widget.prod.description,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 18,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "Reach out to us at:",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Color(0xFF333333),
                          ),
                          SizedBox(width: 8),
                          Text(
                            widget.prod.address,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone_android,
                            color: Color(0xFF333333),
                          ),
                          SizedBox(width: 8),
                          Text(
                            widget.prod.phone,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF666666),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        color: Color(0xFFF4F4F4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiver: widget.prod.user,
                      prodId: widget.prod.id,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.chat, size: 35, color: Color(0xFF3EB489)),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChatThread(chatUserProducts: chatUserProducts)),
                );
              },
              icon: Icon(
                CupertinoIcons.envelope,
                size: 35,
                color: Color(0xFF3EB489),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.add,
                size: 35,
                color: Color(0xFF3EB489),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/addproduct');
              },
            ),
            IconButton(
              icon: Icon(
                Icons.exit_to_app,
                size: 35,
                color: Color(0xFF3EB489),
              ),
              onPressed: () async {
                bool logoutConfirmed =
                    await showLogoutConfirmationDialog(context);

                if (logoutConfirmed) {
                  try {
                    await authService.logout();
                    Navigator.of(context).pushReplacementNamed('/login');
                  } catch (e) {
                    print('Logout error: $e');
                    Widgets.showErrorFlushbar(
                        context, "Error Logging out", "Please try again");
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
