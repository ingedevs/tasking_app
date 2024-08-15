import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../../config/config.dart';
import '../../../i18n/generated/translations.g.dart';
import '../../app.dart';
import '../providers/list_tasks_update_modal_provider.dart';

class ListTasksUpdateModal extends ConsumerWidget {
  const ListTasksUpdateModal(this.list, {super.key});

  final ListTasks list;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme;

    final color = Color(list.color ?? 0xFF000000);

    final provider = ref.watch(listTasksUpdateModalProvider(list));
    final notifier = ref.watch(listTasksUpdateModalProvider(list).notifier);

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              const Gap(defaultPadding * 2),
              Container(
                margin: const EdgeInsets.only(bottom: defaultPadding),
                child: Text(
                  S.common.modals.listTasksUpdate.title,
                  style: style.bodyLarge,
                ),
              ),
              TextFormField(
                style: style.bodyLarge,
                initialValue: provider.title,
                inputFormatters: [LengthLimitingTextInputFormatter(50)],
                maxLines: null,
                cursorColor: color,
                decoration: InputDecoration(
                  hintText: S.common.modals.listTasksUpdate.placeholder,
                  filled: false,
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white12),
                    borderRadius: BorderRadius.circular(defaultRadius),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: color),
                    borderRadius: BorderRadius.circular(defaultRadius),
                  ),
                ),
                onChanged: notifier.onNameChanged,
              ),
              const Gap(defaultPadding),
              ExpansionTile(
                controller: notifier.expansionTileController,
                leading: ColorIndicator(
                  width: 18,
                  height: 18,
                  color: provider.color,
                ),
                iconColor: Colors.white70,
                collapsedIconColor: Colors.white70,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white12),
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
                collapsedShape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.white12),
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
                title: Text('Color', style: style.bodyLarge),
                childrenPadding: EdgeInsets.zero,
                children: [
                  ColorPicker(
                    padding: const EdgeInsets.only(
                      left: defaultPadding,
                      right: defaultPadding,
                      bottom: defaultPadding,
                    ),
                    color: provider.color,
                    enableShadesSelection: false,
                    borderRadius: 20,
                    width: 36,
                    height: 36,
                    pickersEnabled: const <ColorPickerType, bool>{
                      ColorPickerType.wheel: false,
                      ColorPickerType.accent: false,
                      ColorPickerType.bw: false,
                      ColorPickerType.custom: false,
                      ColorPickerType.primary: true,
                    },
                    onColorChanged: notifier.onColorChanged,
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: CustomFilledButton(
                      onPressed: () => Navigator.pop(context),
                      backgroundColor: AppColors.card,
                      foregroundColor: Colors.white,
                      child: Text(S.common.buttons.cancel),
                    ),
                  ),
                  const Gap(defaultPadding),
                  Expanded(
                    child: CustomFilledButton(
                      onPressed: () => notifier.onSubmit(context),
                      backgroundColor: color,
                      child: Text(S.common.buttons.update),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
