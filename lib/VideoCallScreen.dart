import 'dart:convert';
import 'dart:io';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:agora_uikit/controllers/rtc_buttons.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videocall/appManager.dart';
import 'package:videocall/constants.dart';
import 'package:videocall/default.dart';
import 'package:http/http.dart' as http;
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:videocall/userLists.dart';

class VideoCallScreen extends StatefulWidget {
  final bool isRemoteVideoEnabled;
  final bool isRemoteMuted;
  final bool isIncomingCall;
  final AppManager aapManager;
  final String type;
  final String senderID;
  final String isGroup;
  const VideoCallScreen(
      {Key? key,
      required this.isRemoteVideoEnabled,
      required this.isRemoteMuted,
      required this.isIncomingCall,
      required this.aapManager,
      required this.type,
      required this.senderID,
      required this.isGroup})
      : super(key: key);

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  late AgoraClient client;
  late bool _virtualBackgroundToggle;
  bool callAccepted = false;
  int userCount = 0;
  int userId = 0;
  bool isReject = false;
  String agoraToken = '';
  String imagePath = '';
  bool isVideoOff = true;
  String? authToken = '';
  bool isFinish = false;
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    isVideoOff = !widget.isRemoteVideoEnabled;
    getPrefs();
  }

  @override
  void dispose() {
    // destroy sdk
    client.engine.leaveChannel();
    client.engine.stopPreview();
    client.engine.release();
    super.dispose();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    imagePath = await getAssetPath('background.png');
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
          appId: "7b44607b1a1149d59805b360cf4b47dc",
          channelName: "flutter",
          tempToken: prefs.getString('agoraToken') ?? '',
          uid: prefs.getInt('sId') ?? 0),
      enabledPermission: [
        Permission.camera,
        Permission.microphone,
      ],
      agoraEventHandlers: AgoraRtcEventHandlers(
        onUserJoined: (connection, remoteUid, elapsed) {
          Fluttertoast.showToast(msg: "You joined the Video Call");
          setState(() {
            userCount += 1;
          });
        },

        onUserOffline: (connection, remoteUid, reason) {
          if (reason == UserOfflineReasonType.userOfflineQuit) {
            Fluttertoast.showToast(
                msg: "User with ID $remoteUid left the video call.");
            setState(() {
              userCount -= 1;
            });
            print('User Count Decrement $userCount');
            if (isReject == false && userCount == 0) {
              client.engine.leaveChannel();
              client.engine.stopPreview();
              client.engine.release();
              client.engine.stopChannelMediaRelay();
              Navigator.pop(context);
            }
          } else if (reason == UserOfflineReasonType.userOfflineDropped) {
            Fluttertoast.showToast(
                msg: "User with ID $remoteUid dropped the video call.");
            setState(() {
              userCount -= 1;
            });
            print('User Count Decrement $userCount');
            if (isReject == false && userCount == 0) {
              client.engine.leaveChannel();
              client.engine.stopPreview();
              client.engine.release();
              client.engine.stopChannelMediaRelay();
              Navigator.pop(context);
            }
          }
        },
        onError: (ErrorCodeType code, value) {
          if (code == ErrorCodeType.errTokenExpired) {
            print('Token expired. Fetching a new token...');
          } else if (code == ErrorCodeType.errInvalidToken) {
            print('Token Invalid. Fetching a new token...');
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
    await client.initialize();
    initAgora();
    setState(() {
      isFinish = true;
    });
  }

  Future<void> acceptCall() async {
    client.sessionController.updateUserVideo(
      uid: client.agoraConnectionData.uid ?? 0,
      videoDisabled: !isVideoOff,
    );
    // Mute or unmute local video stream
    await client.sessionController.value.engine
        ?.muteLocalVideoStream(!isVideoOff);

    setState(() {
      //   print("Before Update2 $userCount");
      //   userCount = client.users.length + 1;
      //   print("After Update2 $userCount");
      callAccepted = true;
    });
  }

  void rejectCall() {
    if (widget.type == 'Receiver') cutCall();
  }

  //Call Decline Notfication
  Future<DefaultResponse> sendPushNotificationDecline(
      Map<String, dynamic> requestBody) async {
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

  Future<void> cutCall() async {
    String? name = prefs.getString('name');

    final requestBody = {
      "type": 'sender',
      "message": '$name has rejected your call',
      "id": widget.senderID,
      'user_id': prefs.getInt('sId') ?? 0,
      'group': widget.isGroup,
      'agora': agoraToken
    };
    sendPushNotificationDecline(
      requestBody,
    ).then((response) async {
      // Handle successful response
      if (response?.status == 200) {
        showToast(response?.message ?? '', 2, Color(0xFFD14D4D), context);
        client.engine.leaveChannel();
        client.engine.stopPreview();
        client.engine.release();
        client.engine.stopChannelMediaRelay();
        setState(() {
          isReject = true;
        });
        Navigator.pop(context);
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

  Widget buildIncomingCallUI() {
    return Stack(
      children: [
        // Main content with buttons at the bottom
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Accept',
                      onPressed: () async {
                        bool isConnected =
                            await ConnectivityUtils.checkConnectivity();
                        if (isConnected) {
                          acceptCall();
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
                  ),
                  SizedBox(
                      width: 10), // Add some spacing between buttons if needed
                  Expanded(
                    child: CustomButton(
                      text: 'Reject',
                      onPressed: () async {
                        bool isConnected =
                            await ConnectivityUtils.checkConnectivity();
                        if (isConnected) {
                          rejectCall();
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
                  ),
                ],
              )
            ],
          ),
        ),

        // Video Off container in the top-right corner
        if (isVideoOff &&
            widget.isGroup ==
                "0") // Ensure this condition is set based on your logic
          Positioned(
            top: 7.0,
            right: -16.0,
            child: Container(
              width: 170.0, // Fixed width
              height: 160.0, // Fixed height
              padding: EdgeInsets.all(8.0),
              color: Colors.black,
              child: const Center(
                child: Text(
                  'Video Off',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }

  void initAgora() async {
    if (widget.isIncomingCall == true) {
      // client.sessionController.updateUserVideo(
      //   uid: client.agoraConnectionData.uid ?? 0,
      //   videoDisabled: !widget.isRemoteVideoEnabled,
      // );

      client.sessionController.updateUserAudio(
        uid: client.agoraConnectionData.uid ?? 0,
        muted: !widget.isRemoteMuted,
      );
      isVideoOff = !client.sessionController.value.isLocalVideoDisabled;
      print("Is Video Off ${isVideoOff}");

      // client.sessionController.value.copyWith(
      //     isLocalVideoDisabled:
      //         !(client.sessionController.value.isLocalVideoDisabled));
      // await client.sessionController.value.engine?.muteLocalVideoStream(
      //     client.sessionController.value.isLocalVideoDisabled);

      client.sessionController.value.copyWith(
          isLocalUserMuted: !(client.sessionController.value.isLocalUserMuted));
      await client.sessionController.value.engine?.muteLocalAudioStream(
          client.sessionController.value.isLocalUserMuted);

      client.sessionController.updateUserVideo(
        uid: client.agoraConnectionData.uid ?? 0,
        videoDisabled: !isVideoOff,
      );
      // Mute or unmute local video stream
      await client.sessionController.value.engine
          ?.muteLocalVideoStream(isVideoOff);
    }

    // Call the virtual background setup method here
    if (!await client.engine
        .isFeatureAvailableOnDevice(FeatureType.videoVirtualBackground)) {
      return;
    } else {
      if (widget.isGroup == "0") await setVirtualBackground();
    }

    setState(() {
      agoraToken = prefs.getString('agoraToken') ?? '';
      authToken = prefs.getString('authToken');
      userId = prefs.getInt('sId') ?? 0;
      isFinish = true;
    });
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

  void _handleUserListsReturn(Map<String, String> data) {
    print('User returned from UserLists');
    String id = data['id'] ?? '';
    String name = data['name'] ?? ''; // Extract other values as needed
    callUser(name, id);
  }

  Future<void> callUser(String name, String id) async {
    Map<String, dynamic> requestBody = {
      "type": 'receiver',
      "message": '$name is calling',
      'id': id,
      'user_id': prefs.getInt('sId') ?? 0,
      'group': widget.isGroup,
      'agora': prefs.getString('agoraToken') ?? ''
    };
    callSend(
      requestBody,
    ).then((response) async {
      // Handle successful response
      if (response?.status == 200) {
        showToast(response?.message ?? '', 2, Color(0xFFD14D4D), context);
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
    if (isFinish) print('UpdateUserCount $userCount');
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Video Call'),
          actions: [
            widget.isGroup ==
                    "1" //widget.type == 'Sender' && modified on 29 Aug
                ? IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () async {
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
                                  Navigator.of(context)
                                      .pop(); // Close the dialog
                                },
                                child: Text('Cancel'),
                              ),
                            ],
                          );
                        },
                      );

                      if (result != null) {
                        // Navigator.of(context).pop();
                        _handleUserListsReturn(result);
                        print('Call Now Button Tap');
                      }
                    },
                    tooltip: 'Add Users',
                  )
                : Container(),
          ],
        ),
        body: SafeArea(
            child: isFinish && widget.isGroup == '0'
                ? Stack(
                    children: [
                      AgoraVideoViewer(
                        client: client,
                        showNumberOfUsers: true,
                        layoutType: Layout.oneToOne, // For 1 or 2 users
                      ),
                      callAccepted
                          ? AgoraVideoButtons(
                              client: client,
                              enabledButtons: const [
                                BuiltInButtons.toggleCamera,
                                BuiltInButtons.callEnd,
                                BuiltInButtons.toggleMic,
                                // BuiltInButtons.switchCamera,
                              ],
                              extraButtons: [
                                IconButton(
                                  icon: Icon(Icons.blur_on),
                                  // onPressed: _showColorPicker,
                                  onPressed: () {
                                    setImageBackground();
                                  },
                                ),
                              ],
                            )
                          : Center(
                              child: widget.isIncomingCall
                                  ? buildIncomingCallUI()
                                  : AgoraVideoButtons(
                                      client: client,
                                      enabledButtons: const [
                                        BuiltInButtons
                                            .toggleCamera, //Uncomment It
                                        BuiltInButtons.callEnd,
                                        BuiltInButtons.toggleMic,
                                        // BuiltInButtons.switchCamera,
                                      ],
                                      extraButtons: [
                                        IconButton(
                                          icon: Icon(Icons.blur_on),
                                          // onPressed: _showColorPicker,
                                          onPressed: () {
                                            setImageBackground();
                                          },
                                        ),
                                      ],
                                    ),
                            ),
                    ],
                  )
                : isFinish
                    ?
//Group Call
                    Stack(
                        children: [
                          AgoraVideoViewer(
                            client: client,
                            showNumberOfUsers: true,
                            layoutType: Layout.grid, // For 1 or 2 users
                          ),
                          callAccepted
                              ? AgoraVideoButtons(
                                  client: client,
                                  enabledButtons: const [
                                    BuiltInButtons.toggleCamera,
                                    BuiltInButtons.callEnd,
                                    BuiltInButtons.toggleMic,
                                    // BuiltInButtons.switchCamera,
                                  ],
                                  extraButtons: [
                                    IconButton(
                                      icon: Icon(Icons.blur_on),
                                      // onPressed: _showColorPicker,
                                      onPressed: () {
                                        setImageBackground();
                                      },
                                    ),
                                  ],
                                )
                              : Center(
                                  child: widget.isIncomingCall
                                      ? buildIncomingCallUI()
                                      : AgoraVideoButtons(
                                          client: client,
                                          enabledButtons: const [
                                            BuiltInButtons
                                                .toggleCamera, //Uncomment It
                                            BuiltInButtons.callEnd,
                                            BuiltInButtons.toggleMic,
                                            // BuiltInButtons.switchCamera,
                                          ],
                                          extraButtons: [
                                            IconButton(
                                              icon: Icon(Icons.blur_on),
                                              // onPressed: _showColorPicker,
                                              onPressed: () {
                                                setImageBackground();
                                              },
                                            ),
                                          ],
                                        ),
                                ),
                        ],
                      )
                    : Container()),
      ),
    );
  }
}
