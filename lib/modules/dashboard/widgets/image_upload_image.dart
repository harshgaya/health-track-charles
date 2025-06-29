import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_health_tracker/helpers/strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';

class ImageUploadWidget extends StatefulWidget {
  final String timeName;
  const ImageUploadWidget({Key? key, required this.timeName}) : super(key: key);

  @override
  _ImageUploadWidgetState createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  File? _selectedImage;
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _calorieController = TextEditingController();
  bool _isUploading = false;
  bool _isEstimating = false;
  var fat = 0.0;
  var carb = 0.0;
  var protein = 0.0;
  var sugar = 0.0;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _estimateCalories() async {
    if (_itemController.text.isEmpty || _quantityController.text.isEmpty) {
      return;
    }

    setState(() {
      _isEstimating = true;
    });

    try {
      final query = "${_quantityController.text} ${_itemController.text}";
      final url =
          Uri.parse("https://api.calorieninjas.com/v1/nutrition?query=$query");

      final response = await http.get(
        url,
        headers: {
          "X-Api-Key":
              StringsConst.gptApi, // Replace with your CalorieNinjas API key
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['items'] != null && data['items'].isNotEmpty) {
          print('data ${data}');
          final calories = data['items'][0]['calories'].toString();
          _calorieController.text = calories;
          fat = (data['items'][0]['fat_total_g'] ?? 0).toDouble();
          carb = (data['items'][0]['carbohydrates_total_g'] ?? 0).toDouble();
          protein = (data['items'][0]['protein_g'] ?? 0).toDouble();
          sugar = (data['items'][0]['sugar_g'] ?? 0).toDouble();
        } else {
          _calorieController.text = "No data found";
        }
      } else {
        _calorieController.text = "Error: ${response.statusCode}";
      }
    } catch (e) {
      print('error $e');
      _calorieController.text = "Failed to fetch calories";
    }

    setState(() {
      _isEstimating = false;
    });
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null ||
        _itemController.text.isEmpty ||
        // _quantityController.text.isEmpty ||
        _calorieController.text.isEmpty) {
      if (int.tryParse(_calorieController.text) == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Calorie count is invalid")),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields and select an image")),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance
          .refFromURL('gs://adtip-1eb9e.appspot.com')
          .child('uploads/$fileName.jpg');
      UploadTask uploadTask = storageRef.putFile(_selectedImage!);
      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      String userId = FirebaseAuth.instance.currentUser!.uid;
      String todayTimestamp = DateFormat('dd-MM-yyyy').format(DateTime.now());

      DocumentReference userFoodDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('food')
          .doc(todayTimestamp);

      await userFoodDoc.set({
        'time': todayTimestamp,
        widget.timeName: FieldValue.arrayUnion([
          {
            'item': _itemController.text,
            'quantity': _quantityController.text,
            'calorie': _calorieController.text,
            'fats': fat,
            'carbs': carb,
            'proteins': protein,
            'sugars': sugar,
            'imageUrl': imageUrl,
          }
        ])
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload Successful!")),
      );

      setState(() {
        _selectedImage = null;
        _itemController.clear();
        _quantityController.clear();
        _calorieController.clear();
      });
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload Failed!")),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Color(0xFF424242)
          : Colors.white,
      title: Text(
        "Upload Plate",
        style: TextStyle(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(context).size.height * 0.6, // Adjust as needed
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: _selectedImage != null
                    ? Image.file(_selectedImage!,
                        height: 100, fit: BoxFit.cover)
                    : Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.image,
                            size: 40, color: Colors.grey),
                      ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _itemController,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: "Item Name",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _estimateCalories(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                controller: _quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Quantity",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _estimateCalories(),
              ),
              const SizedBox(height: 10),
              TextFormField(
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                controller: _calorieController,
                keyboardType: TextInputType.number,
                readOnly: _isEstimating,
                decoration: InputDecoration(
                  labelText: "Estimated Calories",
                  border: OutlineInputBorder(),
                  suffixIcon: _isEstimating
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: _isUploading ? null : _uploadImage,
          child: _isUploading
              ? const CircularProgressIndicator()
              : const Text("Upload"),
        ),
      ],
    );
  }
}
