import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart_provider.dart';
import 'purchases_provider.dart';
import 'theme_provider.dart';

class StripePaymentScreen extends ConsumerStatefulWidget {
  final double amount;
  const StripePaymentScreen({super.key, required this.amount});

  @override
  ConsumerState<StripePaymentScreen> createState() => _StripePaymentScreenState();
}

class _StripePaymentScreenState extends ConsumerState<StripePaymentScreen> {
  bool isProcessing = false;

  void _simulateStripePayment() {
    setState(() => isProcessing = true);
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => isProcessing = false);

      // 2. GRAB ACTIVE CART ITEMS BEFORE CLEARING
      // Note: adjust '.cartItems' depending on your exact Cart State structure
      final activeCartItems = ref.read(cartProvider); 

      // 3. SAVE TO PURCHASES HISTORY LIST
      ref.read(purchasesProvider.notifier).addPurchasedItems(activeCartItems);

      // Wipe out cart contents globally upon transaction confirmation
      ref.read(cartProvider.notifier).clearCart();

 
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          backgroundColor: ref.read(themeProvider) ? const Color(0xFF221A4A) : Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          title: Text("Payment Successful", style: TextStyle(color: ref.read(themeProvider) ? Colors.white : Colors.black)),
          content: Text("Mock Stripe processed RM ${widget.amount.toStringAsFixed(2)} successfully!", style: TextStyle(color: ref.read(themeProvider) ? Colors.white70 : Colors.black87)),
          actions: [
          
   TextButton(
              onPressed: () {
                Navigator.of(context).pop();
// dismiss dialog
                Navigator.of(context).pop();
// exit payment screen
                Navigator.of(context).pop();
// exit cart screen
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeProvider);
    final Color backgroundTint = isDarkMode ? const Color(0xFF120A2A) : const Color(0xFFF3EEFA);
    final Color cardBackground = isDarkMode ? const Color(0xFF221A4A) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Colors.black;
    final Color fieldColor = isDarkMode ? const Color(0xFF1E163A) : Colors.white;

    return Scaffold(
<<<<<<< HEAD
      backgroundColor: const Color(0xFFF3EEFA),
      appBar: AppBar(title: Text("Checkout"), backgroundColor: Colors.transparent, elevation: 0),
=======
      backgroundColor: backgroundTint,
      appBar: AppBar(
        title: Text("Stripe Checkout", style: TextStyle(color: textColor)), 
        backgroundColor: Colors.transparent, 
        elevation: 0,
        iconTheme: IconThemeData(color: isDarkMode ? const Color(0xFF7B2FF7) : Colors.deepPurple),
      ),
>>>>>>> f28a5c122a510d5eafb351cc5a47785079775c4a
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
     
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: cardBackground, borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Payable Amount", style: 
                  TextStyle(fontSize: 16, color: Colors.grey)),
                  Text("RM ${widget.amount.toStringAsFixed(2)}", 
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isDarkMode ? const Color(0xFF7B2FF7) : Colors.deepPurple)),
                ],
              ),
            ),
<<<<<<< HEAD
            const SizedBox(height: 30),
            const Text("Card Information", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
=======
      
       const SizedBox(height: 30),
            Text("Card Information (Dummy)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
>>>>>>> f28a5c122a510d5eafb351cc5a47785079775c4a
            const SizedBox(height: 10),
            TextFormField(
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                filled: true, fillColor: fieldColor,
           
              hintText: "4242 4242 4242 4242", 
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.credit_card, color: Colors.grey),
                border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            Row(
    
           children: [
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      filled: true, fillColor: fieldColor,
       
                      hintText: "MM/YY",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
 
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
          
                     filled: true, fillColor: fieldColor,
                      hintText: "CVC",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  
   keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const Spacer(),
            SizedBox(
            
   width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
<<<<<<< HEAD
                  backgroundColor: Color(0xFF7B2FF7), // Stripe-style dark layout buttons
=======
                  backgroundColor: isDarkMode ? const Color(0xFF7B2FF7) : Colors.black, 
>>>>>>> f28a5c122a510d5eafb351cc5a47785079775c4a
                  foregroundColor: Colors.white,
           
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isProcessing ?
null : _simulateStripePayment,
                child: isProcessing
<<<<<<< HEAD
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Pay RM ${widget.amount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18),),
=======
                    ?
const CircularProgressIndicator(color: Colors.white)
                    : Text("Pay RM ${widget.amount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18)),
>>>>>>> f28a5c122a510d5eafb351cc5a47785079775c4a
              ),
            ),
          ],
        ),
      ),
    );
  }
}