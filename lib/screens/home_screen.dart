import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/snippet.dart';
import '../providers/snippet_providers.dart';
import '../widgets/snippet_card.dart';
import 'create_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snippets = ref.watch(snippetListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('CopyFast')),
      body: snippets.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No snippets yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) => SnippetCard(
              snippet: items[index],
              onCopy: () => _copySnippet(context, items[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CreateScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _copySnippet(BuildContext context, Snippet snippet) async {
    await Clipboard.setData(ClipboardData(text: snippet.content));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied successfully')),
    );
  }
}
