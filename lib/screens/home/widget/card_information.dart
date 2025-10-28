import 'package:finmene/utils/enums/type_of_record_enum.dart';
import 'package:finmene/utils/extensions/context_extensions.dart';
import 'package:finmene/utils/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CardInformation extends StatelessWidget {
  const CardInformation._({
    super.key,
    required this.bgColor,
    required this.type,
    required this.title,
    required this.total,
    required this.lastTransaction,
  });

  final Color bgColor;
  final TypeOfRecord type;
  final String title, total, lastTransaction;

  factory CardInformation.income({
    Key? key,
    required String total,
    required String lastTransaction,
  }) {
    return CardInformation._(
      key: key,
      bgColor: AppColors.secondary,
      type: TypeOfRecord.income,
      title: "Pendapatan",
      total: total,
      lastTransaction: lastTransaction,
    );
  }

  factory CardInformation.expense({
    Key? key,
    required String total,
    required String lastTransaction,
  }) {
    return CardInformation._(
      key: key,
      bgColor: AppColors.errorSoft,
      type: TypeOfRecord.expense,
      title: "Pengeluaran",
      total: total,
      lastTransaction: lastTransaction,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      color: bgColor,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: context.textTheme.labelLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: type == TypeOfRecord.expense
                        ? AppColors.errorHeavy
                        : AppColors.successHeavy,
                  ),
                ),
                Gap(4),
                type == TypeOfRecord.expense
                    ? Icon(
                        Icons.paid_rounded,
                        size: 20,
                        color: AppColors.errorHeavy,
                      )
                    : Icon(
                        Icons.money,
                        size: 20,
                        color: AppColors.successHeavy,
                      ),
              ],
            ),
            Gap(10),
            Text(
              "Rp. $total",
              style: context.textTheme.headlineMedium!.copyWith(
                color: type == TypeOfRecord.expense ? AppColors.errorHeavy : AppColors.primary,
                fontWeight: FontWeight.w600
              ),
            ),
            Gap(10),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${type == TypeOfRecord.expense ? '-' : "+"} $lastTransaction",
                  style: context.textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: type == TypeOfRecord.expense
                        ? AppColors.errorHeavy
                        : AppColors.successHeavy,
                  ),
                ),
                Icon(Icons.arrow_forward,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
