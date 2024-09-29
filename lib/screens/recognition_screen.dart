import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class RecognitionScreen extends StatefulWidget {
  final File image;
  final String ocrText;

  RecognitionScreen({required this.image, required this.ocrText});

  @override
  _RecognitionScreenState createState() => _RecognitionScreenState();
}

class _RecognitionScreenState extends State<RecognitionScreen> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.ocrText);
    _requestStoragePermission(); // Request permissions
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Function to request storage permissions
  Future<void> _requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      print("Storage permission granted.");
    } else {
      print("Storage permission denied.");
    }

    if (await Permission.manageExternalStorage.request().isGranted) {
      print("Manage External Storage permission granted.");
    } else {
      print("Manage External Storage permission denied.");
    }
  }

  // Function to save the text to a file in the specified folder
  Future<void> _saveTextToFile(String text, String fileName) async {
    final rootDirectory = Directory('/storage/emulated/0/MyAppFolder');

    if (!await rootDirectory.exists()) {
      await rootDirectory.create(recursive: true); // Create the folder if it doesn't exist
    }

    final filePath = '${rootDirectory.path}/$fileName.txt';
    final file = File(filePath);

    if (await file.exists()) {
      // If the file exists, show a confirmation dialog
      _showOverwriteConfirmationDialog(text, fileName, file);
    } else {
      await file.writeAsString(text);
      print('Text saved to: $filePath');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Text saved as $fileName.txt')),
      );
    }
  }

  // Function to show overwrite confirmation dialog
  void _showOverwriteConfirmationDialog(String text, String fileName, File file) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text('File Already Exists'),
            content: Text('Do you want to overwrite $fileName.txt?'),
            actions: [
            TextButton(
            onPressed: () async {
          await file.writeAsString(text); // Overwrite the file
          print('Text overwritten in: ${file.path}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File overwritten: $fileName.txt')),
          );
          Navigator.of(context).pop(); // Close the dialog
        },
        child: Text('Yes'),
        ),
        TextButton(
        onPressed: () {
        Navigator.of(context).pop(); // Close the dialog without saving
        },
        child: Text('No, enter a different name'),
        ),
      ],
    );
  },
  );
}

// Function to show a dialog for entering the file name
void _showFileNameDialog() {
  final TextEditingController fileNameController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter File Name'),
        content: TextField(
          controller: fileNameController,
          decoration: InputDecoration(hintText: "File name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final fileName = fileNameController.text;
              if (fileName.isNotEmpty) {
                final editedText = _textController.text;
                _saveTextToFile(editedText, fileName); // Attempt to save text
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please enter a valid file name.')),
                );
              }
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Save'),
          ),
        ],
      );
    },
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('OCR Result'),
      actions: [
        IconButton(
          icon: Icon(Icons.save),
          onPressed: _showFileNameDialog, // Show the dialog to enter the file name
        ),
      ],
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Recognized Text (Editable):',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _textController,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showFileNameDialog, // Show the dialog to enter the file name
              child: Text('Save Edited Text'),
            ),
          ],
        ),
      ),
    ),
  );
}
}
