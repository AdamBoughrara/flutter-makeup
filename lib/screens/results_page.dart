import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class ResultsPage extends StatefulWidget {
  final Function(int) onTap;
  final int currentIndex;

  ResultsPage({
    required this.onTap,
    required this.currentIndex,
  });

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final Map<String, int> landmarkToCanister = {
    'EyeShadow': 1,
    'Eyebrows': 2,
    'Blush': 3,
    'Lipstick': 4,
  };

  List<LandmarkItem> _landmarks = [
    LandmarkItem(name: 'EyeShadow', color: Colors.blue, colorCode: '#013254'),
    LandmarkItem(name: 'Eyebrows', color: Colors.brown, colorCode: '#013254'),
    LandmarkItem(name: 'Blush', color: Colors.purple, colorCode: '#013254'),
    LandmarkItem(name: 'Lipstick', color: Colors.red, colorCode: '#013254'),
  ];

  bool _areBottlesInserted = false;
  bool _isCleanserInserted = false;
  int _currentStep = 0;

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            if (_currentStep == 0) buildLandmarksList(),
            if (_currentStep == 1 && _areBottlesInserted)
              buildPrepareDeviceSection(),
            if (_currentStep == 2 && _isCleanserInserted)
              buildCleanserSection(),
          ],
        ),
      ),
    );
  }

  Widget buildLandmarksList() {
    return Column(
      children: [
        Text(
          'Select Facial Landmarks',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: _landmarks.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Icon(Icons.circle, color: _landmarks[index].color),
              title: Text(_landmarks[index].name),

              // Text(_landmarks[index].colorCode,
              //     style: TextStyle(
              //         color: Colors.white,
              //         backgroundColor: _landmarks[index].color)),
              trailing: Checkbox(
                value: _landmarks[index].isSelected,
                onChanged: (value) {
                  setState(() {
                    _landmarks[index].isSelected = value ?? false;
                  });
                },
              ),
            );
          },
        ),
        SizedBox(height: 20),
        const Divider(
          color: Colors.blueGrey,
          thickness: 1,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 10,
            ),
          ),
          onPressed: () {
            setState(() {
              _areBottlesInserted = true;
              _currentStep = 1;
            });
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }

  Widget buildPrepareDeviceSection() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Insert Makeup Bottles',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 20),
          // Display inserted landmarks
          ..._landmarks
              .where((landmark) => landmark.isSelected)
              .map((landmark) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: landmark.color,
                    ),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Insert ${landmark.colorCode} bottle in canister ${landmarkToCanister[landmark.name]}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ))
              .toList(),
          //insert a horizontal separation line
          const SizedBox(height: 20),
          const Divider(
            color: Colors.blueGrey,
            thickness: 1,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                //add padding to button
                style: OutlinedButton.styleFrom(
                  //apply color to border
                  side: BorderSide(color: Colors.blueGrey),
                  foregroundColor: Colors.blueGrey,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _currentStep = 0; // Go back to the previous step
                    _areBottlesInserted = false; // Reset the inserted bottles
                  });
                },
                child: Text('Back'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 10,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    _isCleanserInserted = true;
                    _currentStep = 2;
                  });
                },
                child: Text('Confirm'),
              ),
            ],
          ),
          SizedBox(height: 20), // Add some spacing
        ],
      ),
    );
  }

  Widget buildCleanserSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        Text(
          'Insert Cleanser Bottle',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text('Please use official cleanser to avoid any damage to the device.',
            textAlign: TextAlign.center),
        // Display instructions for cleanser
        const SizedBox(height: 20),
        const Divider(
          color: Colors.blueGrey,
          thickness: 1,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _currentStep = 1; // Go back to the previous step
                  _isCleanserInserted = false; // Reset the inserted cleanser
                });
              },
              child: Text('Back'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onTap(5);
              },
              child: Text('Start Makeup Process'),
            ),
          ],
        ),
      ],
    );
  }
}

class LandmarkItem {
  final String name;
  final Color color;
  final String colorCode;
  bool isSelected;

  LandmarkItem({
    required this.name,
    required this.color,
    required this.colorCode,
    this.isSelected = false,
  });
}
