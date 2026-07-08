class TextItem {
  final int? id;
  final String contenu;
  final String categorie; // "Romantique", "Humoristique", "Citation du jour"
  bool favori;

  TextItem({
    this.id,
    required this.contenu,
    required this.categorie,
    this.favori = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'contenu': contenu,
      'categorie': categorie,
      'favori': favori ? 1 : 0,
    };
  }

  factory TextItem.fromMap(Map<String, dynamic> map) {
    return TextItem(
      id: map['id'],
      contenu: map['contenu'],
      categorie: map['categorie'],
      favori: map['favori'] == 1,
    );
  }
}
