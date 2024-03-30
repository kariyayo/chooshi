import 'package:flutter/material.dart';

class TopScreen extends StatefulWidget {
  const TopScreen({super.key, required this.title});

  final String title;

  @override
  State<TopScreen> createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen> {
  late PageController _pageController;
  late ScrollController _scrollController;

  final GlobalKey _tabBarKey = GlobalKey();

  List<Month> monthList = [];
  int _selectedIndex = 0;

  void _onPageChangedByTabTap(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _onPageChangedBySwipe(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30.0),
          child: Container(
            height: 30,
            child: ListView(
              key: _tabBarKey,
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              // onTap: _onPageChangedByTabTap,
              children: monthList
                  .map((month) => _Tab(
                        controller: _scrollController,
                        month: month,
                        tabBarKey: _tabBarKey,
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: _onPageChangedBySwipe,
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
  const _Tab(
      {required this.controller, required this.month, required this.tabBarKey});

  final ScrollController controller;
  final Month month;
  final GlobalKey tabBarKey;

  @override
  State<_Tab> createState() => _TabState();
}

class _TabState extends State<_Tab> {
  late Month month;
  late GlobalKey tabBarKey;
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    month = widget.month;
    tabBarKey = widget.tabBarKey;
    scrollController = widget.controller;
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
    } else {
      print('[${month.year}/${month.month}] i am NOT center');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Tab(text: '${month.year}/${month.month}'),
    );
  }
}

@immutable
class Month {
  final int year;
  final int month;
  const Month(this.year, this.month);
}
