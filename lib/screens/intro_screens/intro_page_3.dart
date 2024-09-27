import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.deepPurple[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset('assets/animation3.gif')
          ),
          Text("Copy,translate and share",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          Container(
            child: Column(
              children: [
                Text("It is easy to copy,transalte it to another",style: TextStyle(fontSize:16,),),
                Text("langauge,and share it with others,all",style: TextStyle(fontSize:16),),
                Text("with just a few taps.",style: TextStyle(fontSize:16),)
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
