import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  int _calibrationRows = 6;
  int _calibrationColumns = 9;
  double _calibrationSquareSize = 30.0;
  int _calibrationImageCount = 10;

  List<String> _registeredDevices = [
    'Device 1',
    'Device 2',
    'Device 3',
    // Add registered devices here
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Camera Calibration'),
            Tab(text: 'Available Devices'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCameraCalibrationTab(),
          _buildAvailableDevicesTab(),
        ],
      ),
    );
  }

  final Uri _url = Uri.parse('https://flutter.dev');
  Widget _buildCameraCalibrationTab() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        ListTile(
          title: Text('Camera Calibration'),
          subtitle: Text('Set calibration parameters for camera'),
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 100.0,
              child: TextFormField(
                initialValue: _calibrationRows.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _calibrationRows = int.parse(value);
                  });
                },
                decoration: InputDecoration(labelText: 'Rows (Chessboard)'),
              ),
            ),
            SizedBox(
              width: 100.0,
              child: TextFormField(
                initialValue: _calibrationColumns.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _calibrationColumns = int.parse(value);
                  });
                },
                decoration: InputDecoration(labelText: 'Columns (Chessboard)'),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: _calibrationSquareSize.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _calibrationSquareSize = double.parse(value);
                  });
                },
                decoration: InputDecoration(labelText: 'Square Size (mm)'),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: _calibrationImageCount.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _calibrationImageCount = int.parse(value);
                  });
                },
                decoration: InputDecoration(labelText: 'Number of Images'),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Calibrate button on pressed logic goes here
              },
              child: Text('Calibrate'),
            ),
          ],
        ),
        SizedBox(height: 36.0),
        Center(
          child: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: 'Need help with calibration? ',
                  style: TextStyle(color: Colors.black, fontSize: 14.0),
                ),
                TextSpan(
                  text: 'Learn more',
                  style: TextStyle(color: Colors.blue, fontSize: 16.0),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      // Open the "Learn more" link in a browser
                      launchUrl(_url);
                    },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableDevicesTab() {
    return ListView.builder(
      itemCount: _registeredDevices.length,
      itemBuilder: (context, index) {
        final device = _registeredDevices[index];
        return ListTile(
          title: Text(device),
          // Add more functionality like edit and delete registered devices
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
          
        );
      },
    );
  }
}
