import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/snippet.dart';
import '../providers/snippet_providers.dart';
import '../theme/app_colors.dart';
import '../utils/clipboard_utils.dart';
import 'edit_screen.dart';

class DetailScreen extends ConsumerStatefulWidget {
  const DetailScreen({super.key, required this.snippet});

  final Snippet snippet;

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  bool _pressed = false;

  void _handleCopy(Snippet current) {
    copySnippetContent(context, current);
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion) return;
    setState(() => _pressed = true);
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) setState(() => _pressed = false);
    });
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _formatUpdatedAt(int updatedAt) {
    final date = DateTime.fromMillisecondsSinceEpoch(updatedAt);
    return 'Updated ${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final snippets = ref.watch(snippetListProvider).value;
    final current = snippets?.firstWhere(
          (s) => s.id == widget.snippet.id,
          orElse: () => widget.snippet,
        ) ??
        widget.snippet;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Snippet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit',
            color: AppColors.textSecondary,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => EditScreen(snippet: current)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
            color: AppColors.textSecondary,
            onPressed: () => _confirmDelete(context, ref, current),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              current.title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                letterSpacing: -0.02,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatUpdatedAt(current.updatedAt),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.surfaceVariant),
              ),
              child: SelectableText(
                current.content,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutQuart,
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton.icon(
              icon: const Icon(Icons.copy_rounded),
              label: const Text(
                'Copy to clipboard',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              onPressed: () => _handleCopy(current),
            ),
          ),
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
