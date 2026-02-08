import 'package:chooshi/model/post.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_add_form.freezed.dart';

@freezed
class PostForm with _$PostForm {
  const factory PostForm({
    required bool isLoading,
    int? rating,
    List<String>? tags,
    Post? originalPost,
  }) = _PostForm;

  const PostForm._();

  bool get isEditMode => originalPost != null;

  bool validate() {
    return rating != null && tags?.isNotEmpty == true;
  }
}
