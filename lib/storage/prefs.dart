import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final prefsProvider = Provider<Prefs>((ref) {
  return Prefs();
});

class Prefs {
  late final SharedPreferences _prefs;

  void init(SharedPreferences prefs) {
    _prefs = prefs;
  }

  SharedPreferences get prefs => _prefs;
}
