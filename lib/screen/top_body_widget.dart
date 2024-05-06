import 'package:chooshi/model/month.dart';
import 'package:chooshi/model/post.dart';
import 'package:chooshi/screen/post_list_notifier.dart';
import 'package:chooshi/screen/top_seleted_page_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopBodyWidget extends ConsumerStatefulWidget {
  const TopBodyWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TopBodyWidgetState();
}

class _TopBodyWidgetState extends ConsumerState<TopBodyWidget> {
  late PageController _pageController;

  void _onPageChanged(int index) {
    ref.read(topSelectedPageNotifierProvider.notifier).update(index);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: ref.read(topSelectedPageNotifierProvider));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(topSelectedPageNotifierProvider, (previous, next) {
      _pageController.jumpToPage(next);
    });
    return PageView.builder(
      controller: _pageController,
      onPageChanged: _onPageChanged,
      itemBuilder: (BuildContext context, int index) {
        return _Content(pageIndex: index);
      },
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.pageIndex});
  final int pageIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month - pageIndex);
    final asyncPosts = ref.watch(postListNotifierProvider(Month(year: dt.year, month: dt.month)));
    switch (asyncPosts) {
      case AsyncData(:final value):
        return _Posts(value);
      case AsyncError(:final error):
        return Center(child: Text('Error: $error'));
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }
}

class _Posts extends StatefulWidget {
  const _Posts(this.posts);
  final List<Post> posts;

  @override
  State<StatefulWidget> createState() => _PostState();
}

class _PostState extends State<_Posts> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final posts = widget.posts;
    if (posts.isEmpty) {
      return const Center(child: Text('No data'));
    } else {
      return ListView.builder(
        controller: _scrollController,
        itemCount: posts.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        prototypeItem: const ListTile(
          title: Text('Rating'),
          subtitle: Text('Timestamp'),
        ),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(posts[index].rating.toString()),
            subtitle: Text(posts[index].timestamp.toString()),
          );
        },
      );
    }
  }
}
