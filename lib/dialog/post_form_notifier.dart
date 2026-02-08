import 'package:chooshi/dialog/post_add_form.dart';
import 'package:chooshi/model/month.dart';
import 'package:chooshi/model/post.dart';
import 'package:chooshi/screen/post_list_notifier.dart';
import 'package:chooshi/storage/post_store.dart';
import 'package:chooshi/storage/tag_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postFormNotifierProvider = AutoDisposeNotifierProvider<PostFormNotifier, PostForm>(PostFormNotifier.new);

class PostFormNotifier extends AutoDisposeNotifier<PostForm> {
  @override
  PostForm build() {
    return const PostForm(isLoading: false);
  }

  void initForEdit(Post post) {
    state = state.copyWith(
      rating: post.rating,
      tags: post.tags,
      originalPost: post,
    );
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

  Future<void> updatePost() async {
    state = state.copyWith(isLoading: true);
    final oldPost = state.originalPost!;
    final newPost = Post(
      timestamp: oldPost.timestamp,
      rating: state.rating!,
      tags: state.tags!,
    );

    await Future.wait([
      Future.sync(() => ref.read(postStoreProvider).update(oldPost, newPost)),
      Future.delayed(const Duration(seconds: 1)),
    ]);

    final oldTags = oldPost.tags.toSet();
    final newTags = newPost.tags.toSet();
    final oldRating = oldPost.rating;
    final newRating = newPost.rating;

    // タグ削除: 元の投稿にあって新しい投稿にないタグ
    for (var tag in oldTags.difference(newTags)) {
      ref.read(tagDetailStoreProvider).remove(tag, oldRating);
    }

    // タグ追加: 新しい投稿にあって元の投稿にないタグ
    for (var tag in newTags.difference(oldTags)) {
      ref.read(tagDetailStoreProvider).add(tag, newRating);
    }

    // 共通タグでレーティング変更がある場合
    if (oldRating != newRating) {
      for (var tag in oldTags.intersection(newTags)) {
        ref.read(tagDetailStoreProvider).remove(tag, oldRating);
        ref.read(tagDetailStoreProvider).add(tag, newRating);
      }
    }

    // リストを更新
    final dt = oldPost.timestamp;
    ref.read(postListNotifierProvider(Month(year: dt.year, month: dt.month)).notifier).refresh();
  }
}
