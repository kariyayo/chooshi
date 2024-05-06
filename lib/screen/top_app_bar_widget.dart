import 'package:chooshi/model/month.dart';
import 'package:chooshi/screen/top_seleted_page_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class TopAppBarWidget extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const TopAppBarWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TopAppBarWidgetState();

  @override
  Size get preferredSize =>
      const Size.fromHeight(_TopAppBarWidgetState.toolbarHeight + _TopAppBarWidgetState.bottomHeight);
}

class _TopAppBarWidgetState extends ConsumerState<TopAppBarWidget> {
  final GlobalKey _tabBarKey = GlobalKey();
  final _scrollController = AutoScrollController();

  static const double toolbarHeight = kToolbarHeight - 16;
  static const double bottomHeight = 40.0;

  final _months = <Month>{};
  var _title = '';

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    setState(() {
      _title = now.year.toString();
    });
    for (var i = 0; i < 10; i++) {
      _months.add(Month(year: now.year, month: now.month));
      now = DateTime(now.year, now.month - 1);
    }
    _scrollController.addListener(_moreMonths);
  }

  void _moreMonths() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      final m = _months.last;
      DateTime d = DateTime(m.year, m.month + 1);
      final months = <Month>[];
      for (var i = 0; i < 10; i++) {
        months.add(Month(year: d.year, month: d.month));
        d = DateTime(d.year, d.month - 1);
      }
      setState(() {
        _months.addAll(months);
      });
    }
  }

  void setTitle(String title) {
    setState(() {
      _title = title;
    });
  }

  void _onPageChangedByTabTap(int index) {
    ref.read(topSelectedPageNotifierProvider.notifier).update(index);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(topSelectedPageNotifierProvider, (previous, next) {
      _scrollController.scrollToIndex(
        next,
        preferPosition: AutoScrollPosition.middle,
      );
    });
    return AppBar(
      backgroundColor: Colors.white,
      title: Consumer(
        builder: (context, ref, _) {
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(_title),
          );
        },
      ),
      toolbarHeight: toolbarHeight,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(bottomHeight),
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1)),
          ),
          height: bottomHeight,
          child: ListView.builder(
            key: _tabBarKey,
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _months.length,
            itemExtent: 100,
            padding: EdgeInsets.zero,
            itemBuilder: (BuildContext context, int index) {
              final month = _months.elementAt(index);
              final currentPageIndex = ref.watch(topSelectedPageNotifierProvider);
              return AutoScrollTag(
                key: ValueKey(index),
                controller: _scrollController,
                index: index,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  horizontalTitleGap: 0,
                  titleAlignment: ListTileTitleAlignment.titleHeight,
                  onTap: () {
                    _onPageChangedByTabTap(index);
                  },
                  selected: currentPageIndex == index,
                  shape: currentPageIndex == index
                      ? BorderDirectional(
                          bottom: BorderSide(color: Theme.of(context).primaryColorLight, width: 4),
                        )
                      : null,
                  dense: true,
                  title: _Tab(
                    controller: _scrollController,
                    month: month,
                    tabBarKey: _tabBarKey,
                    centerCallback: () {
                      if (currentPageIndex < 3 && index < 3) {
                        // 3個目までのタブは中央のタブではなく選択済みのタブをタイトルに表示する
                        setTitle('${_months.elementAt(currentPageIndex).year}');
                      } else {
                        setTitle('${month.year}');
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
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
    final RenderBox? tabBarRenderObject = tabBarKey.currentContext?.findRenderObject() as RenderBox?;
    if (tabBarRenderObject == null) return;
    final tabBarCenter = tabBarRenderObject.size.width / 2;
    if (!context.mounted) return;
    final RenderBox? renderObject = context.findRenderObject() as RenderBox?;
    if (renderObject == null) return;
    final left = renderObject.localToGlobal(Offset.zero).dx;
    final right = renderObject.localToGlobal(Offset.zero).dx + renderObject.size.width;
    if (left <= tabBarCenter && tabBarCenter < right) {
      centerCallback();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      alignment: Alignment.center,
      child: Text(month.label),
    );
  }
}
