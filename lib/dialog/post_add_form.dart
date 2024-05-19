import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_add_form.freezed.dart';

@freezed
class PostForm with _$PostForm {
  const factory PostForm({
    int? rating,
    List<String>? tags,
  }) = _PostForm;

  const PostForm._();

  bool validate() {
    print('validate rating: $rating, tags: $tags');
    return rating != null && tags?.isNotEmpty == true;
  }
}
