import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'theme_provider.dart';

// ---- Cloudinary config: replace with your own values ----
const String kCloudinaryCloudName = 'wxgjqxlr';
const String kCloudinaryUploadPreset = 'wxgjqxlr';

class SellScreen extends ConsumerStatefulWidget {
  final Map<String, dynamic>? productToEdit;

  const SellScreen({super.key, this.productToEdit});

  @override
  ConsumerState<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends ConsumerState<SellScreen> {
  String? selectedCategory = "Food & Drinks";
  String? selectedCondition = "New";

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isSaving = false;

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

  bool get isEditMode => widget.productToEdit != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      final p = widget.productToEdit!;
      nameController.text = p['name'] ?? '';

      String rawPrice = p['price'] ?? '';
      priceController.text = rawPrice.replaceAll('RM ', '').trim();

      descriptionController.text = p['description'] ?? '';

      if (categories.contains(p['category'])) {
        selectedCategory = p['category'];
      }
      if (conditions.contains(p['condition'])) {
        selectedCondition = p['condition'];
      }
    }
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1080,
      imageQuality: 80,
    );
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
    final isDarkMode = ref.watch(themeProvider);
    final Color backgroundTint = isDarkMode ? const Color(0xFF120A2A) : const Color(0xFFF3EEFA);
    final Color cardBackground = isDarkMode ? const Color(0xFF221A4A) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color deepPurpleTheme = isDarkMode ? const Color(0xFF7B2FF7) : Colors.deepPurple;
    final Color fieldColor = isDarkMode ? const Color(0xFF1E163A) : Colors.white;

    final String? existingImageUrl =
        isEditMode ? widget.productToEdit!['image'] as String? : null;

    return Scaffold(
      backgroundColor: backgroundTint,
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
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                      );
                    },
                    icon: Icon(Icons.arrow_back, color: textColor),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isEditMode ? "Edit Item" : "Add Item",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textColor),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- IMAGE PICKER ---
              Text("Product Photo", style: TextStyle(color: deepPurpleTheme, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImageFromGallery,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: fieldColor,
                    border: Border.all(color: deepPurpleTheme, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: _buildImagePreview(existingImageUrl, deepPurpleTheme),
                ),
              ),
              const SizedBox(height: 20),

              // Item Name Field
              Text("Item Name", style: TextStyle(color: deepPurpleTheme, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextField(
                controller: nameController,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: fieldColor,
                  hintText: "Popia Carbonara",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 15),

              // Category Field
              Text("Category", style: TextStyle(color: deepPurpleTheme, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: fieldColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade400),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    dropdownColor: cardBackground,
                    style: TextStyle(color: textColor),
                    isExpanded: true,
                    items: categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c, style: TextStyle(color: textColor))))
                        .toList(),
                    onChanged: (value) => setState(() => selectedCategory = value),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Condition Field
              Text("Condition", style: TextStyle(color: deepPurpleTheme, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: fieldColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade400),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedCondition,
                    dropdownColor: cardBackground,
                    style: TextStyle(color: textColor),
                    isExpanded: true,
                    items: conditions
                        .map((c) => DropdownMenuItem(value: c, child: Text(c, style: TextStyle(color: textColor))))
                        .toList(),
                    onChanged: (value) => setState(() => selectedCondition = value),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Price Field
              Text("Item Price (RM)", style: TextStyle(color: deepPurpleTheme, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: fieldColor,
                  hintText: "5.00",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 15),

              // Description Field
              Text("Description", style: TextStyle(color: deepPurpleTheme, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              TextField(
                controller: descriptionController,
                maxLines: 4,
                style: TextStyle(color: textColor),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: fieldColor,
                  hintText: "Popia carbonara homemade...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 25),

              // Save / Publish Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: deepPurpleTheme,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(isEditMode ? "Save Changes" : "Publish Listing"),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview(String? existingImageUrl, Color deepPurpleTheme) {
    if (_pickedImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(_pickedImage!, fit: BoxFit.cover),
      );
    }
    if (existingImageUrl != null && existingImageUrl.startsWith('http')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(existingImageUrl, fit: BoxFit.cover),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo, color: deepPurpleTheme, size: 30),
        const SizedBox(height: 4),
        Text("Add Photo", style: TextStyle(fontSize: 12, color: deepPurpleTheme)),
      ],
    );
  }

  Future<void> _handleSubmit() async {
    if (nameController.text.isEmpty || priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Item Name and Price are required!")),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      if (isEditMode) {
        await updateProductInFirestore(
          docId: widget.productToEdit!['id'],
          name: nameController.text.trim(),
          category: selectedCategory ?? "Others",
          condition: selectedCondition ?? "New",
          price: priceController.text.trim(),
          description: descriptionController.text.trim(),
          imageFile: _pickedImage,
        );
      } else {
        await addProductToFirestore(
          name: nameController.text.trim(),
          category: selectedCategory ?? "Others",
          condition: selectedCondition ?? "New",
          price: priceController.text.trim(),
          description: descriptionController.text.trim(),
          imageFile: _pickedImage,
        );
      }

      nameController.clear();
      priceController.clear();
      descriptionController.clear();
      setState(() {
        _pickedImage = null;
        _isSaving = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isEditMode ? "Listing updated!" : "Listing published successfully!")),
      );

      if (isEditMode) {
        Navigator.pop(context);
      }
    } catch (e) {
    setState(() => _isSaving = false);
    if (!mounted) return;
    debugPrint('FULL ERROR: $e');  // <-- add this
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error saving product: $e")),
    );
  }
}

  // Uploads to Cloudinary and returns the hosted image URL
  Future<String> _uploadImage(File imageFile) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/$kCloudinaryCloudName/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = kCloudinaryUploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Image upload failed: $resBody');
    } 

    final data = jsonDecode(resBody);
    return data['secure_url'] as String;
  }

  Future<void> addProductToFirestore({
    required String name,
    required String category,
    required String condition,
    required String price,
    required String description,
    File? imageFile,
  }) async {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    String imageUrl = 'assets/images/shoes.png';
    if (imageFile != null) {
      imageUrl = await _uploadImage(imageFile);
    }

    await FirebaseFirestore.instance.collection('products').add({
      'name': name,
      'category': category,
      'condition': condition,
      'price': 'RM $price',
      'description': description,
      'image': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'sellerId': currentUserId,
    });
  }

  Future<void> updateProductInFirestore({
    required String docId,
    required String name,
    required String category,
    required String condition,
    required String price,
    required String description,
    File? imageFile,
  }) async {
    final Map<String, dynamic> updateData = {
      'name': name,
      'category': category,
      'condition': condition,
      'price': 'RM $price',
      'description': description,
    };

    if (imageFile != null) {
      updateData['image'] = await _uploadImage(imageFile);
    }

    await FirebaseFirestore.instance.collection('products').doc(docId).update(updateData);
  }
}