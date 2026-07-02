import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/snippet.dart';
import '../providers/snippet_providers.dart';
import '../theme/app_colors.dart';
import '../utils/clipboard_utils.dart';
import 'edit_screen.dart';

class DetailScreen extends ConsumerWidget {
  const DetailScreen({super.key, required this.snippet});

  final Snippet snippet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snippets = ref.watch(snippetListProvider).value;
    final current = snippets?.firstWhere(
          (s) => s.id == snippet.id,
          orElse: () => snippet,
        ) ??
        snippet;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Snippet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy',
            onPressed: () => copySnippetContent(context, current),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => EditScreen(snippet: current)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () => _confirmDelete(context, ref, current),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              current.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            SelectableText(current.content),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    Snippet current,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete this text?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: AppColors.danger),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    await ref.read(snippetListProvider.notifier).deleteSnippet(current.id!);

    if (!context.mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
