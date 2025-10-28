enum CategoryType {
  foodnDrink("Food & Drink", "Makanan & Minuman"),
  transport("Transport", "Transportasi"),
  shoppingnEnt("Shopping/Ent.", "Belanja & Hiburan"),
  healt("Health", "Kesehatan"),
  rent("Rent", "Sewa"),
  utilities("Utilities", "Keperluan Harian"),
  income("Income", "Pemasukan");

  const CategoryType(this.name, this.labelName);
  final String name;
  final String labelName;
}