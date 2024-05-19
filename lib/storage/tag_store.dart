import 'dart:convert';

import 'package:chooshi/model/tag_detail.dart';
import 'package:chooshi/storage/prefs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final tagDetailStoreProvider = Provider<TagDetailStore>((ref) {
  final prefs = ref.read(prefsProvider).prefs;
  return TagDetailStore(prefs);
});

class TagDetailStore {
  const TagDetailStore(this._prefs);
  final SharedPreferences _prefs;

  String _key({required String tagLabel}) {
    return 'tags_$tagLabel';
  }

  TagDetail? fetch(String tag) {
    final key = _key(tagLabel: tag);
    final json = _prefs.getString(key);
    if (json == null) {
      return null;
    }
    return TagDetail.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  void add(String tag, int rating) {
    final key = _key(tagLabel: tag);
    final json = _prefs.getString(key);
    final TagDetail newTagDetail;
    if (json == null) {
      final ratings = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};
      ratings[rating] = 1;
      newTagDetail = TagDetail(
        label: tag,
        count: 1,
        mean: rating.toDouble(),
        ratings: ratings,
      );
    } else {
      final tagDetail = TagDetail.fromJson(jsonDecode(json) as Map<String, dynamic>);
      newTagDetail = tagDetail.add(rating);
    }
    _prefs.setString(key, jsonEncode(newTagDetail));
  }

  void remove(String tag, int rating) {
    final key = _key(tagLabel: tag);
    final json = _prefs.getString(key);
    if (json == null) {
      return;
    }
    final tagDetail = TagDetail.fromJson(jsonDecode(json) as Map<String, dynamic>);
    if (tagDetail.count == 1) {
      _prefs.remove(key);
    } else {
      final newTagDetail = tagDetail.remove(rating);
      _prefs.setString(key, jsonEncode(newTagDetail));
    }
  }
}
