import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/text_item.dart';

class TextCard extends StatelessWidget {
  final TextItem item;
  final VoidCallback onToggleFavori;

  const TextCard({super.key, required this.item, required this.onToggleFavori});

  void _copier(BuildContext context) {
    Clipboard.setData(ClipboardData(text: item.contenu));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Texte copiÃ© âœ…'), duration: Duration(seconds: 1)),
    );
  }

  Future<void> _envoyerSMS() async {
    final uri = Uri(scheme: 'sms', path: '', queryParameters: {'body': item.contenu});
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _envoyerWhatsApp() async {
    final texte = Uri.encodeComponent(item.contenu);
    final uri = Uri.parse('https://wa.me/?text=$texte');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _partager() {
    Share.share(item.contenu);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.contenu, style: const TextStyle(fontSize: 16, height: 1.4)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Copier',
                      icon: const Icon(Icons.copy_rounded),
                      onPressed: () => _copier(context),
                    ),
                    IconButton(
                      tooltip: 'Envoyer par SMS',
                      icon: const Icon(Icons.sms_rounded),
                      onPressed: _envoyerSMS,
                    ),
                    IconButton(
                      tooltip: 'Envoyer par WhatsApp',
                      icon: const Icon(Icons.chat_rounded, color: Color(0xFF25D366)),
                      onPressed: _envoyerWhatsApp,
                    ),
                    IconButton(
                      tooltip: 'Partager',
                      icon: const Icon(Icons.share_rounded),
                      onPressed: _partager,
                    ),
                  ],
                ),
                IconButton(
                  tooltip: 'Favori',
                  icon: Icon(
                    item.favori ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    color: const Color(0xFFE94F7B),
                  ),
                  onPressed: onToggleFavori,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
