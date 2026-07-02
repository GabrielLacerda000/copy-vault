import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/snippet.dart';

/// Copies [snippet]'s content to the clipboard and shows the standard
/// "Copied successfully" feedback. Shared by Home (list copy button) and
/// Detail (copy action) so both stay in sync.
Future<void> copySnippetContent(BuildContext context, Snippet snippet) async {
  await Clipboard.setData(ClipboardData(text: snippet.content));
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Copied successfully')),
  );
}
