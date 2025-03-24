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
      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          "Authorization": "Bearer ${StringsConst.gptApi}",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a nutrition assistant. Estimate the calories based on the given food item and quantity."
            },
            {
              "role": "user",
              "content":
                  "Estimate calories for ${_quantityController.text} grams of ${_itemController.text}."
            }
          ],
        }),
      );
      print('response ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String estimatedCalories = data['choices'][0]['message']['content'];
        _calorieController.text = estimatedCalories;
      } else {
        _calorieController.text = "Error estimating calories";
      }
    } catch (e) {
      _calorieController.text = "Failed to fetch calories";
    }

    setState(() {
      _isEstimating = false;
    });
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null ||
        _itemController.text.isEmpty ||
        _quantityController.text.isEmpty ||
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
            'fats': "",
            'carbs': "",
            'proteins': 0,
            'sugars': 0,
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
      title: const Text("Upload Plate"),
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
                decoration: const InputDecoration(
                  labelText: "Item Name",
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) => _estimateCalories(),
              ),
              const SizedBox(height: 10),
              TextFormField(
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
