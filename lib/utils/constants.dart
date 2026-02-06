import 'package:flutter/material.dart';

class AppConstants {
  // Avatar sizes
  static const double startAvatarSize = 52.0;
  static const double endAvatarSize = 100.0;
  
  // Card dimensions
  static const double cardHeight = 240.0;
  static const double cardBorderRadius = 24.0;
  
  // Dynamic Island
  static const double islandStartHeight = 56.0;
  static const double islandStartWidth = 220.0;
  static const double islandStartRadius = 28.0;
  static const double islandEndRadius = 42.0;
  
  // Profile
  static const String profileName = "Kyriakos Georgiopoulos";
  static const String balance = "\$24,500.00";
  static const String balanceChange = "2.4%";
  
  // Contacts
  static const List<String> contactNames = ["Farid", "Shadi", "Cyrus"];
  static const List<Color> contactColors = [
    Color(0xFFFF8A65),
    Color(0xFF29B6F6),
    Color(0xFFB9F6CA),
  ];
  
  // Transaction list names
  static const List<String> transactionNames = [
    "Annette Black",
    "Cameron Williamson",
    "Jane Cooper",
    "Wade Warren",
    "Devon Lane",
    "Molly Sanders",
  ];
  
  static const List<String> transactionInitials = ["A", "C", "J", "W", "D", "M"];
}
