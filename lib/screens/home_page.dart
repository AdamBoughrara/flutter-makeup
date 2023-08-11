// ignore_for_file: prefer_const_constructors

import 'package:automated_makeup_robot_software/components/bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomePage extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  HomePage({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 100,
          lightSource: LightSource.top,
          intensity: 0.7,
          color: Colors.white.withOpacity(0.7),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16.0)),
        ),
        padding: const EdgeInsets.all(26.0),
        margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Automated Makeup App',
                  textStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              'Your Makeup Done Automatically',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                color: Color.fromARGB(255, 72, 105, 122),
              ),
            ),
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bluetooth,
                  color: Colors.pink,
                ),
                const SizedBox(width: 8),
                Text(
                  'Connected',
                  style: GoogleFonts.poppins(
                    fontSize: 16.0,
                    color: Colors.pink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                onTap(
                    3); // Replace 3 with the appropriate index for "Choose Model"
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.pink[300],
                padding: const EdgeInsets.fromLTRB(110, 10, 110, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Start',
                style: GoogleFonts.poppins(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
