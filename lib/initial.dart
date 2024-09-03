import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io' show Platform;

import 'package:videocall/appManager.dart';
import 'package:videocall/login.dart';
import 'package:videocall/welcomeScreen.dart';

class InitialScreen extends StatefulWidget {
  InitialScreen({Key? key, required this.title, required this.appManager})
      : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  final localAuth = LocalAuthentication();
  late SharedPreferences prefs;
  String role = '';
  bool isloaded = false;
  authenticateUser() async {
    var result = await this.widget.appManager.hasLoggedIn();
    if (result['hasLoggedIn']) {
      try {
        bool didAuthenticate = true;
        List<BiometricType> availableBiometrics =
            await localAuth.getAvailableBiometrics();
        if (availableBiometrics.length > 0) {
          didAuthenticate = await localAuth.authenticate(
            // biometricOnly: true,//Commneted on 22 Dec
            localizedReason: 'Please authenticate to proceed',
            // useErrorDialogs: true /* , stickyAuth: true *///Commneted on 22 Dec
          );
        }
        print("didAuthenticate $didAuthenticate");
        if (didAuthenticate) {
          if (!this.widget.appManager.appOpenedByNotification) {
            this.widget.appManager.appOpenedByNotification = false;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => WelcomeScreen(
                        isRemoteMuted: true,
                        isRemoteVideoEnabled: true,
                        isIncomingCall: false,
                        aapManager: widget.appManager,
                        type: role,
                      )),
            );
          }
        } else {
          print('authentication failed');
          this.authenticateUser();
          Navigator.pop(context);
        }
      } catch (e) {
        print("exception $e");
      }
    } else {
      if (isloaded == false) {
        this.sleep1();
      }
    }
  }

  Future sleep1() {
    isloaded = true;
    return Future.delayed(
        const Duration(seconds: 2, milliseconds: 800),
        () => {
              /* Remove this login check after local auth starts working properly  */
              this.widget.appManager.hasLoggedIn().then((result) {
                if (result['hasLoggedIn']) {
                  if (role == '') {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Login(
                                title: 'Login',
                                appManager: widget.appManager,
                              )),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WelcomeScreen(
                                isRemoteMuted: true,
                                isRemoteVideoEnabled: true,
                                isIncomingCall: false,
                                aapManager: widget.appManager,
                                type: role,
                              )),
                    );
                  }
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Login(
                              title: 'Login',
                              appManager: widget.appManager,
                            )),
                  );
                }
              })
            });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this
        .widget
        .appManager
        .notifications
        .configureDidReceiveLocalNotificationSubject(this.context);
    getPrefs();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role') ?? '';
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      this.authenticateUser();
    }
    if (isloaded == false) {
      this.sleep1();
    }
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bgimage.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Image.asset(
            'assets/Splash.png',
            width: size.width * 0.6,
            height: size.height * 0.25,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
