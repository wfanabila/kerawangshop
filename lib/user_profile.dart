import 'package:flutter/material.dart';
import 'package:kerawangshop/faq.dart';
import 'setting.dart'; 
import 'my_purchases.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'login.dart';

// for pfp updates
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String pfpPath = 'assets/images/pfp1.jpg';

  final User? currentUser = FirebaseAuth.instance.currentUser;

  // function whenever want to update the pfp
  void updateProfileImage(String newPath) {
    setState(() {
      pfpPath = newPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF7B2FF7);

    return Scaffold(
      backgroundColor: primaryPurple,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // header
            Container(
              width: double.infinity,
              color: primaryPurple,
              child: SafeArea(
                bottom: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(4),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                              onPressed: () {},
                            ),
                          ),
                          Row(
                            // right side header (cart)
                            children: [
                              IconButton(
                                icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 26),
                                onPressed: () {},
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    // Profile avatar
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.6), width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 54,
                        backgroundColor: Colors.white,
                        backgroundImage: AssetImage(pfpPath),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      currentUser?.displayName ?? 'User',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      currentUser?.email ?? 'No Email Provided',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.85),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // main content body
            Container(
              margin: const EdgeInsets.only(top: 360),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),

              // items liked, my purchases
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -35),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildQuickActionButton(
                          Icons.favorite,
                          'Items Liked',
                          primaryPurple,
                          () {},
                        ),
                        const SizedBox(width: 10),
                        _buildQuickActionButton(
                          Icons.hourglass_bottom,
                          'My Purchases',
                          primaryPurple,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const MyPurchasesPage()),
                            );
                          },
                        ),
                        
                        ],
                      ),
                    ),

                    // menu list
                    Transform.translate(
                      offset: const Offset(0, -8),
                      child: Column(
                        children: [
                          _buildMenuListTile(Icons.settings_outlined, 'Setting', primaryPurple, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SettingsPage()),
                            );
                          }),
                          _buildMenuListTile(Icons.quiz_outlined, 'FAQ', primaryPurple, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FAQPage()),
                            );
                          }),
                          _buildMenuListTile(Icons.email_outlined, 'Contact Us', primaryPurple, () {}),
                          const SizedBox(height: 10),
                          // Log Out
                          TextButton.icon(
                            onPressed: () async {
                              try {
                                await FirebaseAuth.instance.signOut();
                                await GoogleSignIn().signOut();
                                Get.snackbar(
                                  "Logged Out",
                                  "Successfully logged out of your account",
                                  backgroundColor: Colors.amber,
                                  colorText: Colors.black,
                                );
                                Get.offAll(() => const Login());   
                              } catch (e) {
                                Get.snackbar(
                                  "Error",
                                  "Failed to log out. Try again.",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            },
                            icon: Icon(Icons.logout, color: Colors.grey[500], size: 20),
                            label: Text(
                              'Log Out',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // items liked, my purchases
  Widget _buildQuickActionButton(IconData icon, String label, Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20), // Keeps the ripple effect matching the container shape
      child: Container(
        width: 115,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 38),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // menu list
  Widget _buildMenuListTile(IconData icon, String title, Color purpleTheme, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12), // space between each list
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: purpleTheme, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}