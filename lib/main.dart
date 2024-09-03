import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:videocall/appManager.dart';
import 'package:videocall/initial.dart';
import 'package:videocall/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Initialize Firebase
  print("Initializing Firebase");
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully");
  } catch (e) {
    print("Error initializing Firebase: $e");
    // Handle Firebase initialization error
    // Optionally, you could navigate to an error page or display a dialog
  }

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.prefs}) : super(key: key);
  final SharedPreferences prefs;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppManager appManager;
  Map<String, Widget Function(BuildContext)> routes = {};

  @override
  void initState() {
    super.initState();

    // Setup Firebase Messaging listeners
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.notification?.title}');
      // Handle notification while the app is in the foreground
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked!');
      // Handle notification when the app is opened from a notification
    });

    var envMode = "prod";
    appManager = AppManager(envMode, widget.prefs);

    appManager.hasLoggedIn().then((result) {
      if (result['hasLoggedIn']) {
        appManager.initSocket(result['authToken']);
      }
    });

    routes = {
      '/': (context) =>
          InitialScreen(title: 'SplashScreen', appManager: appManager),
      // Add more routes as needed
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Call',
      onGenerateRoute: _getRoute,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      builder: (context, child) {
        widget.prefs.setDouble(
            "textScalingFactor", MediaQuery.of(context).textScaleFactor);
        return MediaQuery(
          child: child ?? Container(),
          data: MediaQuery.of(context).copyWith(textScaleFactor: 0.845),
        );
      },
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    appManager.currentPage = settings.name ?? '';
    Widget temp;
    return PageRouteBuilder(
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        switch (settings.name) {
          case '/':
            temp = InitialScreen(
              title: 'Splash',
              appManager: appManager,
            );
            break;
          default:
            temp = routes[settings.name]?.call(context) ?? Container();
        }
        this.appManager.currentPageObject = temp;
        return temp;
      },
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) =>
          SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  void _launchStoreURL() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      final Uri url = Uri.parse('docuvitals://');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        const playStorePackageName = 'com.docuvitals.health';
        final playStoreURL =
            'https://play.google.com/store/apps/details?id=$playStorePackageName';

        if (await canLaunch(playStoreURL)) {
          await launch(playStoreURL);
        } else {
          throw 'Could not launch Play Store URL';
        }
      }
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      final Uri url = Uri.parse('docuvitals://');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        const appStoreID = '1554906931';
        final appStoreURL = 'https://apps.apple.com/app/$appStoreID';

        if (await canLaunch(appStoreURL)) {
          await launch(appStoreURL);
        } else {
          throw 'Could not launch App Store URL';
        }
      }
    }
  }
}
