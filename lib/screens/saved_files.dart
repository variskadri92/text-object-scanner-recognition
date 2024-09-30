import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SavedFilesScreen extends StatefulWidget {
  @override
  _SavedFilesScreenState createState() => _SavedFilesScreenState();
}

class _SavedFilesScreenState extends State<SavedFilesScreen> {
  List<FileSystemEntity> _files = []; // List to store the fetched files
  Directory? _directory;

  @override
  void initState() {
    super.initState();
    _requestStoragePermission(); // Request storage permissions
    _fetchSavedFiles(); // Fetch saved files when the screen initializes
  }

  // Request storage permission
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

  // Fetch the saved files from the specified folder
  Future<void> _fetchSavedFiles() async {
    final rootDirectory = Directory('/storage/emulated/0/MyAppFolder');

    if (await rootDirectory.exists()) {
      setState(() {
        _directory = rootDirectory;
        _files = rootDirectory.listSync(); // Get all the files in the folder
      });
    } else {
      print("Directory doesn't exist");
    }
  }

  // Function to read the file's content
  Future<String> _readFileContent(File file) async {
    try {
      return await file.readAsString();
    } catch (e) {
      print('Error reading file: $e');
      return 'Error reading file';
    }
  }

  // Function to save the edited content to the file
  Future<void> _saveFileContent(File file, String newContent) async {
    try {
      await file.writeAsString(newContent);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File saved: ${file.path.split('/').last}')),
      );
    } catch (e) {
      print('Error saving file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving file: $e')),
      );
    }
  }

  // Function to delete a file
  Future<void> _deleteFile(File file) async {
    try {
      await file.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${file.path.split('/').last} deleted')),
      );
      _fetchSavedFiles(); // Refresh the file list after deletion
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  // Function to view and edit file content in a dialog
  void _viewFileContentDialog(File file) async {
    String content = await _readFileContent(file);
    TextEditingController _textController = TextEditingController(text: content);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(file.path.split('/').last),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _textController,
                  maxLines: null, // Allow multiline editing
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Edit Text',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without saving
              },
              child: Text('Cancel'),
            ),

            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteFile(file); // Option to delete the file
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                _saveFileContent(file, _textController.text); // Save edited content
                Navigator.of(context).pop(); // Close the dialog after saving
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
        title: Text('Saved Files'),
      ),
      body: _directory == null
          ? Center(child: Text('No directory found'))
          : _files.isEmpty
          ? Center(child: Text('No files found'))
          : ListView.builder(
        itemCount: _files.length,
        itemBuilder: (context, index) {
          FileSystemEntity file = _files[index];
          return ListTile(
            title: Text(file.path.split('/').last),
            leading: Icon(Icons.insert_drive_file),
            onTap: () {
              _viewFileContentDialog(File(file.path)); // View and edit file content
            },
          );
        },
      ),
    );
  }
}
