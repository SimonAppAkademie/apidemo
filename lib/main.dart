import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Quote Generator',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: QuoteScreen(),
    );
  }
}

class QuoteScreen extends StatefulWidget {
  @override
  _QuoteScreenState createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String quote = "Drücken Sie den Knopf, um ein Zitat zu laden.";
  String author = "";
  String category = "";

  Future<void> fetchQuote() async {
    final response = await http.get(
      Uri.parse('https://api.api-ninjas.com/v1/quotes'),
      headers: {'X-Api-Key': '6Vwbo7vAZLInrUZVCLU0Wg==6sgPzHBdbtWdCzd3', 'category': 'happiness'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        final quoteData = data[0];
        setState(() {
          quote = quoteData['quote'];
          author = quoteData['author'];
          category = quoteData['category'];
        });
      } else {
        setState(() {
          quote = "Kein Zitat gefunden.";
          author = "";
          category = "";
        });
      }
    } else {
      setState(() {
        quote = "Fehler beim Laden des Zitats.";
        author = "";
        category = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zufälliges Zitat')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                quote,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              if (author.isNotEmpty)
                Text(
                  '- $author',
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: fetchQuote,
                child: Text('Neues Zitat laden'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
