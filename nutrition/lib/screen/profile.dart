import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class profileU extends StatefulWidget {
  const profileU({super.key});

  @override
  State<profileU> createState() => _profileUState();
}

class _profileUState extends State<profileU> {
  String _name = 'John Doe';
  String _address = '123 Main St, Anytown USA';
  File? _image;

// TextEditingController for the TextFormField
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
// Set the initial value of the TextEditingController
    _nameController.text = _name;
    _addressController.text = _address;
  }

  @override
  void dispose() {
    // Clean up the TextEditingController when the widget is disposed
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    // Save the changes to the user's profile
    setState(() {
      _name = _nameController.text;
      _address = _addressController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Take a picture'),
                            onTap: () {
                              Navigator.of(context).pop();
                              _getImage(ImageSource.camera);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.photo_library),
                            title: const Text('Choose from gallery'),
                            onTap: () {
                              Navigator.of(context).pop();
                              _getImage(ImageSource.gallery);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const CircleAvatar(
                radius: 50,
                // backgroundImage: _image!= null?
                // FileImage(_image!) : Image.asset('asset/images/men.jpg'),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
