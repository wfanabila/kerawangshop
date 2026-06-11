import 'package:flutter/material.dart';

// for pfp updates
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String pfpPath = 'assets/images/pfp1.jpg';

  // function whenever want to update the pfp
  void updateProfileImage(String newPath) {
    setState(() {
      pfpPath = newPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF7B2CBF);

    return Scaffold(
      backgroundColor: primaryPurple,
      body: SingleChildScrollView(
        child: Stack(
          children: [

            // header
            Container(
              height: 300,
              width: double.infinity,
              color: primaryPurple,
              child: SafeArea(
                bottom: false,
                child: Column(
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
                    const SizedBox(height: 8),

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
                    const Text(
                      'Leehan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'leehan04@gmail.com',
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

              // items liked, my purchases, rate
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    Transform.translate(
                      offset: const Offset(0, -35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildQuickActionButton(Icons.favorite, 'Items Liked', primaryPurple),
                          _buildQuickActionButton(Icons.hourglass_bottom, 'My Purchases', primaryPurple),
                          _buildQuickActionButton(Icons.reviews, 'Rate', primaryPurple),
                        ],
                      ),
                    ),

                    // menu list
                    Transform.translate(
                      offset: const Offset(0, -8),
                      child: Column(
                        children: [
                          _buildMenuListTile(Icons.settings_outlined, 'Setting', primaryPurple),
                          _buildMenuListTile(Icons.support_agent_outlined, 'Help Center', primaryPurple),
                          _buildMenuListTile(Icons.quiz_outlined, 'FAQ', primaryPurple),
                          _buildMenuListTile(Icons.email_outlined, 'Contact Us', primaryPurple),
                          const SizedBox(height: 10),
                          // Log Out
                          TextButton.icon(
                            onPressed: () {},
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

      // nav bar
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: primaryPurple,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBottomNavItem(Icons.home_outlined, 'Home', false),
                _buildBottomNavItem(Icons.chat_bubble_outline, 'Chat', false),
                
                // adjustt sell button float
                Transform.translate(
                  offset: const Offset(0, -15),
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFD166),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
                      ],
                    ),
                    
                    // sell button
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.attach_money_rounded, color: primaryPurple, size: 30),
                        Text(
                          'Sell',
                          style: TextStyle(
                            color: primaryPurple,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildBottomNavItem(Icons.notifications_none_rounded, 'Notifications', false),
                _buildBottomNavItem(Icons.person_rounded, 'Me', true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // items liked, my purchases, rate
  Widget _buildQuickActionButton(IconData icon, String label, Color iconColor) {
    return Container(
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
    );
  }

  // menu list
  Widget _buildMenuListTile(IconData icon, String title, Color purpleTheme) {
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
      ),
    );
  }

  // nav bar
  Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
    return Expanded(
      child: Opacity(
        opacity: isActive ? 1.0 : 0.65,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 30),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}