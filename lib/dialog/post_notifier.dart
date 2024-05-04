import 'dart:async';

import 'package:chooshi/model/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postNotifierProvider = AutoDisposeAsyncNotifierProvider<PostNotifier, Post?>(PostNotifier.new);

class PostNotifier extends AutoDisposeAsyncNotifier<Post?> {
  @override
  FutureOr<Post?> build() async {
    return Future.value(null);
  }

  Future<void> updateRate(DateTime timestamp, int newRating) async {
    final previous = await future;
    if (previous != null) {
      state = AsyncData(previous.copyWith(rating: newRating));
    } else {
      state = AsyncData(Post(timestamp: timestamp, rating: newRating));
    }
  }

  Future<void> addPost() async {
    final data = await future;
    state = const AsyncLoading();
    // TODO: persistent
    await Future.delayed(const Duration(seconds: 3));
    state = await AsyncValue.guard(() => Future.value(Post(timestamp: data!.timestamp, rating: data.rating)));
  }
}
