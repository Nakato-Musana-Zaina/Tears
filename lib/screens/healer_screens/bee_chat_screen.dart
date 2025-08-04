// lib/screens/bee_chat_screen.dart

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tears/main.dart'; // To access openAiApiKey

class BeeChatScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;

  const BeeChatScreen({Key? key, required this.toggleTheme, required this.isDarkMode}) : super(key: key);

  @override
  _BeeChatScreenState createState() => _BeeChatScreenState();
}

class _BeeChatScreenState extends State<BeeChatScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final stt.SpeechToText _speech = stt.SpeechToText();

  List<_Message> _messages = [];
  bool _isLoading = false;
  bool _isListening = false;
  String _selectedTone = 'Gentle'; // Gentle, Witty, Savage, Angry
  late AnimationController _pulseController;

  // Brand Colors
  final Color primary = Color(0xFF590201);
  final Color accent = Color(0xFFFEC106);
  final Color soft = Color(0xFFF8D56C);

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat();
    _initSpeech();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _messages.add(_Message(
            "Hello! I'm Bee 🐝\nHow would you like me to speak today?",
            false,
          ));
        });
        _scrollToBottom();
      }
    });
  }

  void _initSpeech() async {
    await _speech.initialize(onError: (e) => print("Speech error: $e"));
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _startListening() async {
    if (!_speech.isAvailable) return;
    setState(() => _isListening = true);
    await _speech.listen(
      onResult: (result) {
        _controller.text = result.recognizedWords;
      },
      listenFor: Duration(seconds: 10),
      pauseFor: Duration(seconds: 5),
    );
    setState(() => _isListening = false);
  }

  Future<void> _sendMessage(String text, {bool isRoast = false}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    setState(() {
      _messages.insert(0, _Message(trimmed, true));
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    final tonePrompt = {
      'Gentle': 'Respond with warmth, empathy, and soft wisdom.',
      'Witty': 'Be clever, playful, and lightly sarcastic.',
      'Savage': 'No mercy. Roast with style and confidence.',
      'Angry': 'Channel righteous fury. Be bold and unapologetic.',
    }[_selectedTone];

    final prompt = isRoast
        ? "Bee, give me a savage roast of my ex based on: '$trimmed'. Be $tonePrompt?. Make it witty and painful."
        : "You are Bee, a healing AI. $tonePrompt?. Respond in 1-2 sentences.\n\nUser: $trimmed\nBee:";

    final reply = await _fetchAIResponse(prompt);

    setState(() {
      _messages.insert(0, _Message(reply, false));
      _isLoading = false;
    });

    _scrollToBottom();
  }

  Future<String> _fetchAIResponse(String prompt) async {
    try {
     final response = await http.post(
  Uri.parse('https://api.openai.com/v1/completions'),
  headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $openAiApiKey', // ✅ Use global key
  },
        body: jsonEncode({
          'model': 'text-davinci-003',
          'prompt': prompt,
          'max_tokens': 100,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['text'].trim();
      }
      return "I couldn't connect right now.";
    } catch (e) {
      return "Network error. Check your connection.";
    }
  }

  Future<void> _saveJournal() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/healing_journal.txt');
    final content = _messages.map((m) => '${m.isUser ? 'You' : 'Bee'}: ${m.text}').join('\n\n');
    await file.writeAsString(content);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Saved to journal!")),
    );
  }

  Future<void> _shareJournal() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/healing_journal.txt');
    if (!await file.exists()) await _saveJournal();
    await Share.shareXFiles([XFile(file.path)], text: "My healing journey with Bee 🐝");
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.isDarkMode ? Color(0xFF121212) : Color(0xFFFFF9E3);
    final chatBg = widget.isDarkMode ? Color(0xFF1E1E1E) : soft.withOpacity(0.15);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(scale: 1.0 + 0.05 * _pulseController.value, child: child);
              },
              child: CircleAvatar(backgroundColor: accent, child: Text("🐝", style: TextStyle(fontSize: 28))),
            ),
            SizedBox(width: 12),
            Text("Bee", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: soft,
        elevation: 1,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode, color: Colors.black),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: widget.isDarkMode ? [primary, Color(0xFF2A0B0B)] : [Color(0xFFFFF9E3), soft.withOpacity(0.3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Tone Selector
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                children: ['Gentle', 'Witty', 'Savage', 'Angry'].map((tone) {
                  final isSelected = _selectedTone == tone;
                  return FilterChip(
                    label: Text(tone, style: TextStyle(color: isSelected ? Colors.white : Colors.black)),
                    selected: isSelected,
                    selectedColor: tone == 'Angry' || tone == 'Savage' ? primary : accent,
                    backgroundColor: Colors.white,
                    onSelected: (bool selected) {
                      setState(() => _selectedTone = tone);
                    },
                  );
                }).toList(),
              ),
            ),

            // Messages
            Expanded(
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: chatBg,
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final message = _messages[index];
                        final isUser = message.isUser;
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          child: Align(
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                              child: Container(
                                padding: EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: isUser ? accent : Colors.white,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                    bottomLeft: isUser ? Radius.circular(16) : Radius.circular(4),
                                    bottomRight: isUser ? Radius.circular(4) : Radius.circular(16),
                                  ),
                                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)],
                                ),
                                child: Text(message.text, style: TextStyle(color: isUser ? Colors.black : Colors.black87)),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Typing Indicator
            if (_isLoading)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Bee is typing", style: TextStyle(color: Colors.grey)),
                    ...[0, 1, 2].map((i) => Padding(
                          padding: EdgeInsets.only(left: 4),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 400),
                            width: 6,
                            height: 6,
                            margin: EdgeInsets.only(top: -8 * _pulseController.value),
                            decoration: BoxDecoration(color: Colors.grey, shape: BoxShape.circle),
                          ),
                        )),
                  ],
                ),
              ),

            // Input Area
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: Offset(0, -2)),
              ]),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration(
                            hintText: "Share your thoughts...",
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            filled: true,
                            fillColor: soft.withOpacity(0.3),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(24)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: accent, width: 2),
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onSubmitted: (v) => _sendMessage(v),
                        ),
                      ),
                      SizedBox(width: 8),
                      // Voice Button
                      CircleAvatar(
                        backgroundColor: _isListening ? Colors.red : primary,
                        radius: 20,
                        child: IconButton(
                          icon: Icon(_isListening ? Icons.stop : Icons.mic, size: 16, color: Colors.white),
                          onPressed: _isListening ? _speech.stop : _startListening,
                        ),
                      ),
                      SizedBox(width: 8),
                      // Send Button
                      CircleAvatar(
                        backgroundColor: accent,
                        radius: 24,
                        child: IconButton(
                          icon: Icon(Icons.send, size: 18, color: Colors.black),
                          onPressed: () => _sendMessage(_controller.text),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  // Roast Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _sendMessage(_controller.text, isRoast: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      icon: Icon(Icons.flash_on, size: 18),
                      label: Text("Roast My Ex", style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),

            // Journal Actions
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: _saveJournal,
                      icon: Icon(Icons.save, color: primary),
                      label: Text("Save Journal", style: TextStyle(color: primary)),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: _shareJournal,
                      icon: Icon(Icons.share, color: accent),
                      label: Text("Share", style: TextStyle(color: accent)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message {
  final String text;
  final bool isUser;

  _Message(this.text, this.isUser);
}