import 'package:flutter/material.dart';

import '../models/snippet.dart';
import '../theme/app_colors.dart';

class SnippetCard extends StatefulWidget {
  const SnippetCard({super.key, required this.snippet, this.onTap, this.onCopy});

  final Snippet snippet;
  final VoidCallback? onTap;
  final VoidCallback? onCopy;

  @override
  State<SnippetCard> createState() => _SnippetCardState();
}

class _SnippetCardState extends State<SnippetCard> {
  bool _pressed = false;

  void _handleCopy() {
    widget.onCopy?.call();
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    if (reduceMotion) return;
    setState(() => _pressed = true);
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) setState(() => _pressed = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: widget.onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        title: Text(
          widget.snippet.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16.5,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            widget.snippet.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        trailing: AnimatedScale(
          scale: _pressed ? 0.88 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutQuart,
          child: IconButton.filled(
            icon: const Icon(Icons.copy_rounded, size: 20),
            tooltip: 'Copy',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: AppColors.textPrimary,
            ),
            onPressed: _handleCopy,
          ),
        ),
      ),
    );
  }
}
