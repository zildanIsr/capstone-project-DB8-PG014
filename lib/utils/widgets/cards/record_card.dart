import 'package:finmene/models/entities/report.dart';
import 'package:finmene/utils/extensions/context_extensions.dart';
import 'package:finmene/utils/extensions/num_extensions.dart';
import 'package:flutter/material.dart';

class RecordCard extends StatelessWidget {
  const RecordCard({super.key, required this.record});

  final Report record;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Icon(record.category.icon)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(record.category.labelName),
            Text(
              '${record.trxDate.day}-${record.trxDate.month}-${record.trxDate.year}',
              style: context.textTheme.bodySmall,
            ),
          ],
        ),
        subtitle: Text("Rp. ${record.ammount.rupiah}"),
      ),
    );
  }
}
