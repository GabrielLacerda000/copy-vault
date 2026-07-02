import '../data/database_helper.dart';
import '../models/snippet.dart';

class SnippetRepository {
  SnippetRepository({DatabaseHelper? databaseHelper})
      : _databaseHelper = databaseHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _databaseHelper;

  Future<Snippet> create(Snippet snippet) async {
    final db = await _databaseHelper.database;
    final id = await db.insert('snippets', snippet.toMap());
    return snippet.copyWith(id: id);
  }

  Future<void> update(Snippet snippet) async {
    final db = await _databaseHelper.database;
    await db.update(
      'snippets',
      snippet.toMap(),
      where: 'id = ?',
      whereArgs: [snippet.id],
    );
  }

  Future<List<Snippet>> getAll() async {
    final db = await _databaseHelper.database;
    final rows = await db.query('snippets', orderBy: 'created_at DESC');
    return rows.map(Snippet.fromMap).toList();
  }

  Future<void> delete(int id) async {
    final db = await _databaseHelper.database;
    await db.delete('snippets', where: 'id = ?', whereArgs: [id]);
  }
}
