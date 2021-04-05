import 'package:emoji_chooser/src/category.dart';
import 'package:emoji_chooser/src/category_icon.dart';
import 'package:emoji_chooser/src/emoji_internal_data.dart';

class Group {
  final Category category;
  final CategoryIcon icon;
  final String title;
  final List<String> names;
  final List<List<EmojiInternalData>> pages = [];

  Group(this.category, this.icon, this.title, this.names);
}
