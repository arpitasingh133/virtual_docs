import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:flutter/foundation.dart'; // Import for kIsWeb

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({Key? key}) : super(key: key);

  @override
  State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  PlatformFile? _selectedFile; // Changed to PlatformFile to handle web and mobile
  String? _reportName;
  DateTime? _reportDate;
  String? _reportType;
  String? _doctorHospitalName;
  String? _notes;
  bool _isUploading = false;
  final _formKey = GlobalKey<FormState>();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'], // Example extensions
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.single; // Store PlatformFile object
        });
        print("Selected file: ${_selectedFile!.name}");
      }
    } catch (e) {
      print("Error picking file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error picking file')),
      );
    }
  }

  Future<void> _uploadDocument() async {
    if (_formKey.currentState!.validate() && _selectedFile != null) {
      setState(() => _isUploading = true);

      try {
        final user = _auth.currentUser;
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User not logged in')),
          );
          setState(() => _isUploading = false);
          return;
        }

        String fileName = _selectedFile!.name; // Use name property for filename (works on web and mobile)
        String filePath = 'reports/${user.uid}/$fileName'; // Store files under user-specific folder

        // Upload file to Firebase Storage
        Reference storageRef = _storage.ref().child(filePath);
        if (kIsWeb) {
          // Upload bytes for web
          await storageRef.putData(_selectedFile!.bytes!);
        } else {
          // Upload file for mobile/desktop
          await storageRef.putFile(File(_selectedFile!.path!)); // Convert PlatformFile path to File for mobile
        }

        // Get download URL
        String downloadURL = await storageRef.getDownloadURL();

        // Store file metadata in Firestore under the user's collection
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('reports')
            .add({
          'name': _reportName,
          'type': _reportType,
          'doctorHospitalName': _doctorHospitalName,
          'notes': _notes,
          'filePath': filePath,
          'fileUrl': downloadURL,
          'uploadedAt': DateTime.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Upload Complete!")),
        );

        _formKey.currentState!.reset();
        setState(() {
          _selectedFile = null;
          _reportDate = null;
          _isUploading = false;
        });
      } on FirebaseException catch (e) {
        print("Firebase Error: ${e.code} - ${e.message}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload Failed: ${e.message}")),
        );
        setState(() => _isUploading = false);
      } catch (e) {
        print("Error uploading: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload Failed: $e")),
        );
        setState(() => _isUploading = false);
      }
    } else if (_selectedFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a file')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Medical Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ElevatedButton(
                onPressed: _isUploading ? null : _pickFile,
                child: const Text("Select File"),
              ),
              if (_selectedFile != null)
                Text("Selected File: ${_selectedFile!.name}"), // Display file name instead of path on web
              TextFormField(
                decoration: const InputDecoration(labelText: "Report Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a report name';
                  }
                  return null;
                },
                onChanged: (value) => _reportName = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Date of Report"),
                controller: TextEditingController(
                    text: _reportDate != null
                        ? DateFormat('yyyy-MM-dd').format(_reportDate!)
                        : ""),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _reportDate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _reportDate = pickedDate;
                    });
                  }
                },
                validator: (value) {
                  if (_reportDate == null) {
                    return 'Please select a date';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: "Report Type"),
                value: _reportType,
                items: <String>[
                  'Test',
                  'Prescription',
                  'Scan',
                  'Surgery',
                  'Other'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) => _reportType = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a report type';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration:
                    const InputDecoration(labelText: "Doctor/Hospital Name (Optional)"),
                onChanged: (value) => _doctorHospitalName = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Notes (Optional)"),
                maxLines: 3,
                onChanged: (value) => _notes = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isUploading ? null : _uploadDocument,
                child: _isUploading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Upload"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}












//not able to upload file





// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:intl/intl.dart'; // For date formatting
// import 'package:flutter/foundation.dart'; // Import for kIsWeb

// class UploadDocumentScreen extends StatefulWidget {
//   const UploadDocumentScreen({Key? key}) : super(key: key);

//   @override
//   State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
// }

// class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
//   PlatformFile? _selectedFile; // Changed to PlatformFile to handle web and mobile
//   String? _reportName;
//   DateTime? _reportDate;
//   String? _reportType;
//   String? _doctorHospitalName;
//   String? _notes;
//   bool _isUploading = false;
//   final _formKey = GlobalKey<FormState>();

//   final FirebaseStorage _storage = FirebaseStorage.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> _pickFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'], // Example extensions
//       );

//       if (result != null) {
//         setState(() {
//           _selectedFile = result.files.single; // Store PlatformFile object
//         });
//       }
//     } catch (e) {
//       print("Error picking file: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error picking file')),
//       );
//     }
//   }

//   Future<void> _uploadDocument() async {
//     if (_formKey.currentState!.validate() && _selectedFile != null) {
//       setState(() => _isUploading = true);

//       try {
//         final user = _auth.currentUser;
//         if (user == null) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('User not logged in')),
//           );
//           return;
//         }

//         String fileName = _selectedFile!.name; // Use name property for filename (works on web and mobile)
//         String filePath = 'reports/${user.uid}/$fileName'; // Store files under user-specific folder

//         // Upload file to Firebase Storage
//         Reference storageRef = _storage.ref().child(filePath);
//         if (kIsWeb) {
//           // Upload bytes for web
//           await storageRef.putData(_selectedFile!.bytes!);
//         } else {
//           // Upload file for mobile/desktop
//           await storageRef.putFile(File(_selectedFile!.path!)); // Convert PlatformFile path to File for mobile
//         }

//         // Get download URL
//         String downloadURL = await storageRef.getDownloadURL();

//         // Store file metadata in Firestore under the user's collection
//         await _firestore
//             .collection('users')
//             .doc(user.uid)
//             .collection('reports')
//             .add({
//           'name': _reportName,
//           'type': _reportType,
//           'doctorHospitalName': _doctorHospitalName,
//           'notes': _notes,
//           'filePath': filePath,
//           'fileUrl': downloadURL,
//           'uploadedAt': DateTime.now(),
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Upload Complete!")),
//         );

//         _formKey.currentState!.reset();
//         setState(() {
//           _selectedFile = null;
//           _reportDate = null;
//           _isUploading = false;
//         });
//       } catch (e) {
//         print("Error uploading: $e");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Upload Failed: $e")),
//         );
//         setState(() => _isUploading = false);
//       }
//     } else if (_selectedFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a file')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upload Medical Report'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               ElevatedButton(
//                 onPressed: _isUploading ? null : _pickFile,
//                 child: const Text("Select File"),
//               ),
//               if (_selectedFile != null)
//                 Text("Selected File: ${_selectedFile!.name}"), // Display file name instead of path on web
//               TextFormField(
//                 decoration: const InputDecoration(labelText: "Report Name"),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a report name';
//                   }
//                   return null;
//                 },
//                 onChanged: (value) => _reportName = value,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: "Date of Report"),
//                 controller: TextEditingController(
//                     text: _reportDate != null
//                         ? DateFormat('yyyy-MM-dd').format(_reportDate!)
//                         : ""),
//                 onTap: () async {
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: _reportDate ?? DateTime.now(),
//                     firstDate: DateTime(1900),
//                     lastDate: DateTime.now(),
//                   );
//                   if (pickedDate != null) {
//                     setState(() {
//                       _reportDate = pickedDate;
//                     });
//                   }
//                 },
//                 validator: (value) {
//                   if (_reportDate == null) {
//                     return 'Please select a date';
//                   }
//                   return null;
//                 },
//               ),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(labelText: "Report Type"),
//                 value: _reportType,
//                 items: <String>[
//                   'Test',
//                   'Prescription',
//                   'Scan',
//                   'Surgery',
//                   'Other'
//                 ].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (value) => _reportType = value,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please select a report type';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 decoration:
//                     const InputDecoration(labelText: "Doctor/Hospital Name (Optional)"),
//                 onChanged: (value) => _doctorHospitalName = value,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: "Notes (Optional)"),
//                 maxLines: 3,
//                 onChanged: (value) => _notes = value,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _isUploading ? null : _uploadDocument,
//                 child: _isUploading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text("Upload"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }





















// -------------------------x-------------------------------
// -------------------------ADDING FOR VIEW_DOCS.DART-------------------------------
// -------------------------x-------------------------------




// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart'; // For date formatting
// import 'package:flutter/foundation.dart'; // Import for kIsWeb

// class UploadDocumentScreen extends StatefulWidget {
//   const UploadDocumentScreen({Key? key}) : super(key: key);

//   @override
//   State<UploadDocumentScreen> createState() => _UploadDocumentScreenState();
// }

// class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
//   PlatformFile? _selectedFile; // Changed to PlatformFile to handle web and mobile
//   String? _reportName;
//   DateTime? _reportDate;
//   String? _reportType;
//   String? _doctorHospitalName;
//   String? _notes;
//   bool _isUploading = false;
//   final _formKey = GlobalKey<FormState>();

//   Future<void> _pickFile() async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'], // Example extensions
//       );

//       if (result != null) {
//         setState(() {
//           _selectedFile = result.files.single; // Store PlatformFile object
//         });
//       }
//     } catch (e) {
//       print("Error picking file: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error picking file')),
//       );
//     }
//   }

//   Future<void> _uploadDocument() async {
//     if (_formKey.currentState!.validate() && _selectedFile != null) {
//       setState(() => _isUploading = true);

//       try {
//         String fileName = _selectedFile!.name; // Use name property for filename (works on web and mobile)
//         Reference storageRef = FirebaseStorage.instance
//             .ref()
//             .child('medical_reports/$fileName'); // More descriptive path

//         if (kIsWeb) {
//           // Upload bytes for web
//           await storageRef.putData(_selectedFile!.bytes!);
//         } else {
//           // Upload file for mobile/desktop
//           await storageRef.putFile(File(_selectedFile!.path!)); // Need to convert PlatformFile path to File for mobile
//         }

//         String downloadURL = await storageRef.getDownloadURL();

//         await FirebaseFirestore.instance.collection('medical_reports').add({
//           'reportName': _reportName,
//           'reportDate': _reportDate != null
//               ? DateFormat('yyyy-MM-dd').format(_reportDate!)
//               : null,
//           'reportType': _reportType,
//           'doctorHospitalName': _doctorHospitalName,
//           'notes': _notes,
//           'fileName': fileName,
//           'fileUrl': downloadURL,
//         });

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Upload Complete!")),
//         );

//         _formKey.currentState!.reset();
//         setState(() {
//           _selectedFile = null;
//           _reportDate = null;
//           _isUploading = false;
//         });
//       } catch (e) {
//         print("Error uploading: $e");
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Upload Failed: $e")),
//         );
//         setState(() => _isUploading = false);
//       }
//     } else if (_selectedFile == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a file')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Upload Medical Report'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               ElevatedButton(
//                 onPressed: _isUploading ? null : _pickFile,
//                 child: const Text("Select File"),
//               ),
//               if (_selectedFile != null)
//                 Text("Selected File: ${_selectedFile!.name}"), // Display file name instead of path on web
//               TextFormField(
//                 decoration: const InputDecoration(labelText: "Report Name"),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter a report name';
//                   }
//                   return null;
//                 },
//                 onChanged: (value) => _reportName = value,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: "Date of Report"),
//                 controller: TextEditingController(
//                     text: _reportDate != null
//                         ? DateFormat('yyyy-MM-dd').format(_reportDate!)
//                         : ""),
//                 onTap: () async {
//                   DateTime? pickedDate = await showDatePicker(
//                     context: context,
//                     initialDate: _reportDate ?? DateTime.now(),
//                     firstDate: DateTime(1900),
//                     lastDate: DateTime.now(),
//                   );
//                   if (pickedDate != null) {
//                     setState(() {
//                       _reportDate = pickedDate;
//                     });
//                   }
//                 },
//                 validator: (value) {
//                   if (_reportDate == null) {
//                     return 'Please select a date';
//                   }
//                   return null;
//                 },
//               ),
//               DropdownButtonFormField<String>(
//                 decoration: const InputDecoration(labelText: "Report Type"),
//                 value: _reportType,
//                 items: <String>[
//                   'Test',
//                   'Prescription',
//                   'Scan',
//                   'Surgery',
//                   'Other'
//                 ].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (value) => _reportType = value,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please select a report type';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 decoration:
//                     const InputDecoration(labelText: "Doctor/Hospital Name (Optional)"),
//                 onChanged: (value) => _doctorHospitalName = value,
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: "Notes (Optional)"),
//                 maxLines: 3,
//                 onChanged: (value) => _notes = value,
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _isUploading ? null : _uploadDocument,
//                 child: _isUploading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text("Upload"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }