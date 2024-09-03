import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:videocall/styles.dart';

class Constants {
  static const MAP_REGEXP = '.* id="(.*)" title="(.*)" .* d="(.*)"';
  static const MAP_SIZE_REGEXP = '<svg.* height="(.*)" width="(.*)"';
  static const ASSETS_PATH = 'assets/images';

  static const API_KEY = 'AIzaSyBAMuijvYeVGo9YuWTJfOak0lrgCI5yUTY';
}

void showToast(String msg, int duration, Color bgColor, BuildContext context) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: duration,
    backgroundColor: bgColor,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
void showNotificationDialog({
  required BuildContext context,
  required VoidCallback onOkPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 3, top: 7, bottom: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
             SizedBox(height: 10,),
              const Text(
                'Notification Permission',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'This app requires notification permissions to notify you about important updates.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              TextButton(
                onPressed: onOkPressed,
                child: Text(
                  'Open Settings',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Color(0xFFD14D4D),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: kButtonColor,
        ),
        child: Text(text, style: kButtonTextStyle),
        onPressed: onPressed,
      ),
    );
  }
}

void showInternetDialog({
  required BuildContext context,
  required VoidCallback onOkPressed,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 3, top: 7, bottom: 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image.asset(
                'assets/no_internet.png', // Replace with your own image asset path
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 10.0),
              const Text(
                'Network Connection Error!',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Check your internet connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              TextButton(
                onPressed: onOkPressed,
                child: Text(
                  'OKAY',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: kButtonColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
class ConnectivityUtils {
  static Future<bool> checkConnectivity() async {
    print("Checking internet...");
    bool connected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      final result2 = await InternetAddress.lookup('facebook.com');
      final result3 = await InternetAddress.lookup('microsoft.com');

      // Check if any of the lookup results have a non-empty list of addresses
      if ((result.isNotEmpty && result[0].rawAddress.isNotEmpty) ||
          (result2.isNotEmpty && result2[0].rawAddress.isNotEmpty) ||
          (result3.isNotEmpty && result3[0].rawAddress.isNotEmpty)) {
        print('Connected');
        connected = true;
      } else {
        print("Not connected");
        connected = false;
      }
    } on SocketException catch (_) {
      print('Not connected');
      connected = false;
    }
    return connected;
  }
}


void _sendEmail(String mail) {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: mail,
      queryParameters: {'subject': '', 'body': ''},
    );
    launchUrl(emailLaunchUri);
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
