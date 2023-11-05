import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holx/models/Products.dart';
import 'package:holx/screens/chat_screen.dart';


class ProductDetail extends StatelessWidget {
  final Product prod;
  const ProductDetail({required this.prod});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Color(0xff3EB489),
      ),
      body: ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Card(
                            semanticContainer: true,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            elevation: 5,
                            child: Image.network(prod.imageUrl,
                                // ignore: prefer_interpolation_to_compose_strings
                                fit: BoxFit.cover),
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        prod.name.toString(),
                        style: GoogleFonts.raleway(
                          textStyle: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff333333),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Description",
                          style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff333333),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          prod.description.toString(),
                          style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff333333),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Reach out to us at:",
                          style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff333333),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          prod.address.toString(),
                          style: GoogleFonts.raleway(
                            textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.normal,
                              color: Color(0xff333333),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.phone_android_outlined,
                            ),
                            Text(
                              "Call us at: ",
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff333333),
                                ),
                              ),
                            ),
                            Text(
                              prod.phone,
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff333333),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        color: Color(0xff3EB489),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () async{
                // final productName = await fetchProductName(prod.id);
                // final userName = await fetchUsername(prod.user);
                Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>ChatPage(receiver: prod.user, prodId: prod.id
        // ,receiverName: userName,prodName: productName,
        )
      ),
    );
              },
              icon: Icon(
                size: 35,
                Icons.chat_bubble_outline,
                color: Color(0xfff5fffa),
              ),
            ),
            Container(
              height: 50,
              color: Colors.black,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.payment_outlined,
                size: 35,
                color: Color(0xfff5fffa),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
