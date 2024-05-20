import 'package:chooshi/dialog/post_form_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

Future<void> showPostDialog(BuildContext context, DateTime dateTime) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text(
          DateFormat('yyyy.MM.dd\nHH:mm').format(dateTime),
          textAlign: TextAlign.center,
        ),
        content: _Content(timestamp: dateTime),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        actions: <Widget>[
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final postForm = ref.watch(postFormNotifierProvider);
              return postForm.isLoading
                  ? const SizedBox()
                  : TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    );
            },
          ),
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
              final postForm = ref.watch(postFormNotifierProvider);
              return postForm.isLoading
                  ? const Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
                      child: CircularProgressIndicator(),
                    )
                  : TextButton(
                      onPressed: postForm.validate()
                          ? () async {
                              await ref.read(postFormNotifierProvider.notifier).addPost();
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            }
                          : null,
                      child: Text(
                        'Add',
                        style: postForm.validate() ? null : const TextStyle(color: Colors.grey),
                      ),
                    );
            },
          ),
        ],
      );
    },
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
          onRatingUpdate: (newRating) {
            ref.read(postFormNotifierProvider.notifier).updateRate(timestamp, newRating.toInt());
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

  @override
  Widget build(BuildContext context) {
    final postForm = ref.watch(postFormNotifierProvider);
    final inputedTags = postForm.tags ?? [];
    return Column(
      children: [
        TextFormField(
          controller: _textEditorController,
          onFieldSubmitted: (input) {
            final value = input.trim();
            if (value.isEmpty) {
              return;
            }
            final newTags = [...inputedTags, value];
            _textEditorController.clear();
            ref.read(postFormNotifierProvider.notifier).updateTags(DateTime.now(), newTags);
          },
          decoration: const InputDecoration(
            icon: Icon(Icons.new_label_outlined),
            hintText: 'Enter label name',
          ),
        ),
        if (inputedTags.isNotEmpty) ...[
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            width: double.maxFinite,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: inputedTags.map((s) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Chip(
                    label: Text(s),
                    onDeleted: () {
                      final newTags = [...inputedTags];
                      newTags.remove(s);
                      ref.read(postFormNotifierProvider.notifier).updateTags(DateTime.now(), newTags);
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
