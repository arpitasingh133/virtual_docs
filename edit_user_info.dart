import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class EditUserInfoScreen extends StatefulWidget {
  const EditUserInfoScreen({super.key});

  @override
  _EditUserInfoScreenState createState() => _EditUserInfoScreenState();
}

class _EditUserInfoScreenState extends State<EditUserInfoScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final List<TextEditingController> _allergiesControllers = [TextEditingController()];
  final List<TextEditingController> _medicationsControllers = [TextEditingController()];
  final List<Map<String, TextEditingController>> _emergencyContactsControllers = [
    {'name': TextEditingController(), 'phone': TextEditingController()}
  ];

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          _firstNameController.text = userData['firstName'] ?? '';
          _lastNameController.text = userData['lastName'] ?? '';
          _emailController.text = userData['email'] ?? '';
          _phoneController.text = userData['phone'] ?? '';
          _bloodGroupController.text = userData['bloodGroup'] ?? '';
          _heightController.text = userData['height'] ?? '';
          _weightController.text = userData['weight'] ?? '';
          _allergiesControllers[0].text = userData['allergies']?.join(', ') ?? '';
          _medicationsControllers[0].text = userData['medications']?.join(', ') ?? '';
          if (userData['emergencyContacts'] != null) {
            _emergencyContactsControllers.clear();
            for (var contact in userData['emergencyContacts']) {
              _emergencyContactsControllers.add({
                'name': TextEditingController(text: contact['name']),
                'phone': TextEditingController(text: contact['phone']),
              });
            }
          }
        });
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveUserInfo() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Upload profile image if selected
      String? profileImageUrl;
      if (_profileImage != null) {
        final ref = _storage.ref().child('profile_pictures/${user.uid}');
        await ref.putFile(_profileImage!);
        profileImageUrl = await ref.getDownloadURL();
      }

      // Prepare user data
      final userData = {
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'bloodGroup': _bloodGroupController.text,
        'height': _heightController.text,
        'weight': _weightController.text,
        'allergies': _allergiesControllers.map((c) => c.text).toList(),
        'medications': _medicationsControllers.map((c) => c.text).toList(),
        'emergencyContacts': _emergencyContactsControllers
            .map((c) => {'name': c['name']!.text, 'phone': c['phone']!.text})
            .toList(),
        if (profileImageUrl != null) 'profileImageUrl': profileImageUrl,
      };

      // Save to Firestore
      await _firestore.collection('users').doc(user.uid).set(userData, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User Info'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveUserInfo,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile Picture
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage('assets/user_pic.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 16),

            // Personal Details
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),

            // Health Details
            TextField(
              controller: _bloodGroupController,
              decoration: const InputDecoration(labelText: 'Blood Group'),
            ),
            TextField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Height'),
            ),
            TextField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight'),
            ),

            // Allergies
            _buildDynamicFields(
              title: 'Allergies',
              controllers: _allergiesControllers,
              hintText: 'Add allergy',
            ),

            // Medications
            _buildDynamicFields(
              title: 'Medications',
              controllers: _medicationsControllers,
              hintText: 'Add medication',
            ),

            // Emergency Contacts
            _buildEmergencyContacts(),

            // Update Profile Button
            ElevatedButton(
              onPressed: () {
                _saveUserInfo();
                Navigator.pop(context); // Redirect to user profile
              },
              child: const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicFields({
    required String title,
    required List<TextEditingController> controllers,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ...controllers.map((controller) {
          return Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: hintText),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    controllers.remove(controller);
                  });
                },
              ),
            ],
          );
        }).toList(),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              controllers.add(TextEditingController());
            });
          },
        ),
      ],
    );
  }

  Widget _buildEmergencyContacts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Emergency Contacts',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        ..._emergencyContactsControllers.map((controllers) {
          return Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controllers['name'],
                  decoration: const InputDecoration(hintText: 'Name'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controllers['phone'],
                  decoration: const InputDecoration(hintText: 'Phone Number'),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    _emergencyContactsControllers.remove(controllers);
                  });
                },
              ),
            ],
          );
        }).toList(),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              _emergencyContactsControllers.add({
                'name': TextEditingController(),
                'phone': TextEditingController(),
              });
            });
          },
        ),
      ],
    );
  }
}




