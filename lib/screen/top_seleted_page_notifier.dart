import 'package:flutter_riverpod/flutter_riverpod.dart';

final topSelectedPageNotifierProvider = NotifierProvider.autoDispose<TopSelectedPageNotifier, int>(
  TopSelectedPageNotifier.new,
);

class TopSelectedPageNotifier extends AutoDisposeNotifier<int> {
  @override
  int build() {
    return 0;
  }

  void update(int index) {
    state = index;
  }
}
