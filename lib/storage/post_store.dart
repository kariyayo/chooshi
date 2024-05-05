import 'dart:convert';

import 'package:chooshi/model/month.dart';
import 'package:chooshi/model/post.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostStore {
  Future<void> add(Post post) async {
    final dt = post.timestamp;
    final key = 'posts_${dt.year.toString() + dt.month.toString()}';
    print('add: $key');
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(key) ?? [];
    await prefs.setStringList(key, [jsonEncode(post), ...jsonList]);
    return;
  }

  Future<List<Post>> fetchByYearMonth(Month month) async {
    final key = 'posts_${month.year.toString() + month.month.toString()}';
    print('fetch: $key');
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(key);
    if (jsonList == null) {
      return [];
    }
    return jsonList.map((json) => Post.fromJson(jsonDecode(json))).toList();
  }
}
