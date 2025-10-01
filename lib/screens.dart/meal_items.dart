import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MealItems extends StatefulWidget {
  const MealItems({super.key});

  @override
  State<MealItems> createState() => _MealItemsState();
}

class _MealItemsState extends State<MealItems> {
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  bool _isLoading = false;

  String genRec = 'Generate Recipe';

  String? _aiResponse;

  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash',
    generationConfig: GenerationConfig(
      temperature: 0.9,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Recipe Generator'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Container(
        width: double.infinity,
        color: Color.fromARGB(252, 255, 253, 241),
        padding: EdgeInsets.only(
          left: 10,
          right: 10,
        ),
        margin: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Ingredients',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                hintText: 'e.g., chicken, rice, broccoli',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              controller: _ingredientsController,
            ),
            SizedBox(height: 15),
            TextField(
              decoration: InputDecoration(
                labelText: 'Notes',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                hintText: 'e.g., vegetarian, no nuts, quick to make',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              controller: _notesController,
            ),
            SizedBox(height: 15),
            if (!_isLoading)
              ElevatedButton(
                onPressed: _generatePrompt,
                child: Text(genRec),
              )
            else
              CircularProgressIndicator(),
            SizedBox(height: 15),
            if (_aiResponse != null && !_isLoading)
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Markdown(
                    data: _aiResponse!,
                    padding: EdgeInsets.all(16),
                    selectable: true,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _generatePrompt() async {
    FocusScope.of(context).unfocus();

    if (_ingredientsController.text.isEmpty) {
      // Maybe show a snackbar to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter some ingredients!')),
      );
      return; // Stop the function
    }

    setState(() {
      _isLoading = true;
    });

    final String ingredients = _ingredientsController.text;
    final String notes = _notesController.text;
    String prompt;

    if (genRec == 'Generate Recipe' && notes.trim().isNotEmpty) {
      prompt = '''
      Generate a recipe based on the following ingredients: "$ingredients".
      Please consider these notes: "$notes".
      Provide a title for the recipe, list the ingredients(with amount of each if required) wihtout more explanations, and step-by-step instructions.
    ''';
    } else if (genRec == 'Generated new recipe' && notes.trim().isNotEmpty) {
      prompt = '''
      Please generate another recipe based on the following ingredients: "$ingredients".
      Please consider these notes: "$notes".
      Provide a title for the recipe, list the ingredients(with amount of each if required) wihtout more explanations, and step-by-step instructions.
    ''';
    } else {
      prompt = '''
      Generate a recipe based on the following ingredients: "$ingredients".
      Provide a title for the recipe, list the ingredients(with amount of each if required) wihtout more explanations, and step-by-step instructions.
    ''';
    }

    final response = await model.generateContent([Content.text(prompt)]);

    setState(() {
      _isLoading = false;
      _aiResponse = response.text;
      genRec = "Generated new recipe";
    });

    // Add your async logic here
  }
}
