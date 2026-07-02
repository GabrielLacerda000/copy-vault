import 'package:flutter/material.dart';

import '../models/snippet.dart';

class SnippetCard extends StatelessWidget {
  const SnippetCard({super.key, required this.snippet, this.onTap});

  final Snippet snippet;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(snippet.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(
          snippet.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
