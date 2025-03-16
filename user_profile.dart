import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:virtual_docs/edit_user_info.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isPersonalDetailsExpanded = false;
  bool _isHealthDetailsExpanded = false;
  bool _isAllergiesExpanded = false;
  bool _isMedicationsExpanded = false;
  bool _isEmergencyContactsExpanded = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        setState(() {
          _userData = userDoc.data() as Map<String, dynamic>;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditUserInfoScreen()),
              ).then((_) => _fetchUserData()); // Refresh data after editing
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Info Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _userData?['profileImageUrl'] != null
                          ? NetworkImage(_userData!['profileImageUrl'])
                          : const AssetImage('assests/images/user_pic.png') as ImageProvider,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _userData?['firstName'] ?? 'User',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Healthy',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildInfoItem('Age', _userData?['age'] ?? 'N/A'),
                        _buildInfoItem('Blood Group', _userData?['bloodGroup'] ?? 'N/A'),
                        _buildInfoItem('Height', _userData?['height'] ?? 'N/A'),
                        _buildInfoItem('Weight', _userData?['weight'] ?? 'N/A'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Personal Details
            _buildExpandableSection(
              title: 'Personal Details',
              isExpanded: _isPersonalDetailsExpanded,
              onTap: () {
                setState(() {
                  _isPersonalDetailsExpanded = !_isPersonalDetailsExpanded;
                });
              },
              children: [
                _buildDetailItem(Icons.person, 'Name', _userData?['firstName'] ?? 'N/A'),
                _buildDetailItem(Icons.email, 'Email', _userData?['email'] ?? 'N/A'),
                _buildDetailItem(Icons.phone, 'Phone', _userData?['phone'] ?? 'N/A'),
              ],
            ),

            // Health Details
            _buildExpandableSection(
              title: 'Health Details',
              isExpanded: _isHealthDetailsExpanded,
              onTap: () {
                setState(() {
                  _isHealthDetailsExpanded = !_isHealthDetailsExpanded;
                });
              },
              children: [
                _buildDetailItem(Icons.bloodtype, 'Blood Group', _userData?['bloodGroup'] ?? 'N/A'),
                _buildDetailItem(Icons.height, 'Height', _userData?['height'] ?? 'N/A'),
                _buildDetailItem(Icons.monitor_weight, 'Weight', _userData?['weight'] ?? 'N/A'),
                _buildDetailItem(Icons.calculate, 'BMI', _userData?['bmi'] ?? 'N/A'),
              ],
            ),

            // Allergies
            _buildExpandableSection(
              title: 'Allergies',
              isExpanded: _isAllergiesExpanded,
              onTap: () {
                setState(() {
                  _isAllergiesExpanded = !_isAllergiesExpanded;
                });
              },
              children: [
                _buildDetailItem(Icons.warning, 'Allergies', _userData?['allergies']?.join(', ') ?? 'N/A'),
              ],
            ),

            // Medications
            _buildExpandableSection(
              title: 'Medications',
              isExpanded: _isMedicationsExpanded,
              onTap: () {
                setState(() {
                  _isMedicationsExpanded = !_isMedicationsExpanded;
                });
              },
              children: [
                _buildDetailItem(Icons.medication, 'Current Medications', _userData?['medications']?.join(', ') ?? 'N/A'),
              ],
            ),

            // Emergency Contacts
            _buildExpandableSection(
              title: 'Emergency Contacts',
              isExpanded: _isEmergencyContactsExpanded,
              onTap: () {
                setState(() {
                  _isEmergencyContactsExpanded = !_isEmergencyContactsExpanded;
                });
              },
              children: [
                if (_userData?['emergencyContacts'] != null)
                  ..._userData!['emergencyContacts'].map<Widget>((contact) {
                    return _buildDetailItem(
                      Icons.contact_emergency,
                      contact['name'],
                      contact['phone'],
                    );
                  }).toList(),
              ],
            ),

            // Help & Support
            _buildSectionHeader('Help & Support'),
            _buildActionItem(Icons.help, 'FAQs', () {
              // Navigate to FAQs screen
            }),
            _buildActionItem(Icons.support, 'Customer Support', () {
              // Navigate to customer support screen
            }),
            _buildActionItem(Icons.settings, 'App Settings', () {
              // Navigate to app settings screen
            }),
          ],
        ),
      ),
    );
  }

  // Helper method to build an expandable section
  Widget _buildExpandableSection({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ExpansionTile(
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          isExpanded ? Icons.expand_less : Icons.expand_more,
        ),
        onExpansionChanged: (bool expanded) {
          onTap();
        },
        children: children,
      ),
    );
  }

  // Helper method to build an info item (e.g., Age, Blood Group)
  Widget _buildInfoItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Helper method to build a section header
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Helper method to build a detail item (e.g., Name, Email)
  Widget _buildDetailItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label),
      subtitle: Text(value),
    );
  }

  // Helper method to build an action item (e.g., FAQs, Customer Support)
  Widget _buildActionItem(IconData icon, String label, VoidCallback onPressed) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward),
      onTap: onPressed,
    );
  }
}
















































