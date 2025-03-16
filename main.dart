import 'package:flutter/material.dart';
import 'login_page.dart';
import 'sign_in.dart';
import 'sign_up.dart';
import 'home.dart';
import 'upload_docs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCpDKfPv1luK4THv32JkKX6u5qqNxPEvGE",
            authDomain: "mydocs-af86d.firebaseapp.com",
            projectId: "mydocs-af86d",
            storageBucket: "mydocs-af86d.firebasestorage.app",
            messagingSenderId: "1927823239",
            appId: "1:1927823239:web:00cf5e20b30a20c1971d22"));
  } else {
    Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Health App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/', // Default route
      routes: {
        '/': (context) => const LoginPage(), // Login Page
        '/signin': (context) => SignInPage(), // Sign In Page
        '/signup': (context) => const SignUpPage(), // Sign Up Page
        '/home': (context) => const HomePage(), // Home Page
        '/upload': (context) =>
            const UploadDocumentScreen(), // Upload Documents Page
        // '/book_appointment': (context) =>
        //   const BookAppointmentScreen(), // Book Appointment Screen
        // '/view_appointments': (context) =>
        //   ViewAppointmentScreen(),
      },
    );
  }
}
