import 'dart:convert';

import 'package:chooshi/model/month.dart';
import 'package:chooshi/model/post.dart';
import 'package:chooshi/storage/prefs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final postStoreProvider = Provider<PostStore>((ref) {
  final prefs = ref.read(prefsProvider).prefs;
  return PostStore(prefs);
});

class PostStore {
  const PostStore(this._prefs);
  final SharedPreferences _prefs;

  String _keyByMonth({required int year, required int month}) {
    return 'posts_${year.toString() + month.toString()}';
  }

  void add(Post post) {
    final dt = post.timestamp;
    final key = _keyByMonth(year: dt.year, month: dt.month);
    final jsonList = _prefs.getStringList(key) ?? [];
    _prefs.setStringList(key, [jsonEncode(post), ...jsonList]);
  }

  List<Post> fetchByYearMonth(Month month) {
    final key = _keyByMonth(year: month.year, month: month.month);
    final jsonList = _prefs.getStringList(key);
    if (jsonList == null) {
      return [];
    }
    return jsonList.map((json) => Post.fromJson(jsonDecode(json))).toList();
  }

  void remove(Post post) {
    final dt = post.timestamp;
    final month = Month(year: dt.year, month: dt.month);
    final list = fetchByYearMonth(month);
    list.remove(post);
    final key = _keyByMonth(year: month.year, month: month.month);
    _prefs.setStringList(key, list.map((post) => jsonEncode(post)).toList());
    return;
  }

  void update(Post oldPost, Post newPost) {
    final dt = oldPost.timestamp;
    final month = Month(year: dt.year, month: dt.month);
    final list = fetchByYearMonth(month);
    final index = list.indexWhere((p) => p.timestamp == oldPost.timestamp);
    if (index != -1) {
      list[index] = newPost;
      final key = _keyByMonth(year: month.year, month: month.month);
      _prefs.setStringList(key, list.map((post) => jsonEncode(post)).toList());
    }
  }
}
