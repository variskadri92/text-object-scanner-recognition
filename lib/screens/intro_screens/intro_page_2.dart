import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/animation2.gif'),
          ),
          Text("Convert Any Image to Text",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          Container(
            child: Column(
              children: [
                Text("With our app,you can easily scan text",
                  style: TextStyle(fontSize: 16,),),
                Text("from images and convert it to editable",
                  style: TextStyle(fontSize: 16),),
                Text("text.Say goodbye to manual typing!",
                  style: TextStyle(fontSize: 16),)
              ],
            ),
          )
          // Padding(
          //   padding: const EdgeInsets.only(left: 26,right: 26),
          //   child: Text("Our AI-powered app can scan text from"
          //       " any image,including documents,signs,"
          //       "and more.Try it out for yourself!",style: TextStyle(fontSize:16),),
          // )

        ],
      ),
    );
  }
}
