import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:copy_vault/main.dart';
import 'package:copy_vault/models/snippet.dart';
import 'package:copy_vault/providers/snippet_providers.dart';
import 'package:copy_vault/repositories/snippet_repository.dart';

class FakeSnippetRepository implements SnippetRepository {
  FakeSnippetRepository({List<Snippet> seed = const []})
      : _snippets = List<Snippet>.from(seed);

  final List<Snippet> _snippets;
  int _nextId = 1;

  @override
  Future<Snippet> create(Snippet snippet) async {
    final saved = snippet.copyWith(id: _nextId++);
    _snippets.add(saved);
    return saved;
  }

  @override
  Future<List<Snippet>> getAll() async {
    final sorted = List<Snippet>.from(_snippets)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }
}

void main() {
  testWidgets('tapping the copy button copies content and shows feedback',
      (tester) async {
    String? copiedText;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copiedText = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(() {
      tester.binding.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, null);
    });

    final now = DateTime.now().millisecondsSinceEpoch;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          snippetRepositoryProvider.overrideWithValue(
            FakeSnippetRepository(
              seed: [
                Snippet(
                  id: 1,
                  title: 'My title',
                  content: 'My full content',
                  createdAt: now,
                  updatedAt: now,
                ),
              ],
            ),
          ),
        ],
        child: const MainApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.copy));
    await tester.pumpAndSettle();

    expect(copiedText, 'My full content');
    expect(find.text('Copied successfully'), findsOneWidget);
    expect(find.text('CopyFast'), findsOneWidget);
  });
}
