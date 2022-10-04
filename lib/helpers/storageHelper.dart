import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? _prefs;
Future<SharedPreferences> getPrefs()async => _prefs??await SharedPreferences.getInstance();