import 'dart:io';

import 'package:automated_makeup_robot_software/screens/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FavoritesPage extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  FavoritesPage({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _imagePicker = ImagePicker();
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  bool _isAddingNewFavorite = false;
  bool _isImageUploading = false;
  bool _isImageUploaded = false;
  String? _uploadedImageUrl;
  bool _isPrivate = false; // Add this line to define _isPrivate

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: Future.value(_auth.currentUser),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.data == null) {
          return Neumorphic(
            style: NeumorphicStyle(
              depth: 100,
              lightSource: LightSource.top,
              intensity: 0.7,
              color: Colors.white.withOpacity(0.7),
              boxShape:
                  NeumorphicBoxShape.roundRect(BorderRadius.circular(16.0)),
            ),
            padding: const EdgeInsets.all(26.0),
            //margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('You need to be signed in to use favorites.'),
                ElevatedButton(
                  onPressed: () {
                    widget.onTap(2);
                  },
                  child: Text('Go to Profile Page'),
                ),
              ],
            ),
          );
        }

        return _isAddingNewFavorite
            ? _buildAddNewFavoriteWidget()
            : _buildFavoritesPage();
      },
    );
  }

  Widget _buildFavoritesPage() {
    return Center(
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 100,
          lightSource: LightSource.top,
          intensity: 0.7,
          color: Colors.grey.shade200.withOpacity(0.8),
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(16.0)),
        ),
        padding: const EdgeInsets.all(26.0),
        margin: const EdgeInsets.symmetric(vertical: 80, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isAddingNewFavorite = true;
                });
              },
              child: Text('Add favorite'),
            ),
            SizedBox(height: 20),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchUserFavoriteModels(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text('You have no favorite makeup models.'));
                }

                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> makeupModelData =
                        snapshot.data![index];
                    return _buildMakeupModelCard(makeupModelData);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewFavoriteWidget() {
    if (_isImageUploaded) {
      return Column(
        children: [
          Image.network(_uploadedImageUrl!),
          // Display the processing results here
          _buildResultsSection(),
          Row(
            children: [
              Text('Private'),
              Switch(
                value: _isPrivate,
                onChanged: (newValue) {
                  setState(() {
                    _isPrivate = newValue;
                  });
                },
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              _saveMakeupModel(_uploadedImageUrl!);
            },
            child: Text('Save'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isAddingNewFavorite = false;
                _isImageUploading = false;
                _isImageUploaded = false;
                _uploadedImageUrl = null;
                _isPrivate = false; // Reset private toggle
              });
            },
            child: Text('Cancel'),
          ),
        ],
      );
    } else if (_isImageUploading) {
      return Column(
        children: [
          CircularProgressIndicator(),
          Text('Uploading image...'),
        ],
      );
    } else {
      return Column(
        children: [
          ElevatedButton(
            onPressed: () {
              _pickAndUploadImage();
            },
            child: Text('Pick and Upload Image'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _isAddingNewFavorite = false;
              });
            },
            child: Text('Cancel'),
          ),
        ],
      );
    }
  }

  Widget _buildResultsSection() {
    // Display the processing results (static for now)
    Map<String, String> placeholderResults = {
      'eyebrows': '024532',
      'eyeshadow': 'F04521',
      'lipstick': 'FF4532',
    };

    return Column(
      children: placeholderResults.entries.map((entry) {
        return Row(
          children: [
            Text(entry.key), // Display makeup type
            SizedBox(width: 5),
            Container(
              width: 20,
              height: 20,
              color: Color(int.parse(entry.value, radix: 16)),
            ), // Display makeup color
          ],
        );
      }).toList(),
    );
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage == null) {
      return;
    }

    firebase_storage.Reference storageRef = _storage.ref().child(
        'makeup_models/${_auth.currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg');

    setState(() {
      _isImageUploading = true;
    });

    final firebase_storage.UploadTask uploadTask =
        storageRef.putFile(File(pickedImage.path));

    final firebase_storage.TaskSnapshot downloadUrl =
        await uploadTask.whenComplete(() {});

    final String imageUrl = await downloadUrl.ref.getDownloadURL();

    setState(() {
      _isImageUploading = false;
      _isImageUploaded = true;
      _uploadedImageUrl = imageUrl;
    });
  }

  void _saveMakeupModel(String imageUrl) async {
    User? user = _auth.currentUser;
    if (user == null) {
      return;
    }

    Map<String, String> placeholderResults = {
      'eyebrows': '024532',
      'eyeshadow': 'F04521',
      'lipstick': 'FF4532',
    };

    try {
      // Add the new makeup model to the makeupModels collection
      DocumentReference newModelRef =
          await FirebaseFirestore.instance.collection('makeupModels').add({
        'userId': user.uid,
        'imageUrl': imageUrl,
        'private': _isPrivate, // Use the private toggle value
        'results': placeholderResults,
      });

      // Update the user's favorites list
      await FirebaseFirestore.instance
          .collection('users')
          .where('UID', isEqualTo: user.uid)
          .get()
          .then((querySnapshot) {
        if (querySnapshot.docs.isNotEmpty) {
          DocumentReference userDocRef = querySnapshot.docs.first.reference;
          userDocRef.update({
            'favorites': FieldValue.arrayUnion([newModelRef.id]),
          });
        }
      });

      print('New favorite added successfully!');
      setState(() {
        _isAddingNewFavorite = false;
        _uploadedImageUrl = null;
      });
    } catch (e) {
      print('Error adding new favorite: $e');
    }
  }

  Future<List<Map<String, dynamic>>> _fetchUserFavoriteModels() async {
    User? user = _auth.currentUser;
    if (user == null) {
      return [];
    }

    // Query for favorites where the user ID matches the current user's UID
    QuerySnapshot<Map<String, dynamic>> favoritesQuery = await FirebaseFirestore
        .instance
        .collection('makeupModels')
        .where('userId', isEqualTo: user.uid)
        .get();

    List<Map<String, dynamic>> favoriteModels = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> favoriteDoc
        in favoritesQuery.docs) {
      // Check if the favorite is private and owned by the user
      if (favoriteDoc['private'] && favoriteDoc['userId'] == user.uid) {
        favoriteModels.add(favoriteDoc.data());
      } else if (!favoriteDoc['private']) {
        favoriteModels.add(favoriteDoc.data());
      }
    }

    return favoriteModels;
  }

  Widget _buildMakeupModelCard(Map<String, dynamic> makeupModelData) {
    String imageUrl = makeupModelData['imageUrl'];
    bool isPrivate = makeupModelData['private'];
    Map<String, String> results =
        Map<String, String>.from(makeupModelData['results']);

    return GestureDetector(
      onTap: () {
        _showMakeupModelPopup(makeupModelData);
      },
      child: Card(
        color: Colors.white,
        shadowColor: Colors.black,
        elevation: 3,
        margin: EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Column(
            children: [
              Image.network(
                imageUrl,
                height: 90,
              ), // Display the model image
              Text(isPrivate ? 'Private' : 'Public'), // Display privacy status
              // Display makeup model details using results Map
              // Column(
              //   children: results.entries.map((entry) {
              //     return Row(
              //       children: [
              //         Text(entry.key), // Display makeup type
              //         SizedBox(width: 5),
              //         Container(
              //           width: 20,
              //           height: 20,
              //           color: Color(int.parse(entry.value, radix: 16)),
              //         ), // Display makeup color
              //       ],
              //     );
              //   }).toList(),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showMakeupModelPopup(
      Map<String, dynamic> makeupModelData) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isCurrentUserModel =
            makeupModelData['userId'] == _auth.currentUser!.uid;

        return AlertDialog(
          title: Text('Makeup Model Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(makeupModelData['imageUrl']),
              Text(makeupModelData['private'] ? 'Private' : 'Public'),
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
                widget.onTap(
                    4); // Replace 3 with the appropriate index for "Choose Model"

                // Navigate to the results page with makeupModelData
                // You should implement this navigation in your app
                // using Navigator.push.

                // For now, I'll just print a message for illustration:
                print('Apply button clicked!');
              },
              child: Text('Apply'),
            ),
            if (isCurrentUserModel)
              TextButton(
                onPressed: () async {
                  bool? confirmed = await _showDeleteConfirmation();
                  if (confirmed != null && confirmed) {
                    // Delete the model
                    await _deleteMakeupModel(makeupModelData['id']);

                    // Refresh the GridView
                    setState(() {});
                  }
                },
                child: Text('Delete'),
              ),
          ],
        );
      },
    );
  }

  Future<bool?> _showDeleteConfirmation() async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this makeup model?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false); // Not confirmed
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true); // Confirmed
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteMakeupModel(String modelId) async {
    await FirebaseFirestore.instance
        .collection('makeupModels')
        .doc(modelId)
        .delete();
  }
}
