import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/text_item.dart';
import '../widgets/text_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<TextItem> favoris = [];
  bool chargement = true;

  @override
  void initState() {
    super.initState();
    _charger();
  }

  Future<void> _charger() async {
    final result = await DatabaseHelper.instance.getFavoris();
    setState(() {
      favoris = result;
      chargement = false;
    });
  }

  Future<void> _toggleFavori(TextItem item) async {
    await DatabaseHelper.instance.toggleFavori(item);
    setState(() => favoris.removeWhere((t) => t.id == item.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mes favoris')),
      body: chargement
          ? const Center(child: CircularProgressIndicator())
          : favoris.isEmpty
              ? const Center(child: Text('Tu n\'as pas encore de favoris â¤ï¸'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: favoris.length,
                  itemBuilder: (context, index) {
                    final item = favoris[index];
                    return TextCard(item: item, onToggleFavori: () => _toggleFavori(item));
                  },
                ),
    );
  }
