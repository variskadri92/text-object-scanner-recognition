import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:text_and_object_scanner/screens/recognition_screen.dart';
import 'package:text_and_object_scanner/screens/saved_files.dart';

class HomeScreendemo extends StatefulWidget {
  const HomeScreendemo({super.key});

  @override
  State<HomeScreendemo> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreendemo> {
  File? _image; // To store the captured image
  final ImagePicker _picker = ImagePicker();
  String? _ocrText;
  bool _isLoading = false; // Variable to track loading state

  // Function to open the camera
  Future<void> _openCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _openGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _sendImageToServer(File image) async {
    setState(() {
      _isLoading = true; // Set loading to true when the request starts
    });

    final request = http.MultipartRequest('POST', Uri.parse('http://192.168.29.5:5000/api'));
    request.files.add(await http.MultipartFile.fromPath('image', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final decoded = json.decode(responseBody);
      setState(() {
        _ocrText = decoded['text'];
        _isLoading = false; // Stop loading when the request is complete
      });

      // Navigate to the recognition screen after OCR text is set
      _navigateToRecognitionScreen();
    } else {
      setState(() {
        _isLoading = false; // Stop loading if the request fails
      });
      print('Error: ${response.reasonPhrase}');
    }
  }

  // Function to navigate to the RecognitionScreen
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple[500],
        title: Text(
          "Text and Object Recognizer",
          style: TextStyle(color: Colors.grey[300]),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: 400,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _openCamera, // Open camera when tapped
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurple[300],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              height: 350,
                              width: 100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 150,
                                      width: 150,
                                      child: Image.asset('assets/camera.png')),
                                  SizedBox(height: 20),
                                  Text(
                                    'Camera',
                                    style: TextStyle(
                                        fontSize: 26, fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: _openGallery,
                          child: Expanded(
                            child: Card(
                              elevation: 10,
                              child: Container(
                                height: 150,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      child: Image.asset('assets/gallery.png'),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Gallery',
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (_image != null) {
                              _sendImageToServer(_image!);
                            } else {
                              print('No image selected');
                            }
                          },
                          child: Expanded(
                            child: Card(
                              elevation: 10,
                              child: Container(
                                height: 150,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple[300],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      child: Image.asset('assets/scanner.png'),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Extract',
                                      style: TextStyle(
                                          fontSize: 20, fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SavedFilesScreen(), // Navigate to SavedFilesScreen
                    ),
                  );
                },
                child: Card(
                  elevation: 10,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Saved files',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(Icons.arrow_forward_sharp),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Display loading indicator when extracting text
              _isLoading
                  ? Center(child: CircularProgressIndicator()) // Show loader during OCR processing
                  : _image != null
                  ? Image.file(
                _image!,
                height: 200,
              )
                  : Text('No image selected'),
            ],
          ),
        ),
      ),
    );
  }
}
