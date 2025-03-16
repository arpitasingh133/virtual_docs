import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtual_docs/chats/chat_home_screen.dart';
import 'package:virtual_docs/pharmacy_first.dart';
import 'package:virtual_docs/user_profile.dart';
import 'package:virtual_docs/health_reports/view_reports.dart';
import 'upload_docs.dart';
import 'appointments/appointment_home.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = ''; // Declare userName variable

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (userData.exists) {
        setState(() {
          userName = userData['firstName']; // Use 'firstName' from Firestore
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 25,
            backgroundImage:
                AssetImage('assets/user_pic.png'), // Add your user pic asset
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              //Welcome Section
              Text(
                'Health Cheers!\n$userName', // Replace 'John' with the user's name
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              // Curved Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Grid of 4 Boxes
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  // Box 1: Upload Doc
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UploadDocumentScreen()),
                      );
                    },
                    child: _buildBox(
                      icon: Icons.upload,
                      title: 'Upload Doc',
                      color: Colors.blue[100]!,
                    ),
                  ),

                  // Box 2: Appointments
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AppointmentHomeScreen()),
                      );
                    },
                    child: _buildBox(
                      icon: Icons.calendar_today,
                      title: 'Appointments',
                      color: const Color.fromARGB(255, 200, 230, 201),
                    ),
                  ),

                  // Box 3: Pharmacy

                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PharmacyHomeScreen()),
                      );
                    },
                    child: _buildBox(
                      icon: Icons.local_pharmacy,
                      title: 'Pharmacy',
                      color: Colors.orange[100]!,
                    ),
                  ),

                  // Box 4: Health Track
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ViewReportsScreen()),
                      );
                    },
                    child: _buildBox(
                      icon: Icons.assignment,
                      title: 'Health Reports',
                      color: Colors.purple[100]!,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        elevation: 10,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Chat
            IconButton(
              icon: const Icon(Icons.chat, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatHomeScreen()),
                );
              },
            ),

            // Home
            IconButton(
              icon: const Icon(Icons.home, color: Colors.blue),
              onPressed: () {},
            ),

            // Profile
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }


// Helper function to create a box
  Widget _buildBox(
      {required IconData icon, required String title, required Color color}) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.black),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
