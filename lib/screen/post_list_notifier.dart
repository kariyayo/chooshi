import 'package:chooshi/model/month.dart';
import 'package:chooshi/model/post.dart';
import 'package:chooshi/storage/post_store.dart';
import 'package:chooshi/storage/tag_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postListNotifierProvider =
    NotifierProvider.autoDispose.family<PostListNotifier, List<Post>, Month>(PostListNotifier.new);

class PostListNotifier extends AutoDisposeFamilyNotifier<List<Post>, Month> {
  @override
  List<Post> build(Month arg) {
    return _fetch();
  }

  void refresh() async {
    state = _fetch();
  }

  List<Post> _fetch() {
    return ref.read(postStoreProvider).fetchByYearMonth(arg);
  }

  Future<void> remove(Post post) async {
    ref.read(postStoreProvider).remove(post);
    for (var tag in post.tags) {
      ref.read(tagDetailStoreProvider).remove(tag, post.rating);
    }
    refresh();
  }
}
