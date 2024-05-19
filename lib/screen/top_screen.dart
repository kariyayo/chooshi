import 'package:chooshi/dialog/post_dialog.dart';
import 'package:chooshi/model/month.dart';
import 'package:chooshi/screen/post_list_notifier.dart';
import 'package:chooshi/screen/top_app_bar_widget.dart';
import 'package:chooshi/screen/top_body_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopScreen extends ConsumerWidget {
  const TopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const TopAppBarWidget(),
      body: const TopBodyWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final now = DateTime.now();
          await showPostDialog(context, now);
          ref.read(postListNotifierProvider(Month(year: now.year, month: now.month)).notifier).refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
