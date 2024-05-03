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
    print('onPageChanged: $index');
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
        return Center(child: Text('Page${index + 1}'));
      },
    );
  }
}
