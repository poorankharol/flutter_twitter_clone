import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_clone/core/constants/appcolors.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("assets/images/icon-48.png"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "See what's happening in\nthe world right now.",
                    style: textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/register");
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.white,
                          elevation: 2,
                          backgroundColor: AppColors.blue,
                        ),
                        child: Text(
                          "Create account",
                          style: textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: RichText(
                  text: TextSpan(
                    text: 'Have an account already? ',
                    style: textTheme.titleMedium!.copyWith(
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(
                        text: 'Log in',
                        recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, "/login"),
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, color: AppColors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
