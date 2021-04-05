import 'package:emoji_chooser/src/skin_dot.dart';
import 'package:emoji_chooser/src/skin_tones.dart';
import 'package:flutter/material.dart';

class SkinToneSelector extends StatefulWidget {
  final Function(int) onSkinChanged;

  const SkinToneSelector({
    Key key,
    @required this.onSkinChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SkinToneState();
}

class _SkinToneState extends State<SkinToneSelector> {
  int _skin = 0;
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    if (_expanded) {
      List<Widget> dots = [];
      for (var i = 0; i < SkinTones.tones.length; i++) {
        dots.add(
          Padding(
            child: SkinDot(
              skin: i,
              onTap: (skin) {
                setState(() {
                  _expanded = !_expanded;
                  _skin = skin;
                  widget.onSkinChanged(skin);
                });
              },
            ),
            padding: EdgeInsets.only(
              left: 24.0,
            ),
          ),
        );
      }
      return Row(
        children: dots,
      );
    } else {
      return SkinDot(
        skin: _skin,
        onTap: (skin) {
          setState(() {
            _expanded = !_expanded;
          });
        },
      );
    }
  }
}
