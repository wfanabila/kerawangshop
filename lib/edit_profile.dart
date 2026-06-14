import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: 'Leehan Kim');
  final TextEditingController _emailController =
      TextEditingController(text: 'leehan04@gmail.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '+60 187906534');

  String pfpPath = 'assets/images/pfp1.jpg';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryPurple = Color(0xFF7B2CBF);
    const Color backgroundTint = Color(0xFFF3EEFD);

    return Scaffold(
      backgroundColor: backgroundTint,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryPurple, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Color(0xFF2D2D2D),
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
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
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [

                  // pfp 
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 58,
                        backgroundImage: AssetImage(pfpPath),
                        backgroundColor: Colors.grey[200],
                      ),
                      Positioned(
                        bottom: 2,
                        right: 2,
                        child: GestureDetector(
                          onTap: () {
                            // TODO: change pfp
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(Icons.add,
                                color: Colors.black87, size: 20),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // name
                  _buildEditField(
                    label: 'Name',
                    controller: _nameController,
                    trailingIcon: Icons.edit_outlined,
                    purpleTheme: primaryPurple,
                  ),

                  const SizedBox(height: 14),

                  // email
                  _buildEditField(
                    label: 'Email',
                    controller: _emailController,
                    trailingIcon: Icons.mail_outline_rounded,
                    purpleTheme: primaryPurple,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 14),

                  // phone number
                  _buildEditField(
                    label: 'Phone',
                    controller: _phoneController,
                    trailingIcon: Icons.phone_outlined,
                    purpleTheme: primaryPurple,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 30),

                  // change pass
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.withOpacity(0.40)),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryPurple.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.lock_outline_rounded,
                            color: primaryPurple, size: 24),
                      ),
                      title: const Text(
                        'Change Password?',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          size: 15, color: primaryPurple),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),


      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(context).padding.bottom + 20,
          top: 12,
        ),
        child: Row(
          children: [

            // discard button
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFFCCCCCC), width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Discard',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // save button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: save
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryPurple,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditField({
    required String label,
    required TextEditingController controller,
    required IconData trailingIcon,
    required Color purpleTheme,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.50)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
            Icon(trailingIcon, color: Colors.grey[400], size: 22),
          ],
        ),
      ),
    );
  }
}