import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

void main() {
 runApp(MyApp());
}

class MyApp extends StatelessWidget {
 @override
 Widget build(BuildContext context) {
  return MaterialApp(
    home: SpeechPage(),
  );
 }
}

class SpeechPage extends StatefulWidget {
 @override
 _SpeechPageState createState() => _SpeechPageState();
}

class _SpeechPageState extends State<SpeechPage> {
 SpeechToText _speechToText = SpeechToText();
 bool _speechEnabled = false;
 String _lastWords = '';
 String _currentWords = '';
 String _selectedLocaleId = 'en-US';
 Map<String, String> _availableLanguages = {'English': 'en-US', 'العربية': 'ar-EG'};

 @override
 void initState() {
  super.initState();
  _speechToText.initialize(
    onStatus: _onSpeechStatus,
    // onError: _onSpeechError,
  );
 }

 @override
 Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            items: _availableLanguages.entries.map((entry) {
             return DropdownMenuItem<String>(
              value: entry.value,
              child: Text(entry.key),
             );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedLocaleId = value!;
              });
            },
            value: _selectedLocaleId,
          ),
          SizedBox(height: 10), // Add some space between the dropdown and the buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FloatingActionButton(
                onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
                tooltip: 'Listen',
                child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
              ),
              ElevatedButton(
                onPressed: _clearTranscription,
                child: Text('Clear Transcription'),
              ),
            ],
          ),
          Text(_lastWords),
        ],
      ),
    ),
  );
 }

 void _onSpeechStatus(String status) {
  print('Status: $status');
 }

//  void _onSpeechError(SpeechRecognitionError error) {
//   print('Error: ${error.toString()}');
//  }

 void _startListening() async {
  _currentWords = _lastWords; // Store the current transcription
  await _speechToText.listen(
    onResult: _onSpeechResult,
    localeId: _selectedLocaleId,
  );
  setState(() {});
 }

 void _stopListening() async {
  await _speechToText.stop();
  setState(() {});
 }

 void _onSpeechResult(SpeechRecognitionResult result) {
  setState(() {
    _lastWords = _currentWords + ' ' + result.recognizedWords; // Append new words to the stored transcription
  });
 }

 void _clearTranscription() {
  setState(() {
    _lastWords = '';
  });
 }
}
