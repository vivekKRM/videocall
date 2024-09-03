import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videocall/VideoCallScreen.dart';
import 'package:videocall/appManager.dart';
import 'package:videocall/constants.dart';
import 'package:videocall/default.dart';
import 'package:http/http.dart' as http;
import 'package:videocall/groupCall.dart';
import 'package:videocall/login.dart';
import 'package:videocall/userLists.dart';

class WelcomeScreen extends StatefulWidget {
  final String type;
  final bool isRemoteVideoEnabled;
  final bool isRemoteMuted;
  final bool isIncomingCall;
  final AppManager aapManager;
  const WelcomeScreen({
    Key? key,
    required this.type,
    required this.isRemoteVideoEnabled,
    required this.isRemoteMuted,
    required this.isIncomingCall,
    required this.aapManager,
  }) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late SharedPreferences prefs;
  String name = '';
  int userId = 0;
  String agoraToken = '';
  bool group = false;
  TextEditingController channelName = TextEditingController();

  // late AppManager appManager;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received message: ${message.notification?.title}');
      // Call function in message screen
      // widget.aapManager.configureDidReceiveLocalNotification(context);
      if (message.data['type'] == 'receiver') {
        //  prefs.setString('agoraToken', message.data['agora'] ?? '');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoCallScreen(
                    isRemoteMuted: false,
                    isIncomingCall: true,
                    isRemoteVideoEnabled: false,
                    aapManager: widget.aapManager,
                    type: 'Receiver',
                    senderID: message.data['user_id'] ?? '',
                    isGroup: message.data['grp'] ?? '',
                  )),
        );
      } else {
        Navigator.pop(context);
      }
    });

    // For handling notification when the app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
          'Notification opened from background: ${message.notification?.title}');
      // Call function in message screen
      if (message.data['type'] == 'receiver') {
        //  prefs.setString('agoraToken', message.data['agora'] ?? '');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoCallScreen(
                    isRemoteMuted: false,
                    isIncomingCall: true,
                    isRemoteVideoEnabled: false,
                    aapManager: widget.aapManager,
                    type: 'Receiver',
                    senderID: message.data['user_id'] ?? '',
                    isGroup: message.data['grp'] ?? '',
                  )),
        );
      } else {
        Navigator.pop(context);
      }
      //  widget.aapManager.configureDidReceiveLocalNotification(context);
    });
    getPrefs();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      userId = prefs.getInt('sId') ?? 0;
    });
    getAgoraToken();
  }

  void _callNow(BuildContext context) async {
    // callUser(name);
    final result = await showDialog<Map<String, String>>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Select User'),
            content: UserLists(
              title: 'User List',
              aapManager: widget.aapManager,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Cancel'),
              ),
            ],
          );
        });
    if (result != null) {
      // Navigator.of(context).pop();
      final Map<String, String> data = result;
      _handleUserListsReturn(data);
      print('Call Now Button Tap');
    }
  }

  //Call Send Notfication
  Future<DefaultResponse> callSend(Map<String, dynamic> requestBody) async {
    String? authToken = prefs.getString('authToken');
    print(requestBody);
    final String apiUrl = '${widget.aapManager.serverURL}/notification';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    DefaultResponse profileResp = DefaultResponse.fromJson(jsonResponse);
    return profileResp;
  }

  Future<void> callUser(String name, String id) async {
    Map<String, dynamic> requestBody = {
      "type": 'receiver',
      "message": '$name is calling',
      'id': id,
      'user_id': userId,
      'group': group ? '1' : '0',
      'agora': agoraToken
    };
    callSend(
      requestBody,
    ).then((response) async {
      // Handle successful response
      if (response?.status == 200) {
        showToast(response?.message ?? '', 2, Color(0xFFD14D4D), context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoCallScreen(
                    isRemoteMuted: true,
                    isRemoteVideoEnabled: true,
                    isIncomingCall: false,
                    aapManager: widget.aapManager,
                    type: 'Sender',
                    senderID: '',
                    isGroup: group ? '1' : '0',
                  )),
        );
      } else if (response?.status == 202) {
        showToast(response?.message ?? '', 2, Color(0xFFD14D4D), context);
      } else if (response?.status == 503) {
      } else {
        print("Failed to get dashboard data");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to get dashboard data: $error");
    });
  }

  //Get Token
  Future<DefaultResponse> getToken(Map<String, dynamic> requestBody) async {
    String? authToken = prefs.getString('authToken');
    final String apiUrl = '${widget.aapManager.serverURL}/agtoken';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $authToken",
        },
        body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    DefaultResponse profileResp = DefaultResponse.fromJson(jsonResponse);
    return profileResp;
  }

  Future<void> getAgoraToken() async {
    Map<String, dynamic> requestBody = {};
    getToken(
      requestBody,
    ).then((response) async {
      // Handle successful response
      if (response?.status == 200) {
        showToast(response?.message ?? '', 2, Color(0xFFD14D4D), context);
        agoraToken = response?.token ?? '';
        print("agoraToken , $agoraToken");
        prefs.setString('agoraToken', agoraToken);
      } else if (response?.status == 202) {
        showToast(response?.message ?? '', 2, Color(0xFFD14D4D), context);
      } else if (response?.status == 503) {
      } else {
        print("Failed to get dashboard data");
      }
    }).catchError((error) {
      // Handle error
      print("Failed to get dashboard data: $error");
    });
  }

  void _logouts(BuildContext context) async {
    // Show a confirmation dialog before logging out
    bool? confirmLogout = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text("Logout"),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmLogout == true) {
      // Clear the SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await widget.aapManager.clearLoggedIn();
      if (widget.aapManager.islogout == true) {
        // Navigate to the login screen (assuming LoginScreen is the name of your login screen widget)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => Login(
                    title: 'Login',
                    appManager: widget.aapManager,
                  )),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  void _handleUserListsReturn(Map<String, String> data) {
    print('User returned from UserLists');
    String id = data['id'] ?? '';
    String name = data['name'] ?? ''; // Extract other values as needed
    callUser(name, id);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logouts(context),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/welcom.png',
              height: size.height * 0.5,
              width: size.height * 0.6,
              fit: BoxFit.cover,
            ),
            Text(
              'Welcome, ${name}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                CustomButton(
                  text: 'Call with contacts',
                  onPressed: () async {
                    bool isConnected =
                        await ConnectivityUtils.checkConnectivity();
                    if (isConnected) {
                      setState(() {
                        group = false;
                      });
                      _callNow(context);
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
                SizedBox(
                  height: 10,
                ),
                CustomButton(
                  text: 'Group Call',
                  onPressed: () async {
                    bool isConnected =
                        await ConnectivityUtils.checkConnectivity();
                    if (isConnected) {
                      // _showJoinDialog(context);
                      setState(() {
                        group = true;
                      });
                      _callNow(context);
                    } else {
                      showInternetDialog(
                        context: context,
                        onOkPressed: () {
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
