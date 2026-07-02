import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // <--- ADD THIS LINE
import 'dart:io';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'seller_listing.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  String? selectedCategory = "Food & Drinks";
  String? selectedCondition = "New";

  // State variable to store the picked single image
  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();

  // Text editing controllers to hold the user inputs
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final List<String> categories = [
    "Stationary",
    "Fashion",
    "Food & Drinks",
    "Electronics",
    "Beauty & Health",
    "Others",
  ];

  final List<String> conditions = ["New", "Used"];

  // Helper method to open the device gallery and select an image
  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = File(image.path);
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EEFA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeScreen(),
                        ), // Replace with your home class name
                        (route) =>
                            false, // This clears the navigation history so they can't "pop" back into the edit screen
                      );
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Add Item",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- SINGLE IMAGE PICKER ROW ---
              const Text(
                "Product Photo",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImageFromGallery,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.deepPurple, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      _pickedImage != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(_pickedImage!, fit: BoxFit.cover),
                          )
                          : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                color: Colors.deepPurple,
                                size: 30,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Add Photo",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                ),
              ),
              const SizedBox(height: 20),

              // Item Name Field
              const Text(
                "Item Name",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Popia Carbonara",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Category Field
              const Text(
                "Category",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    isExpanded: true,
                    items:
                        categories
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                    onChanged:
                        (value) => setState(() => selectedCategory = value),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Condition Field
              const Text(
                "Condition",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCondition,
                    isExpanded: true,
                    items:
                        conditions
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                    onChanged:
                        (value) => setState(() => selectedCondition = value),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Price Field
              const Text(
                "Item Price (RM)",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "5.00",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Description Field
              const Text(
                "Description",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Popia carbonara homemade...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Save Changes Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        priceController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Item Name and Price are required!"),
                        ),
                      );
                      return;
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Uploading listing...")),
                    );

                    try {
                      // Pass inputs along with image data (if selected)
                      await addProductToFirestore(
                        name: nameController.text.trim(),
                        category: selectedCategory ?? "Others",
                        condition: selectedCondition ?? "New",
                        price: priceController.text.trim(),
                        description: descriptionController.text.trim(),
                        imageFile: _pickedImage,
                      );

                      // Clear fields and selected image upon success
                      nameController.clear();
                      priceController.clear();
                      descriptionController.clear();
                      setState(() {
                        _pickedImage = null;
                      });

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Listing published successfully!"),
                        ),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SellerListingPage(),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error listing product: $e")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text("Publish Listing"),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Local helper method to handle writing data directly to Firestore
  Future<void> addProductToFirestore({
    required String name,
    required String category,
    required String condition,
    required String price,
    required String description,
    File? imageFile,
  }) async {
    // Grab the current user's ID safely
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'category': category,
      'condition': condition,
      'price': 'RM $price',
      'description': description,
      'image': 'assets/images/google.png',
      'createdAt': FieldValue.serverTimestamp(),
      'sellerId':
          currentUserId, // <--- Saves who uploaded it, but doesn't restrict home screen visibility!
    });
  }
}
