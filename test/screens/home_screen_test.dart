import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:copy_vault/main.dart';
import 'package:copy_vault/models/snippet.dart';
import 'package:copy_vault/providers/snippet_providers.dart';
import 'package:copy_vault/repositories/snippet_repository.dart';

class FakeSnippetRepository implements SnippetRepository {
  FakeSnippetRepository(this._snippets);

  final List<Snippet> _snippets;
  int _nextId = 1000;

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
  Future<void> pumpHome(WidgetTester tester, List<Snippet> seed) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          snippetRepositoryProvider
              .overrideWithValue(FakeSnippetRepository(seed)),
        ],
        child: const MainApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('filters the list by title as the user types', (tester) async {
    await pumpHome(tester, [
      Snippet(
          id: 1,
          title: 'Shopping list',
          content: 'milk, eggs',
          createdAt: 1,
          updatedAt: 1),
      Snippet(
          id: 2,
          title: 'Work notes',
          content: 'standup at 9am',
          createdAt: 2,
          updatedAt: 2),
    ]);

    await tester.enterText(find.byType(TextField), 'Shopping');
    await tester.pumpAndSettle();

    expect(find.text('Shopping list'), findsOneWidget);
    expect(find.text('Work notes'), findsNothing);
  });

  testWidgets('filters the list by content as the user types', (tester) async {
    await pumpHome(tester, [
      Snippet(
          id: 1,
          title: 'Shopping list',
          content: 'milk, eggs',
          createdAt: 1,
          updatedAt: 1),
      Snippet(
          id: 2,
          title: 'Work notes',
          content: 'standup at 9am',
          createdAt: 2,
          updatedAt: 2),
    ]);

    await tester.enterText(find.byType(TextField), 'standup');
    await tester.pumpAndSettle();

    expect(find.text('Work notes'), findsOneWidget);
    expect(find.text('Shopping list'), findsNothing);
  });

  testWidgets('clearing the search restores the full list, newest first',
      (tester) async {
    await pumpHome(tester, [
      Snippet(
          id: 1,
          title: 'Shopping list',
          content: 'milk, eggs',
          createdAt: 1,
          updatedAt: 1),
      Snippet(
          id: 2,
          title: 'Work notes',
          content: 'standup at 9am',
          createdAt: 2,
          updatedAt: 2),
    ]);

    await tester.enterText(find.byType(TextField), 'standup');
    await tester.pumpAndSettle();
    expect(find.text('Shopping list'), findsNothing);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    expect(find.text('Shopping list'), findsOneWidget);
    expect(find.text('Work notes'), findsOneWidget);
  });

  testWidgets('shows a no-matches message when nothing matches the query',
      (tester) async {
    await pumpHome(tester, [
      Snippet(
          id: 1,
          title: 'Shopping list',
          content: 'milk, eggs',
          createdAt: 1,
          updatedAt: 1),
    ]);

    await tester.enterText(find.byType(TextField), 'nonexistent');
    await tester.pumpAndSettle();

    expect(find.text('No matches found'), findsOneWidget);
    expect(find.text('No snippets yet'), findsNothing);
  });

  testWidgets('shows the empty-list message when there are no snippets at all',
      (tester) async {
    await pumpHome(tester, []);

    expect(find.text('No snippets yet'), findsOneWidget);
  });
}
