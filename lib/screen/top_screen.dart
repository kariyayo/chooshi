import 'package:flutter/material.dart';

class TopScreen extends StatefulWidget {
  const TopScreen({super.key, required this.title});

  final String title;

  @override
  State<TopScreen> createState() => _TopScreenState();
}

class _TopScreenState extends State<TopScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  int _selectedIndex = 0;
  final int _pageSize = 10;

  void _onPageChangedByTabTap(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.jumpToPage(index);
    });
  }

  void _onPageChangedBySwipe(int index) {
    setState(() {
      _selectedIndex = index;
      _tabController.animateTo(index);
    });
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pageSize, vsync: this);
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
          bottom: TabBar(
            isScrollable: true,
            controller: _tabController,
            onTap: _onPageChangedByTabTap,
            tabs: List.generate(
              _pageSize,
              (index) => Tab(text: 'Tab${index + 1}'),
            ),
          )),
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
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
