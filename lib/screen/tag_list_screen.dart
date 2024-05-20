import 'package:chooshi/screen/tag_detail_screen.dart';
import 'package:chooshi/storage/tag_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TagListScrean extends ConsumerWidget {
  const TagListScrean({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const TagListScrean());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagDetailList = ref.read(tagDetailStoreProvider).fetch();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tags'),
      ),
      body: SafeArea(
        child: tagDetailList.isEmpty
            ? const Center(child: Text('No data'))
            : ListView(
                children: tagDetailList.map((tagDetail) {
                  return ListTile(
                    title: Text(tagDetail.label),
                    trailing: Text(tagDetail.mean.toString()),
                    onTap: () {
                      Navigator.of(context).push(TagDetailScreen.route(tagDetail.label));
                    },
                  );
                }).toList(),
              ),
      ),
    );
  }
}
