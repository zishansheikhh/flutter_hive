import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../screens/form_list.dart';
import '../screens/homepage.dart';
import '../screens/rating_screen.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;

  CustomBottomBar({required this.currentIndex});

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return; // Prevent reloading the same page
    Widget destination;
    switch (index) {
      case 0:
        destination = FormScreen();
        break;
      case 1:
        destination = ListScreen();
        break;
      case 2:
        destination = RatingScreen();
        break;
      default:
        destination = FormScreen();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      backgroundColor:
          const Color.fromARGB(255, 240, 240, 240), // Custom background color
      items: [
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            height: 20,
            currentIndex == 0 ? 'assets/home_active.svg' : 'assets/home.svg',
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            height: 20,
            currentIndex == 1 ? 'assets/bookmarked.svg' : 'assets/bookmark.svg',
          ),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: SvgPicture.asset(
            height: 20,
            currentIndex == 2
                ? 'assets/feedback-review.svg'
                : 'assets/feedback-review.svg',
          ),
          label: 'Rate',
        ),
      ],
    );
  }
}
