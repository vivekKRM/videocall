import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videocall/appManager.dart';
import 'package:videocall/constants.dart';
import 'package:videocall/login.dart';
import 'package:videocall/styles.dart';

class Register extends StatefulWidget {
  Register({
    Key? key,
    required this.title,
    required this.appManager,
  }) : super(key: key);

  final String title;
  final AppManager appManager;

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String email = '';
  String password = '';
  String token = '';
  bool loginError = false;
  bool obscureText = true;
  bool obscureText1 = true;
  late FToast fToast;
  late SharedPreferences prefs;
  String selectedRole = 'Sender';
  List<String> texts = [
    'Name',
    'Email',
    'Phone Number',
    'Password',
    'Confirm Password',
  ];

  List<bool> isError = [
    false,
    false,
    false,
    false,
    false,
  ];

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _cpasswordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  Future<void> registerUser() async {
    final requestBody = {
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _mobileController.text,
      "password": _passwordController.text,
      "type": selectedRole.toLowerCase()
    };
    widget.appManager.apis
        .sendPostRequest(requestBody, (prefs.getString('authToken') ?? ''))
        .then((response) {
      // Handle successful response
      if (response.status == 200) {
        showToast(response?.message ?? '', 2, kToastColor, context);
        Navigator.pop(context);
      } else if (response.status == 201) {
        showToast(response?.message ?? '', 2, kToastColor, context);
      } else {
        print("Failed to register");
        showToast(response?.message ?? '', 2, kToastColor, context);
      }
    }).catchError((error) {
      // Handle error
      print("Failed to fregister: $error");
    });
  }

