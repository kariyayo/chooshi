import 'package:chooshi/dialog/post_add_form.dart';
import 'package:chooshi/model/post.dart';
import 'package:chooshi/storage/post_store.dart';
import 'package:chooshi/storage/tag_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postFormNotifierProvider = AutoDisposeNotifierProvider<PostFormNotifier, PostForm>(PostFormNotifier.new);

class PostFormNotifier extends AutoDisposeNotifier<PostForm> {
  @override
  PostForm build() {
    return const PostForm();
  }

  void updateRate(DateTime timestamp, int newRating) {
    print('updateRate');
    state = state.copyWith(rating: newRating);
  }

  void updateTags(DateTime timestamp, List<String> tags) {
    print('updateTags');
    state = state.copyWith(tags: tags);
  }

  void addPost() {
    final post = Post(timestamp: DateTime.now(), rating: state.rating!, tags: state.tags!);
    ref.read(postStoreProvider).add(post);
    for (var tag in post.tags) {
      ref.read(tagDetailStoreProvider).add(tag, post.rating);
    }
  }
}
