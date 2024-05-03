import 'package:chooshi/screen/top_app_bar_widget.dart';
import 'package:chooshi/screen/top_body_widget.dart';
import 'package:flutter/material.dart';

class TopScreen extends StatelessWidget {
  const TopScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopAppBarWidget(),
      body: TopBodyWidget(),
    );
  }
}
