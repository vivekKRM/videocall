import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videocall/appManager.dart';

class GroupCall extends StatefulWidget {
  final AppManager aapManager;
  final String title;
  const GroupCall({Key? key, required this.aapManager, required this.title})
      : super(key: key);

  @override
  _GroupCallState createState() => _GroupCallState();
}

class _GroupCallState extends State<GroupCall> {
  final AgoraClient client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: "7b44607b1a1149d59805b360cf4b47dc",
      channelName: "flutter",
      tempToken:
          '007eJxTYIg65WxvaJfGpypRmDBR++eq/tj4nopHbyu0dnTv/LjBPkCBwTzJxMTMwDzJMNHQ0MQyxdTSwsA0ydjMIDnNJMnEPCU5nftMWkMgI8OSqt2sjAwQCOKzM6TllJaUpBYxMAAAOGQftg==',
    ),
    enabledPermission: [
      Permission.camera,
      Permission.microphone,
    ],
    agoraEventHandlers: AgoraRtcEventHandlers(
      onUserJoined: ((connection, remoteUid, elapsed) =>
          Fluttertoast.showToast(msg: "You joined the Video Call")),
      onUserOffline: (connection, remoteUid, reason) {
        if (reason == UserOfflineReasonType.userOfflineQuit) {
          Fluttertoast.showToast(
              msg: "User with ID $remoteUid left the video call.");
        }
      },
      // onNetworkQuality: (connection, remoteUid, txQuality, rxQuality) { Fluttertoast.showToast(msg: "Network Quality: $txQuality, $rxQuality"); },
      onUserMuteAudio: (connection, remoteUid, muted) {
        if (muted == true) {
          Fluttertoast.showToast(
              msg: "User with ID $remoteUid muted their audio.");
        }
      },
      onUserMuteVideo: (connection, remoteUid, muted) {
        if (muted == true) {
          Fluttertoast.showToast(
              msg: "User with ID $remoteUid disabled their video.");
        }
      },
    ),
  );
  late bool _virtualBackgroundToggle;
  bool callAccepted = false;
  String imagePath = '';
  String? authToken = '';
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    initAgora();
    getPrefs();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    authToken = prefs.getString('authToken');
    // imagePath = await getAssetPath('background.png');
    // setState(() {
    //   print("Before Update1 $userCount");
    //   userCount = client.users.length + 1;
    //   print("After Update1 $userCount");
    // });
  }

  void initAgora() async {
    await client.initialize();

    // Call the virtual background setup method here
    if (!await client.engine
        .isFeatureAvailableOnDevice(FeatureType.videoVirtualBackground)) {
      return;
    } else {
      // await setVirtualBackground();
    }
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(bottom: 40, left: 10, right: 10),
          height: 170.0,
          child: GridView.count(
            crossAxisCount: 5,
            children: [
              _buildColorOption(0xFF0000), // Red
              _buildColorOption(0x00FF00), // Green
              _buildColorOption(0x0000FF), // Blue
              _buildColorOption(0xFFFF00), // Yellow
              _buildColorOption(0x800080), // Purple
              _buildColorOption(0xFFA500), // Orange
              _buildColorOption(0xFFC0CB), // Pink
              _buildColorOption(0xA52A2A), // Brown
              _buildColorOption(0x808080), // Grey
              _buildColorOption(0x00FFFF), // Cyan
            ],
          ),
        );
      },
    );
  }

  Widget _buildColorOption(int colorValue) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Close the color picker
        setColorBackground(colorValue); // Set the selected color as background
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: Color(0xFF000000 | colorValue), // Convert int to Color
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  void _showBackgroundPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.only(bottom: 40, left: 10, right: 10),
          height: 170.0,
          child: GridView.count(
            crossAxisCount: 3,
            children: [
              _buildImageOption('assets/background1.jpg'),
              _buildImageOption('assets/background2.jpg'),
              _buildImageOption('assets/background3.jpg'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImageOption(String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // Close the image picker
        // setImageBackground(imagePath); // Set the selected image as background
      },
      child: Container(
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Future<void> setBlurBackground() async {
    final virtualBackgroundSource = const VirtualBackgroundSource(
      backgroundSourceType: BackgroundSourceType.backgroundBlur,
      blurDegree: BackgroundBlurDegree.blurDegreeHigh,
    );

    final segmentationProperty = const SegmentationProperty(
      modelType: SegModelType.segModelAi,
      greenCapacity: 0.5,
    );

    // Enable or disable virtual background
    client.engine.enableVirtualBackground(
        enabled: true,
        backgroundSource: virtualBackgroundSource,
        segproperty: segmentationProperty);
  }

  Future<void> setColorBackground(int selectedColor) async {
    final virtualBackgroundSource = VirtualBackgroundSource(
      backgroundSourceType: BackgroundSourceType.backgroundColor,
      color: selectedColor, //0x0000FF,
    );

    final segmentationProperty = const SegmentationProperty(
      modelType: SegModelType.segModelAi,
      greenCapacity: 0.5,
    );

    // Enable or disable virtual background
    client.engine.enableVirtualBackground(
        enabled: true,
        backgroundSource: virtualBackgroundSource,
        segproperty: segmentationProperty);
  }

  Future<String> getAssetPath(String assetName) async {
    final byteData = await rootBundle.load('assets/$assetName');
    final file = File('${(await getTemporaryDirectory()).path}/$assetName');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  }

  Future<void> setImageBackground() async {
    final virtualBackgroundSource = VirtualBackgroundSource(
      backgroundSourceType: BackgroundSourceType.backgroundImg,
      source: imagePath,
    );

    final segmentationProperty = const SegmentationProperty(
      modelType: SegModelType.segModelAi,
      greenCapacity: 0.5,
    );

    // Enable or disable virtual background
    client.engine.enableVirtualBackground(
        enabled: true,
        backgroundSource: virtualBackgroundSource,
        segproperty: segmentationProperty);
  }

  Future<void> resetVirtualBackground() async {
    await client.engine.enableVirtualBackground(
      enabled: false,
      backgroundSource: const VirtualBackgroundSource(),
      segproperty: const SegmentationProperty(),
    );
  }

  setVirtualBackground() async {
    // Define the background source
    VirtualBackgroundSource backgroundSource = const VirtualBackgroundSource(
      backgroundSourceType: BackgroundSourceType.backgroundBlur,
      // source: "assets/welcome.png", // Path to your background image
      color:
          0xFFFFFF, // Optional: Set a background color if the source is a color
    );
    // Define segmentation properties if needed (optional)
    SegmentationProperty segproperty = const SegmentationProperty(
      modelType: SegModelType.segModelAi,
    );
    // Enable the virtual background
    await client.engine.enableVirtualBackground(
      enabled: true,
      backgroundSource: backgroundSource,
      segproperty: segproperty,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Group Video Call'),
        ),
        body: SafeArea(
            child: Stack(
          children: [
            AgoraVideoViewer(
              client: client,
              showNumberOfUsers: true,
              layoutType: Layout.grid, // For 1 or 2 users
            ),
            AgoraVideoButtons(
              client: client,
              enabledButtons: const [
                BuiltInButtons.toggleCamera,
                BuiltInButtons.callEnd,
                BuiltInButtons.toggleMic,
                BuiltInButtons.switchCamera,
              ],
              // extraButtons: [
              //   IconButton(
              //     icon: Icon(Icons.blur_on),
              //     onPressed: _showColorPicker,
              //     // onPressed: () {
              //     //   setImageBackground();
              //     // },
              //   ),
              // ],
            ),
          ],
        )),
      ),
    );
  }
}
