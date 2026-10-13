import 'package:booking_app/features/booking/presentation/jobs_page.dart';
import 'package:booking_app/features/booking/presentation/my_bookings_page.dart';
import 'package:booking_app/features/home/presentation/home.dart';
import 'package:booking_app/features/profile/presentation/profile_page.dart';
import 'package:booking_app/features/providers/presentation/providers_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  int _bookingsVersion = 0;
  bool _providerMode = false;

  void _setProviderMode(bool value) => setState(() {
    _providerMode = value;
    _index = value ? 1 : 3;
  });

  @override
  Widget build(BuildContext context) {
    final profile = ProfilePage(
      isProviderMode: _providerMode,
      onModeChanged: _setProviderMode,
    );
    final profileDestination = NavigationDestination(
      icon: const Icon(Icons.person_outline),
      selectedIcon: const Icon(Icons.person),
      label: 'nav.profile'.tr(context: context),
    );

    if (_providerMode) {
      return Scaffold(
        body: IndexedStack(
          key: const ValueKey('provider'),
          index: _index,
          children: [const JobsPage(), profile],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (i) => setState(() => _index = i),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.work_outline),
              selectedIcon: const Icon(Icons.work),
              label: 'nav.jobs'.tr(context: context),
            ),
            profileDestination,
          ],
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        key: const ValueKey('customer'),
        index: _index,
        children: [
          const Home(),
          const ProvidersPage(),
          MyBookingsPage(key: ValueKey(_bookingsVersion)),
          profile,
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() {
          if (i == 2 && _index != 2) _bookingsVersion++;
          _index = i;
        }),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: 'nav.home'.tr(context: context),
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people),
            label: 'nav.providers'.tr(context: context),
          ),
          NavigationDestination(
            icon: const Icon(Icons.event_note_outlined),
            selectedIcon: const Icon(Icons.event_note),
            label: 'nav.bookings'.tr(context: context),
          ),
          profileDestination,
        ],
      ),
    );
  }
}
