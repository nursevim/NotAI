import 'package:flutter/material.dart';

class AddNotePage extends StatefulWidget {
  @override
  _AddNotePageState createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  String _note = '';

  void _saveNote() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Navigator.pop(context, _note);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Not Ekle'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Not'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Lütfen Önce Notunuzu Giriniz';
                  }
                  return null;
                },
                onSaved: (value) {
                  _note = value!;
                },
                maxLines: null, // Alt satıra geçişi sağlamak için maxLines'ı null yapın
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveNote,
                child: Text('Kaydet',
                  style: TextStyle(
                    color: Colors.black
                  ),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(140,177,222,255),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}