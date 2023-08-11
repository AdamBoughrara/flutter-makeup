import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class FeedbackPage extends StatelessWidget {
  final Function(int) onTap;
  final int currentIndex;

  FeedbackPage({
    required this.onTap,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
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
        children: const [
          Text(
            'SUCCESS!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'The data has been successfully sent to your device. Please insert your head in the indicated position and keep it steady with your eyes closed until you hear an audio message indicating the end of the process.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
