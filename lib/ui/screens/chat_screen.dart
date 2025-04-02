import 'dart:convert';

import 'package:ai_chat_app/api_service.dart';
import 'package:ai_chat_app/ui/widgets/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatScreen extends StatefulWidget {
  final ApiService apiService;

  const ChatScreen({super.key, required this.apiService});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  bool _isListening = false;
  String _text = "";
  List<String> messages = [];
  final ScrollController _scrollController = ScrollController();

  Future _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() => _text = result.recognizedWords);
        },
      );
    }
  }

  Future _stopListening() async {
    setState(() => _isListening = false);
    _speech.stop();
    if (_text.isNotEmpty) {
      messages.add("You: $_text");
      final response = await widget.apiService.sendToHuggingFace(_text);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final String reply = data[0]["generated_text"];
          setState(() => messages.add("AI: $reply"));
          _tts.speak(reply);
        }
      } else {
        setState(() => messages.add("AI: Error occurred"));
      }
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

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
      body: messages.isEmpty
          ? Center(
              child: Text(
                "Press the mic button to start chatting",
                style: TextStyle(fontSize: 20),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, i) => MessageWidget(message: messages[i]),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
    );
  }
}
