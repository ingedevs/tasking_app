import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:icons_plus/icons_plus.dart';

import '../../../config/config.dart';
import '../../../generated/l10n.dart';
import '../providers/intro_provider.dart';
import '../widgets/widgets.dart';

class IntroSetupPage extends ConsumerWidget {
  const IntroSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: IntroSetupPage Implement build method.

    final provider = ref.watch(introProvider);
    final notifier = ref.read(introProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          height: 10,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const Gap(4),
            itemCount: provider.items.length,
            itemBuilder: (_, index) => Container(
              width: defaultPadding,
              decoration: BoxDecoration(
                color: index == provider.currentPage
                    ? Colors.white
                    : Colors.white12,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => notifier.onPreviousPage(context),
          icon: const Icon(BoxIcons.bx_arrow_back),
        ),
        actions: [
          if (provider.items[provider.currentPage].skip)
            TextButton(
              onPressed: notifier.onNextPage,
              child: const Text('skip'),
            ),
        ],
      ),
      body: PageView(
        controller: notifier.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _IntroCloudSync(),
          _IntroTaskLists(),
          _IntroNotifications(),
        ],
      ),
    );
  }
}

class _IntroNotifications extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final provider = ref.watch(introProvider);
    final notifier = ref.read(introProvider.notifier);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Notifications',
                style: style.displaySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.primary,
                )),
            const Gap(defaultPadding),
            Text(
              'Receive notifications for due dates, reminders, and priority levels.',
              style: style.bodyLarge,
            ),
            const Gap(defaultPadding * 2),
            Text(
              'Example',
              style: style.bodyLarge,
            ),
            const Gap(defaultPadding),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(defaultRadius),
              ),
              tileColor: Colors.white.withOpacity(0.06),
              iconColor: colors.primary,
              leading: const Icon(BoxIcons.bx_bell),
              title: const Text('Task Reminder'),
              subtitle: Text('Task: Finish the project',
                  style: style.bodySmall?.copyWith(
                    color: Colors.white70,
                  )),
              trailing: Text('Today, 9:00 AM',
                  style: style.bodySmall?.copyWith(
                    color: Colors.white70,
                  )),
            ),
            const Gap(defaultPadding),
            if (!provider.isNotificationsGranted)
              Text.rich(TextSpan(
                text: 'You have denied the notification permission. ',
                style: style.bodyMedium?.copyWith(color: Colors.redAccent),
                children: [
                  TextSpan(
                    text: 'Please enable it in the settings.',
                    style: const TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.redAccent,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = notifier.onOpenAppSettings,
                  ),
                ],
              )),
            const Spacer(),
            Text(
              'Without this permission the app may not work correctly or as you expect.',
              style: style.bodyLarge,
            ),
            CustomFilledButton(
              margin: const EdgeInsets.only(top: defaultPadding),
              onPressed: notifier.onFinish,
              textStyle: style.bodyLarge,
              child: const Text('Continue'),
            )
          ],
        ),
      ),
    );
  }
}

class _IntroTaskLists extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    final notifier = ref.read(introProvider.notifier);

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 28, right: 28, bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('List of Tasks',
                style: style.displaySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.primary,
                )),
            const Gap(defaultPadding),
            Text(
              'Create, edit, and delete tasks. Set due dates, reminders, and priority levels.',
              style: style.bodyLarge,
            ),
            const Gap(defaultPadding * 2),
            Text(
              'Selected List',
              style: style.bodyLarge,
            ),
            const Gap(defaultPadding),
            Container(
              margin: const EdgeInsets.only(bottom: defaultPadding),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
                tileColor: Colors.white.withOpacity(0.06),
                iconColor: colors.primary,
                leading: const Icon(BoxIcons.bx_list_ul),
                title: Text(S.current.default_group_1),
                trailing: Text('Default',
                    style: style.bodySmall?.copyWith(
                      color: Colors.white70,
                    )),
              ),
            ),
            const Gap(defaultPadding * 2),
            Text(
              'Suggestions List',
              style: style.bodyLarge,
            ),
            const Gap(defaultPadding),
            Container(
              margin: const EdgeInsets.only(bottom: defaultPadding),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
                tileColor: Colors.white.withOpacity(0.06),
                iconColor: colors.primary,
                leading: const Icon(BoxIcons.bx_cart),
                title: Text(S.current.default_group_2),
                trailing: Text('Add',
                    style: style.bodySmall?.copyWith(
                      color: colors.primary,
                    )),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: defaultPadding),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
                tileColor: Colors.white.withOpacity(0.06),
                iconColor: colors.primary,
                leading: const Icon(BoxIcons.bx_briefcase),
                title: Text(S.current.default_group_3),
                trailing: Text('Add',
                    style: style.bodySmall?.copyWith(
                      color: colors.primary,
                    )),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: defaultPadding),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(defaultRadius),
                ),
                tileColor: Colors.white.withOpacity(0.06),
                iconColor: colors.primary,
                leading: const Icon(BoxIcons.bx_star),
                title: const Text('Important'),
                trailing: Text('Add',
                    style: style.bodySmall?.copyWith(
                      color: colors.primary,
                    )),
              ),
            ),
            const Spacer(),
            CustomFilledButton(
              margin: const EdgeInsets.only(top: defaultPadding),
              onPressed: notifier.onNextPage,
              textStyle: style.bodyLarge,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroCloudSync extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final style = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    return SafeArea(
      child: Container(
        padding: const EdgeInsets.only(left: 28, right: 28, bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/svg/undraw_cloud_sync.svg',
                height: 260,
              ),
            ),
            Text('Cloud Sync',
                style: style.displaySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colors.primary,
                )),
            const Gap(defaultPadding),
            Text(
              'Sync your tasks across all devices, anywhere, anytime. Offline support included.',
              style: style.bodyLarge,
            ),
            const Spacer(),
            CustomFilledButton(
              margin: const EdgeInsets.only(top: defaultPadding),
              onPressed: () {},
              textStyle: style.bodyLarge,
              backgroundColor: Colors.white.withOpacity(0.06),
              foregroundColor: Colors.white,
              child: const Row(
                children: [
                  Icon(BoxIcons.bxl_google, size: 28),
                  Gap(8),
                  Text('Sign in with Google'),
                ],
              ),
            ),
            CustomFilledButton(
              margin: const EdgeInsets.only(top: defaultPadding),
              onPressed: () {},
              textStyle: style.bodyLarge,
              backgroundColor: Colors.white.withOpacity(0.06),
              foregroundColor: Colors.white,
              child: const Row(
                children: [
                  Icon(BoxIcons.bxl_apple, size: 28),
                  Gap(8),
                  Text('Sign in with Apple'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}