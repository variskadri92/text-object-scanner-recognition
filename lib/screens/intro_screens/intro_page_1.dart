import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage1 extends StatelessWidget {
  const IntroPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Lottie.network(
                'https://lottie.host/aa7b0d9c-10b7-443e-83ae-f9f9262b0f18/yotnY3r9VW.json'),
          ),
          Text("Welcome to Image-to-Text App!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          Container(
            child: Column(
              children: [
                Text("Our AI-powered app can scan text from",style: TextStyle(fontSize:16),),
                Text("any image,including documents,signs",style: TextStyle(fontSize:16),),
                Text("and more.Try it out for yourself!",style: TextStyle(fontSize:16),)
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
