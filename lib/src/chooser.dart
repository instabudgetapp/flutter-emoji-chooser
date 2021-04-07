import 'dart:convert';
import 'dart:math';

import 'package:emoji_chooser/emoji_chooser.dart';
import 'package:emoji_chooser/src/category.dart';
import 'package:emoji_chooser/src/category_icon.dart';
import 'package:emoji_chooser/src/category_selector.dart';
import 'package:emoji_chooser/src/emoji_internal_data.dart';
import 'package:emoji_chooser/src/emoji_page.dart';
import 'package:emoji_chooser/src/group.dart';
import 'package:emoji_chooser/src/skin_tone_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

class EmojiChooser extends StatefulWidget {
  final int columns;
  final int rows;
  final Function(EmojiData) onSelected;

  const EmojiChooser({
    Key key,
    this.columns = 10,
    this.rows = 5,
    @required this.onSelected,
  }) : super(key: key);
  @override
  State<StatefulWidget> createState() => _EmojiChooserState();
}

class _EmojiChooserState extends State<EmojiChooser> {
  Category selectedCategory = Category.SMILEYS;

  List<EmojiInternalData> _emojis = [];
  Map<Category, Group> _groups = {
    Category.SMILEYS: Group(
      Category.SMILEYS,
      CategoryIcons.smileyIcon,
      'Smileys & People',
      ['Smileys & Emotion', 'People & Body'],
    ),
    Category.ANIMALS: Group(
      Category.ANIMALS,
      CategoryIcons.animalIcon,
      'Animals & Nature',
      ['Animals & Nature'],
    ),
    Category.FOODS: Group(
      Category.FOODS,
      CategoryIcons.foodIcon,
      'Food & Drink',
      ['Food & Drink'],
    ),
    Category.ACTIVITIES: Group(
      Category.ACTIVITIES,
      CategoryIcons.activityIcon,
      'Activity',
      ['Activities'],
    ),
    Category.TRAVEL: Group(
      Category.TRAVEL,
      CategoryIcons.travelIcon,
      'Travel & Places',
      ['Travel & Places'],
    ),
    Category.OBJECTS: Group(
      Category.OBJECTS,
      CategoryIcons.objectIcon,
      'Objects',
      ['Objects'],
    ),
    Category.SYMBOLS: Group(
      Category.SYMBOLS,
      CategoryIcons.symbolIcon,
      'Symbols',
      ['Symbols'],
    ),
    Category.FLAGS: Group(
      Category.FLAGS,
      CategoryIcons.flagIcon,
      'Flags',
      ['Flags'],
    ),
  };
  List<Category> order = [
    Category.SMILEYS,
    Category.ANIMALS,
    Category.FOODS,
    Category.ACTIVITIES,
    Category.TRAVEL,
    Category.OBJECTS,
    Category.SYMBOLS,
    Category.FLAGS,
  ];

  int _skin = 0;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    loadEmoji(context);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return Container();

    int smileysNum = _groups[Category.SMILEYS].pages.length;
    int animalsNum = _groups[Category.ANIMALS].pages.length;
    int foodsNum = _groups[Category.FOODS].pages.length;
    int activitiesNum = _groups[Category.ACTIVITIES].pages.length;
    int travelNum = _groups[Category.TRAVEL].pages.length;
    int objectsNum = _groups[Category.OBJECTS].pages.length;
    int symbolsNum = _groups[Category.SYMBOLS].pages.length;
    int flagsNum = _groups[Category.FLAGS].pages.length;

    PageController pageController;
    switch (selectedCategory) {
      case Category.SMILEYS:
        pageController = PageController(initialPage: 0);
        break;
      case Category.ANIMALS:
        pageController = PageController(initialPage: smileysNum);
        break;
      case Category.FOODS:
        pageController = PageController(initialPage: smileysNum + animalsNum);
        break;
      case Category.ACTIVITIES:
        pageController =
            PageController(initialPage: smileysNum + animalsNum + foodsNum);
        break;
      case Category.TRAVEL:
        pageController = PageController(
            initialPage: smileysNum + animalsNum + foodsNum + activitiesNum);
        break;
      case Category.OBJECTS:
        pageController = PageController(
            initialPage:
                smileysNum + animalsNum + foodsNum + activitiesNum + travelNum);
        break;
      case Category.SYMBOLS:
        pageController = PageController(
            initialPage: smileysNum +
                animalsNum +
                foodsNum +
                activitiesNum +
                travelNum +
                objectsNum);
        break;
      case Category.FLAGS:
        pageController = PageController(
            initialPage: smileysNum +
                animalsNum +
                foodsNum +
                activitiesNum +
                travelNum +
                objectsNum +
                symbolsNum);
        break;
      default:
        pageController = PageController(initialPage: 0);
        break;
    }
    pageController.addListener(() {
      setState(() {});
    });

