import 'package:shared_preferences/shared_preferences.dart';

class SettingsPreferences {
  String uri = 'none';

  SettingsPreferences(String uri) {
    this.uri = uri;
  }

  static Future<SettingsPreferences> getSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String uri = (prefs.getString('uri'));
    SettingsPreferences response = SettingsPreferences(uri);
    return response;
  }

  static Future applyFormUri(String uri) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString('uri', uri);
    //'key','value'
  }
}
