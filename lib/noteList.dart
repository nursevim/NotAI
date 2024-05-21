import 'package:flutter/material.dart';
import 'package:notai/addNote.dart';
import 'package:notai/chatgptAskPage.dart';
import 'package:notai/databaseHelper.dart';
import 'package:notai/noteDetail.dart';
import 'package:notai/notes.dart';

class NoteListPage extends StatefulWidget {
  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  List<Note> notes = [];
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadNotes();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadMoreNotes();
      }
    });
  }

  Future<void> _loadNotes() async {
    final data = await DatabaseHelper().getNotes();
    setState(() {
      notes = data.map((item) => Note.fromMap(item)).toList();
    });
  }

  Future<void> _loadMoreNotes() async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    await Future.delayed(Duration(seconds: 2));

    List<Note> newNotes = List.generate(
      20,
      (index) => Note(
        content: 'Note ${notes.length + index + 1}',
      ),
    );

    for (var note in newNotes) {
      await DatabaseHelper().insertNote(note.content);
    }

    _loadNotes();

    setState(() {
      isLoading = false;
    });
  }

  void _addNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddNotePage()),
    );

    if (result != null && result.isNotEmpty) {
      await DatabaseHelper().insertNote(result);
      _loadNotes();
    }
  }

  void _viewNoteDetails(Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteDetailPage(note: note)),
    );

    if (result == true) {
      _loadNotes();
    }
  }

  void _goToChatGptPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatGptPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/notailogo.png', // Logonuzun yolunu buraya ekleyin
              height: 24, // Logo yüksekliği
              width: 24, // Logo genişliği
            ),
            SizedBox(width: 8), // Logo ile metin arasına boşluk eklemek için
            Text('Notlarım'),
          ],
        ),
        actions: [
          IconButton(
            icon: ImageIcon(
              AssetImage('assets/chatgpticon.png'),
            ),
            onPressed: _goToChatGptPage,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1.0,
              ),
              itemCount: notes.length + 1,
              itemBuilder: (context, index) {
                if (index == notes.length) {
                  return _buildProgressIndicator();
                } else {
                  return GestureDetector(
                    onTap: () => _viewNoteDetails(notes[index]),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5.0,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              notes[index].content,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 5,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          if (notes[index].content.length > 50)
                            Text(
                              '...',
                              style: TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(62, 95, 140, 255),
        onPressed: _addNote,
        tooltip: 'Not Ekle',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: isLoading ? CircularProgressIndicator() : SizedBox.shrink(),
      ),
    );
  }
}
