import 'package:chooshi/dialog/post_add_form.dart';
import 'package:chooshi/model/post.dart';
import 'package:chooshi/storage/post_store.dart';
import 'package:chooshi/storage/tag_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postFormNotifierProvider = AutoDisposeNotifierProvider<PostFormNotifier, PostForm>(PostFormNotifier.new);

class PostFormNotifier extends AutoDisposeNotifier<PostForm> {
  @override
  PostForm build() {
    return const PostForm(isLoading: false);
  }

  void updateRate(DateTime timestamp, int newRating) {
    state = state.copyWith(rating: newRating);
  }

  void updateTags(DateTime timestamp, List<String> tags) {
    state = state.copyWith(tags: tags);
  }

  Future<void> addPost() async {
    state = state.copyWith(isLoading: true);
    final post = Post(timestamp: DateTime.now(), rating: state.rating!, tags: state.tags!);
    await Future.wait([
      Future.sync(() => ref.read(postStoreProvider).add(post)),
      Future.delayed(const Duration(seconds: 1)),
    ]);
    for (var tag in post.tags) {
      ref.read(tagDetailStoreProvider).add(tag, post.rating);
    }
  }
}
