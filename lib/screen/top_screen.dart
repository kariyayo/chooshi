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
  final GlobalKey _tabBarKey = GlobalKey();
  final _scrollController = AutoScrollController();
  final _months = <Month>{};

  int _selectedIndex = 0;
  late PageController _pageController;

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
    DateTime now = DateTime.now();
    for (var i = 0; i < 10; i++) {
      _months.add(Month(now.year, now.month));
      now = DateTime(now.year, now.month - 1);
    }
    _pageController = PageController(initialPage: _selectedIndex);
    _scrollController.addListener(_moreMonths);
  }

  void _moreMonths() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final m = _months.last;
      DateTime d = DateTime(m.year, m.month + 1);
      final months = <Month>[];
      for (var i = 0; i < 10; i++) {
        months.add(Month(d.year, d.month));
        d = DateTime(d.year, d.month - 1);
      }
      setState(() {
        _months.addAll(months);
      });
    }
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
              itemCount: _months.length,
              prototypeItem: _Tab(
                controller: _scrollController,
                month: _months.elementAt(0),
                tabBarKey: _tabBarKey,
                centerCallback: () {},
              ),
              itemBuilder: (BuildContext context, int index) {
                final month = _months.elementAt(index);
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
                          notifier.update(
                              '${_months.elementAt(_selectedIndex).year}');
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
      centerCallback();
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
class Month implements Comparable<Month> {
  final int year;
  final int month;
  const Month(this.year, this.month);

  @override
  int compareTo(Month other) {
    if (year != other.year) {
      return year.compareTo(other.year);
    }
    return month.compareTo(other.month);
  }

  @override
  bool operator ==(Object other) =>
      other is Month && year == other.year && month == other.month;

  @override
  int get hashCode => year.hashCode ^ month.hashCode;
}
