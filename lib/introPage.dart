import 'package:flutter/material.dart';
import 'package:notai/noteList.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(241, 246, 249, 255),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 275, // Görselin genişliği
              height: 360, // Görselin yüksekliği
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/notai.png'), // Görselin yolu
                  fit: BoxFit.cover, // Görselin kutuya sığdırılması
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: const Text(
                'Notlarını yapay zekanın gücü ile daha verimli kullan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => NoteListPage()),
                  );
                },
                child: const Text(
                  'Notlarını Eklemeye Başla',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                  textStyle: TextStyle(fontSize: 18),
                  backgroundColor: Color.fromARGB(140, 177, 222, 255),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
