import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:todo_app/signuppage.dart';

class OnboardingScreens extends StatelessWidget {
  List<PageViewModel> _getPages(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return [
      PageViewModel(
        title: "",
        bodyWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Text(
            "Plan your tasks to do, that way you'll stay organized and you won't skip any",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
        image: Image.asset(
          'assets/image2.png',
          height: size.height * 0.35,
          fit: BoxFit.contain,
        ),
      ),

      PageViewModel(
        titleWidget: Text(
          "Do it",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        bodyWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Text(
            "Make a full schedule for the whole week and stay organized and productive all days",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
        image: Image.asset(
          "assets/image3.png",
          height: size.height * 0.3,
          fit: BoxFit.contain,
        ),
      ),

      PageViewModel(
        title: "",
        bodyWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Text(
            "Create a team task, invite people and manage your work together",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
        image: Image.asset(
          "assets/image4.png",
          height: size.height * 0.25,
          fit: BoxFit.contain,
        ),
      ),

      PageViewModel(
        title: "",
        bodyWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
          child: Text(
            "Your information's are secure with us",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 22),
          ),
        ),
        image: Image.asset(
          "assets/image5.png",
          height: size.height * 0.28,
          fit: BoxFit.contain,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1253AA), Color(0xFF05243E)],
          ),
        ),
        child: IntroductionScreen(
          globalBackgroundColor: Colors.transparent,
          pages: _getPages(context),
          next: const Icon(
            Icons.arrow_circle_right_sharp,
            color: Colors.cyan,
            size: 60,
          ),
          done: const Icon(
            Icons.check_circle_sharp,
            size: 65,
            color: Colors.white,
          ),
          dotsDecorator: const DotsDecorator(
            color: Colors.white70,
            activeColor: Colors.teal,
          ),
          onDone: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => SignUpScreen()),
            );
          },
        ),
      ),
    );
  }
}
