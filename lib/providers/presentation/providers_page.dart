import 'package:booking_app/core/di/di.dart';
import 'package:booking_app/providers/presentation/bloc/providers_bloc.dart';
import 'package:booking_app/core/common/widgets/provider_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProvidersPage extends StatefulWidget {
  const ProvidersPage({super.key});

  @override
  State<ProvidersPage> createState() => _ProvidersPageState();
}

class _ProvidersPageState extends State<ProvidersPage> {
  final _bloc = sl<AllProvidersBloc>();

  @override
  void initState() {
    super.initState();
    _bloc.add(const LoadAllProviders());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Providers')),
        body: BlocBuilder<AllProvidersBloc, AllProvidersState>(
          builder: (context, state) => switch (state) {
            AllProvidersLoading() => const Center(
              child: CircularProgressIndicator(),
            ),

            AllProvidersError error => Center(child: Text(error.message)),

            AllProvidersLoaded loaded =>
              loaded.providers.isEmpty
                  ? const Center(child: Text('No providers found'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      itemCount: loaded.providers.length,
                      itemBuilder: (_, i) =>
                          ProviderCard(provider: loaded.providers[i]),
                    ),
          },
        ),
      ),
    );
  }
}
