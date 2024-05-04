import 'package:chooshi/dialog/post_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

Future<void> showPostDialog(BuildContext context, WidgetRef ref, DateTime dateTime) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      title: Text(DateFormat('yyyy.MM.dd\nHH:mm').format(dateTime)),
      content: _Content(timestamp: dateTime),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        Consumer(builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final asyncData = ref.watch(postNotifierProvider);
          if (asyncData.isLoading) {
            return const CircularProgressIndicator();
          } else {
            return TextButton(
              onPressed: () async {
                await ref.read(postNotifierProvider.notifier).addPost();
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
              child: const Text('OK'),
            );
          }
        }),
      ],
    ),
  );
}

class _Content extends ConsumerWidget {
  const _Content({required this.timestamp});

  final DateTime timestamp;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBar.builder(
          minRating: 1,
          direction: Axis.horizontal,
          itemCount: 5,
          itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
          onRatingUpdate: (newRating) async {
            await ref.read(postNotifierProvider.notifier).updateRate(timestamp, newRating.toInt());
          },
        ),
      ],
    );
  }
}
