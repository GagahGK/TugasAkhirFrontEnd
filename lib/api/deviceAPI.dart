import 'package:flutter/cupertino.dart';
import 'package:futurebuilder_example/page/settings_page.dart';

//import 'package:flutter/material.dart';
import 'package:futurebuilder_example/model/devices.dart';
import 'package:http/http.dart' as http;

final uriKey = GlobalKey<SettingsPageState>();
final GlobalKey<SettingsPageState> settingsKey = GlobalKey();
String url = 'https://2da6df8c4d15.ngrok.io/devices';
// final uri

class DeviceApi {
  static Future<List<Devices>> getDevices() async {
    final data = settingsKey.currentState.getText().toString();
    final response = await http.get(data);
    print(response.statusCode);

    if (response.statusCode == 200) {
      return devicesFromJson(response.body);
    } else {
      throw Exception('Failed to load devices');
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