// import 'package:flutter/material.dart';
// import 'package:virtual_docs/edit_user_info.dart';

// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({super.key});

//   @override
//   _UserProfileScreenState createState() => _UserProfileScreenState();
// }

// class _UserProfileScreenState extends State<UserProfileScreen> {
//   bool _isPersonalDetailsExpanded = false;
//   bool _isHealthDetailsExpanded = false;
//   bool _isAllergiesExpanded = false;
//   bool _isMedicationsExpanded = false;
//   bool _isEmergencyContactsExpanded = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const EditUserInfoScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Basic Info Card
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     const CircleAvatar(
//                       radius: 50,
//                       backgroundImage: AssetImage('assets/user_pic.png'), // Replace with user's profile picture
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Anitej',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Healthy',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.green,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         _buildInfoItem('Age', '28'),
//                         _buildInfoItem('Blood Group', 'O+'),
//                         _buildInfoItem('Height', '175 cm'),
//                         _buildInfoItem('Weight', '70 kg'),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Personal Details
//             _buildExpandableSection(
//               title: 'Personal Details',
//               isExpanded: _isPersonalDetailsExpanded,
//               onTap: () {
//                 setState(() {
//                   _isPersonalDetailsExpanded = !_isPersonalDetailsExpanded;
//                 });
//               },
//               children: [
//                 _buildDetailItem(Icons.person, 'Name', 'Anitej'),
//                 _buildDetailItem(Icons.email, 'Email', 'anitej@example.com'),
//                 _buildDetailItem(Icons.phone, 'Phone', '+91 9876543210'),
//               ],
//             ),

//             // Health Details
//             _buildExpandableSection(
//               title: 'Health Details',
//               isExpanded: _isHealthDetailsExpanded,
//               onTap: () {
//                 setState(() {
//                   _isHealthDetailsExpanded = !_isHealthDetailsExpanded;
//                 });
//               },
//               children: [
//                 _buildDetailItem(Icons.bloodtype, 'Blood Group', 'O+'),
//                 _buildDetailItem(Icons.height, 'Height', '175 cm'),
//                 _buildDetailItem(Icons.monitor_weight, 'Weight', '70 kg'),
//                 _buildDetailItem(Icons.calculate, 'BMI', '22.9'),
//               ],
//             ),

//             // Allergies
//             _buildExpandableSection(
//               title: 'Allergies',
//               isExpanded: _isAllergiesExpanded,
//               onTap: () {
//                 setState(() {
//                   _isAllergiesExpanded = !_isAllergiesExpanded;
//                 });
//               },
//               children: [
//                 _buildDetailItem(Icons.warning, 'Allergies', 'Pollen, Dust'),
//               ],
//             ),

//             // Medications
//             _buildExpandableSection(
//               title: 'Medications',
//               isExpanded: _isMedicationsExpanded,
//               onTap: () {
//                 setState(() {
//                   _isMedicationsExpanded = !_isMedicationsExpanded;
//                 });
//               },
//               children: [
//                 _buildDetailItem(Icons.medication, 'Current Medications', 'Paracetamol, Vitamin D'),
//               ],
//             ),

//             // Emergency Contacts
//             _buildExpandableSection(
//               title: 'Emergency Contacts',
//               isExpanded: _isEmergencyContactsExpanded,
//               onTap: () {
//                 setState(() {
//                   _isEmergencyContactsExpanded = !_isEmergencyContactsExpanded;
//                 });
//               },
//               children: [
//                 _buildDetailItem(Icons.contact_emergency, 'Contact 1', 'John Doe - +91 9876543210'),
//                 _buildDetailItem(Icons.contact_emergency, 'Contact 2', 'Jane Doe - +91 9876543211'),
//               ],
//             ),

//             // Help & Support
//             _buildSectionHeader('Help & Support'),
//             _buildActionItem(Icons.help, 'FAQs', () {
//               // Navigate to FAQs screen
//             }),
//             _buildActionItem(Icons.support, 'Customer Support', () {
//               // Navigate to customer support screen
//             }),
//             _buildActionItem(Icons.settings, 'App Settings', () {
//               // Navigate to app settings screen
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper method to build an expandable section
//   Widget _buildExpandableSection({
//     required String title,
//     required bool isExpanded,
//     required VoidCallback onTap,
//     required List<Widget> children,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ExpansionTile(
//         title: Text(
//           title,
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         trailing: Icon(
//           isExpanded ? Icons.expand_less : Icons.expand_more,
//         ),
//         onExpansionChanged: (bool expanded) {
//           onTap();
//         },
//         children: children,
//       ),
//     );
//   }

//   // Helper method to build an info item (e.g., Age, Blood Group)
//   Widget _buildInfoItem(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Colors.grey,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   // Helper method to build a section header
//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   // Helper method to build a detail item (e.g., Name, Email)
//   Widget _buildDetailItem(IconData icon, String label, String value) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.blue),
//       title: Text(label),
//       subtitle: Text(value),
//     );
//   }

//   // Helper method to build an action item (e.g., FAQs, Customer Support)
//   Widget _buildActionItem(IconData icon, String label, VoidCallback onPressed) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.blue),
//       title: Text(label),
//       trailing: const Icon(Icons.arrow_forward),
//       onTap: onPressed,
//     );
//   }
// }




































// import 'package:flutter/material.dart';

// class UserProfileScreen extends StatelessWidget {
//   const UserProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('User Profile'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.edit),
//             onPressed: () {
//               // Navigate to edit profile screen
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Basic Info Card
//             Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     const CircleAvatar(
//                       radius: 50,
//                       backgroundImage: AssetImage('assets/user_pic.png'), // Replace with user's profile picture
//                     ),
//                     const SizedBox(height: 16),
//                     const Text(
//                       'Anitej',
//                       style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       'Healthy',
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: Colors.green,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         _buildInfoItem('Age', '28'),
//                         _buildInfoItem('Blood Group', 'O+'),
//                         _buildInfoItem('Height', '175 cm'),
//                         _buildInfoItem('Weight', '70 kg'),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),

//             // Personal Details
//             _buildSectionHeader('Personal Details'),
//             _buildDetailItem(Icons.person, 'Name', 'Anitej'),
//             _buildDetailItem(Icons.email, 'Email', 'anitej@example.com'),
//             _buildDetailItem(Icons.phone, 'Phone', '+91 9876543210'),

//             // Health Details
//             _buildSectionHeader('Health Details'),
//             _buildDetailItem(Icons.bloodtype, 'Blood Group', 'O+'),
//             _buildDetailItem(Icons.height, 'Height', '175 cm'),
//             _buildDetailItem(Icons.monitor_weight, 'Weight', '70 kg'),
//             _buildDetailItem(Icons.calculate, 'BMI', '22.9'),

//             // Allergies
//             _buildSectionHeader('Allergies'),
//             _buildDetailItem(Icons.warning, 'Allergies', 'Pollen, Dust'),

//             // Medications
//             _buildSectionHeader('Medications'),
//             _buildDetailItem(Icons.medication, 'Current Medications', 'Paracetamol, Vitamin D'),

//             // Emergency Contacts
//             _buildSectionHeader('Emergency Contacts'),
//             _buildDetailItem(Icons.contact_emergency, 'Contact 1', 'John Doe - +91 9876543210'),
//             _buildDetailItem(Icons.contact_emergency, 'Contact 2', 'Jane Doe - +91 9876543211'),

//             // Help & Support
//             _buildSectionHeader('Help & Support'),
//             _buildActionItem(Icons.help, 'FAQs', () {
//               // Navigate to FAQs screen
//             }),
//             _buildActionItem(Icons.support, 'Customer Support', () {
//               // Navigate to customer support screen
//             }),
//             _buildActionItem(Icons.settings, 'App Settings', () {
//               // Navigate to app settings screen
//             }),
//           ],
//         ),
//       ),
//     );
//   }

//   // Helper method to build an info item (e.g., Age, Blood Group)
//   Widget _buildInfoItem(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 14,
//             color: Colors.grey,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ],
//     );
//   }

//   // Helper method to build a section header
//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16.0),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   // Helper method to build a detail item (e.g., Name, Email)
//   Widget _buildDetailItem(IconData icon, String label, String value) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.blue),
//       title: Text(label),
//       subtitle: Text(value),
//     );
//   }

//   // Helper method to build an action item (e.g., FAQs, Customer Support)
//   Widget _buildActionItem(IconData icon, String label, VoidCallback onPressed) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.blue),
//       title: Text(label),
//       trailing: const Icon(Icons.arrow_forward),
//       onTap: onPressed,
//     );
//   }
// }

























// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // For Date Formatting (if needed)

// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({super.key});

//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }

// class _UserProfileScreenState extends State<UserProfileScreen> {
//   // --- Placeholder User Data (Replace with actual data fetching) ---
//   final Map<String, dynamic> _userData = {
//     'profilePictureUrl': 'URL_TO_PROFILE_PICTURE_OR_NULL', // Replace with actual URL or null
//     'fullName': 'Anitej Sharma', // Replace with actual user's name
//     'email': 'anitej.sharma@example.com', // Replace with actual email
//     'phoneNumber': '+1-555-123-4567', // Replace with actual phone
//     'dateOfBirth': DateTime(1990, 5, 15), // Replace with actual DoB or null
//     'gender': 'Male', // Replace with actual gender or null
//     'allergies': ['Pollen', 'Dust Mites'], // Replace with actual allergies or empty list
//     'emergencyContacts': [  // Replace with actual contacts or empty list
//       {'name': 'Spouse Name', 'phone': '+1-555-987-6543', 'relationship': 'Spouse'},
//       {'name': 'Parent Name', 'phone': '+1-555-111-2222', 'relationship': 'Parent'},
//     ],
//   };
//   // --- End Placeholder Data ---

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'), // Or use the user's name as title
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // --- Top Rectangular Header Section ---
//               _buildProfileHeader(),
//               const SizedBox(height: 24), // Spacing after header

//               // --- General Information Section ---
//               _buildSectionHeader('General Information'),
//               _buildInfoTile('Email', _userData['email']),
//               _buildInfoTile('Phone Number', _userData['phoneNumber']),
//               _buildInfoTile('Date of Birth', _formatDate(_userData['dateOfBirth'])),
//               _buildInfoTile('Gender', _userData['gender']),
//               const Divider(), // Visual separator

//               // --- Health Information Section ---
//               _buildSectionHeader('Health Information'),
//               _buildAllergiesSection(),
//               _buildEmergencyContactsSection(),
//               const Divider(),

//               // --- App Settings & Utility Section ---
//               _buildSectionHeader('App Settings & Utility'),
//               _buildSettingsTile('Settings', Icons.settings),
//               _buildSettingsTile('Help & Support', Icons.help_outline),
//               _buildSettingsTile('Terms of Service', Icons.document_scanner_outlined), // Example icon
//               _buildSettingsTile('Privacy Policy', Icons.security), // Example icon
//               _buildSettingsTile('Logout', Icons.logout),
//               const SizedBox(height: 20), // Bottom spacing
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // --- Helper Widgets to Build Sections ---

//   Widget _buildProfileHeader() {
//     return Row(
//       children: [
//         CircleAvatar(
//           radius: 50,
//           backgroundImage: _userData['profilePictureUrl'] != null
//               ? NetworkImage(_userData['profilePictureUrl']) as ImageProvider<Object>?
//               : const AssetImage('assets/default_profile_image.png'), // Replace with your default asset
//           child: _userData['profilePictureUrl'] == null ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 _userData['fullName'],
//                 style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//               // Optional summary line can be added here if needed
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
//       child: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700])),
//     );
//   }

//   Widget _buildInfoTile(String title, String? value) {
//     return ListTile(
//       title: Text(title),
//       subtitle: Text(value ?? 'Not provided'), // Display 'Not provided' if value is null
//     );
//   }

//   Widget _buildSettingsTile(String title, IconData icon) {
//     return ListTile(
//       leading: Icon(icon),
//       title: Text(title),
//       trailing: const Icon(Icons.chevron_right), // Navigation indicator
//       onTap: () {
//         // TODO: Implement navigation or action for each setting
//         print('$title tapped'); // Placeholder action
//         if (title == 'Logout') {
//           // TODO: Implement Logout functionality
//         } else if (title == 'Settings') {
//           // TODO: Navigate to Settings screen
//         } // ... add actions for other settings
//       },
//     );
//   }

//   Widget _buildAllergiesSection() {
//     return ExpansionTile(
//       title: const Text('Allergies'),
//       leading: const Icon(Icons.warning_amber_rounded), // Example icon
//       children: [
//         if (_userData['allergies'] != null && _userData['allergies'].isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: _userData['allergies'].map<Widget>((allergy) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4.0),
//                 child: Text('- $allergy'),
//               )).toList(),
//             ),
//           )
//         else
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text('No allergies recorded.'),
//           ),
//       ],
//     );
//   }

//   Widget _buildEmergencyContactsSection() {
//     return ExpansionTile(
//       title: const Text('Emergency Contacts'),
//       leading: const Icon(Icons.contacts), // Example icon
//       children: [
//         if (_userData['emergencyContacts'] != null && _userData['emergencyContacts'].isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: _userData['emergencyContacts'].map<Widget>((contact) =>
//                   ListTile(
//                     title: Text(contact['name']),
//                     subtitle: Text('${contact['relationship']}, Phone: ${contact['phone']}'),
//                   )
//               ).toList(),
//             ),
//           )
//         else
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text('No emergency contacts added.'),
//           ),
//       ],
//     );
//   }


//   // --- Utility Functions ---
//   String _formatDate(DateTime? date) {
//     if (date == null) {
//       return 'Not provided';
//     }
//     return DateFormat('MMMM d, yyyy').format(date); // Example format
//   }
// }