import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:holx/screens/add_product_screen.dart';
import 'package:holx/screens/home_screen.dart';
import 'package:holx/screens/login_screen.dart';
import 'package:holx/screens/register_screen.dart';
import '../utils/http.dart';
import 'package:holx/utils/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final AuthService authService = AuthService();
  static const Color backgroundColor = Color(0xfff5fffa);
  static const Color buttonColor = Color(0xffF97B22);
  static const Color textColor = Color(0xff333333);
  Future<bool> checkLoginState() async {
    return await authService.isLoggedIn();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.roboto().fontFamily,
        brightness: Brightness.light,
        backgroundColor: backgroundColor,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme.apply(
                bodyColor: Colors.black.withOpacity(0.8),
              ),
        ),
      ),
      initialRoute:'/',
      home:FutureBuilder<bool>(
        future: checkLoginState(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final bool isLoggedIn = snapshot.data ?? false;
            return isLoggedIn ? HomeScreen() : LoginScreen();
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xff3EB489),
              ),
            );
          }
        },
      ),
      routes: {
        MyRoutes.HomeRoute: (context) => HomeScreen(),
        MyRoutes.RegisterRoute:(context) => RegisterScreen(),
        MyRoutes.LoginRoute:(context) => LoginScreen(),
        MyRoutes.AddProductRoute:(context) => AddProduct(),
      },
    );
  }
}
