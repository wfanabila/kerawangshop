import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'edit_profile.dart';
import 'package:kerawangshop/faq.dart';
import 'change_password.dart';
import 'login.dart';
import 'theme_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final Color primaryPurple = isDarkMode ? const Color(0xFF7B2FF7) : const Color(0xFF7B2CBF);
    final Color backgroundTint = isDarkMode ? const Color(0xFF120A2A) : const Color(0xFFF3EEFD);
    final Color cardBackground = isDarkMode ? const Color(0xFF221A4A) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF2D2D2D);
    final Color labelColor = isDarkMode ? Colors.white : const Color(0xFF3A3A3A);

    return Scaffold(
      backgroundColor: backgroundTint,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryPurple, size: 26),
          onPressed: () {
            Navigator.pop(context);
          },
        
        ),
        title: Text(
          'Setting',
          style: TextStyle(
            color: textColor,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
   
    ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              // 
// account
              _buildSectionHeader('Account', labelColor),
              const SizedBox(height: 10),
              _buildSettingsTile(
                Icons.person_outline_rounded, 
                'Edit Profile', 
                primaryPurple,
                cardBackground,
                textColor,
     
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditProfilePage()),
                  );
},
              ),
              _buildSettingsTile(
                Icons.lock_open_rounded, 
                'Change Password', 
                primaryPurple,
                cardBackground,
                textColor,
                onTap: () {
   
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
                  );
                },
       
        ),
              
              const SizedBox(height: 25),

              // theme
              _buildSectionHeader('Theme', labelColor),
              const SizedBox(height: 10),
              Container(
    
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SwitchListTile(
                
                  secondary: Icon(Icons.dark_mode_outlined, color: primaryPurple, size: 28),
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
       
                      fontSize: 16,
                      color: textColor,
                    ),
                  ),
                  activeColor: Colors.white,
    
                  activeTrackColor: primaryPurple,
                  value: isDarkMode,
                  onChanged: (bool value) {
                    ref.read(themeProvider.notifier).toggleTheme(value);
                  },
                ),
              ),

              const SizedBox(height: 40),

              // help & support
              _buildSectionHeader('Help and Support', labelColor),
              const SizedBox(height: 10),
   
            _buildSettingsTile(Icons.quiz_outlined, 'FAQ', primaryPurple, cardBackground, textColor, onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FAQPage()),
                );
            
  }),
              _buildSettingsTile(Icons.email_outlined, 'Contact Us', primaryPurple, cardBackground, textColor, onTap: () {}),

              const SizedBox(height: 25),

              // logout
              Center(
                child: TextButton.icon(
                
                  onPressed: () => _handleLogOut(context),
                  icon: Icon(Icons.logout, color: Colors.grey[500], size: 22),
                  label: Text(
                    'Log Out',
                    style: TextStyle(
           
                    color: Colors.grey[500],
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
    
            ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()), 
          (Route<dynamic> route) => false,
        );
}
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error logging out: ${e.toString()}')),
        );
}
    }
  }

  Widget _buildSectionHeader(String title, Color labelColor) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: labelColor,
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, Color purpleTheme, Color backgroundColor, Color textColor, {required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        leading: Icon(icon, color: purpleTheme, size: 28),
        title: Text(
 
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: textColor,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: purpleTheme),        
 
        onTap: onTap,
      ),
    );
  }
}