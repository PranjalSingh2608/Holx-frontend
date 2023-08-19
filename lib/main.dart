import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holx/screens/home_screen.dart';
// import 'package:holx/screens/product_detail_screen.dart';
import 'package:holx/utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const Color backgroundColor = Color(0xfff5fffa);
  static const Color buttonColor = Color(0xffF97B22);
  static const Color textColor = Color(0xff333333);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        backgroundColor: backgroundColor,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
              ),
        ),
      ),
      initialRoute: '/home',
      routes: {
        MyRoutes.HomeRoute: (context) => HomeScreen(),
      },
    );
  }
}
