import 'dart:convert';

//import 'package:flutter/material.dart';
import 'package:futurebuilder_example/model/devices.dart';
import 'package:http/http.dart' as http;

final url = 'https://2da6df8c4d15.ngrok.io/devices';

class DeviceApi {
  static Future<List<Devices>> getDevices() async {
    final response = await http.get(url);
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
