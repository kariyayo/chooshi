import 'package:chooshi/screen/top_screen.dart';
import 'package:chooshi/storage/prefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  Future<void>? _initialized;

  @override
  initState() {
    super.initState();
    final prefsFuture = SharedPreferences.getInstance();
    _initialized = prefsFuture.then((value) {
      ref.read(prefsProvider).init(value);
      return Future.value();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Chooshi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return FutureBuilder(
            future: _initialized,
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return const TopScreen();
              } else {
                return const SizedBox();
              }
            },
          );
        },
      ),
    );
  }
}
