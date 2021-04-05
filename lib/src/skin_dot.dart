import 'package:emoji_chooser/src/skin_tones.dart';
import 'package:flutter/material.dart';

class SkinDot extends StatelessWidget {
  final int skin;
  final Function(int skin) onTap;

  const SkinDot({Key key, this.skin, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: SkinTones.tones[skin],
          shape: BoxShape.circle,
        ),
      ),
      onTap: () {
        if (onTap != null) {
          onTap(skin);
        }
      },
    );
  }
}
