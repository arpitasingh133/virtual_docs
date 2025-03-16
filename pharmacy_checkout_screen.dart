import 'package:flutter/material.dart';

import 'pharmacy_first.dart';

class PharmacyCheckoutScreen extends StatefulWidget {
  const PharmacyCheckoutScreen({Key? key}) : super(key: key);

  @override
  _PharmacyCheckoutScreenState createState() => _PharmacyCheckoutScreenState();
}

class _PharmacyCheckoutScreenState extends State<PharmacyCheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  // ignore: unused_field
  String _deliveryAddress = '';
  String _paymentMethod = 'COD'; // Default payment method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigate back to PharmacyCartScreen
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Delivery address input field
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Delivery Address',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your delivery address.';
                  }
                  return null;
                },
                onSaved: (value) {
                  _deliveryAddress = value ?? '';
                },
              ),
              const SizedBox(height: 20),

              // Payment method selection
              const Text(
                'Payment Method:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Radio(
                    value: 'COD',
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value as String;
                      });
                    },
                  ),
                  const Text('COD'),
                  const SizedBox(width: 20),
                  Radio(
                    value: 'Card',
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value as String;
                      });
                    },
                  ),
                  const Text('Card'),
                  const SizedBox(width: 20),
                  Radio(
                    value: 'UPI',
                    groupValue: _paymentMethod,
                    onChanged: (value) {
                      setState(() {
                        _paymentMethod = value as String;
                      });
                    },
                  ),
                  const Text('UPI'),
                ],
              ),
              const SizedBox(height: 20),

              // Order summary section
              const Text(
                'Order Summary:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'Total Cost: ₹500', // Replace with actual total cost
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Place Order button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();

                    // Show success message or navigate back to PharmacyHomeScreen
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Order placed successfully!')),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PharmacyHomeScreen(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 20),
                ),
                child: const Text(
                  'Place Order',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

















//----------x-----------------------x----------------------x----------------------
// import 'package:flutter/material.dart';

// class CheckoutScreen extends StatefulWidget {
//   const CheckoutScreen({Key? key}) : super(key: key);

//   @override
//   _CheckoutScreenState createState() => _CheckoutScreenState();
// }

// class _CheckoutScreenState extends State<CheckoutScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String name = '';
//   String address = '';
//   String phone = '';
//   String selectedPaymentMethod = 'Cash on Delivery'; // Default payment method

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Checkout'),
//         backgroundColor: Colors.orange,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Delivery Details',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),

//               // Name Field
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Full Name',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.person),
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your name.';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   name = value ?? '';
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Address Field
//               TextFormField(
//                 decoration: const InputDecoration(
//                   labelText: 'Delivery Address',
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.location_on),
//                 ),
//                 maxLines: 3,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your address.';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   address = value ?? '';
//                 },
//               ),
//               const SizedBox(height: 16),

//               // Phone Field
//               TextFormField(
//                 decoration: InputDecoration(
//                   labelText: 'Phone Number',
//                   border: OutlineInputBorder(),
//                   prefixIcon: const Icon(Icons.phone),
//                 ),
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your phone number.';
//                   } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
//                     return 'Please enter a valid phone number.';
//                   }
//                   return null;
//                 },
//                 onSaved: (value) {
//                   phone = value ?? '';
//                 },
//               ),
//               const SizedBox(height: 24),

//               const Text(
//                 'Payment Method',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),

//               // Payment Method Dropdown
//               DropdownButtonFormField<String>(
//                 value: selectedPaymentMethod,
//                 decoration: const InputDecoration(
//                   border: OutlineInputBorder(),
//                   prefixIcon: Icon(Icons.payment),
//                 ),
//                 items: ['Cash on Delivery', 'UPI', 'Credit/Debit Card'].map((method) {
//                   return DropdownMenuItem<String>(
//                     value: method,
//                     child: Text(method),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedPaymentMethod = value!;
//                   });
//                 },
//               ),
//               const SizedBox(height: 24),

//               const Text(
//                 'Order Summary',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),

//               // Order Summary Section
//               const Card(
//                 elevation: 3,
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                        Text(
//                         'Items: 3', // Update this with the actual number of items from the Cart Screen
//                         style: TextStyle(fontSize: 16),
//                       ),
//                        SizedBox(height: 8),
//                        Text(
//                         'Total Price: ₹450', // Update this with the actual price from the Cart Screen
//                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // Place Order Button
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState?.validate() ?? false) {
//                       _formKey.currentState?.save();

//                       // TODO: Implement backend API call to place the order
//                       // Pass the collected data (name, address, phone, selectedPaymentMethod, and cart details) to the server

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(content: Text('Order placed successfully!')),
//                       );

//                       // TODO: Navigate to an Order Confirmation screen (optional)
//                       Navigator.pop(context); // Return to previous screen for now
//                     }
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   child: const Text(
//                     'Place Order',
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

