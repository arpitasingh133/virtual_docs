import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PreviewScreen extends StatelessWidget {
  const PreviewScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Documents'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('uploaded_pdfs').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No documents uploaded yet.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              final doc = documents[index];
              final fileName = doc['fileName'];
              final fileUrl = doc['fileUrl'];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(
                    fileName,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.preview, color: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFViewerScreen(fileUrl: fileUrl),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String fileUrl; // URL of the PDF file

  const PDFViewerScreen({Key? key, required this.fileUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Document'),
        backgroundColor: Colors.blue,
      ),
      body: SfPdfViewer.network(fileUrl),
    );
  }
}








//--------------------------------x----------------------------x--------------------

// import 'package:flutter/material.dart';
// //import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'dart:io';

// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// class PreviewScreen extends StatelessWidget {
//   final List<File> files; 

//   const PreviewScreen({Key? key, required this.files}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Preview Documents'), //screen name
//         backgroundColor: Colors.blue, 
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(20.0),
//         itemCount: files.length,
//         itemBuilder: (context, index) {
//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 10.0),
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: ListTile(
//               leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
//               title: Text(
//                 files[index].path.split('/').last, // Display file name
//                 overflow: TextOverflow.ellipsis,
//               ),
//               trailing: IconButton(
//                 icon: const Icon(Icons.preview, color: Colors.blue),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => PDFViewerScreen(file: files[index]),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

// class PDFViewerScreen extends StatelessWidget {
//   final File file; // File to display in the viewer

//   const PDFViewerScreen({Key? key, required this.file}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(file.path.split('/').last), // Show file name in title
//         backgroundColor: Colors.blue, // Same color palette
//       ),
//       body: SfPdfViewer.file(file),
//     );
//   }
// }
