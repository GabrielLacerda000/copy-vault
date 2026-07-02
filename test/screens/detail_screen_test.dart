import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:copy_vault/main.dart';
import 'package:copy_vault/models/snippet.dart';
import 'package:copy_vault/providers/snippet_providers.dart';
import 'package:copy_vault/repositories/snippet_repository.dart';
import 'package:copy_vault/screens/detail_screen.dart';
import 'package:copy_vault/screens/edit_screen.dart';

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
}

const _title = 'My title';
const _content = 'My full content that is quite long indeed';

Future<void> _pumpHomeWithOneSnippet(
  WidgetTester tester, {
  FakeSnippetRepository? repository,
}) async {
  final now = DateTime.now().millisecondsSinceEpoch;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        snippetRepositoryProvider.overrideWithValue(
          repository ??
              FakeSnippetRepository(
                seed: [
                  Snippet(
                    id: 1,
                    title: _title,
                    content: _content,
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
}

void main() {
  testWidgets(
      'tapping a snippet card (not the copy icon) navigates to Detail '
      'showing full title and content', (tester) async {
    await _pumpHomeWithOneSnippet(tester);

    await tester.tap(find.text(_title).first);
    await tester.pumpAndSettle();

    final detailFinder = find.byType(DetailScreen);
    expect(detailFinder, findsOneWidget);
    expect(
      find.descendant(of: detailFinder, matching: find.text(_title)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: detailFinder, matching: find.text(_content)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: detailFinder, matching: find.byIcon(Icons.edit)),
      findsOneWidget,
    );
    expect(
      find.descendant(of: detailFinder, matching: find.byIcon(Icons.delete)),
      findsOneWidget,
    );
  });

  testWidgets(
      'copy action on Detail screen copies content and shows feedback',
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

    await _pumpHomeWithOneSnippet(tester);

    await tester.tap(find.text(_title).first);
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(DetailScreen),
        matching: find.byIcon(Icons.copy),
      ),
    );
    await tester.pumpAndSettle();

    expect(copiedText, _content);
    expect(find.text('Copied successfully'), findsOneWidget);
  });

  testWidgets(
      'edit action opens a prefilled Edit screen and blocks save on empty fields',
      (tester) async {
    await _pumpHomeWithOneSnippet(tester);

    await tester.tap(find.text(_title).first);
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(DetailScreen),
        matching: find.byIcon(Icons.edit),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EditScreen), findsOneWidget);

    final fieldsFinder = find.descendant(
      of: find.byType(EditScreen),
      matching: find.byType(TextFormField),
    );
    final titleField = tester.widget<TextFormField>(fieldsFinder.at(0));
    final contentField = tester.widget<TextFormField>(fieldsFinder.at(1));
    expect(titleField.controller!.text, _title);
    expect(contentField.controller!.text, _content);

    await tester.enterText(fieldsFinder.at(0), '');
    await tester.enterText(fieldsFinder.at(1), '');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.text('Title is required'), findsOneWidget);
    expect(find.text('Content is required'), findsOneWidget);
    expect(find.byType(EditScreen), findsOneWidget);
  });

  testWidgets(
      'saving an edit updates Detail and Home, bumping updatedAt but not createdAt',
      (tester) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final repository = FakeSnippetRepository(
      seed: [
        Snippet(
          id: 1,
          title: _title,
          content: _content,
          createdAt: now,
          updatedAt: now,
        ),
      ],
    );

    await _pumpHomeWithOneSnippet(tester, repository: repository);

    await tester.tap(find.text(_title).first);
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(DetailScreen),
        matching: find.byIcon(Icons.edit),
      ),
    );
    await tester.pumpAndSettle();

    final fieldsFinder = find.descendant(
      of: find.byType(EditScreen),
      matching: find.byType(TextFormField),
    );
    await tester.enterText(fieldsFinder.at(0), 'Updated title');
    await tester.enterText(fieldsFinder.at(1), 'Updated content');
    await tester.tap(find.widgetWithText(FilledButton, 'Save'));
    await tester.pumpAndSettle();

    expect(find.byType(EditScreen), findsNothing);
    expect(find.byType(DetailScreen), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(DetailScreen),
        matching: find.text('Updated title'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byType(DetailScreen),
        matching: find.text('Updated content'),
      ),
      findsOneWidget,
    );

    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.text('Updated title'), findsOneWidget);
    expect(find.text(_title), findsNothing);

    final saved = (await repository.getAll()).single;
    expect(saved.createdAt, now);
    expect(saved.updatedAt, greaterThan(now));
  });
}
