import 'package:booking_app/core/di/di.dart';
import 'package:booking_app/home/domain/entities/category_entity.dart';
import 'package:booking_app/home/presentation/bloc/providers_bloc.dart';
import 'package:booking_app/home/presentation/widgets/provider_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProvidersPage extends StatefulWidget {
  const ProvidersPage({super.key, required this.category});

  final CategoryEntity category;

  @override
  State<ProvidersPage> createState() => _ProvidersPageState();
}

class _ProvidersPageState extends State<ProvidersPage> {
  final _bloc = sl<ProvidersBloc>();

  @override
  void initState() {
    super.initState();
    _bloc.add(LoadProviders(widget.category.id));
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
        appBar: AppBar(title: Text(widget.category.name)),
        body: BlocBuilder<ProvidersBloc, ProvidersState>(
          builder: (context, state) => switch (state) {
            ProvidersLoading() => const Center(
              child: CircularProgressIndicator(),
            ),

            ProvidersError error => Center(child: Text(error.message)),

            ProvidersLoaded loaded =>
              loaded.providers.isEmpty
                  ? const Center(child: Text('No providers found'))
                  : ListView.builder(
                      itemCount: loaded.providers.length,
                      itemBuilder: (_, i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: ProviderCard(provider: loaded.providers[i]),
                      ),
                    ),
          },
        ),
      ),
    );
  }
}
