import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatGptService {
  // OpenAI API anahtarınızı buraya ekleyin
  final String apiKey = 'sk-proj-gGaxqCKMWbKZhT2jmhP4T3BlbkFJvLvilyEUwmzwnveuffJa'; // API anahtarınızı buraya ekleyin

  Future<String> getChatGptResponse(String question, List<String> notes) async {
    final url = Uri.parse('https://api.openai.com/v1/chat/completions');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    };

    final prompt = "Aşağıdaki notlara sahibim:\n" +
        notes.join("\n") +
        "\nSadece yukarıdaki notları kullanarak aşağıdaki soruyu yanıtla. Açıklama yapmana gerek yok sadece cevabı yaz. Notlardaki bilgileri kullanarak soruya cevap bulamıyorsan 'Bu sorunun cevabı notlarınızda bulunmuyor' şeklinde geri dönüş yap: $question";

    final body = json.encode({
      'model': 'gpt-3.5-turbo', // OpenAI'nin geçerli modeli
      'messages': [
        {
          'role': 'system',
          'content': 'You are a helpful assistant.'
        },
        {
          'role': 'user',
          'content': prompt,
        }
      ],
      'max_tokens': 1000,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'].trim();
      } else {
        print('Failed to load response: ${response.body}');
        throw Exception('Failed to load response from ChatGPT');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to load response from ChatGPT');
    }
  }
}