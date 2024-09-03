import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:videocall/appManager.dart';

class General {
  AppManager appManager;
  RegExp passwordChecker = new RegExp(
      r"[\S]{6,20}"); //r"((?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*~]).{6,40})"
  List<String> elevationLevels = [
    'Normal',
    'Elevated',
    'Stage 1',
    'Stage 2',
    'Crisis'
  ];
  List<String> categorySequence = [
    'Blood Pressure',
    'Glucose',
    'Weight',
    'Oxygen',
    'Psychology',
    'Pain',
    'Mood',
    'Therapy'
  ];
  Map<String, String> categoryAgainstVariable = {
    'bloodPressure': 'Blood Pressure',
    'glucose': 'Glucose',
    'weight': 'Weight',
    'oxygen': 'Oxygen',
    'psychology': 'Psychology',
    'pain': 'Pain',
    'mood': 'Mood',
    'general': 'General',
    'therapy': 'Therapy'
  };
  List<num> goalSuccessThresholds = [2, 5, 1000000];

  // Psychology questions and answers
  List<String> questions = [
    'Little Interest or pleasure in doing things',
    'Feeling down, depressed or hopeless?',
    'Trouble falling or staying asleep, or sleeping too much',
    'Feeling tired or having little energy?',
    'Poor appetite or overeating?',
    'Feeling bad about yourself - or that you are a failure of have let yourself or your family down?',
    'Trouble concentrating on things, such as reading the newspaper or watching TV?',
    'Moving or speaking so slowly that other people could noticed? or the opposite - being so fidgety or restless that you have been moving around a lot more that usual?',
    'Thoughts that you would be better off dead or of hurting yourself in some way?',
  ];
  List<String> possibleAnswers = [
    'Not at all',
    'Several Days',
    'More than half the days',
    'Nearly everyday'
  ];
  List<String> options = [
    'Not at all',
    'Somewhat difficult',
    'Very difficult',
    'Extremely difficult',
  ];
   late tz.Location localTimeZone;

  /*  Flutter to Platform communicator */
  static const platform =
      const MethodChannel('docuvitals.bysness.com/communicator');
  Map<String, Function> platformMethodsReceiver = {};

  invokePlatformMethod(String methodName, dynamic arguments) async {
    return await platform.invokeMethod(methodName, arguments);
  }

  addPlatformMethodHandler(String methodName, Function func) {
    if (platformMethodsReceiver[methodName] == null) {
      platformMethodsReceiver[methodName] = func;
    }
  }

  removePlatformMethodHandler(String methodName) {
    if (platformMethodsReceiver.containsKey(methodName)) {
      platformMethodsReceiver.remove(methodName);
    }
  }
  /*  Flutter to Platform communicator */

  General(this.appManager) {
    platform.setMethodCallHandler((call) {
      if (this.platformMethodsReceiver.containsKey(call.method)) {
        return this.platformMethodsReceiver[call.method]!(call.arguments);
      } else {
         return Future.value(null);
      }
    });
    // this.initilizeTimeZoneWithLocal();
  }

  initilizeTimeZoneWithLocal() async {
    tz.initializeTimeZones();
    String timeZoneString =
        await invokePlatformMethod("getTimeZoneName", {});
        //Old Code Commented on 1 Jan Creating issue for foreign countries
    // Location defaultLocation = tz.Location("Default", 0, 0, "Default");
    tz.setLocalLocation(tz.timeZoneDatabase.locations[
        timeZoneString == "Asia/Calcutta" ? "Asia/Kolkata" : timeZoneString] ?? tz.Location("Default", [0], [0], []));
      // tz.setLocalLocation(tz.getLocation(timeZoneString));
    this.localTimeZone = tz.local;
    debugPrint("this.localTimeZone ${this.localTimeZone}", wrapWidth: 1000);
  }

  
//Modified on 29 Jun
 String parseDate(String format, String dateInString) {
  try {
    DateTime parsedDate = DateTime.parse(dateInString);
    return DateFormat(format).format(parsedDate.toLocal());
  } catch (e) {
    print("Error parsing date: $e");
    // Handle the error, e.g., return a default value or rethrow the exception
    return "Invalid Date";
  }
}

String parseDates(String format, String dateInString) {
  try {
    DateTime parsedDate = DateTime.parse(dateInString);
    return DateFormat(format).format(parsedDate);
  } catch (e) {
    print("Error parsing date: $e");
    // Handle the error, e.g., return a default value or rethrow the exception
    return "Invalid Date";
  }
}

  String convertStringToDateTime(String inputString) {
    final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss.SSSZ");
    final outputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss");

    final dateTime = inputFormat.parse(inputString);
    final formattedDateTime = outputFormat.format(dateTime);

    return formattedDateTime;
  }

  String convertStringToDateTimes(String inputString) {
    final inputFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ");
    final outputFormat = DateFormat("MM-dd-yyyy h:mm a");

    final dateTime = inputFormat.parse(inputString).toLocal();
    final formattedDateTime = outputFormat.format(dateTime);

    return formattedDateTime;
  }

  

  getElevationString(int level) {
    if (level > -1 && level < this.elevationLevels.length) {
      return this.elevationLevels[level] ;
    } else {
      return "";
    }
  }

  getProperRole(String role) {
    if (role == 'doctor') {
      return 'DR';
    } else {
      return role;
    }
  }

  upperCaseFirst(String str) {
    if (str.length > 0) {
      return str[0].toUpperCase() + str.substring(1);
    } else {
      return str;
    }
  }

  lowerCaseFirst(String str) {
    if (str.length > 0) {
      return str[0].toLowerCase() + str.substring(1);
    } else {
      return str;
    }
  }

  kgsToLbs(num weight) {
    return num.parse((weight / 0.45359237).toStringAsFixed(2));
  }
  //  cancelReadingReminder(int notificationId, String category) {
  //   print("notificationId $notificationId");
  //   print("Cancel Reminder on BP ${notificationId}");
  //   this.appManager.notifications.cancelNotification(notificationId);
  //   this.appManager.prefs.remove("$category reminder id");
  //   this.appManager.prefs.remove("$category reminder time");
  // }
  removeLastPopup(BuildContext context) {
    Navigator.of(context).pop();
  }

  jsonToString(dynamic obj) {
    JsonEncoder encode = new JsonEncoder.withIndent("    ");
    return encode.convert(obj);
  }

  getBMILabel(num bmi) {
    if (bmi < 19) {
      return 'Underweight';
    } else if (bmi > 18 && bmi < 25) {
      return 'Healthy';
    } else if (bmi > 24 && bmi < 30) {
      return 'Overweight';
    } else if (bmi > 29 && bmi < 40) {
      return 'Obese';
    } else if (bmi > 40) {
      return 'Extremely Obese';
    }
  }

  bool isPatientExitDialogShown = false;
}
