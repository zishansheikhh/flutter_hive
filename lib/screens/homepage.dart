import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/bottombar.dart';

class FormScreen extends StatefulWidget {
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _selectedImage;
  bool _isLoading = false;

  // Request necessary permissions
  Future<void> _requestPermissions() async {
    final cameraStatus = await Permission.camera.request();
    final galleryStatus = await Permission.photos.request();

    if (cameraStatus.isGranted && galleryStatus.isGranted) {
      // If permissions are granted, show the image source dialog
      _showImageSourceDialog();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Permissions are required to pick an image.')),
      );
    }
  }

  // Show bottom sheet to choose between camera or gallery
  Future<void> _showImageSourceDialog() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Image Source',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Camera option
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context); // Close the bottom sheet
                    final pickedFile = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _selectedImage = File(pickedFile.path);
                      });
                    }
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.camera_alt, size: 40, color: Colors.blue),
                      SizedBox(height: 8),
                      Text('Camera'),
                    ],
                  ),
                ),
                // Gallery option
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context); // Close the bottom sheet
                    final pickedFile = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      setState(() {
                        _selectedImage = File(pickedFile.path);
                      });
                    }
                  },
                  child: const Column(
                    children: [
                      Icon(Icons.photo_library, size: 40, color: Colors.green),
                      SizedBox(height: 8),
                      Text('Gallery'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Submit form
  Future<void> _submitForm() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all the fields.'),
          backgroundColor: Colors.red.shade400.withOpacity(0.9),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final box = Hive.box('formData');
    await box.add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'imagePath': _selectedImage!.path,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'Form submitted successfully!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 3),
      ),
    );

    setState(() {
      _isLoading = false;
      _selectedImage = null;
    });

    _titleController.clear();
    _descriptionController.clear();
  }

  // Delete image
  void _deleteImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Screen'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 16),
          child: Column(
            children: [
              const SizedBox(height: 25),
              Text('Fill the details below',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 30),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _requestPermissions, // Trigger permission request
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 190, 191, 190),
                        width: 4),
                    borderRadius: BorderRadius.circular(16),
                    image: _selectedImage != null
                        ? DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover)
                        : null,
                  ),
                  child: _selectedImage == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.image,
                                color: Color.fromARGB(255, 124, 172, 124),
                                size: 50),
                            SizedBox(height: 8),
                            Text('Choose Image',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 124, 172, 124))),
                          ],
                        )
                      : Stack(
                          children: [
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: _deleteImage,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      _isLoading ? Colors.grey : Colors.orange.shade700,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Submit', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomBar(currentIndex: 0),
    );
  }
}
