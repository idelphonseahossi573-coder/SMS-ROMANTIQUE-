import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/text_item.dart';
import 'category_screen.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextItem? citationDuJour;

  final List<Map<String, dynamic>> categories = const [
    {'nom': 'Romantique', 'icone': Icons.favorite_rounded, 'couleur': Color(0xFFE94F7B)},
    {'nom': 'Humoristique', 'icone': Icons.emoji_emotions_rounded, 'couleur': Color(0xFFFFA726)},
    {'nom': 'Citation du jour', 'icone': Icons.format_quote_rounded, 'couleur': Color(0xFF7E57C2)},
  ];

  @override
  void initState() {
    super.initState();
    _chargerCitation();
  }

  Future<void> _chargerCitation() async {
    final citation = await DatabaseHelper.instance.getCitationDuJour();
    setState(() => citationDuJour = citation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SMS Romantique'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_rounded),
            tooltip: 'Mes favoris',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Citation du jour en haut
          if (citationDuJour != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFE94F7B), Color(0xFFB5324F)]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.format_quote_rounded, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Citation du jour', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(citationDuJour!.contenu, style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.4)),
                ],
              ),
            ),

          const SizedBox(height: 24),
          const Text('CatÃ©gories', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),

          // Grille des catÃ©gories
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            children: categories.map((cat) {
              return InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CategoryScreen(categorie: cat['nom'])),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: (cat['couleur'] as Color).withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: (cat['couleur'] as Color).withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(cat['icone'], size: 40, color: cat['couleur']),
                      const SizedBox(height: 10),
                      Text(cat['nom'], textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),
          Card(
            color: const Color(0xFFFCE8ED),
            child: ListTile(
              leading: const Icon(Icons.favorite_rounded, color: Color(0xFFE94F7B)),
              title: const Text('Mes favoris'),
              subtitle: const Text('Retrouve tes textes prÃ©fÃ©rÃ©s'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
