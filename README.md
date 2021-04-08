# Emoji Chooser

Emoji Chooser is an emoji picker component for Flutter.

![Screenhot of emoji chooser](https://github.com/instabudgetapp/flutter-emoji-chooser/blob/main/images/emoji_chooser.png?raw=true)

Brought to you by the [InstaBudget](https://instabudget.app) team.

## Getting Started

Declare dependency in your `pubspec.yaml`
```yaml
dependencies:
    emoji_chooser: ^0.9.3
```

You can then easily embed the Emoji Chooser Widget anywhere in your application:
```dart
EmojiChooser(
    onSelected: (emoji) {
        print('Selected emoji ${emoji.char}');
    },
),
```

You will receive a callback with an `EmojiData` object represented the emoji picked by the user.

```dart
class EmojiData {
  final String id;
  final String name;
  final String unified;
  final String char;
  final String category;
  final int skin;
}
```

When the emoji is qualified with a skin tone, both `unified` and `char` contains the qualifed values.

The `skin` parameter goes from 0 to 6, 0 representing no skin tone applied. 1 is then the lighter skin tone and 6 the darkest.

## How to use as a keyboard

You can use a modal sheet to simulate a keyboard.

```dart
return showModalBottomSheet(
    context: context,
    builder: (BuildContext subcontext) {
        return Container(
        height: 266,
        child: EmojiChooser(
            onSelected: (emoji) {
            Navigator.of(subcontext).pop(emoji);
            },
        ),
        );
    },
);
```


## 🎩 Hat tips!
Powered by [iamcal/emoji-data](https://github.com/iamcal/emoji-data) and inspired by [JeffG05/emoji_picker](https://github.com/JeffG05/emoji_picker).<br>
🙌🏼  [Cal Henderson](https://github.com/iamcal).
