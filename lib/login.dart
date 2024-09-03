import 'dart:convert';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:videocall/VideoCallScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:videocall/appManager.dart';
import 'package:videocall/constants.dart';
import 'package:videocall/default.dart';
import 'package:http/http.dart' as http;
import 'package:videocall/register.dart';
import 'package:videocall/styles.dart';
import 'package:videocall/welcomeScreen.dart';

class Login extends StatefulWidget {
  Login({
    Key? key,
    required this.title,
    required this.appManager,
  }) : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String email = '';
  late SharedPreferences prefs;
  String firebase_token = '';
  String password = '';
  bool obscureText = true;
  bool loginn = false;
  String? errorText;
  String selectedRole = 'Sender';

  void login() {
    widget.appManager
        .login(emailController.text, passwordController.text, firebase_token,
            selectedRole.toLowerCase())
        .then(((response) async {
      print(response);
      if (response?.status == 200) {
        prefs.setString('email', email);
        prefs.setInt('sId', response?.data?.id ?? 0);
        prefs.setString('authToken', response?.token ?? '');
        prefs.setString('role', selectedRole);
        prefs.setString('name', response?.data?.name ?? '');
        await widget.appManager.markLoggedIn(response?.token ?? '');
        await widget.appManager.initSocket(response?.token ?? '');
        var loggedIn = await widget.appManager.hasLoggedIn();
        if (loggedIn['hasLoggedIn']) {
          if (selectedRole == 'Sender') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => WelcomeScreen(
                        isRemoteMuted: true,
                        isRemoteVideoEnabled: true,
                        isIncomingCall: false,
                        aapManager: widget.appManager,
                        type: 'Sender',
                      )),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => WelcomeScreen(
                        isRemoteMuted: false,
                        isIncomingCall: true,
                        isRemoteVideoEnabled: false,
                        aapManager: widget.appManager,
                        type: 'Receiver',
                      )),
            );
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => VideoCallScreen(
            //           isRemoteMuted: false,
            //           isIncomingCall: true,
            //           isRemoteVideoEnabled: false,
            //           aapManager: widget.appManager,
            //           type: 'Receiver')),
            // );
          }
        }
        showToast(response?.message ?? '', 2, Color(0xFFD14D4D), context);
      } else if (response?.status == 202) {
        showToast(response?.message ?? '', 2, Color(0xFFD14D4D), context);
      } else if (response?.status == 503) {
        showToast(response?.message ?? '', 2, Color(0xFFD14D4D), context);
      } else {
        showToast(response?.message ?? '', 2, Color(0xFFD14D4D), context);
      }
    }));
  }

  bool isValidEmailAndPassword(String email, String password) {
    // Email regex pattern
    final emailPattern = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailPattern.hasMatch(email)) {
      errorText = 'Please provide a valid email address.';
      showToast(
          'Please provide a valid email address.', 2, Colors.red, context);

      return false;
    } else if (password.isEmpty) {
      errorText = 'Password must not contain spaces.';
      showToast('Password field cannot be empty.', 2, Colors.red, context);
      return false;
    } else if (firebase_token.isEmpty) {
      showToast('Firebase token has been expired,please restart app.', 2,
          Colors.red, context);
      return false;
    } else {
      return true;
    }
  }

  _launchURL(String urlhit) async {
    if (await canLaunch(urlhit)) {
      await launch(urlhit);
    } else {
      throw 'Could not launch $urlhit';
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      _checkAndroidNotificationPermission();
      getPrefs();
    } else {
      getPrefs();
    }
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    var loggedIn = await widget.appManager.hasLoggedIn();
    String name = prefs.getString('name') ?? '';
    String role = prefs.getString('role') ?? '';
    firebase_token = await widget.appManager.notifications.getUserToken();
    print("mobileToken $firebase_token");
    widget.appManager.notifications
        .configureDidReceiveLocalNotificationSubject(context);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.notification?.title}');
      // _handleNotificationTap(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      // _handleNotificationTap(message);
    });

    if (loggedIn['hasLoggedIn']) {
      if (role == 'Sender') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => WelcomeScreen(
                    isRemoteMuted: true,
                    isRemoteVideoEnabled: true,
                    isIncomingCall: false,
                    aapManager: widget.appManager,
                    type: 'Sender',
                  )),
        );
      } else if (role == 'Receiver') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => WelcomeScreen(
                    isRemoteMuted: false,
                    isIncomingCall: true,
                    isRemoteVideoEnabled: false,
                    aapManager: widget.appManager,
                    type: 'Receiver',
                  )),
        );
      }
    }
  }

  Future<void> _checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (!status.isGranted) {
      showNotificationDialog(
        context: context,
        onOkPressed: () {
          Navigator.of(context).pop();
          AppSettings.openAppSettings();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarColor,
        surfaceTintColor: kAppBarColor,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: Colors.black),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/bgimage.jpg',
            height: size.height,
            width: size.width,
            fit: BoxFit.fill,
          ),
          SingleChildScrollView(
            child: Container(
              color: Colors.transparent, // Make container transparent
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // SizedBox(height: size.height * 0.05), // Space for image
                    Image.asset(
                      'assets/Splash.png',
                      height: size.width * 0.25,
                      width: size.width * 0.25,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text('Login', style: kLoginTextStyle),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Sender Radio Button
                        Radio<String>(
                          value: 'Sender',
                          groupValue: selectedRole,
                          onChanged: (String? value) {
                            // prefs.remove('firebaseToken');
                            prefs.remove('sId');
                            prefs.remove('role');
                            prefs.remove('email');
                            prefs.remove('authToken');
                            prefs.remove('name');
                            prefs.remove('agoraToken');
                            // prefs.clear();
                            setState(() {
                              emailController.text = '';
                              passwordController.text = '';
                              selectedRole = value!;
                            });
                          },
                        ),
                        Text(
                          'Sender',
                          style: kEventHeadStyle,
                        ),

                        // Receiver Radio Button
                        Radio<String>(
                          value: 'Receiver',
                          groupValue: selectedRole,
                          onChanged: (String? value) {
                            // prefs.remove('firebaseToken');
                            prefs.remove('sId');
                            prefs.remove('role');
                            prefs.remove('email');
                            prefs.remove('authToken');
                            prefs.remove('name');
                            setState(() {
                              emailController.text = '';
                              passwordController.text = '';
                              selectedRole = value!;
                            });
                          },
                        ),
                        Text(
                          'Receiver',
                          style: kEventHeadStyle,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kLoginTextFieldFillColor,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person_2_outlined,
                              size: 20, color: kLoginIconColor),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: 'Email address',
                                hintStyle: kLoginTextFieldTextStyle,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  email = value;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                      margin: EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: kLoginTextFieldFillColor,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lock_open_outlined,
                              size: 20, color: kLoginIconColor),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              controller: passwordController,
                              obscureText: obscureText,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                hintText: 'Password',
                                hintStyle: kLoginTextFieldTextStyle,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              },
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Icon(
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: kButtonColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 26),
                    CustomButton(
                      text: 'Log in',
                      onPressed: () async {
                        bool isConnected =
                            await ConnectivityUtils.checkConnectivity();
                        if (isConnected) {
                          if (isValidEmailAndPassword(
                              emailController.text, passwordController.text)) {
                            // showToast('User login successfull', 2, kToastColor, context);
                            login();
                          }
                        } else {
                          showInternetDialog(
                            context: context,
                            onOkPressed: () {
                              Navigator.of(context).pop();
                            },
                          );
                        }
                      },
                    ),
                    SizedBox(height: 26),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Register(
                              title: 'Register',
                              appManager: widget.appManager,
                            )),
                  );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: kPHPopupCheckListTitleTextStyle,
                          ),
                          Text(
                            'Sign up',
                            style: kSignUpTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
