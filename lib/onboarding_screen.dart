import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:text_and_object_scanner/screens/Homescreen.dart';
import 'package:text_and_object_scanner/screens/intro_screens/intro_page_1.dart';
import 'package:text_and_object_scanner/screens/intro_screens/intro_page_2.dart';
import 'package:text_and_object_scanner/screens/intro_screens/intro_page_3.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: _controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: [IntroPage1(), IntroPage2(), IntroPage3()],
        ),
        Container(
            alignment: Alignment(0, 0.85),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text('Skip',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,))),
                SmoothPageIndicator(controller: _controller, count: 3),
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return Homescreen();
                          }));
                        },
                        child: Text('Done',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        },
                        child: Text('Next',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,),),
                      )
              ],
            )),
      ],
    ));
  }
}
