import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//added
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:videocall/VideoCallScreen.dart';
import 'package:videocall/appManager.dart';

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  print("messages in background $message");
}

class Notifications {
  final AppManager appManager;
  late SharedPreferences prefs;
  late BuildContext context;
  late String mobileToken;

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String> behaviorSubject = BehaviorSubject();
  final BehaviorSubject<ReceivedNotification>
      didReceiveLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  final BehaviorSubject<String> selectNotificationSubject =
      BehaviorSubject<String>();
  BehaviorSubject<RemoteMessage> remoteMessages =
      BehaviorSubject<RemoteMessage>();

  static const String navigationActionId = 'id_1';
  static const String darwinNotificationCategoryPlain = 'plainCategory';
  // Firebase message variables;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  Stream<RemoteMessage> onMessage = FirebaseMessaging.onMessage;

  Notifications(this.appManager) {
    _requestPermissions();
    setupFirebaseNotifications();
    setupNotifications();
    this.configureSelectNotificationSubject();
//added 1 Jun
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received: ${message.messageId}");
      print('Received a message while in the foreground!');
      print('Message data: ${message.data}');
      if (message.data['type'] == 'receiver') {
        //  prefs.setString('agoraToken', message.data['agora'] ?? '');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoCallScreen(
                    isRemoteMuted:
                        message.data['grp'] ?? '' == '1' ? true : false,
                    isIncomingCall: true,
                    isRemoteVideoEnabled: false,
                    aapManager: appManager,
                    type: 'Receiver',
                    senderID: message.data['user_id'] ?? '',
                    isGroup: message.data['grp'] ?? '',
                  )),
        );
      } else {
        Navigator.pop(context);
      }

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        _showNotification(message.notification!, message.data);
      }
      //when notification came on live
      // Call the necessary function to handle the push notification data
    });
  }

  Future<String> getUserToken() async {
    prefs = await SharedPreferences.getInstance();
    this.mobileToken = await _firebaseMessaging.getToken() ?? '';
    print("this.mobileToken ${this.mobileToken}");
    this.prefs.setString("firebaseToken", this.mobileToken);
    return this.mobileToken;
  }

  Future<void> _showNotification(
      RemoteNotification notification, Map<String, dynamic> data) async {
    const DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentList: true,
      presentBanner: true,
      interruptionLevel: InterruptionLevel.timeSensitive,
      presentSound: true,
      threadIdentifier: "localDailyNotifications",
      categoryIdentifier: 'demoCategory',
    );
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'dailyNotification',
      'Daily Reminder',
      channelDescription: "Reminder Description",
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
      enableVibration: true,
      ticker: 'ticker',
      // groupKey: 'groupKey',
      // autoCancel: false,
      playSound: true,
      ongoing: true,
      setAsGroupSummary: true,
      icon:
          '@mipmap/ic_launcher', // Ensure this is the correct path to your icon
    );

    // Combine notification and data into a single payload map
    Map<String, dynamic> payload = {
      'notification': {
        'id': notification.hashCode,
        'title': notification.title,
        'body': notification.body,
        // Add other notification properties as needed
      },
      'data': data,
    };

    // Encode the payload map to JSON
    String payloadJson = jsonEncode(payload);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: payloadJson,
    );
  }

  setupNotifications() async {
    print('Notifications setup started');
    this.prefs = await SharedPreferences.getInstance();

    // final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    //     await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      defaultPresentAlert: true,
      defaultPresentSound: true,
      onDidReceiveLocalNotification:
          (int? id, String? title, String? body, String? payload) async {
        print("onDidReceive Notification in---initializationSettingsIOS");
        didReceiveLocalNotificationSubject.add(
          ReceivedNotification(
            id: (id ?? 0).toString(),
            title: title ?? "",
            body: body ?? "",
            payload: payload ?? "",
          ),
        );
      },
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    ); //Donot add iOS , as it duplicates notfication in iOS device

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            print("coming from selecting Notification");
            // _handleNotificationResponse(notificationResponse.payload, false);
            break;
          case NotificationResponseType.selectedNotificationAction:
            print("coming from action button selectedNotificationAction");
            // _handleNotificationResponse(notificationResponse.payload, false);
            break;
        }
      },
      // onDidReceiveBackgroundNotificationResponse:
      //     onDidReceiveBackgroundNotificationResponse,
    );
    print('Notifications setup done');
  }

  _launchURLs(String urls) async {
    if (await canLaunch(urls)) {
      await launch(urls);
    } else {
      throw 'Could not launch $urls';
    }
  }

  Future<void> configureDidReceiveLocalNotification(BuildContext parentContext,
      Map<String, dynamic>? retrievedNotvalues) async {
    int user_id = prefs.getInt('sId') ?? 0;
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> saveStringValue(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Future<void> _handleNotificationResponse(
  //     String? payload, bool isRecived) async {
  //   if (payload != '' || payload != null) {
  //     Map<String, dynamic> data = jsonDecode(payload ?? '');
  //     print("Notification payload data: $data");
  //     Map<String, dynamic>? notification = data['notification'];
  //     Map<String, dynamic>? customData = data['data'];
  //     if (customData != null || notification != null) {
  //       String? url = customData?['url'];
  //       String? type = customData?['type'];
  //       Map<String, dynamic> notvalues = {};
  //       // Now you can use 'url' and 'type' as needed
  //       print("Notification payload data - URL: $url, Type: $type");
  //       // Example of how to use them:
  //       switch (type) {
  //         case "1":
  //           // Handle type 1 notification (if needed)
  //           if (isRecived == false)
  //             Navigator.pushNamed(context, "/getconnectionrequests");
  //           break;
  //         case "2":
  //           // Handle type 2 notification (if needed)//move to connection tab
  //           if (isRecived == false) Navigator.pushNamed(context, "/event");
  //           break;
  //         case "3":
  //           // Handle type 3 notification (if needed)//move to connection tab
  //           // saveStringValue('move','1');
  //           if (isRecived == false) Navigator.pushNamed(context, "/connection");
  //           break;
  //         case "4":
  //           // Handle type 4 notification (if needed)//move to message screen
  //           // saveStringValue('move','2');
  //           if (isRecived == false) Navigator.pushNamed(context, "/message");
  //           break;
  //         case "5":
  //           // Handle type 5 notification (if needed)//move to home screen//save URL
  //           notvalues['title'] = notification?['title'];
  //           notvalues['body'] = notification?['body'];
  //           notvalues['url'] = url;
  //           notvalues['type'] = 5;

  //           if (isRecived == false) configureDidReceiveLocalNotification(context, notvalues);
  //           break;
  //         case "6":
  //           // Handle type 6 notification (if needed)//move to home screen//save URL
  //           notvalues['title'] = notification?['title'];
  //           notvalues['body'] = notification?['body'];
  //           notvalues['url'] = url;
  //           notvalues['type'] = 6;
  //           if (isRecived == false) configureDidReceiveLocalNotification(context, notvalues);
  //           break;
  //         case "7":
  //           // Handle type 7 notification (if needed)
  //           notvalues['title'] = notification?['title'];
  //           notvalues['body'] = notification?['body'];
  //           notvalues['type'] = 7;
  //           if (isRecived == false) configureDidReceiveLocalNotification(context, notvalues);
  //           break;
  //         default:
  //           // Handle other types or fallback
  //           Navigator.pushNamed(context, "/event");
  //           break;
  //       }
  //     }

  //     // Example of navigating to a URL if available
  //   } else {
  //     print('Payload not found');
  //   }
  // }

  setupFirebaseNotifications() async {
    if (Platform.isIOS) await _firebaseMessaging.requestPermission();
    _firebaseMessaging.onTokenRefresh.listen((event) {
      print("on notification token changed $event");
      // TODO: implement this to save new token;
    });

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(new AndroidNotificationChannel(
            "dailyNotifications", "Daily Reminders"));
    // "Server notification receiving channel"));

    _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);

    // Grabbing notification which opened the app;
    RemoteMessage? messageFromOutside =
        await _firebaseMessaging.getInitialMessage();
    debugPrint("messageFromOutside $messageFromOutside");
    if (messageFromOutside != null) {
      // this.foundServerNorification(messageFromOutside, true);
      //  Navigator.pushNamed(context, "/connection");//Added New
      // Map<String, dynamic> payload = {
      //   'notification': {
      //     'id': messageFromOutside.notification?.hashCode,
      //     'title': messageFromOutside.notification?.title,
      //     'body': messageFromOutside.notification?.body,
      //     // Add other notification properties as needed
      //   },
      //   'data': messageFromOutside.data,
      // };
      // String payloadJson = jsonEncode(payload);
      print(
          'User tapped on push notification: ${messageFromOutside.notification?.title}');
      // foundServerNorification(message, true);
      // _handleNotificationResponse(payloadJson, false);
      if (messageFromOutside.data['type'] == 'receiver') {
        // prefs.setString('agoraToken', messageFromOutside.data['agora'] ?? '');
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VideoCallScreen(
                    isRemoteMuted: messageFromOutside.data['grp'] ?? '' == '1'
                        ? true
                        : false,
                    isIncomingCall: true,
                    isRemoteVideoEnabled: false,
                    aapManager: appManager,
                    type: 'Receiver',
                    senderID: messageFromOutside.data['user_id'] ?? '',
                    isGroup: messageFromOutside.data['grp'] ?? '',
                  )),
        );
      } else {
        Navigator.pop(context);
      }
    }

    // Grabbing notification while on foreground
    this.onMessage.listen((RemoteMessage message) {
      print("OnMessage");
      print(message);

      onDidReceiveLocalNotification(
          message.messageId ?? '',
          message.notification?.title ?? '',
          message.notification?.body ?? '',
          '');

      //when notification receiived live
      // prefs.setInt('therapy', tCounter);
      // if (message.data['category'] == "medicine:add" ||
      //     message.data['category'] == "medicine:update:data" ||
      //     message.data['category'] == "medcine:update:timing" ||
      //     message.data['category'] == "medicine:delete" ||
      //     message.data['category'] == "therapy:add" ||
      //     message.data['category'] == "therapy:update:data" ||
      //     message.data['category'] == "therapy:update:timing" ||
      //     message.data['category'] == "therapy:delete") {
      //   this.foundServerNorification(message, true);
      // } else {
      // this.foundServerNorification(message, false);
      // }
    });

    // Setting background handler

    // FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    // Handle the received message when the user taps on the notification
    // Map<String, dynamic> payload = {
    //   'notification': {
    //     'id': message.notification?.hashCode,
    //     'title': message.notification?.title,
    //     'body': message.notification?.body,
    //     // Add other notification properties as needed
    //   },
    //   'data': message.data,
    // };
    // String payloadJson = jsonEncode(payload);
    print('User tapped on push notification: ${message.notification?.title}');
    if (message.data['type'] == 'receiver') {
      // prefs.setString('agoraToken', message.data['agora'] ?? '');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VideoCallScreen(
                  isRemoteMuted:
                      message.data['grp'] ?? '' == '1' ? true : false,
                  isIncomingCall: true,
                  isRemoteVideoEnabled: false,
                  aapManager: appManager,
                  type: 'Receiver',
                  senderID: message.data['user_id'] ?? '',
                  isGroup: message.data['grp'] ?? '',
                )),
      );
    } else {
      Navigator.pop(context);
    }
    // foundServerNorification(message, true);
    // _handleNotificationResponse(payloadJson, false);
  }

  void onDidReceiveBackgroundNotificationResponse(
      NotificationResponse notificationResponse) {
    // Handle the background notification response here
    // This function will be called when your app is in the background or closed
    switch (notificationResponse.notificationResponseType) {
      case NotificationResponseType.selectedNotification:
        // Handle the selected notification response
        print("coming from selecting Notifications2");
        // You can add your custom logic here
        break;
      case NotificationResponseType.selectedNotificationAction:
        // Handle the selected notification action response
        print("coming from action button selectedNotificationAction");
        // You can add your custom logic here
        break;
    }
  }

  Future onDidReceiveLocalNotification(
      String id, String title, String body, String payload) async {
    print('onDidReceiveLocalNotification occur');
    didReceiveLocalNotificationSubject.add(
      ReceivedNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
      ),
    );
  }

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  configureDidReceiveLocalNotificationSubject(BuildContext context) {
    print("configureDidReceiveLocalNotificationSubject");
    // saveStringValue('Hello');//when run app 26 Oct
    this.context = context;
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      // _handleNotificationResponse(receivedNotification.payload,
      //     true); //When app is running, receive message only
    });
  }

  selectNotification(String payload) async {
    if (payload != null && payload.isNotEmpty) {
      debugPrint('notification: payload 1 $payload');
    }
    selectNotificationSubject.add(payload);
    // Clear the notification from the status bar
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  //Added 6 Jun

  configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((payload) async {
      //on Tap this function called
      print(payload);
    });
  }

  cancelNotification(int? notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId ?? 0);
  }

  cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  getPendingNotifications() async {
    List<PendingNotificationRequest> pendingNotificationRequests =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  foundServerNorification(
      RemoteMessage message, bool appOpenedByRemoteMessage) {
    print(
        "notification type ${message.data["category"]} and ${message.data["category"] == "message"} and type ${message.data["category"].runtimeType}");
    if (message != null) {
      if (message.data["category"] == "message") {
        if (this.appManager.currentPage == "/messages") {
          this.remoteMessages.add(message);
        } else {
          if (appOpenedByRemoteMessage) {
            Navigator.pushNamed(context, "/messages");
          } else {
            print("Not Navigator.pushNamed $appOpenedByRemoteMessage");
            /* TODO: Find proper action to be taken */
          }
        }
      } else if (message.data["category"] == "readingAcknowledgement") {
        print(
            "readingAcknowledgement message.data.data ${jsonDecode(message.data["data"])}");
        var data = jsonDecode(message.data["data"]);
      } else if ((message.data["category"] == "medicine:add") ||
          (message.data["category"] == "medicine:update:data")) {
        print("medicine message.data.data ${jsonDecode(message.data["data"])}");
        var data = jsonDecode(message.data["data"]);
      } else if (message.data["category"] == "medcine:update:timing") {
        print("medicine message.data.data ${jsonDecode(message.data["data"])}");
        var data = jsonDecode(message.data["data"]);
      } else {}
      //navigate to medicine List and reload list and Update Reminder, remove older reminder
    } else if (message.data["category"] == "medicine:delete") {
      print("medicine message.data.data ${jsonDecode(message.data["data"])}");
      var data = jsonDecode(message.data["data"]);
    } else if ((message.data["category"] == "therapy:add") ||
        (message.data["category"] == "therapy:update:data")) {
      print("therapy message.data.data ${jsonDecode(message.data["data"])}");
      var data = jsonDecode(message.data["data"]);
    } else if (message.data["category"] == "therapy:update:timing") {
      print("therapy message.data.data ${jsonDecode(message.data["data"])}");
      var data = jsonDecode(message.data["data"]);
    } else if (message.data["category"] == "therapy:delete") {
      print("therapy message.data.data ${jsonDecode(message.data["data"])}");
      var data = jsonDecode(message.data["data"]);
    }
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final String id;
  final String title;
  final String body;
  final String payload;
}
