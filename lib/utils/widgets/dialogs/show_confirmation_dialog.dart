import 'package:finmene/utils/enums/button_size_type_enum.dart';
import 'package:finmene/utils/res/string_res.dart';
import 'package:finmene/utils/widgets/buttons/button_outlined.dart';
import 'package:finmene/utils/widgets/buttons/button_primary.dart';
import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog(
    {required BuildContext context,
    String? title,
    Widget? icon,
    required String subtitle}) async {
  var myTitle = title ?? "Konfirmasi";
  var result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            icon: icon, 
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(myTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ButtonOutlined(
                        sizeType: ButtonSizeType.SMALL,
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        title: StringRes.noTitle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ButtonPrimary(
                        sizeType: ButtonSizeType.SMALL,
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        title: StringRes.yesTitle,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ));
  return result ?? false;
}
