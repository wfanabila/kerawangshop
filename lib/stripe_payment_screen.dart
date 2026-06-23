import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart_provider.dart';

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

    // Simulate Network Latency talking to Stripe APIs
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() => isProcessing = false);

      // Wipe out cart contents globally upon transaction confirmation
      ref.read(cartProvider.notifier).clearCart();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.check_circle, color: Colors.green, size: 60),
          title: const Text("Payment Successful"),
          content: Text("Mock Stripe processed RM ${widget.amount.toStringAsFixed(2)} successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                // Bounce back out to main menu
                Navigator.of(context).pop(); // dismiss dialog
                Navigator.of(context).pop(); // exit payment screen
                Navigator.of(context).pop(); // exit cart screen
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
    return Scaffold(
      backgroundColor: const Color(0xFFF3EEFA),
      appBar: AppBar(title: const Text("Stripe Checkout"), backgroundColor: Colors.transparent, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Payable Amount", style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Text("RM ${widget.amount.toStringAsFixed(2)}", 
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            const Text("Card Information (Dummy)", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            // Mock Credit Card Fields
            TextFormField(
              decoration: const InputDecoration(
                filled: true, fillColor: Colors.white,
                hintText: "4242 4242 4242 4242", prefixIcon: Icon(Icons.credit_card),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      filled: true, fillColor: Colors.white,
                      hintText: "MM/YY",
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      filled: true, fillColor: Colors.white,
                      hintText: "CVC",
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
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
                  backgroundColor: Colors.black, // Stripe-style dark layout buttons
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: isProcessing ? null : _simulateStripePayment,
                child: isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Pay RM ${widget.amount.toStringAsFixed(2)}", style: const TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}