import 'package:flutter/material.dart';

class CareView extends StatelessWidget {
  final AnimationController animationController;

  const CareView({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    final firstHalfAnimation =
        Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(0.2, 0.4, curve: Curves.fastOutSlowIn),
          ),
        );
    final secondHalfAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-1, 0)).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(0.4, 0.6, curve: Curves.fastOutSlowIn),
          ),
        );
    final relaxFirstHalfAnimation =
        Tween<Offset>(begin: Offset(2, 0), end: Offset(0, 0)).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(0.2, 0.4, curve: Curves.fastOutSlowIn),
          ),
        );
    final relaxSecondHalfAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-2, 0)).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(0.4, 0.6, curve: Curves.fastOutSlowIn),
          ),
        );

    final imageFirstHalfAnimation =
        Tween<Offset>(begin: Offset(4, 0), end: Offset(0, 0)).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(0.2, 0.4, curve: Curves.fastOutSlowIn),
          ),
        );
    final imageSecondHalfAnimation =
        Tween<Offset>(begin: Offset(0, 0), end: Offset(-4, 0)).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(0.4, 0.6, curve: Curves.fastOutSlowIn),
          ),
        );

    return SlideTransition(
      position: firstHalfAnimation,
      child: SlideTransition(
        position: secondHalfAnimation,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideTransition(
                position: imageFirstHalfAnimation,
                child: SlideTransition(
                  position: imageSecondHalfAnimation,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 350, maxHeight: 300),
                    child: Image.asset(
                      'assets/introduction_animation/Generated/recommendation.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SlideTransition(
                position: relaxFirstHalfAnimation,
                child: SlideTransition(
                  position: relaxSecondHalfAnimation,
                  child: Text(
                    "           Personalized \n Recommendations",
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 64,
                  right: 64,
                  bottom: 16,
                  top: 0,
                ),
                child: Text(
                  '''Discover What Your Skin Truly Needs \n Get product suggestions tailored to your skin type and tone - backed by science, not guesswork.''',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
