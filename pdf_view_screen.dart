import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  final String fileUrl; // URL of the PDF file

  const PDFViewerScreen({Key? key, required this.fileUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileUrl.split('/').last), // Show file name in title
      ),
      body: SfPdfViewer.network(fileUrl), // Use Syncfusion PDF Viewer with URL
    );
  }
}













//changing as analyze report isn't being loaded.

// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// import 'dart:io';

// class PDFViewerScreen extends StatelessWidget {
//   final File file; // File to display in the viewer

//   const PDFViewerScreen({Key? key, required this.file}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Debugging: Print file path and check if file exists
//     print('File Path: ${file.path}');
//     if (file.existsSync()) {
//       print('File exists');
//     } else {
//       print('File does not exist');
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(file.path.split('/').last), // Show file name in title
//         backgroundColor: Colors.blue, // Same color palette
//       ),
//       body: SfPdfViewer.file(file), // Use Syncfusion PDF Viewer
//     );
//   }
// }