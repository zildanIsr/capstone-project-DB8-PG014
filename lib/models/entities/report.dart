import 'package:equatable/equatable.dart';
import 'package:finmene/utils/enums/category_enum.dart';

class Report extends Equatable {
  final DateTime trxDate;
  final num ammount;
  final CategoryType category;
  final String? description;

  const Report({required this.trxDate, required this.ammount, required this.category, required this.description});

  factory Report.empty() {
    return Report(trxDate: DateTime.timestamp(), ammount: 12000, category: CategoryType.foodnDrink, description: null);
  }
  
  @override
  List<Object?> get props => [trxDate, ammount, category, description];
  
}