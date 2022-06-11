import 'package:flutter/material.dart';
import 'package:my_tutor/content_model.dart';
import 'package:my_tutor/loginscreen.dart';
import 'package:my_tutor/registerscreen.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  // ignore: must_call_super
  void initState() {
    _controller = PageController(
      initialPage: 0
    );
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(36, 47, 155, 1),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contents.length,
              onPageChanged:(int index){
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_,i){
                return Padding(
                  padding: const EdgeInsets.only(left:35, right:35, top:100, bottom:35),
                  child: Column(
                    children:[
                      Image.asset(contents[i].image, height: 300),
                      Text(
                        contents[i].title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
          
                      const SizedBox(height:30),
                      Text(
                        contents[i].description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                        ),
                      ),
                    ]
                  )
                );
              }
            ),
          ),

          // ignore: avoid_unnecessary_containers
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length, (index) => buildDot(index, context))
            )
          ),

          Container(
            height: 50,
            width:290,
            margin: const EdgeInsets.only(left:40, right:40, bottom:10, top:40),
            child: ElevatedButton(
              
              child:  Text(currentIndex == contents.length -1 ? "Sign Up Now": "Next"),
              
              onPressed: (){
                if(currentIndex == contents.length -1){
                  Navigator.push(context, MaterialPageRoute(builder:(content) => const SignUpScreen()));
                }
                _controller.nextPage(
                  duration: const Duration(milliseconds:100),
                  curve: Curves.easeIn,
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              )
            ),
          ),

          Container(
            height: 50,
            width:290,
            margin: const EdgeInsets.all(15),
            child: ElevatedButton(
              
              child:  Text(currentIndex == contents.length -1 ? "Already have an account":"Skip to login form"),
              
              onPressed: (){
                 Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => const SignInScreen()),
                            );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )
              )
            ),
          )
        ],
      )
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 12, 
      width: currentIndex == index ? 20:10,
      margin: const EdgeInsets.only(right:5),
      decoration: BoxDecoration(
        borderRadius : BorderRadius.circular(8),
        color: Colors.white,
      )
    );
  }
}