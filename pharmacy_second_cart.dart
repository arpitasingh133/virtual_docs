import 'package:flutter/material.dart';

class PharmacyCartScreen extends StatefulWidget {
  const PharmacyCartScreen({Key? key}) : super(key: key);

  @override
  _PharmacyCartScreenState createState() => _PharmacyCartScreenState();
}

class _PharmacyCartScreenState extends State<PharmacyCartScreen> {
  // Dummy data for the cart
  List<Map<String, dynamic>> cartItems = [
    {
      'name': 'Paracetamol',
      'image': 'assets/pain_relief.png', // Replace with actual image path
      'price': 50.0,
      'quantity': 1,
    },
    {
      'name': 'Amoxicillin',
      'image': 'assets/vitamins.png', // Replace with actual image path
      'price': 120.0,
      'quantity': 2,
    },
    {
      'name': 'Cough Syrup',
      'image': 'assets/cough_cold.png', // Replace with actual image path
      'price': 80.0,
      'quantity': 1,
    },
  ];

  // Calculate total price
  double get totalPrice {
    return cartItems.fold(
        0, (sum, item) => sum + (item['price'] * item['quantity']));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to PharmacyHomeScreen
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          // List of cart items
          Expanded(
            child: cartItems.isEmpty
                ? const Center(
                    child: Text(
                      'Your cart is empty.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          leading: Image.asset(
                            item['image'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(item['name']),
                          subtitle: Text('Price: ₹${item['price']}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle,
                                    color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    if (item['quantity'] > 1) {
                                      item['quantity']--;
                                    } else {
                                      cartItems.removeAt(index);
                                    }
                                  });
                                },
                              ),
                              Text('${item['quantity']}'),
                              IconButton(
                                icon: const Icon(Icons.add_circle,
                                    color: Colors.green),
                                onPressed: () {
                                  setState(() {
                                    item['quantity']++;
                                  });
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    cartItems.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),

          // Total price and checkout button
          if (cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Navigate to PharmacyCheckoutScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PharmacyCheckoutScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                    ),
                    icon: const Icon(Icons.payment, color: Colors.white),
                    label: const Text(
                      'Checkout',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class PharmacyCheckoutScreen extends StatelessWidget {
  const PharmacyCheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.orange,
      ),
      body: const Center(
        child: Text(
          'Checkout Screen Coming Soon!',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}

























// import 'package:flutter/material.dart';
// // import 'pharmacy_checkout_screen.dart';

// class CartScreen extends StatefulWidget {
//   const CartScreen({Key? key}) : super(key: key);

//   @override
//   _CartScreenState createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   // Dummy data for the cart
//   List<Map<String, dynamic>> cartItems = [
//     {'name': 'Paracetamol', 'price': 50, 'quantity': 1},
//     {'name': 'Amoxicillin', 'price': 120, 'quantity': 2},
//     {'name': 'Cough Syrup', 'price': 80, 'quantity': 1},
//   ];

//   // Calculate total price
//   double get totalPrice {
//     return cartItems.fold(0, (sum, item) => sum + (item['price'] * item['quantity']));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Cart'),
//         backgroundColor: Colors.orange,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             // List of cart items
//             Expanded(
//               child: cartItems.isEmpty
//                   ? const Center(
//                       child: Text(
//                         'Your cart is empty.',
//                         style: TextStyle(fontSize: 16, color: Colors.grey),
//                       ),
//                     )
//                   : ListView.builder(
//                       itemCount: cartItems.length,
//                       itemBuilder: (context, index) {
//                         final item = cartItems[index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: ListTile(
//                             leading: const Icon(Icons.medication, color: Colors.orange),
//                             title: Text(item['name']),
//                             subtitle: Text('Price: ₹${item['price']}'),
//                             trailing: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 IconButton(
//                                   icon: const Icon(Icons.remove_circle, color: Colors.red),
//                                   onPressed: () {
//                                     setState(() {
//                                       if (item['quantity'] > 1) {
//                                         item['quantity']--;
//                                       } else {
//                                         cartItems.removeAt(index);
//                                       }
//                                     });
//                                   },
//                                 ),
//                                 Text('${item['quantity']}'),
//                                 IconButton(
//                                   icon: const Icon(Icons.add_circle, color: Colors.green),
//                                   onPressed: () {
//                                     setState(() {
//                                       item['quantity']++;
//                                     });
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//             ),

//             // Total price and checkout button
//             if (cartItems.isNotEmpty)
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Total:',
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       Text(
//                         '₹${totalPrice.toStringAsFixed(2)}',
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       // Navigate to Checkout Screen
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const CheckoutScreen()),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.orange,
//                       padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
//                     ),
//                     icon: const Icon(Icons.payment, color: Colors.white),
//                     label: const Text(
//                       'Proceed to Checkout',
//                       style: TextStyle(color: Colors.white, fontSize: 16),
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CheckoutScreen extends StatelessWidget {
//   const CheckoutScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         backgroundColor: Colors.orange,
//       ),
//       body: const Center(
//         child: Text(
//           'Checkout Screen Coming Soon!',
//           style: TextStyle(fontSize: 18, color: Colors.grey),
//         ),
//       ),
//     );
//   }
// }
