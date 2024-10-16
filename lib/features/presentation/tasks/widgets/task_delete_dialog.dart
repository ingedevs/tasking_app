import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tasking/config/config.dart';
import 'package:tasking/features/presentation/shared/shared.dart';
import 'package:tasking/i18n/i18n.dart';

class TaskDeleteDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text(
        S.dialogs.deleteTask.title,
        style: style.titleLarge?.copyWith(fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
      content: Text(
        S.dialogs.deleteTask.subtitle,
        style: style.bodyLarge?.copyWith(fontWeight: FontWeight.w300),
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: CustomFilledButton(
                height: 50,
                onPressed: () => Navigator.pop(context, false),
                backgroundColor: AppColors.card,
                foregroundColor: Colors.white,
                child: Text(S.common.buttons.cancel),
              ),
            ),
            const Gap(defaultPadding),
            Expanded(
              child: CustomFilledButton(
                height: 50,
                onPressed: () => Navigator.pop(context, true),
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                child: Text(S.common.buttons.delete),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
