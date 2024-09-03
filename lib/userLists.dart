import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:videocall/accountList.dart';
import 'package:videocall/appManager.dart';
import 'package:videocall/constants.dart';
import 'package:videocall/styles.dart';

class UserLists extends StatefulWidget {
  final AppManager aapManager;
  final String title;
  const UserLists({
    Key? key,
    required this.aapManager,
    required this.title,
  }) : super(key: key);

  @override
  _UserListsState createState() => _UserListsState();
}

class _UserListsState extends State<UserLists> {
  late SharedPreferences prefs;
  int user_id = 0;
  bool _isLoading = false;
  List<UserLis?> myAccount = [];
  List<UserLis?> senderAccount = [];

  Future<void> getAccountData(int user_id) async {
    if (user_id != 0) {
      setState(() {
        _isLoading = true; // Start loading
      });
      final requestBody = {"": ""};
      widget.aapManager.apis
          .accountListing(requestBody, (prefs.getString('authToken') ?? ''))
          .then((response) {
        // Handle successful response
        if (response?.status == 200) {
          showToast(response?.message ?? '', 2, kToastColor, context);
          setState(() {
            myAccount = response?.accounts ?? [];
            senderAccount = response?.senderaccounts ?? [];
            _isLoading = false;
          });
        } else if (response.status == 201) {
          showToast(response?.message ?? '', 2, kToastColor, context);
        } else {
          print("Failed to get account list");
        }
      }).catchError((error) {
        // Handle error
        setState(() {
          _isLoading = false; // Stop loading
        });
        print("Failed to get account list: $error");
      });
    } else {
      showToast('Please enter user_id', 2, kToastColor, context);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrefs();
  }

  getPrefs() async {
    prefs = await SharedPreferences.getInstance();
    user_id = prefs.getInt('sId') ?? 0;
    getAccountData(user_id);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //    automaticallyImplyLeading: false,
      //   // title: Text('Sender and Receiver Lists'),
      // ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(), // Show loading indicator
            )
          : ListView(
              children: [
                // Sender Header
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     'Sender',
                //     style: TextStyle(
                //       color: kButtonColor,
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // Sender List
                ListView.builder(
                  shrinkWrap:
                      true, // Prevents the ListView from expanding infinitely
                  physics:
                      NeverScrollableScrollPhysics(), // Disable scrolling for this ListView
                  itemCount: senderAccount.length,
                  itemBuilder: (context, index) {
                    return _buildAccountCard(context, senderAccount[index]);
                  },
                ),
                // Receiver Header
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     'Receiver',
                //     style: TextStyle(
                //        color: kButtonColor,
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // Receiver List
                ListView.builder(
                  shrinkWrap:
                      true, // Prevents the ListView from expanding infinitely
                  physics:
                      NeverScrollableScrollPhysics(), // Disable scrolling for this ListView
                  itemCount: myAccount.length,
                  itemBuilder: (context, index) {
                    return _buildAccountCard(context, myAccount[index]);
                  },
                ),
              ],
            ),
    );
  }

  // Helper method to build account card
  Widget _buildAccountCard(BuildContext context, UserLis? account) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account?.account_name ?? '',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(account?.email ?? ''),
                SizedBox(height: 5),
                Text(account?.phone ?? ''),
              ],
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.blue),
              onPressed: () {
                // Handle plus icon tap here
                print('Plus icon tapped for ${account?.account_name}');
                print('Plus icon tapped for id ${account?.id}');
                Navigator.pop(context, {
                  'id': (account?.id ?? 0).toString(),
                  'name': account?.account_name ?? '',
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
