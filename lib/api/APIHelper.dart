import 'package:futurebuilder_example/api/settingPreferences.dart';

//import 'package:flutter/material.dart';
import 'package:futurebuilder_example/model/devices.dart';
import 'package:http/http.dart' as http;

class DeviceApi {
  static Future<List<Devices>> getDevices() async {
    SettingsPreferences sp = await SettingsPreferences.getSettings();
    String uri = sp.uri ?? 'localhost';
    try {
      var response = await http.get(uri + "/devices");
      print(uri);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print(response.body);
        return devicesFromJson(response.body);
      } else {
        throw Exception('Failed to load devices');
      }
    } on ArgumentError catch (e) {
      return Future.error("Please Provide correct API URL");
    }

    //get from local
    // static Future<List<User>> getUsersLocally(BuildContext context) async {
    //   final assetBundle = DefaultAssetBundle.of(context);
    //   final data = await assetBundle.loadString('assets/users.json');
    //   final body = json.decode(data);

    //   return body.map<User>(User.fromJson).toList();
    // }
  }

  // =======================================================
  // Static Method untuk dapetin record dari api uri/records
  // To be replaced with getRecord() from RecordAPI class
  // =======================================================
  static Future<Devices> getDeviceRecord(int deviceId) async {
    SettingsPreferences sp = await SettingsPreferences.getSettings();
    String uri = sp.uri ?? 'localhost';
    try {
      var response = await http.get(uri + "$deviceId" + "/records");
      print(uri);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print(response.body);
        return deviceFromJson(response.body);
      } else {
        throw Exception('Failed to load devices');
      }
    } on ArgumentError catch (e) {
      return Future.error("Please Provide correct API URL");
    }
  }
}

class RecordAPI {
  static Future<List<Record>> getRecord(
      int deviceId, DateTime dateStart) async {
    SettingsPreferences sp = await SettingsPreferences.getSettings();
    String uri = sp.uri ?? 'localhost';
    DateTime dateStart00 = returnDate(dateStart);
    DateTime dateEnd00 = dateStart00.add(Duration(days: 1));
    try {
      var response = await http.get(uri +
          "$deviceId" +
          "/records" +
          "/${dateStart00.toIso8601String()}" +
          "/${dateEnd00.toIso8601String()}");
      print(uri);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print(response.body);
        return recordsFromJson(response.body);
      } else {
        throw Exception('Failed to load devices');
      }
    } on ArgumentError catch (e) {
      return Future.error("Please Provide correct API URL");
    }
  }
}

DateTime returnDate(DateTime date) {
  date = date.subtract(Duration(
      hours: date.hour,
      minutes: date.minute,
      seconds: date.second,
      milliseconds: date.millisecond,
      microseconds: date.microsecond));
  return date;
}
