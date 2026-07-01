import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_provider.dart';
import 'theme_provider.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});
 @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
 late TextEditingController _confirmPasswordController;
  bool _isLoading = false; // Prevents double taps while communicating with Firebase

  @override
  void initState() {
    super.initState();
 _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
 _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final Color primaryPurple = isDarkMode ? const Color(0xFF7B2FF7) : const Color(0xFF7B2CBF);
    final Color backgroundTint = isDarkMode ? const Color(0xFF120A2A) : const Color(0xFFF3EEFD);
    final Color cardBackground = isDarkMode ? const Color(0xFF221A4A) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: backgroundTint,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryPurple, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
      
          'Change Password',
          style: TextStyle(color: isDarkMode ? Colors.white : const Color(0xFF2D2D2D), fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Container(
   
            width: double.infinity,
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 180,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
     
            color: cardBackground,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
   
            child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildPasswordField(
                    label: 'Current Password',
           
          controller: _currentPasswordController,
                    hintText: '******',
                    textColor: textColor,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 24),
                  _buildPasswordField(
             
        label: 'Set New Password',
                    controller: _newPasswordController,
                    hintText: 'New Password',
                    textColor: textColor,
                    isDarkMode: isDarkMode,
                  ),
                  const SizedBox(height: 14),
         
          _buildPasswordField(
                    label: 'Confirm New Password',
                    controller: _confirmPasswordController,
                    hintText: 'New Password Again',
                    textColor: textColor,
                    isDarkMode: isDarkMode,
                  ),
      
           ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: cardBackground,
        padding: EdgeInsets.only(
          left: 20, right: 20, top: 
 12,
          bottom: MediaQuery.of(context).padding.bottom + 20,
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading ?
 null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: isDarkMode ? Colors.white24 : const Color(0xFFCCCCCC), width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
               
  ),
                child: Text('Discard', style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ElevatedButton(
       
          onPressed: _isLoading ? null : () => _handlePasswordChange(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
        
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isLoading 
                    ?
 const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Save', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
 }

  Future<void> _handlePasswordChange(BuildContext context) async {
    final currentInput = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
 final confirmPassword = _confirmPasswordController.text.trim();

    if (currentInput.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showSnackbar('Please fill in all fields.', Colors.orangeAccent);
 return;
    }

    if (newPassword != confirmPassword) {
      _showSnackbar('New passwords do not match!', Colors.redAccent);
 return;
    }

    if (newPassword.length < 6) {
      _showSnackbar('Password must be at least 6 characters long.', Colors.orangeAccent);
 return;
    }

    setState(() => _isLoading = true);
 try {
      await ref.read(profileProvider.notifier).changePassword(
            currentPassword: currentInput,
            newPassword: newPassword,
          );
 if (context.mounted) {
        _showSnackbar('Password updated successfully!', Colors.green);
        Navigator.pop(context);
 }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred. Please try again.';
      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        errorMessage = 'Incorrect current password! Please check your credentials.';
      } else if (e.code == 'requires-recent-login') {
        errorMessage = 'Security action required. Please log out and back in, then retry.';
      }
      _showSnackbar(errorMessage, Colors.redAccent);
 } catch (e) {
      _showSnackbar('Error: ${e.toString()}', Colors.redAccent);
 } finally {
      if (mounted) setState(() => _isLoading = false);
 }
  }

  void _showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
 }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required Color textColor,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textColor)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            
            border: Border.all(color: const Color(0xFF7B2CBF).withOpacity(0.3)),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: TextField(
              controller: controller,
              obscureText: true,
   
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),
              decoration: InputDecoration(
                isDense: true,
                hintText: hintText,
                hintStyle: TextStyle(color: isDarkMode ? Colors.white60 : Colors.grey[400], fontSize: 15),
             
    contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
 }
}