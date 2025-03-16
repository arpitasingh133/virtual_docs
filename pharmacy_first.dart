import 'package:flutter/material.dart';

class PharmacyHomeScreen extends StatelessWidget {
  const PharmacyHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dummy list of categories with images and labels
    final List<Map<String, String>> categories = [
      {
        'name': 'Pain Relief',
        'image': 'assets/pain_relief.png', // Replace with actual image path
      },
      {
        'name': 'Vitamins',
        'image': 'assets/vitamins.png', // Replace with actual image path
      },
      {
        'name': 'Cough & Cold',
        'image': 'assets/cough_cold.png', // Replace with actual image path
      },
      {
        'name': 'Digestive Health',
        'image': 'assets/digestive_health.png', // Replace with actual image path
      },
      {
        'name': 'Skin Care',
        'image': 'assets/skin_care.png', // Replace with actual image path
      },
      {
        'name': 'Allergy Relief',
        'image': 'assets/allergy_relief.png', // Replace with actual image path
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacy'),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navigate to PharmacyCartScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PharmacyCartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Search medicines...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.orange),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Grid view of categories
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 items per row
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.8, // Adjust the aspect ratio as needed
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        // Navigate to PharmacyCheckoutScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PharmacyCheckoutScreen(
                              categoryName: categories[index]['name']!,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            categories[index]['image']!,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            categories[index]['name']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to PharmacyCheckoutScreen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PharmacyCheckoutScreen(
                                    categoryName: categories[index]['name']!,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors .orange,
                            ),
                            child: const Text('Buy Now'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PharmacyCartScreen extends StatelessWidget {
  const PharmacyCartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text(
          'Cart Screen Coming Soon!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}

class PharmacyCheckoutScreen extends StatelessWidget {
  final String categoryName;

  const PharmacyCheckoutScreen({Key? key, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$categoryName Checkout'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Text(
          'Checkout for $categoryName',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}























// import 'package:flutter/material.dart';
// //ignore: unused_import
// import 'pharmacy_second_cart.dart'; 

// class PharmacyHomeScreen extends StatelessWidget {
//   const PharmacyHomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // Dummy list of medicines for now
//     final List<Map<String, String>> medicines = [
//       {'name': 'Paracetamol', 'description': 'Pain reliever and fever reducer'},
//       {
//         'name': 'Amoxicillin',
//         'description': 'Antibiotic for bacterial infections'
//       },
//       {
//         'name': 'Cough Syrup',
//         'description': 'Relieves coughing and throat irritation'
//       },
//     ];

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Pharmacy'),
//         backgroundColor: Colors.orange, // Match the color palette
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.shopping_cart),
//             onPressed: () {
//               // Navigate to CartScreen
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const CartScreen()),
//               );
//             },
//           )
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // Search bar
//             TextField(
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                 hintText: 'Search medicines...',
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(color: Colors.grey),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: const BorderSide(color: Colors.orange),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),

//             // List of medicines
//             Expanded(
//               child: ListView.builder(
//                 itemCount: medicines.length,
//                 itemBuilder: (context, index) {
//                   return Card(
//                     child: ListTile(
//                       leading:
//                           const Icon(Icons.medication, color: Colors.orange),
//                       title: Text(medicines[index]['name']!),
//                       subtitle: Text(medicines[index]['description']!),
//                       trailing:
//                           const Icon(Icons.arrow_forward, color: Colors.orange),
//                       onTap: () {
//                         // Navigate to MedicineDetailsScreen
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => MedicineDetailsScreen(
//                               medicineName: medicines[index]['name']!,
//                               medicineDescription: medicines[index]
//                                   ['description']!,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class MedicineDetailsScreen extends StatelessWidget {
//   final String medicineName;
//   final String medicineDescription;

//   const MedicineDetailsScreen({
//     Key? key,
//     required this.medicineName,
//     required this.medicineDescription,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(medicineName),
//         backgroundColor: Colors.orange,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               medicineName,
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text(
//               medicineDescription,
//               style: const TextStyle(fontSize: 16, color: Colors.grey),
//             ),
//             const Spacer(),
//             ElevatedButton.icon(
//               onPressed: () {
//                 // Navigate to CartScreen
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const CartScreen(),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.orange,
//                 padding:
//                     const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//               ),
//               icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
//               label: const Text(
//                 'Add to Cart',
//  style: TextStyle(color: Colors.white, fontSize: 16),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CartScreen extends StatelessWidget {
//   const CartScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cart'),
//         backgroundColor: Colors.orange,
//       ),
//       body: const Center(
//         child: Text(
//           'Cart Screen Coming Soon!',
//           style: TextStyle(fontSize: 18, color: Colors.grey),
//         ),
//       ),
//     );
//   }
// }