import 'package:chooshi/model/month.dart';
import 'package:chooshi/model/post.dart';
import 'package:chooshi/screen/post_list_notifier.dart';
import 'package:chooshi/screen/top_seleted_page_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
      return ListView.separated(
        controller: _scrollController,
        itemCount: posts.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        separatorBuilder: (BuildContext context, int index) => const Divider(),
        itemBuilder: (BuildContext context, int index) {
          var post = posts[index];
          return _PostRow(post);
        },
      );
    }
  }
}

class _PostRow extends ConsumerWidget {
  const _PostRow(this.post);
  final Post post;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dt = post.timestamp;
    var formatter = DateFormat('EE');
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      // dense: true,
      leading: Text(
        '${formatter.format(dt)} ${dt.day}\n${dt.hour}:${dt.minute.toString().padLeft(2, '0')}',
        style: const TextStyle(fontSize: 16),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: RatingBar.builder(
          initialRating: post.rating.toDouble(),
          ignoreGestures: true,
          tapOnlyMode: true,
          updateOnDrag: false,
          minRating: 1,
          direction: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (_) {},
        ),
      ),
      subtitle: SizedBox(
        height: 40,
        width: double.maxFinite,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: post.tags.map((s) {
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Chip(
                label: Text(s),
              ),
            );
          }).toList(),
        ),
      ),
      trailing: GestureDetector(
        child: const Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: Icon(Icons.more_vert),
        ),
        onTapDown: (details) {
          final pos = details.globalPosition;
          showMenu(
            context: context,
            position: RelativeRect.fromLTRB(pos.dx, pos.dy, 0, 0),
            items: [
              PopupMenuItem(
                child: const Row(children: [Icon(Icons.delete), Text('Remove')]),
                onTap: () {
                  ref.read(postListNotifierProvider(Month(year: dt.year, month: dt.month)).notifier).remove(post);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
