import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{
  static SharedPreferences? _preferences;

  static Future<void> setPrefsInstance() async{
    if(_preferences == null){
      _preferences = await SharedPreferences.getInstance();
    }
  }

  static Future<void> setUid() async{

  }
}