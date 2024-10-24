import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tasking/config/config.dart';

class TaskNotesModal extends ConsumerStatefulWidget {
  const TaskNotesModal({
    this.value,
    super.key,
  });

  final String? value;

  @override
  ConsumerState<TaskNotesModal> createState() => _TaskNotesModalState();
}

class _TaskNotesModalState extends ConsumerState<TaskNotesModal> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorPrimary = ref.watch(colorThemeProvider);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              autofocus: true,
              controller: controller,
              maxLength: 255,
              maxLines: 4,
              cursorColor: colorPrimary,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                filled: false,
                border: InputBorder.none,
                labelText: 'Notas',
                labelStyle: const TextStyle(color: Colors.grey),
                helperStyle: const TextStyle(color: Colors.grey),
                helper: (controller.text.isNotEmpty)
                    ? _CleanButton(
                        onTap: () {
                          controller.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: (value) {
                Navigator.pop(context, value);
              },
            ),
            const Gap(8),
          ],
        ),
      ),
    );
  }
}

class _CleanButton extends ConsumerWidget {
  const _CleanButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme;

    final colorPrimary = ref.watch(colorThemeProvider);

    return GestureDetector(
      onTap: onTap,
      child: Text(
        'Limpiar',
        style: style.bodySmall?.copyWith(
          color: colorPrimary,
        ),
      ),
    );
  }
}
