import 'package:chooshi/dialog/post_form_notifier.dart';
import 'package:chooshi/model/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

Future<void> showPostDialog(BuildContext context, DateTime dateTime, {Post? editingPost}) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return _PostDialogContent(dateTime: dateTime, editingPost: editingPost);
    },
  );
}

class _PostDialogContent extends ConsumerStatefulWidget {
  const _PostDialogContent({required this.dateTime, this.editingPost});
  final DateTime dateTime;
  final Post? editingPost;

  @override
  ConsumerState<_PostDialogContent> createState() => _PostDialogContentState();
}

class _PostDialogContentState extends ConsumerState<_PostDialogContent> {
  @override
  void initState() {
    super.initState();
    if (widget.editingPost != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(postFormNotifierProvider.notifier).initForEdit(widget.editingPost!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final postForm = ref.watch(postFormNotifierProvider);
    final isEditMode = widget.editingPost != null;

    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      title: Text(
        DateFormat('yyyy.MM.dd\nHH:mm').format(widget.dateTime),
        textAlign: TextAlign.center,
      ),
      content: _Content(
        timestamp: widget.dateTime,
        initialRating: widget.editingPost?.rating.toDouble(),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      actions: <Widget>[
        postForm.isLoading
            ? const SizedBox()
            : TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
        postForm.isLoading
            ? const Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 8, 8),
                child: CircularProgressIndicator(),
              )
            : TextButton(
                onPressed: postForm.validate()
                    ? () async {
                        if (isEditMode) {
                          await ref.read(postFormNotifierProvider.notifier).updatePost();
                        } else {
                          await ref.read(postFormNotifierProvider.notifier).addPost();
                        }
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    : null,
                child: Text(
                  isEditMode ? 'Update' : 'Add',
                  style: postForm.validate() ? null : const TextStyle(color: Colors.grey),
                ),
              ),
      ],
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.timestamp, this.initialRating});

  final DateTime timestamp;
  final double? initialRating;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBar.builder(
          initialRating: initialRating ?? 0,
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
