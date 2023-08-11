import 'package:flutter/material.dart';

class TestDiagnosisPage extends StatefulWidget {
  @override
  _TestDiagnosisPageState createState() => _TestDiagnosisPageState();
}

class _TestDiagnosisPageState extends State<TestDiagnosisPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Test and Diagnosis'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Test Features'),
              Tab(text: 'Command Manually'),
              Tab(text: 'Diagnose'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            TestFeaturesTab(),
            CommandManuallyTab(),
            DiagnoseTab(),
          ],
        ),
      ),
    );
  }
}

class TestFeaturesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _buildTestButton(context, 'Test Xmotor'),
        _buildTestButton(context, 'Test Ymotor'),
        _buildTestButton(context, 'Test Compressor & Trigger'),
        _buildTestButton(context, 'Test Valves'),
        _buildTestButton(context, 'Test Right Limit Switch'),
        _buildTestButton(context, 'Test Left Limit Switch'),
      ],
    );
  }

  Widget _buildTestButton(BuildContext context, String text) {
    return ListTile(
      title: Text(text),
      onTap: () {
        _showTestStatusPopup(context, text);
      },
    );
  }

  void _showTestStatusPopup(BuildContext context, String testName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(testName),
          content:
              Text('Test result: Success!'), // Replace with actual test result
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class CommandManuallyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              // Handle Initialize Camera
            },
            child: Text('Initialize Camera'),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle Initialize Airbrush
            },
            child: Text('Initialize Airbrush'),
          ),
          SizedBox(height: 16),
          _buildMotorControlSection(context, 'Xmotor'),
          SizedBox(height: 16),
          _buildMotorControlSection(context, 'Ymotor'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Handle "Press & Hold to Spray"
            },
            onLongPress: () {
              // Handle "Press & Hold to Spray"
            },
            child: Text('Press & Hold to Spray'),
          ),
        ],
      ),
    );
  }

  Widget _buildMotorControlSection(BuildContext context, String motorName) {
    return Column(
      children: [
        Text('$motorName Control'),
        TextField(
          decoration: InputDecoration(labelText: 'Enter ${motorName} Value'),
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle Left or Up button
              },
              child: Text('Left / Up'),
            ),
            ElevatedButton(
              onPressed: () {
                // Handle Right or Down button
              },
              child: Text('Right / Down'),
            ),
          ],
        ),
      ],
    );
  }
}

class DiagnoseTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Run full system diagnosis button pressed logic goes here
          },
          child: Text('Run full system diagnosis'),
        ),
        SizedBox(height: 20),
        Expanded(
          child: Container(
            width: double.infinity,
            color: Color.fromARGB(255, 60, 60, 60),
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Text(
                  'Diagnosis Results\n\n'
                  'Test 1: Passed\n'
                  'Test 2: Failed\n',
                  // ... Add more test results here
                  style: TextStyle(
                    color: Color.fromARGB(255, 33, 198, 0),
                    fontSize: 20,
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
