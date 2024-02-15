import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class Widgets {
  static void showErrorFlushbar(
      BuildContext context, String message, String title) {
    Flushbar(
      title: title,
      message: message,
      duration: Duration(seconds: 3),
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(25),
      backgroundGradient: LinearGradient(
        colors: [
          Color(0xff3EB489),
          Color.fromARGB(255, 70, 206, 170),
          Color.fromARGB(255, 83, 237, 180),
        ],
        stops: [0.4, 0.7, 1],
      ),
      boxShadows: [
        BoxShadow(
          color: Colors.black45,
          offset: Offset(3, 3),
          blurRadius: 3,
        ),
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
      borderRadius: BorderRadius.circular(10),
      messageSize: 17,
    )..show(context);
  }
}

Future<bool> showLogoutConfirmationDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 10,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No',
                    style: TextStyle(
                      color: Color(0xff3EB489),
                      fontSize: 20,
                    )),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes',
                    style: TextStyle(color: Color(0xff3EB489), fontSize: 20)),
              ),
            ],
          ),
        ],
      );
    },
  );
}
