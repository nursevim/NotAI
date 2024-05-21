import 'package:flutter/material.dart';
import 'package:notai/chatgptService.dart';
import 'package:notai/databaseHelper.dart';
import 'package:notai/notes.dart';

class ChatGptPage extends StatefulWidget {
  @override
  _ChatGptPageState createState() => _ChatGptPageState();
}

class _ChatGptPageState extends State<ChatGptPage> {
  final _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  Future<void> _askQuestion() async {
    setState(() {
      _isLoading = true;
    });

    final question = _controller.text;
    _controller.clear();

    setState(() {
      _messages.add({'role': 'user', 'content': question});
    });

    final data = await DatabaseHelper().getNotes();
    final notes = data.map((item) => Note.fromMap(item).content).toList();

    final service = ChatGptService();
    try {
      final response = await service.getChatGptResponse(question, notes);
      setState(() {
        _messages.add({'role': 'assistant', 'content': response});
      });
    } catch (error) {
      setState(() {
        _messages
            .add({'role': 'assistant', 'content': 'Failed to load response from ChatGPT. Please try again later.'});
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildMessage(Map<String, String> message) {
    final isUser = message['role'] == 'user';
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final color = isUser ? Colors.blue : Color(0xFF00A67E);
    final textColor = isUser ? Colors.white : Colors.white;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      alignment: alignment,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Text(
          message['content']!,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yapay Zekaya Sor'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          if (_isLoading) CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Notlarından Cevap Al',
                      labelStyle: TextStyle(
                        color: Color.fromARGB(200, 95, 140, 255),
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromARGB(200, 95, 140, 255)),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _askQuestion,
                  child: Text(
                    'Gönder',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(140, 177, 222, 255),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
