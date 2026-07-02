import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/snippet.dart';
import '../repositories/snippet_repository.dart';

final snippetRepositoryProvider = Provider<SnippetRepository>((ref) {
  return SnippetRepository();
});

class SnippetListNotifier extends AsyncNotifier<List<Snippet>> {
  @override
  Future<List<Snippet>> build() {
    return ref.read(snippetRepositoryProvider).getAll();
  }

  Future<void> create(String title, String content) async {
    final repository = ref.read(snippetRepositoryProvider);
    final now = DateTime.now().millisecondsSinceEpoch;
    await repository.create(
      Snippet(title: title, content: content, createdAt: now, updatedAt: now),
    );
    state = await AsyncValue.guard(() => repository.getAll());
  }
}

final snippetListProvider =
    AsyncNotifierProvider<SnippetListNotifier, List<Snippet>>(
  SnippetListNotifier.new,
);
