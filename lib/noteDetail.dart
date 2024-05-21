import 'package:flutter/material.dart';
import 'package:notai/databaseHelper.dart';
import 'package:notai/notes.dart';

class NoteDetailPage extends StatefulWidget {
  final Note note;

  NoteDetailPage({required this.note});

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late TextEditingController _controller;
  late String _initialContent;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.note.content);
    _initialContent = widget.note.content;
  }

  Future<void> _saveNote() async {
    final updatedContent = _controller.text;
    if (updatedContent.isNotEmpty && updatedContent != widget.note.content) {
      final updatedNote = Note(
        id: widget.note.id,
        content: updatedContent,
      );
      await DatabaseHelper().updateNote(updatedNote);
    }
  }

  Future<bool> _onWillPop() async {
    if (_controller.text != _initialContent) {
      bool? shouldSave = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Değişikliği Kaydet'),
            content: Text('Notta yapılan değişiklikleri kaydetmek istiyor musunuz?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Hayır'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Evet'),
              ),
            ],
          );
        },
      );

      if (shouldSave == true) {
        await _saveNote();
        Navigator.of(context).pop(true); // Geri dönerken true döndür
        return true;
      }
    }
    Navigator.of(context).pop(false); // Değişiklik yapılmadıysa false döndür
    return true;
  }

  void _deleteNote() async {
    bool? shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Notu Sil'),
          content: Text('Notu silmek istediğine emin misin?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Hayır'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Evet'),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await DatabaseHelper().deleteNote(widget.note.id!);
      Navigator.of(context).pop(true); // Silme işleminden sonra true döndür
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Not Detayı'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteNote,
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: TextFormField(
            controller: _controller,
            maxLines: null, // Sınırsız sayıda satır için
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}