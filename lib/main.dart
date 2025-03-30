// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:speech_to_text/speech_to_text.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  runApp(AIChatApp());
}

class AIChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isListening = false;
  String _text = "";
  List<String> messages = [];

  Future _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        setState(() => _text = result.recognizedWords);
      });
    }
  }

  Future _stopListening() async {
    setState(() => _isListening = false);
    _speech.stop();
    if (_text.isNotEmpty) {
      messages.add("You: $_text");
      _sendToHuggingFace(_text);
    }
  }

  Future _sendToHuggingFace(String message) async {
    final url = Uri.parse(
      "https://api-inference.huggingface.co/models/facebook/blenderbot-400M-distill",
    );

    final response = await http.post(
      url,
      headers: {"Authorization": "Bearer ${dotenv.env['HUGGINGFACE_API_KEY']}"},
      body: jsonEncode({"inputs": message}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        log(
          data.toString(),
          name: "HuggingFace Response",
        );
        final String reply = data[0]["generated_text"];
        setState(() => messages.add("AI: $reply"));
        _tts.speak(reply);
      }
    }
  }

  bool _messageFromMe(String message) => message.startsWith('You');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Voice Chat")),
      floatingActionButton: FloatingActionButton(
        onPressed: _isListening ? _stopListening : _startListening,
        splashColor: Colors.blue,
        backgroundColor: Colors.blue.shade300,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, i) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _messageFromMe(messages[i]) ? Color(0xFF6CB2FF) : Colors.green.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(_messageFromMe(messages[i]) ? 15 : 0),
                      topRight: Radius.circular(_messageFromMe(messages[i]) ? 0 : 15),
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      messages[i],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
