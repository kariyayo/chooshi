import 'dart:convert';

import 'package:chooshi/model/month.dart';
import 'package:chooshi/model/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostStore {
  String _keyByMonth({required int year, required int month}) {
    return 'posts_${year.toString() + month.toString()}';
  }

  Future<void> add(Post post) async {
    final dt = post.timestamp;
    final key = _keyByMonth(year: dt.year, month: dt.month);
    print('add: $key');
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(key) ?? [];
    await prefs.setStringList(key, [jsonEncode(post), ...jsonList]);
    return;
  }

  Future<List<Post>> fetchByYearMonth(Month month) async {
    final key = _keyByMonth(year: month.year, month: month.month);
    print('fetch: $key');
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(key);
    if (jsonList == null) {
      return [];
    }
    return jsonList.map((json) => Post.fromJson(jsonDecode(json))).toList();
  }

  Future<void> remove(Post post) async {
    final dt = post.timestamp;
    final month = Month(year: dt.year, month: dt.month);
    final list = await fetchByYearMonth(month);
    list.remove(post);
    _put(month, list);
    return;
  }

  Future<void> _put(Month month, List<Post> data) async {
    final key = _keyByMonth(year: month.year, month: month.month);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(key, data.map((post) => jsonEncode(post)).toList());
    return;
  }
}