  bool isValidForm() {
    final validMobileNumber = RegExp(r'^[0-9]+$');
    isError.clear();
    isError = [
      false,
      false,
      false,
      false,
      false,
    ];
    // Email regex pattern
    final emailPattern = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (_nameController.text == '') {
      showToast('Name can not be empty', 2, kToastColor, context);
      setState(() {
        isError[0] = true;
      });
      return false;
    } else if (!emailPattern.hasMatch(_emailController.text)) {
      showToast(
          'Please provide a valid email address.', 2, kToastColor, context);
      setState(() {
        isError[1] = true;
      });
      return false;
    } else if (_mobileController.text != '') {
      if (!validMobileNumber.hasMatch(_mobileController.text)) {
        showToast(
            'Please enter valid phone number.', 2, kToastColor, this.context);
        setState(() {
          isError[2] = true;
        });
        return false;
      } else if (_mobileController.text.length < 10) {
        showToast('Please enter 10 digit phone number.', 2, kToastColor,
            this.context);
        setState(() {
          isError[2] = true;
        });
        return false;
      }
      return true;
    } else if (_passwordController.text == '') {
      showToast('Password field cannot be empty.', 2, kToastColor, context);
      setState(() {
        isError[3] = true;
      });
      return false;
    } else if (_passwordController.text.contains(' ')) {
      showToast('Password must not contain spaces.', 2, kToastColor, context);
      setState(() {
        isError[3] = true;
      });
      return false;
    } else if (_passwordController.text.length < 6) {
      showToast(
          'Password must be at least 6 characters.', 2, kToastColor, context);
      setState(() {
        isError[3] = true;
      });
      return false;
    } else if (_cpasswordController.text == '') {
      showToast(
          'Confirm password field cannot be empty.', 2, kToastColor, context);
      setState(() {
        isError[4] = true;
      });
      return false;
    } else if (_cpasswordController.text.contains(' ')) {
      showToast(
          'Confirm Password must not contain spaces.', 2, kToastColor, context);
      setState(() {
        isError[4] = true;
      });
      return false;
    } else if (_cpasswordController.text.length < 6) {
      showToast('Comfirm password must be at least 6 characters.', 2,
          kToastColor, context);
      setState(() {
        isError[4] = true;
      });
      return false;
    } else if (_passwordController.text != _cpasswordController.text) {
      showToast('Password and confirm password do not match.', 2, kToastColor,
          context);
      setState(() {
        isError[4] = true;
        isError[3] = true;
      });
      return false;
    } else {
      print("Proceed");
      FocusScope.of(context).unfocus();
      return true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // this.jumpToHomeIfRequired();
    fToast = FToast();
    getPrefs();
    fToast.init(context);
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        // Disable back button
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kAppBarColor,
          surfaceTintColor: kAppBarColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white, // Make container transparent
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Sign up', style: kLoginTextStyle),
                        SizedBox(height: 20),
                        Text(
                          "Create your account to get started .",
                          style: kObsText,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 22),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Sender Radio Button
                            Radio<String>(
                              value: 'Sender',
                              groupValue: selectedRole,
                              onChanged: (String? value) {
                                // prefs.remove('firebaseToken');
                                 setState(() {
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
                                 setState(() {
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
                        Container(
                          color: Colors.white,
                          height: size.height * 0.6,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: texts.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 14, horizontal: 15),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: kLoginTextFieldFillColor,
                                        border: isError[index]
                                            ? Border.all(color: Colors.red)
                                            : Border.all(
                                                color:
                                                    kLoginTextFieldFillColor),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            index == 3 || index == 4
                                                ? Icons.lock_open_outlined
                                                : index == 1
                                                    ? Icons.email_outlined
                                                    : index == 2
                                                        ? Icons.phone
                                                        : Icons.verified_user,
                                            size: 20,
                                            color: kLoginIconColor,
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: TextFormField(
                                              inputFormatters:  index == 2 ?[
            FilteringTextInputFormatter.digitsOnly, // Only allows numeric input
            LengthLimitingTextInputFormatter(10), // Restricts the length to 10 characters
          ] : [LengthLimitingTextInputFormatter(100)],
                                              keyboardType: index == 1
                                                  ? TextInputType.emailAddress
                                                  : TextInputType.name,
                                              controller: index == 0
                                                  ? _nameController
                                                  : index == 1
                                                      ? _emailController
                                                      : index == 2
                                                          ? _mobileController
                                                          : index == 3
                                                              ? _passwordController
                                                              : _cpasswordController,
                                              obscureText: index == 3
                                                  ? obscureText
                                                  : index == 4
                                                      ? obscureText1
                                                      : false,
                                              onTapAlwaysCalled: true,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                isDense: true,
                                                hintText: '${texts[index]}',
                                                hintStyle:
                                                    kLoginTextFieldTextStyle,
                                              ),
                                              onFieldSubmitted: (value) {
                                                setState(() {
                                                  index == 0
                                                      ? _nameController.text =
                                                          value
                                                      : index == 1
                                                          ? _emailController
                                                              .text = value
                                                          : index == 2
                                                              ? _mobileController
                                                                  .text = value
                                                              : index == 3
                                                                  ? _passwordController
                                                                          .text =
                                                                      value
                                                                  : index == 4
                                                                      ? _cpasswordController
                                                                              .text =
                                                                          value
                                                                      : null;
                                                });
                                              },
                                            ),
                                          ),
                                          index == 3
                                              ? GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      obscureText =
                                                          !obscureText;
                                                    });
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            0.0),
                                                    child: Icon(
                                                      obscureText
                                                          ? Icons.visibility
                                                          : Icons
                                                              .visibility_off,
                                                      color: kButtonColor,
                                                    ),
                                                  ),
                                                )
                                              : index == 4
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          obscureText1 =
                                                              !obscureText1;
                                                        });
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(0.0),
                                                        child: Icon(
                                                          obscureText1
                                                              ? Icons.visibility
                                                              : Icons
                                                                  .visibility_off,
                                                          color: kButtonColor,
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 30, top: 20),
                          child: CustomButton(
                            text: 'Sign up',
                            onPressed: () async {
                              bool isConnected =
                                  await ConnectivityUtils.checkConnectivity();
                              if (isConnected) {
                                if (isValidForm()) {
                                  registerUser();
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
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
