class CategoryModel {
  String? id;
  String? title;
  bool? isExpanded = false;
  bool? isSelected;
  double? height;
  int? level;
  String? levelText;
  String? parentLevel;
  List<CategoryModel> children;

  CategoryModel(
      {this.id,
      this.title,
      this.isExpanded,
      this.isSelected,
      this.children = const [],
      this.height,
      this.level,
      this.parentLevel,
      this.levelText});

  setLevelText() {
    String tmpTxt = "";
    for (int i = 0; i < level!; i++) {
      tmpTxt += "–";
    }
    levelText = "$tmpTxt $levelText";
  }
}

class Seller {
  final int id;
  final String name;

  Seller(this.id, this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Seller &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}
