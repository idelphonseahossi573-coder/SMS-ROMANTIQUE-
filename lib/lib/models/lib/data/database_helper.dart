import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/text_item.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('sms_romantique.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE textes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contenu TEXT NOT NULL,
        categorie TEXT NOT NULL,
        favori INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await _insertDonneesInitiales(db);
  }

  Future _insertDonneesInitiales(Database db) async {
    final List<TextItem> donnees = [
      // Romantique
      TextItem(contenu: "Chaque battement de mon cÅ“ur murmure ton nom.", categorie: "Romantique"),
      TextItem(contenu: "Depuis que tu es lÃ , mes journÃ©es ont une couleur diffÃ©rente.", categorie: "Romantique"),
      TextItem(contenu: "Tu es la raison pour laquelle je souris en lisant mes messages.", categorie: "Romantique"),
      TextItem(contenu: "Si l'amour Ã©tait une distance, je marcherais jusqu'Ã  toi sans jamais me fatiguer.", categorie: "Romantique"),
      TextItem(contenu: "Ton absence me rappelle Ã  quel point ta prÃ©sence compte.", categorie: "Romantique"),
      TextItem(contenu: "Je n'ai pas besoin de la lune, ton sourire Ã©claire dÃ©jÃ  mes nuits.", categorie: "Romantique"),
      TextItem(contenu: "Tu es le genre de bonheur que je n'attendais pas et que je ne veux plus quitter.", categorie: "Romantique"),
      TextItem(contenu: "Penser Ã  toi est devenu mon passe-temps prÃ©fÃ©rÃ©.", categorie: "Romantique"),

      // Humoristique
      TextItem(contenu: "Je ne suis pas romantique, je suis juste sÃ©rieusement accro Ã  toi.", categorie: "Humoristique"),
      TextItem(contenu: "On dit que l'amour rend aveugle... heureusement que je t'ai vu(e) avant !", categorie: "Humoristique"),
      TextItem(contenu: "Mon wifi et toi, vous Ãªtes les deux connexions dont je ne peux pas me passer.", categorie: "Humoristique"),
      TextItem(contenu: "Je voulais t'envoyer un texto romantique mais mon cerveau a buggÃ© en pensant Ã  toi.", categorie: "Humoristique"),
      TextItem(contenu: "Attention : ce message contient un taux Ã©levÃ© de charme irrÃ©sistible (le mien).", categorie: "Humoristique"),
      TextItem(contenu: "Je ne crois pas au coup de foudre... jusqu'Ã  ce que je t'aie rencontrÃ©(e), bug inclus.", categorie: "Humoristique"),
      TextItem(contenu: "Tu es la seule notification que je ne mets jamais en silencieux.", categorie: "Humoristique"),

      // Citation du jour
      TextItem(contenu: "\"Aimer, ce n'est pas se regarder l'un l'autre, c'est regarder ensemble dans la mÃªme direction.\" â€” Antoine de Saint-ExupÃ©ry", categorie: "Citation du jour"),
      TextItem(contenu: "\"Le cÅ“ur a ses raisons que la raison ne connaÃ®t point.\" â€” Blaise Pascal", categorie: "Citation du jour"),
      TextItem(contenu: "\"Il n'y a qu'un bonheur dans la vie, c'est d'aimer et d'Ãªtre aimÃ©.\" â€” George Sand", categorie: "Citation du jour"),
      TextItem(contenu: "\"Aimer quelqu'un, c'est lui montrer sa libertÃ©.\" â€” Jean-Paul Sartre", categorie: "Citation du jour"),
      TextItem(contenu: "\"La vie est une fleur dont l'amour est le miel.\" â€” Victor Hugo", categorie: "Citation du jour"),
    ];

    for (final item in donnees) {
      await db.insert('textes', item.toMap());
    }
  }

  // --- CRUD ---

  Future<List<TextItem>> getTextesParCategorie(String categorie) async {
    final db = await instance.database;
    final result = await db.query('textes', where: 'categorie = ?', whereArgs: [categorie]);
    return result.map((e) => TextItem.fromMap(e)).toList();
  }

  Future<List<TextItem>> getFavoris() async {
    final db = await instance.database;
    final result = await db.query('textes', where: 'favori = 1');
    return result.map((e) => TextItem.fromMap(e)).toList();
  }

  Future<TextItem> getCitationDuJour() async {
    final db = await instance.database;
    final result = await db.query('textes', where: 'categorie = ?', whereArgs: ['Citation du jour']);
    final liste = result.map((e) => TextItem.fromMap(e)).toList();
    final index = DateTime.now().day % liste.length;
    return liste[index];
  }

  Future<void> toggleFavori(TextItem item) async {
    final db = await instance.database;
    await db.update(
      'textes',
      {'favori': item.favori ? 0 : 1},
      where: 'id = ?',
      whereArgs: [item.id],
    );
  }
}
