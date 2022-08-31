// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

BottomNavigationBarItem bottomNavItem(IconData icon, String title) {
  return BottomNavigationBarItem(
    icon: Icon(icon),
    label: title,
  );
}
