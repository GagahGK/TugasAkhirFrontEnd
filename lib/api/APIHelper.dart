import 'package:futurebuilder_example/api/settingPreferences.dart';

//import 'package:flutter/material.dart';
import 'package:futurebuilder_example/model/devices.dart';
import 'package:futurebuilder_example/model/cluster.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class DeviceApi {
  static Future<List<Device>> getDevices() async {
    SettingsPreferences? sp = await SettingsPreferences.getSettings();
    String uri = sp?.uri ?? 'localhost';
    try {
      var response = await http.get(Uri.parse(uri + "/devices"));
      print(response.statusCode);

      if (response.statusCode == 200) {
        // print(response.body);
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
  static Future<Device> getDeviceRecord(int deviceId) async {
    SettingsPreferences? sp = await SettingsPreferences.getSettings();
    String uri = sp?.uri ?? 'localhost';
    try {
      var response = await http.get(Uri.parse(uri + "/$deviceId" + "/records"));
      print(response.statusCode);

      if (response.statusCode == 200) {
        print("get records");
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
      int? deviceId, DateTime dateStart) async {
    SettingsPreferences? sp = await SettingsPreferences.getSettings();
    String uri = sp?.uri ?? 'http://localhost:8000';
    DateTime dateStart00 = returnDate00(dateStart);
    DateTime dateEnd00 = dateStart00.add(Duration(days: 1));
    try {
      String request = "/devices" +
          "/$deviceId" +
          "/records" +
          "/${dateStart00.toIso8601String()}" +
          "/${dateEnd00.toIso8601String()}";
      print(uri + request);
      var response = await http.get(Uri.parse(uri + request));
      print(uri);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print(response.body);
        return recordsFromJson(response.body);
      } else if (response.statusCode == 404) {
        return Future.error("Data tidak tersedia silahkan pilih tanggal lain");
      } else {
        throw Exception('Failed to load devices');
      }
    } on ArgumentError catch (e) {
      return Future.error("Please Provide correct API URL");
    }
  }
}

DateTime returnDate00(DateTime date) {
  //return date to 00
  //example date = 2020-12-12T12:32:12:23Z
  //returned date = 2020-12-12T00:00:00:00Z
  date = date.subtract(Duration(
      hours: date.hour,
      minutes: date.minute,
      seconds: date.second,
      milliseconds: date.millisecond,
      microseconds: date.microsecond));
  return date;
}

class ClusterAPI {
  static List categoryList = ['hourly', 'daily', 'monthly', 'devices'];
  static Future<List<Cluster>> getCluster(
      int category, DateTime dateStart, DateTime dateEnd, int? deviceId) async {
    String responseAddress;
    SettingsPreferences? sp = await SettingsPreferences.getSettings();
    String uri = sp?.uri ?? 'http://localhost:8000';
    // String categoryName = categoryList[category];

    final String payload = "/devices" +
        "/$deviceId" +
        "/cluster" +
        "/${categoryList[category]}" +
        "/${DateFormat("yyyy-MM-dd").format(dateStart)}" +
        "/${DateFormat("yyyy-MM-dd").format(dateEnd)}";
    responseAddress = uri + payload;

    print(responseAddress);
    try {
      var response = await http.get(Uri.parse(responseAddress));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        return clustersFromJson(response.body);
      } else if (response.statusCode == 404) {
        return Future.error("Data not available try selecting other dates");
      } else if (response.statusCode == 400) {
        return Future.error("${response.body}");
      } else {
        throw Exception('Failed to load cluster');
      }
    } on ArgumentError catch (e) {
      return Future.error("Please Provide correct API URL");
    }
  }

  static Future<List<Cluster>> getDevicesCluster(
      {DateTime? dateStart, DateTime? dateEnd}) async {
    SettingsPreferences? sp = await SettingsPreferences.getSettings();
    String uri = sp?.uri ?? 'http://localhost:8000';
    String responseAddress = uri;
    if (dateStart == null || dateEnd == null) {
      final String payload = "/devices/cluster/";
      responseAddress = uri + payload;
      print(responseAddress);
    } else {
      final String payload =
          "/devices/cluster/${DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateStart)}/${DateFormat("yyyy-MM-ddTHH:mm:ss").format(dateEnd)}";
      responseAddress = uri + payload;
      print(responseAddress);
    }
    try {
      var response = await http.get(Uri.parse(responseAddress));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print(response.body);
        return clustersFromJson(response.body);
      } else if (response.statusCode == 404) {
        return Future.error("Data not available try selecting other dates");
      } else if (response.statusCode == 400) {
        return Future.error("${response.body}");
      } else {
        throw Exception('Failed to load cluster');
      }
    } on ArgumentError catch (e) {
      return Future.error("Please Provide correct API URL");
    }
  }

  // Gatau buat apa awoekawoek gajadi dipake
  // todo getCluster
  static Future<List<Cluster>> getClusterDaily(
      int deviceId, DateTime dateStart, int categoryId) async {
    SettingsPreferences? sp = await SettingsPreferences.getSettings();
    String uri = sp?.uri ?? 'http://localhost:8000';
    DateTime dateStart00 = returnDate00(dateStart);
    DateTime dateEnd00 = dateStart00.add(Duration(days: 7));
    final String category = "daily";
    // ================================================
    // unused asalnya buat di halaman record list
    // if (categoryId == 0) {
    //   //Weekly
    //   dateEnd00 = dateStart00.add(Duration(days: 7));
    // } else {
    //   //Monthly
    //   dateEnd00 =
    //       DateTime(dateStart00.year, dateStart00.month + 1, dateStart00.day);
    // }
    // ================================================
    try {
      String request = "/devices" +
          "/$deviceId" +
          "/cluster" +
          "/$category" +
          "/${dateStart00.toIso8601String()}" +
          "/${dateEnd00.toIso8601String()}";
      print(uri + request);
      var response = await http.get(Uri.parse(uri + request));
      print(uri);
      print(response.statusCode);

      if (response.statusCode == 200) {
        print(response.body);
        return clustersFromJson(response.body);
      } else if (response.statusCode == 404) {
        return Future.error("Data not available try selecting other date");
      } else {
        throw Exception('Failed to load cluster');
      }
    } on ArgumentError catch (e) {
      return Future.error("Please Provide correct API URL");
    }
  }
}
