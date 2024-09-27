import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:text_and_object_scanner/screens/recognition_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Homescreen());
}

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  File? _image;
  String? _ocrText;
  bool _isLoading = false;

  void _navigateToRecognitionScreen() {
    if (_image != null && _ocrText != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RecognitionScreen(image: _image!, ocrText: _ocrText!),
        ),
      );
    } else {
      print('Image or OCR text is not available');
    }
  }

  Future<void> _sendImageToServer(File image) async {
    setState(() {
      _isLoading = true;
    });

    final request = http.MultipartRequest('POST', Uri.parse('http://192.168.43.5:5000/api'));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decoded = json.decode(responseBody);
      setState(() {
        _ocrText = decoded['text'];
        _isLoading = false;
      });
      print(_ocrText);
      _navigateToRecognitionScreen(); // Navigate to the recognition screen after OCR text is set
    } else {
      setState(() {
        _isLoading = false;
      });
      print('Error: ${response.reasonPhrase}');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        print('Sending to server');
        await _sendImageToServer(_image!);
        print(_image.toString());
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Container(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Card(
                        color: Colors.blueAccent,
                        child: Container(
                          height: 100,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.scanner,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {},
                                  ),
                                  Text(
                                    "Scan",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.assignment_sharp,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      _navigateToRecognitionScreen();
                                    },
                                  ),
                                  Text(
                                    "Recognize",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.image,
                                      size: 50,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {},
                                  ),
                                  Text(
                                    "Enhance",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      child: Container(
                        height: MediaQuery.of(context).size.height - 300,
                        child: _image == null ? Text('No image selected') : Image.file(_image!),
                      ),
                    ),
                    Card(
                      color: Colors.blueAccent,
                      child: Container(
                        height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.refresh_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.camera,
                                size: 50,
                                color: Colors.white,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.image,
                                size: 50,
                                color: Colors.white,
                              ),
                              onPressed: () => _pickImage(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
