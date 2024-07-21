import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

  Future<void> _pickImage() async {
    print('hwlo');
    final picker = ImagePicker();
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        print(_image.toString());
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }
  @override
  void initState(){
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding:EdgeInsets.only(top:30),
            child: Card(
              color: Colors.blueAccent,
              child: Container(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(icon: Icon(Icons.scanner,size: 50,color: Colors.white,),onPressed: (){},),
                        Text("Scan",style: TextStyle(color: Colors.white),),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(icon: Icon(Icons.assignment_sharp,size: 50,color: Colors.white,),onPressed: (){},),
                        Text("Recognize",style: TextStyle(color: Colors.white),),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(icon: Icon(Icons.image,size: 50,color: Colors.white,),onPressed: (){},),
                        Text("Enhance",style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(child: Container(height: MediaQuery.of(context).size.height-300,
            child: _image ==null? Text('no iamge') : Image.file(_image!),
          ),),
          Card(
            color: Colors.blueAccent,
            child: Container(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(icon: Icon(Icons.refresh_rounded,size: 50,color: Colors.white,),onPressed: (){},),
                  IconButton(icon: Icon(Icons.camera,size: 50,color: Colors.white,),onPressed: (){},),
                  IconButton(icon: Icon(Icons.image,size: 50,color: Colors.white,),onPressed:()=> _pickImage()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
