import 'package:flutter/material.dart';

class HomeScreendemo extends StatefulWidget {
  const HomeScreendemo({super.key});

  @override
  State<HomeScreendemo> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreendemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple[500],
        title: (Text("Text and Object Recognizer",style: TextStyle(color: Colors.grey[300]),)),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 400, // Increase overall height for more spacious layout
            child: Row(
              children: [
                Expanded(
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
                            SizedBox(height: 20,),
                            Text('Camera', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 10,
                        child: Container(
                          height: 150, // Increased height for Gallery card
                          width: 120, // Increase width for more spacious look
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 80, // Adjust image height
                                width: 80, // Adjust image width
                                child: Image.asset('assets/gallery.png'),
                              ),
                              SizedBox(height: 10,), // Add some space between image and text
                              Text('Gallery', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 10,
                        child: Container(
                          height: 150, // Increased height for Scan card
                          width: 120, // Increase width for more spacious look
                          decoration: BoxDecoration(
                            color: Colors.deepPurple[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 80, // Adjust image height
                                width: 80, // Adjust image width
                                child: Image.asset('assets/scanner.png'),
                              ),
                              SizedBox(height: 10,), // Add some space between image and text
                              Text('Scan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
