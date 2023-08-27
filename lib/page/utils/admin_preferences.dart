import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sub_mgmt/page/model/admin.dart';

import '../../login/provider/auth_provider.dart';

class AdminPreferences {
  static late SharedPreferences _preferences;
  static const _keyAdmin = 'admin';
  static const myAdmin = Admin(
    imagePath: "assets/images/dummyfood.jpg",
    name: 'Yes Sir',
    email: 'yessirmess@gmail.com',
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setAdmin(Admin admin) async {
    final json = jsonEncode(admin.toJson());

    await _preferences.setString(_keyAdmin, json);
  }

  static Admin getAdmin() {
    final json = _preferences.getString(_keyAdmin);

    return json == null ? myAdmin : Admin.fromJson(jsonDecode(json));
  }
}