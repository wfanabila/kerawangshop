import 'package:flutter/material.dart';
import 'package:kerawangshop/user_profile.dart';
import 'package:kerawangshop/sell_screen.dart';
import 'home_content.dart';
import 'item_model.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentTab = 0;

  final List<Widget> screens = const [
    HomeContent(),
    SellScreen(),
    UserProfilePage(),
  ];

  static const Color barColor = Color(0xFF7B2FF7);
  static const Color sellColor = Color(0xFFF2C14E);

  List<ShopItem> uploadedItems = [];

  void addItemToList(ShopItem newItem) {
    setState(() {
      uploadedItems.add(newItem);
      currentTab = 0;
    });
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> screens = [
      HomeContent(),
      SellScreen(),
      UserProfilePage(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentTab,
        children: screens,
      ),
      bottomNavigationBar: SizedBox(
        height: 90,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Rounded purple bar
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 75,
                decoration: const BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _navItem(icon: Icons.home, label: 'Home', index: 0),
                      const SizedBox(width: 60), // spacing alignment buffer around floating center anchor
                      _navItem(icon: Icons.person, label: 'Me', index: 2),
                    ],
                  ),
                ),
              ),
            ),
            // Floating circular "Sell" button
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      currentTab = 1;
                    });
                  },
                  child: Container(
                    width: 75,
                    height: 75,
                    decoration: const BoxDecoration(
                      color: sellColor,
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: currentTab == 1 ? Colors.white : barColor,
                          size: 28,
                        ),
                        Text(
                          'Sell',
                          style: TextStyle(
                            color: currentTab == 1 ? Colors.white : barColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isActive = currentTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          currentTab = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? sellColor : Colors.white,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? sellColor : Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}