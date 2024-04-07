import 'dart:convert';
import 'package:http/http.dart' as http;

const originalText =
    "Hey guys, I have been learning and understanding about Traces in Ethereum to build something out of it. I was going through Alchemy's guide on EVM Traces and found this image but while checking out in Node, they don't work in this order. Is the order in the image correct?";
const apiKey = '';

Future<void> main() async {
  final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.0-pro:generateContent?key=$apiKey');

  final requestBody = jsonEncode({
    "contents": [
      {
        "parts": [
          {
            "text": """
            你是一位專業的翻譯者，請你將即時通訊軟體上的對話翻譯為正體中文（zh-tw）。
            你應確認此翻譯符合臺灣人口語使用，而非單純照字面意思翻譯。
            不需要每個字詞都翻譯，請以符合原句意思為優先考量。
            專有名詞請你附上原文，將其放在（）中。例子：智能合約（smart contract）。
            以下為對話內容：$originalText
            """
          }
        ]
      }
    ],
    "generationConfig": {
      "temperature": 0.9,
      "topK": 1,
      "topP": 1,
      "maxOutputTokens": 2048,
      "stopSequences": []
    },
    "safetySettings": [
      {"category": "HARM_CATEGORY_HARASSMENT", "threshold": "BLOCK_NONE"},
      {"category": "HARM_CATEGORY_HATE_SPEECH", "threshold": "BLOCK_NONE"},
      {
        "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
        "threshold": "BLOCK_NONE"
      },
      {"category": "HARM_CATEGORY_DANGEROUS_CONTENT", "threshold": "BLOCK_NONE"}
    ]
  });

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: requestBody,
  );
  final responseJson = jsonDecode(response.body);

  print(responseJson['candidates'][0]['content']['parts'][0]['text']);
}
