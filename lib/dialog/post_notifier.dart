import 'package:chooshi/model/post.dart';
import 'package:chooshi/storage/post_store.dart';
import 'package:chooshi/storage/tag_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postNotifierProvider = AutoDisposeNotifierProvider<PostNotifier, Post?>(PostNotifier.new);

class PostNotifier extends AutoDisposeNotifier<Post?> {
  @override
  Post? build() {
    return null;
  }

  void updateRate(DateTime timestamp, int newRating) {
    state = state?.copyWith(rating: newRating);
    state ??= Post(timestamp: timestamp, rating: newRating, tags: []);
  }

  void updateTags(DateTime timestamp, List<String> tags) {
    state = state?.copyWith(tags: tags);
    state ??= Post(timestamp: timestamp, rating: 0, tags: []);
  }

  void addPost() {
    if (state != null) {
      ref.read(postStoreProvider).add(state!);
    }
  }
}
