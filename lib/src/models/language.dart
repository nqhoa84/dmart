class Language {
  String code;
  String englishName;
  String localName;
  String flag;
  bool selected;

  Language(this.code, this.englishName, this.localName, this.flag, {this.selected = false});

  static Language khmer = Language("fr", "Khmer", "ខ្មែរ", "assets/img/M_Flag_Cambodia.png");
  static Language english = Language("en", "English", "English", "assets/img/M_Flag_Eng.png");
}