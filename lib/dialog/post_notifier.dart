import 'dart:async';

import 'package:chooshi/model/post.dart';
import 'package:chooshi/storage/post_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postNotifierProvider = AutoDisposeAsyncNotifierProvider<PostNotifier, Post?>(() => PostNotifier(PostStore()));

class PostNotifier extends AutoDisposeAsyncNotifier<Post?> {
  PostNotifier(this._store);
  final PostStore _store;

  @override
  FutureOr<Post?> build() async {
    return Future.value(null);
  }

  Future<void> updateRate(DateTime timestamp, int newRating) async {
    final previous = await future;
    if (previous != null) {
      state = AsyncData(previous.copyWith(rating: newRating));
    } else {
      state = AsyncData(Post(timestamp: timestamp, rating: newRating, tags: []));
    }
  }

  Future<void> updateTags(DateTime timestamp, List<String> tags) async {
    final previous = await future;
    if (previous != null) {
      state = AsyncData(previous.copyWith(tags: tags));
    } else {
      state = AsyncData(Post(timestamp: timestamp, rating: 0, tags: []));
    }
  }

  Future<void> addPost() async {
    final data = await future;
    if (data == null) return;
    state = const AsyncLoading();
    await Future.wait([
      _store.add(data),
      Future.delayed(const Duration(seconds: 3)),
    ]);
    state = await AsyncValue.guard(
      () => Future.value(Post(
        timestamp: data.timestamp,
        rating: data.rating,
        tags: data.tags,
      )),
    );
  }
}
