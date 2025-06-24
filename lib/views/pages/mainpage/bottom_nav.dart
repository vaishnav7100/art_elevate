import 'package:art_elevate/views/utils/constant.dart';
import 'package:art_elevate/views/pages/mainpage/homepage.dart';
import 'package:art_elevate/chats/chatpage.dart';
import 'package:art_elevate/views/pages/settings/become_seller.dart';
import 'package:art_elevate/views/pages/settings/my_orderpage.dart';
import 'package:art_elevate/views/pages/settings/myaccount/myaccount.dart';
import 'package:art_elevate/views/pages/settings/settings.dart';
import 'package:art_elevate/views/pages/settings/wishlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  const BottomNavBar({super.key, this.currentIndex = 0});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int currentIndex;
  List screens = [
    const HomePage(),
    const ChatPage(),
    const BecomeSellerPage(),
    const MyOrders(),
    const MySettings(),
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton(
        splashColor: Colors.grey.shade200,
        tooltip: 'Sell your artwork',
        onPressed: () {
          setState(() {
            currentIndex = 2;
          });
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: const BorderSide(color: Colors.black, width: 0.2)),
        backgroundColor: Colors.white,
        child: Icon(
          currentIndex == 2 ? Icons.upload : Icons.add,
          color: currentIndex == 2 ? Colors.black : Colors.grey,
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black38,
              blurRadius: 12,
            ),
          ],
        ),
        child: BottomAppBar(
          elevation: 20,
          height: 60,
          color: Colors.grey[50],
          shape: const CircularNotchedRectangle(),
          notchMargin: currentIndex == 2 ? 6 : 0,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 0;
                  });
                },
                icon: Icon(
                  currentIndex == 0 ? Iconsax.home_1 : Iconsax.home_copy,
                  size: 30,
                  color: currentIndex == 0 ? Colors.black : Colors.black26,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 1;
                  });
                },
                icon: Icon(
                  currentIndex == 1 ? Iconsax.message : Iconsax.message_copy,
                  size: 30,
                  color: currentIndex == 1 ? Colors.black : Colors.black26,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 3;
                  });
                },
                icon: Icon(
                  currentIndex == 3
                      ? Iconsax.shopping_cart
                      : Iconsax.shopping_cart_copy,
                  size: 30,
                  color: currentIndex == 3 ? Colors.black : Colors.black26,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    currentIndex = 4;
                  });
                },
                icon: Icon(
                  currentIndex == 4 ? Iconsax.user : Iconsax.user_copy,
                  size: 30,
                  color: currentIndex == 4 ? Colors.black : Colors.black26,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: screens[currentIndex],
    );
  }
}
