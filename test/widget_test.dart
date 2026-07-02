import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:copy_vault/main.dart';
import 'package:copy_vault/models/snippet.dart';
import 'package:copy_vault/providers/snippet_providers.dart';
import 'package:copy_vault/repositories/snippet_repository.dart';

class FakeSnippetRepository implements SnippetRepository {
  final List<Snippet> _snippets = [];
  int _nextId = 1;

  @override
  Future<Snippet> create(Snippet snippet) async {
    final saved = snippet.copyWith(id: _nextId++);
    _snippets.add(saved);
    return saved;
  }

  @override
  Future<void> update(Snippet snippet) async {
    final index = _snippets.indexWhere((s) => s.id == snippet.id);
    if (index != -1) {
      _snippets[index] = snippet;
    }
  }

  @override
  Future<List<Snippet>> getAll() async {
    final sorted = List<Snippet>.from(_snippets)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted;
  }

  @override
  Future<void> delete(int id) async {
    _snippets.removeWhere((s) => s.id == id);
  }
}

void main() {
  testWidgets('creating a snippet shows it at the top of the Home list',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          snippetRepositoryProvider.overrideWithValue(FakeSnippetRepository()),
        ],
        child: const MainApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No snippets yet'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Title'), 'My title');
    await tester.enterText(
        find.widgetWithText(TextFormField, 'Content'), 'My content');

    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('My title'), findsOneWidget);
    expect(find.text('My content'), findsOneWidget);
  });

  testWidgets('Save is blocked when fields are empty', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          snippetRepositoryProvider.overrideWithValue(FakeSnippetRepository()),
        ],
        child: const MainApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Title is required'), findsOneWidget);
    expect(find.text('Content is required'), findsOneWidget);
  });
}
