import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/UserModel.dart';
import '../utills/Utils.dart';

class UserPreferences {
  SharedPreferences? prefs;
  BuildContext? buildContext;
  String USER_LOGIN = "login_user";
  static String user_id = "id";
  static String access_token = "access_token";
  static String store_code = "store_code";

  UserPreferences(BuildContext buildContext) {
    this.buildContext = buildContext;
    getinstnace();
  }

  Future<SharedPreferences?> getinstnace() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
      return prefs;
    }
  }

  addStringValues(String key, String values) {
    final prefs = this.prefs;
    if (prefs != null) prefs.setString(key, values);
  }

  Future<String?> getStringValues(String key) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    //Return String
    return prefs?.getString(key);
  }



  setStringUserId(String key, String values) {
    if (prefs != null) prefs?.setString(key, values);
  }

  Future<String?> getStringUserId(String key) async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    return prefs?.getString(key);
  }



  addUserModelPrfernces(UserModel userModel) {
    if (prefs != null) prefs?.setString(USER_LOGIN, jsonEncode(userModel));
  }

  Future<UserModel?> getUserModel() async {
    prefs = await SharedPreferences.getInstance();
 // Utils().customPrint("Usernodel=="+prefs?.getString(USER_LOGIN));
 //    if(prefs?.getString(USER_LOGIN)??false){
 //     Map map = jsonDecode(prefs!.getString(this.USER_LOGIN));
 //       return UserModel.fromMap(map);
 //    }

    return null;
  }

  removeValues() async {
    if (prefs == null) prefs = await SharedPreferences.getInstance();
    prefs?.clear();
  }
}
