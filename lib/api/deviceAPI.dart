import 'package:flutter/cupertino.dart';
import 'package:futurebuilder_example/api/settingPreferences.dart';

//import 'package:flutter/material.dart';
import 'package:futurebuilder_example/model/devices.dart';
import 'package:http/http.dart' as http;

class DeviceApi {
  static Future<List<Devices>> getDevices() async {
    SettingsPreferences sp = await SettingsPreferences.getSettings();
    String uri = sp.uri ?? 'localhost';
    try {
      var response = await http.get(uri);
      print(uri);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print(response.body);
        return devicesFromJson(response.body);
      } else {
        throw Exception('Failed to load devices');
      }
    } on ArgumentError catch (e) {
      return Future.error("asdasd");
    }

    //get from local
    // static Future<List<User>> getUsersLocally(BuildContext context) async {
    //   final assetBundle = DefaultAssetBundle.of(context);
    //   final data = await assetBundle.loadString('assets/users.json');
    //   final body = json.decode(data);

    //   return body.map<User>(User.fromJson).toList();
    // }
  }
}
