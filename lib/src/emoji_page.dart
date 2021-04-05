import 'package:emoji_chooser/src/emoji_internal_data.dart';
import 'package:flutter/material.dart';

class EmojiPage extends StatelessWidget {
  final int rows;
  final int columns;
  final int skin;
  final List<EmojiInternalData> emojis;
  final Function(EmojiInternalData) onSelected;

  const EmojiPage(
      {Key key,
      @required this.rows,
      @required this.columns,
      @required this.skin,
      @required this.emojis,
      @required this.onSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.count(
          crossAxisCount: columns,
          children: List.generate(rows * columns, (index) {
            if (index >= emojis.length) return Container();
            var emoji = emojis[index];
            return Center(
              child: FlatButton(
                padding: EdgeInsets.all(0.0),
                child: Center(
                  child: Text(
                    emoji.charForSkin(skin),
                    style: TextStyle(fontSize: 24.0),
                  ),
                ),
                onPressed: () {
                  onSelected(emoji);
                },
              ),
            );
          })),
    );
  }
}