    List<Widget> pages = [];
    List<Widget> selectors = [];
    Group selectedGroup = _groups[selectedCategory];
    int index = 0;
    for (Category category in _groups.keys) {
      Group group = _groups[category];
      pages.addAll(group.pages.map((e) => EmojiPage(
            rows: widget.rows,
            columns: widget.columns,
            skin: _skin,
            emojis: e,
            onSelected: (internalData) {
              EmojiData emoji = EmojiData(
                internalData.id,
                internalData.name,
                internalData.unifiedForSkin(_skin),
                internalData.charForSkin(_skin),
                internalData.category,
                _skin,
              );
              if (widget.onSelected != null) {
                widget.onSelected(emoji);
              }
            },
          )));
      int current = index;
      selectors.add(
        CategorySelector(
          icon: group.icon,
          selected: selectedCategory == group.category,
          onSelected: () {
            pageController.jumpToPage(current);
          },
        ),
      );
      index += group.pages.length;
    }
    selectors.add(
      SkinToneSelector(onSkinChanged: (skin) {
        setState(() {
          _skin = skin;
        });
      }),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedGroup.title.toUpperCase(),
                style: TextStyle(
                  color: Theme.of(context).primaryTextTheme.caption.color,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          padding: EdgeInsets.fromLTRB(
            10.0,
            10.0,
            10.0,
            4.0,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: (MediaQuery.of(context).size.width / widget.columns) *
              widget.rows,
          child: PageView(
            children: pages,
            pageSnapping: true,
            controller: pageController,
            onPageChanged: (index) {
              if (index < smileysNum) {
                selectedCategory = Category.SMILEYS;
              } else if (index < smileysNum + animalsNum) {
                selectedCategory = Category.ANIMALS;
              } else if (index < smileysNum + animalsNum + foodsNum) {
                selectedCategory = Category.FOODS;
              } else if (index <
                  smileysNum + animalsNum + foodsNum + activitiesNum) {
                selectedCategory = Category.ACTIVITIES;
              } else if (index <
                  smileysNum +
                      animalsNum +
                      foodsNum +
                      activitiesNum +
                      travelNum) {
                selectedCategory = Category.TRAVEL;
              } else if (index <
                  smileysNum +
                      animalsNum +
                      foodsNum +
                      activitiesNum +
                      travelNum +
                      objectsNum) {
                selectedCategory = Category.OBJECTS;
              } else if (index <
                  smileysNum +
                      animalsNum +
                      foodsNum +
                      activitiesNum +
                      travelNum +
                      objectsNum +
                      symbolsNum) {
                selectedCategory = Category.SYMBOLS;
              } else if (index <
                  smileysNum +
                      animalsNum +
                      foodsNum +
                      activitiesNum +
                      travelNum +
                      objectsNum +
                      symbolsNum +
                      flagsNum) {
                selectedCategory = Category.FLAGS;
              }
            },
          ),
        ),
        Container(
          /* Category PICKER */
          height: 50,
          child: Row(
            children: selectors,
          ),
        ),
      ],
    );
  }

  loadEmoji(BuildContext context) async {
    const path = 'packages/emoji_chooser/data/emoji.json';
    String data = await rootBundle.loadString(path);
    final emojiList = json.decode(data);
    for (var emojiJson in emojiList) {
      EmojiInternalData data = EmojiInternalData.fromJson(emojiJson);
      _emojis.add(data);
    }
    // Per Category, create pages
    for (Category category in order) {
      Group group = _groups[category];
      List<EmojiInternalData> categoryEmojis = [];
      for (String name in group.names) {
        List<EmojiInternalData> subName = _emojis
            .where((element) => element.category == name && element.hasApple)
            .toList();
        subName.sort((lhs, rhs) => lhs.sortOrder.compareTo(rhs.sortOrder));
        categoryEmojis.addAll(subName);
      }

      // Create pages for that Category
      int num = (categoryEmojis.length / (widget.rows * widget.columns)).ceil();
      for (var i = 0; i < num; i++) {
        int start = widget.columns * widget.rows * i;
        int end =
            min(widget.columns * widget.rows * (i + 1), categoryEmojis.length);
        List<EmojiInternalData> pageEmojis = categoryEmojis.sublist(start, end);
        group.pages.add(pageEmojis);
      }
    }
    setState(() {
      _loaded = true;
    });
  }
}
