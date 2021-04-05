class EmojiInternalData {
  String id;
  String name;
  String unified;
  String char;
  String category;
  int sortOrder;
  bool hasApple;
  bool hasGoogle;
  List<String> skins = [];

  String charForSkin(int skin) {
    if (skin == 0 || skin >= skins.length + 1) {
      return this.char;
    }
    String unified = skins[skin - 1];
    return String.fromCharCodes(unified.split('-').map((e) {
      return int.parse(e, radix: 16);
    }));
  }

  String unifiedForSkin(int skin) {
    if (skin == 0 || skin >= skins.length + 1) {
      return this.unified;
    }
    return skins[skin - 1];
  }

  EmojiInternalData.fromJson(Map<String, dynamic> jsonData) {
    this.id = jsonData['unified'];
    this.name = jsonData['name'];
    this.unified = jsonData['unified'];
    this.category = jsonData['category'];
    this.sortOrder = jsonData['sort_order'];
    this.hasApple = jsonData['has_img_apple'];
    this.hasGoogle = jsonData['has_img_google'];
    this.char = String.fromCharCodes(this.unified.split('-').map((e) {
      return int.parse(e, radix: 16);
    }));
    if (jsonData.containsKey('skin_variations')) {
      for (var key in jsonData['skin_variations'].keys) {
        var entry = jsonData['skin_variations'][key];
        skins.add(entry['unified']);
      }
    }
  }
}
