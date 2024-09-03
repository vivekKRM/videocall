import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';
import 'package:videocall/accountList.dart';
import 'package:videocall/appManager.dart';
import 'package:videocall/default.dart';
import 'package:videocall/registerR.dart';

class Apis {
  AppManager appManager;

  Apis(this.appManager);

  //Forgot Password
  Future<DefaultResponse> sendPostRequest(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/register';
    var response = await http.post(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
        },
        // "Authorization": "Bearer $bearerToken",
        body: jsonEncode(requestBody));
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    DefaultResponse profileResp = DefaultResponse.fromJson(jsonResponse);
    return profileResp;
  }

  Future<AccountLists> accountListing(
      Map<String, dynamic> requestBody, String bearerToken) async {
    final String apiUrl = '${appManager.serverURL}/receivers';
    var response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $bearerToken",
      },
    );
    print('uriResponse ${response.body}');
    final jsonResponse = jsonDecode(response.body);
    AccountLists profileResp = AccountLists.fromJson(jsonResponse);
    return profileResp;
  }

  
}
