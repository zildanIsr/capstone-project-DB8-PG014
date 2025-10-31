import 'package:flutter/material.dart';

enum CategoryType {
  foodnDrink("Food & Drink", "Makanan & Minuman", Icons.fastfood_rounded),
  transport("Transport", "Transportasi", Icons.emoji_transportation_rounded),
  shoppingnEnt("Shopping/Ent.", "Belanja & Hiburan", Icons.shopping_bag_rounded),
  healt("Health", "Kesehatan", Icons.health_and_safety_rounded),
  rent("Rent", "Sewa", Icons.house_rounded),
  utilities("Utilities", "Keperluan Harian", Icons.devices_other_rounded),
  income("Income", "Pemasukan", Icons.money);

  const CategoryType(this.name, this.labelName, this.icon);
  final String name;
  final String labelName;
  final IconData icon;
}