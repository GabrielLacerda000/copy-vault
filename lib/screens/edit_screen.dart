import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/snippet.dart';
import '../providers/snippet_providers.dart';

class EditScreen extends ConsumerStatefulWidget {
  const EditScreen({super.key, required this.snippet});

  final Snippet snippet;

  @override
  ConsumerState<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends ConsumerState<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _titleController = TextEditingController(text: widget.snippet.title);
  late final _contentController = TextEditingController(text: widget.snippet.content);
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    
    try {
      await ref.read(snippetListProvider.notifier).updateSnippet(
            widget.snippet,
            _titleController.text.trim(),
            _contentController.text.trim(),
          );

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      // Opcional: Adicionar um ScaffoldMessenger para mostrar o erro
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit snippet')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Title is required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 8,
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Content is required' : null,
            ),
          ],
        ),
      ),
      // --- Botão fixado no rodapé da tela de edição ---
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FilledButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving 
                ? const SizedBox(
                    height: 20, 
                    width: 20, 
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                  )
                : const Text('Save'),
          ),
        ),
      ),
    );
  }
}