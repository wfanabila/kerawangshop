import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme_provider.dart';
import 'profile_provider.dart';

class ContactUsPage extends ConsumerStatefulWidget {
  const ContactUsPage({super.key});

  @override
  ConsumerState<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends ConsumerState<ContactUsPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final profile = ref.watch(profileProvider);
    final Color primaryPurple =
        isDarkMode ? const Color(0xFF7B2FF7) : const Color(0xFF7B2CBF);
    final Color backgroundTint =
        isDarkMode ? const Color(0xFF120A2A) : const Color(0xFFF3EEFD);
    final Color cardBackground =
        isDarkMode ? const Color(0xFF221A4A) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : const Color(0xFF2D2D2D);
    final Color subTextColor =
        isDarkMode ? Colors.white70 : const Color(0xFF555555);
    final Color fieldColor =
        isDarkMode ? const Color(0xFF1E163A) : const Color(0xFFF3EEFD);
    final Color fieldBorder =
        isDarkMode ? primaryPurple.withOpacity(0.5) : Colors.transparent;
    final Color whatsappGreen = const Color(0xFF25D366);

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
          'Contact Us',
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: isDarkMode
                      ? Border.all(color: primaryPurple.withOpacity(0.25))
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "We're here to help.",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: textColor,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Have a question about listing or order? Send us a message and our student support team will get back to you within 24 hours.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: subTextColor,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildContactMethod(
                            icon: Icons.email_rounded,
                            iconColor: primaryPurple,
                            iconBg: isDarkMode
                                ? primaryPurple.withOpacity(0.15)
                                : const Color(0xFFEDEAF7),
                            label: 'Email Support',
                            subLabel: '(Response in 24h)',
                            labelColor: primaryPurple,
                            isDarkMode: isDarkMode,
                            subTextColor: subTextColor,
                            onTap: () => _showComingSoon(context, 'Email Support'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildContactMethod(
                            icon: Icons.chat_bubble_rounded,
                            iconColor: whatsappGreen,
                            iconBg: isDarkMode
                                ? whatsappGreen.withOpacity(0.15)
                                : const Color(0xFFE3F9EA),
                            label: 'WhatsApp',
                            subLabel: '(Live Chat)',
                            labelColor: whatsappGreen,
                            isDarkMode: isDarkMode,
                            subTextColor: subTextColor,
                            onTap: () => _showComingSoon(context, 'WhatsApp'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardBackground,
                  borderRadius: BorderRadius.circular(20),
                  border: isDarkMode
                      ? Border.all(color: primaryPurple.withOpacity(0.25))
                      : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fill Your Details:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildInputField(
                      label: 'Name',
                      value: profile.name,
                      icon: Icons.person_outline_rounded,
                      fieldColor: fieldColor,
                      fieldBorder: fieldBorder,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 14),
                    _buildInputField(
                      label: 'Email',
                      value: profile.email,
                      icon: Icons.mail_outline_rounded,
                      fieldColor: fieldColor,
                      fieldBorder: fieldBorder,
                      textColor: textColor,
                      subTextColor: subTextColor,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Your Message',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: fieldColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: fieldBorder),
                      ),
                      child: TextField(
                        controller: _messageController,
                        maxLines: 4,
                        style: TextStyle(fontSize: 14, color: textColor),
                        decoration: InputDecoration(
                          hintText: 'How can we help you today?',
                          hintStyle: TextStyle(
                            color: isDarkMode ? Colors.white38 : Colors.grey[500],
                            fontSize: 14,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    _showComingSoon(context, 'Send Message');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF9C846),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Text(
                    'Send Message',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
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

  void _showComingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon')),
    );
  }

  Widget _buildContactMethod({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String subLabel,
    required Color labelColor,
    required bool isDarkMode,
    required Color subTextColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.transparent : const Color(0xFFF7F5FC),
          borderRadius: BorderRadius.circular(16),
          border: isDarkMode
              ? Border.all(color: Colors.white.withOpacity(0.12))
              : null,
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: iconBg,
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: labelColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subLabel,
              style: TextStyle(
                fontSize: 12,
                color: subTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String value,
    required IconData icon,
    required Color fieldColor,
    required Color fieldBorder,
    required Color textColor,
    required Color subTextColor,
    required bool isDarkMode,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: fieldColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: fieldBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : '-',
                  style: TextStyle(fontSize: 14, color: subTextColor),
                ),
              ],
            ),
          ),
          Icon(
            icon,
            size: 20,
            color: isDarkMode ? Colors.white54 : Colors.grey[500],
          ),
        ],
      ),
    );
  }
}