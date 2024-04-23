import 'package:chooshi/screen/top_app_bar_title_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class TopScreen extends ConsumerStatefulWidget {
  const TopScreen({super.key, required this.title});

  final String title;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TopScreenState();
}

class _TopScreenState extends ConsumerState<TopScreen> {
  late PageController _pageController;
  late AutoScrollController _scrollController;

  final GlobalKey _tabBarKey = GlobalKey();

  List<Month> monthList = [];
  int _selectedIndex = 0;

  void _onPageChangedByTabTap(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _onPageChanged(int index) {
    print('onPageChanged: $index');
    setState(() {
      _selectedIndex = index;
    });
    _scrollController.scrollToIndex(
      index,
      preferPosition: AutoScrollPosition.middle,
    );
  }

  @override
  void initState() {
    super.initState();
    monthList = [
      const Month(2024, 2),
      const Month(2024, 1),
      const Month(2023, 12),
      const Month(2023, 11),
      const Month(2023, 10),
      const Month(2023, 9),
      const Month(2023, 8),
      const Month(2023, 7),
      const Month(2023, 6),
      const Month(2023, 5),
      const Month(2023, 4),
      const Month(2023, 3),
      const Month(2023, 2),
      const Month(2023, 1),
      const Month(2022, 12),
      const Month(2022, 11),
      const Month(2022, 10),
      const Month(2022, 9),
      const Month(2022, 8),
      const Month(2022, 7),
      const Month(2022, 6),
      const Month(2022, 5),
      const Month(2022, 4),
      const Month(2022, 3),
      const Month(2022, 2),
      const Month(2022, 1),
    ];

    _pageController = PageController(initialPage: _selectedIndex);
    _scrollController = AutoScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Consumer(
          builder: (context, ref, _) {
            final title = ref.watch(topAppBarTitleNotifierProvider);
            return Text(title);
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: SizedBox(
            height: 40,
            child: ListView.builder(
              key: _tabBarKey,
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              itemCount: monthList.length,
              prototypeItem: _Tab(
                controller: _scrollController,
                month: monthList[0],
                tabBarKey: _tabBarKey,
                centerCallback: () {},
              ),
              itemBuilder: (BuildContext context, int index) {
                final month = monthList[index];
                return AutoScrollTag(
                  key: ValueKey(index),
                  controller: _scrollController,
                  index: index,
                  child: ListTile(
                    onTap: () {
                      print("onTap: $index");
                      _onPageChangedByTabTap(index);
                    },
                    selected: _selectedIndex == index,
                    shape: _selectedIndex == index
                        ? const BorderDirectional(
                            bottom: BorderSide(color: Colors.orange, width: 2),
                          )
                        : null,
                    title: _Tab(
                      controller: _scrollController,
                      month: month,
                      tabBarKey: _tabBarKey,
                      centerCallback: () {
                        final notifier =
                            ref.read(topAppBarTitleNotifierProvider.notifier);
                        if (_selectedIndex < 3 && index < 3) {
                          // 3個目までのタブは中央のタブではなく選択済みのタブをタイトルに表示する
                          notifier.update('${monthList[_selectedIndex].year}');
                        } else {
                          notifier.update('${month.year}');
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        itemBuilder: (BuildContext context, int index) {
          return Center(child: Text('Page${index + 1}'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Tab extends StatefulWidget {
  const _Tab({
    required this.controller,
    required this.month,
    required this.tabBarKey,
    required this.centerCallback,
  });

  final ScrollController controller;
  final Month month;
  final GlobalKey tabBarKey;
  final VoidCallback centerCallback;

  @override
  State<StatefulWidget> createState() => _TabState();
}

class _TabState extends State<_Tab> {
  late Month month;
  late GlobalKey tabBarKey;
  late ScrollController scrollController;
  late VoidCallback centerCallback;

  @override
  void initState() {
    super.initState();
    month = widget.month;
    tabBarKey = widget.tabBarKey;
    scrollController = widget.controller;
    centerCallback = widget.centerCallback;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(_onScroll);
    });
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final RenderBox? tabBarRenderObject =
        tabBarKey.currentContext?.findRenderObject() as RenderBox?;
    if (tabBarRenderObject == null) return;
    final tabBarCenter = tabBarRenderObject.size.width / 2;
    if (!context.mounted) return;
    final RenderBox? renderObject = context.findRenderObject() as RenderBox?;
    if (renderObject == null) return;
    final left = renderObject.localToGlobal(Offset.zero).dx;
    final right =
        renderObject.localToGlobal(Offset.zero).dx + renderObject.size.width;
    if (left <= tabBarCenter && tabBarCenter < right) {
      print('[${month.year}/${month.month}] i am center =========');
      centerCallback();
    } else {
      print('[${month.year}/${month.month}] i am NOT center');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      alignment: Alignment.center,
      child: Text('${month.month}'),
    );
  }
}

@immutable
class Month {
  final int year;
  final int month;
  const Month(this.year, this.month);
}
