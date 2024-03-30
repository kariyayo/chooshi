import 'package:flutter_riverpod/flutter_riverpod.dart';

final topAppBarTitleNotifierProvider =
    NotifierProvider.autoDispose<TopAppBarTitleNotifier, String>(
  TopAppBarTitleNotifier.new,
);

class TopAppBarTitleNotifier extends AutoDisposeNotifier<String> {
  @override
  String build() {
    final now = DateTime.now();
    return now.year.toString();
  }

  void update(String title) {
    state = title;
  }
}
