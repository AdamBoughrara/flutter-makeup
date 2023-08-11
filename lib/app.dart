import 'dart:io';

import 'package:automated_makeup_robot_software/screens/choose_model_page.dart';
import 'package:automated_makeup_robot_software/screens/favorites_page.dart';
import 'package:automated_makeup_robot_software/screens/feedback_page.dart';
import 'package:automated_makeup_robot_software/screens/home_page.dart';
import 'package:automated_makeup_robot_software/screens/profile_page.dart';
import 'package:automated_makeup_robot_software/screens/results_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'components/bottom_navigation_bar.dart';

class AppScreen extends StatefulWidget {
  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _currentIndex = 0;
  List<int> _previousIndexes = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading:
              _currentIndex > 0 // Show back button only if not on home page
                  ? IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: _navigateBack,
                    )
                  : IconButton(
                      color: Colors.transparent,
                      icon: Icon(Icons.arrow_back),
                      onPressed: (() {}),
                    ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.pink.shade300,
          title: Text(
            'Makeup Robot',
            style: GoogleFonts.pacifico(
              textStyle: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                _showCupertinoModalPopup(context);
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomePage(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _previousIndexes
                      .add(_currentIndex); // Update the previous index
                  _currentIndex = index;
                });
              },
            ),
            FavoritesPage(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _previousIndexes
                      .add(_currentIndex); // Update the previous index
                  _currentIndex = index;
                });
              },
            ),
            ProfilePage(),
            ChooseModelPage(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _previousIndexes
                      .add(_currentIndex); // Update the previous index
                  _currentIndex = index;
                });
              },
            ),
            ResultsPage(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _previousIndexes
                      .add(_currentIndex); // Update the previous index
                  _currentIndex = index;
                });
              },
            ),
            FeedbackPage(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _previousIndexes
                      .add(_currentIndex); // Update the previous index
                  _currentIndex = index;
                });
              },
            ),

            // Add more screens here
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 3) {
              _showCupertinoModalPopup(context);
            } else {
              setState(() {
                _previousIndexes
                    .add(_currentIndex); // Update the previous index
                _currentIndex = index;
              });
            }
          },
        ),
      ),
    );
  }

  void _showCupertinoModalPopup(BuildContext context) {
    showCupertinoModalPopup(
      anchorPoint: Offset(-1.0, -1.0),
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.transparent,
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: -4, // Adjust depth for your preference
              color: Theme.of(context).scaffoldBackgroundColor,
              intensity: 0.8,
              boxShape: NeumorphicBoxShape.roundRect(
                const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDrawerListItem(Icons.settings, 'Settings', () {
                  Navigator.pushNamed(context, '/settings');
                }),
                _buildDrawerListItem(Icons.build, 'Diagnose & Test', () {
                  Navigator.pushNamed(context, '/testing');
                }),
                _buildDrawerListItem(Icons.help, 'Help', () {
                  //open the help link in browser
                  launchUrl(Uri.parse('https://google.com'));
                }),
                _buildDrawerListItem(Icons.info, 'About us', () {
                  _showAboutUsPopup();
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateBack() {
    if (_previousIndexes.length > 0) {
      int previousIndex = _previousIndexes.removeLast(); // Get the last index
      setState(() {
        _currentIndex = previousIndex; // Update the current index
      });
    }
  }

  Widget _buildDrawerListItem(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.pink),
            SizedBox(width: 20),
            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                color: Colors.blueGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAboutUsPopup() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About us'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(
                  "https://inovtech-engineering.com/wp-content/uploads/2019/06/testt-min.png"),
              Text(
                  "Inovtech Engineering is a company that provides solutions for the development of the industry 4.0 ecosystem. We provide solutions for the development of the industry 4.0 ecosystem, including the development of industrial automation systems, IoT, and AI. We also provide training and consulting services for the development of the industry 4.0 ecosystem."),
              // Display other makeup model details here
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the popup
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context); // Close the popup
                launchUrl(Uri.parse('https://google.com'));

                // For now, I'll just print a message for illustration:
                print('Apply button clicked!');
              },
              child: Text('Visit website'),
            ),
          ],
        );
      },
    );
  }
}
