import 'package:booking_app/core/common/entities/current_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({
    super.key,
    required this.isProviderMode,
    required this.onModeChanged,
  });

  final bool isProviderMode;
  final ValueChanged<bool> onModeChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('profile.title'.tr(context: context))),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Card(
            margin: EdgeInsets.zero,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                child: Icon(
                  isProviderMode ? Icons.handyman_outlined : Icons.person,
                ),
              ),
              title: Text(
                isProviderMode
                    ? CurrentProvider.name
                    : 'profile.customer'.tr(context: context),
                style: theme.textTheme.titleMedium,
              ),
              subtitle: Text(
                isProviderMode
                    ? 'profile.provider_id'.tr(
                        context: context,
                        namedArgs: {'id': CurrentProvider.id},
                      )
                    : 'profile.customer_subtitle'.tr(context: context),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            margin: EdgeInsets.zero,
            child: SwitchListTile(
              secondary: const Icon(Icons.swap_horiz),
              title: Text('profile.provider_mode'.tr(context: context)),
              subtitle: Text(
                isProviderMode
                    ? 'profile.provider_mode_on'.tr(
                        context: context,
                        namedArgs: {'name': CurrentProvider.name},
                      )
                    : 'profile.provider_mode_off'.tr(context: context),
              ),
              value: isProviderMode,
              onChanged: onModeChanged,
            ),
          ),
        ],
      ),
    );
  }
}
