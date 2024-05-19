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

  String _keyAll() {
    return 'tags';
  }

  String _keyByLabel({required String tagLabel}) {
    return 'tags_$tagLabel';
  }

  List<TagDetail> fetch() {
    final jsonList = _prefs.getStringList(_keyAll());
    if (jsonList == null) {
      return [];
    }
    return jsonList.map((json) => TagDetail.fromJson(jsonDecode(json) as Map<String, dynamic>)).toList();
  }

  TagDetail? fetchBy(String tag) {
    final key = _keyByLabel(tagLabel: tag);
    final json = _prefs.getString(key);
    if (json == null) {
      return null;
    }
    return TagDetail.fromJson(jsonDecode(json) as Map<String, dynamic>);
  }

  void add(String tag, int rating) {
    final key = _keyByLabel(tagLabel: tag);
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

    final tagDetails = fetch();
    if (tagDetails.contains(newTagDetail)) {
      tagDetails.remove(newTagDetail);
    }
    tagDetails.add(newTagDetail);
    tagDetails.sort((a, b) {
      if (a.mean == b.mean) {
        return a.label.compareTo(b.label);
      } else {
        return -1 * a.mean.compareTo(b.mean);
      }
    });
    _prefs.setStringList(_keyAll(), tagDetails.map((tagDetail) => jsonEncode(tagDetail)).toList());
  }

  void remove(String tag, int rating) {
    final key = _keyByLabel(tagLabel: tag);
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
