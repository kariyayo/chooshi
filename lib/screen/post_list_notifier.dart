import 'package:chooshi/model/month.dart';
import 'package:chooshi/model/post.dart';
import 'package:chooshi/storage/post_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postListNotifierProvider = AsyncNotifierProvider.autoDispose.family<PostListNotifier, List<Post>, Month>(
  () => PostListNotifier(PostStore()),
);

class PostListNotifier extends AutoDisposeFamilyAsyncNotifier<List<Post>, Month> {
  PostListNotifier(this._store);
  final PostStore _store;

  @override
  Future<List<Post>> build(Month arg) async {
    return _store.fetchByYearMonth(this.arg);
  }
}
