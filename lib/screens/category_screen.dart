import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/text_item.dart';
import '../widgets/text_card.dart';

class CategoryScreen extends StatefulWidget {
  final String categorie;
  const CategoryScreen({super.key, required this.categorie});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<TextItem> textes = [];
  bool chargement = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final result = await DatabaseHelper.instance.getTextesParCategorie(widget.categorie);
    setState(() {
      textes = result;
      chargement = false;
    });
  }

  Future<void> _toggleFavori(TextItem item) async {
    await DatabaseHelper.instance.toggleFavori(item);
    setState(() => item.favori = !item.favori);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categorie)),
      body: chargement
          ? const Center(child: CircularProgressIndicator())
          : textes.isEmpty
              ? const Center(child: Text('Aucun texte disponible.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: textes.length,
                  itemBuilder: (context, index) {
                    final item = textes[index];
                    return TextCard(item: item, onToggleFavori: () => _toggleFavori(item));
                  },
                ),
    );
  }
