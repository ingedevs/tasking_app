import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:tasking/config/config.dart';
import 'package:tasking/features/presentation/intro/intro.dart';
import 'package:tasking/features/presentation/shared/shared.dart';
import 'package:tasking/i18n/i18n.dart';

class IntroPage extends ConsumerWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme;

    final colorPrimary = ref.watch(colorThemeProvider);

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    IconsaxBold.crown_1,
                    color: colorPrimary,
                    size: 32,
                  ),
                  const Gap(defaultPadding / 2),
                  Text(
                    S.common.labels.appName,
                    style: style.displaySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(defaultPadding / 2),
                  Text(
                    'beta',
                    style: style.bodyLarge?.copyWith(color: colorPrimary),
                  ),
                ],
              ),
              const Gap(defaultPadding),
              Text(
                S.pages.intro.title,
                style: style.titleLarge?.copyWith(color: Colors.white),
              ),
              const Gap(defaultPadding),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const _Leading(icon: IconsaxBold.timer),
                textColor: Colors.white,
                titleTextStyle: style.bodyLarge,
                title: Text(S.pages.intro.feature1),
              ),
              const Gap(4),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const _Leading(icon: IconsaxBold.mobile),
                textColor: Colors.white,
                title: Text(S.pages.intro.feature2),
              ),
              const Gap(4),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const _Leading(icon: IconsaxBold.key),
                textColor: Colors.white,
                title: Text(S.pages.intro.feature3),
              ),
              const Gap(4),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const _Leading(icon: IconsaxBold.notification),
                textColor: Colors.white,
                title: Text(S.pages.intro.feature4),
              ),
              const Spacer(),
              Text(S.pages.intro.disclaimer),
              CustomFilledButton(
                height: 60,
                width: double.infinity,
                margin: const EdgeInsets.only(top: defaultPadding),
                onPressed: () => ref.read(introProvider).call(context),
                textStyle: style.titleLarge,
                child: Text(S.pages.intro.button),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Leading extends ConsumerWidget {
  const _Leading({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorPrimary = ref.watch(colorThemeProvider);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorPrimary.withOpacity(.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: colorPrimary),
    );
  }
}
