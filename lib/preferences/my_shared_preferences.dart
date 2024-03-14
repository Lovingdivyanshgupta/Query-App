import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  static Future<bool?> getUserDefault(String userLogin) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    bool? getBool = pref.getBool(userLogin);
    //print('pref.getBool : $getBool');
    return getBool;
  }

  static Future<bool?> setUserDefault(String userLogin, bool value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    bool? setBool = await pref.setBool(userLogin, value);
    //print('pref.setBool tab bar : $setBool');
    return setBool;
  }

  static void setStringUserDefault(String profileName , String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(profileName, value);
  }

  static Future<String?> getStringUserDefault(String profileName) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? getString = pref.getString(profileName);
    return getString;
  }


}
