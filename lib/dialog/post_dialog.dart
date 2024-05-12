import 'package:chooshi/dialog/post_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

Future<void> showPostDialog(BuildContext context, WidgetRef ref, DateTime dateTime) async {
  return await showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: Text(
        DateFormat('yyyy.MM.dd\nHH:mm').format(dateTime),
        textAlign: TextAlign.center,
      ),
      content: _Content(timestamp: dateTime),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
        const SizedBox(height: 4),
        _TagInputField(),
      ],
    );
  }
}

class _TagInputField extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TagInputFieldState();
}

class _TagInputFieldState extends ConsumerState<_TagInputField> {
  final TextEditingController _textEditorController = TextEditingController();

  List<String> _inputedTags = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _inputedTags = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _textEditorController,
          onFieldSubmitted: (input) {
            final value = input.trim();
            if (value.isEmpty) {
              return;
            }
            final newTags = [..._inputedTags, value];
            _textEditorController.clear();
            setState(() {
              _inputedTags = newTags;
            });
          },
          decoration: const InputDecoration(
            icon: Icon(Icons.new_label_outlined),
            hintText: 'Enter label name',
          ),
        ),
        if (_inputedTags.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            width: double.maxFinite,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: _inputedTags.map((s) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Chip(
                    label: Text(s),
                    onDeleted: () {
                      setState(() {
                        _inputedTags.remove(s);
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}
