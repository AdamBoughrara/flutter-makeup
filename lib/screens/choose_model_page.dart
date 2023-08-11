import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:automated_makeup_robot_software/services/bluetooth_service.dart';
import 'package:automated_makeup_robot_software/screens/results_page.dart';

class ChooseModelPage extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  ChooseModelPage({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _ChooseModelPageState createState() => _ChooseModelPageState();
}

class _ChooseModelPageState extends State<ChooseModelPage> {
  MyBluetoothService _bluetoothService = MyBluetoothService();
  PickedFile? pickedFile;
  bool _isSending = false;
  bool _isImageSelected = false;

  Future<void> _selectAndSendImage() async {
    pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        final Function(int) onTap;
        _isSending = true;
        _isImageSelected = true; // Image is selected
      });
      List<int> imageData = await pickedFile!.readAsBytes();
      await _bluetoothService.sendData(imageData, 'YOUR_CHARACTERISTIC_UUID');
      setState(() {
        _isSending = false;
      });
      // Show the processing page (you can implement this later)
      // Navigate to the "Choose Model" page
    }
  }

  // void _navigateToResultsPage() {
  //   if (pickedFile != null) {
  //     Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) => ResultsPage(imageFile: File(pickedFile!.path)),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(26.0),
        margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Choose a Model",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Select an image to begin",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
            SizedBox(height: 20),
            if (pickedFile == null)
              ElevatedButton(
                onPressed: _isSending ? null : _selectAndSendImage,
                child: _isSending
                    ? CircularProgressIndicator()
                    : Text("Choose an Image"),
              ),
            if (pickedFile != null)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: Colors.pink[300]!,
                    width: 1.0,
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: _isSending ? null : _selectAndSendImage,
                child: _isSending
                    ? CircularProgressIndicator()
                    : Text("Change Image"),
              ),
            SizedBox(height: 20),
            if (pickedFile != null)
              Image.file(
                File(pickedFile!.path),
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              ),
            if (_isImageSelected)
              ElevatedButton(
                onPressed: () {
                  widget.onTap(
                      4); // Index for results page
                },
                child: Text("Continue"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.pink[300],
                  padding: const EdgeInsets.fromLTRB(110, 10, 110, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}
