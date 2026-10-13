import 'package:booking_app/core/di/di.dart';
import 'package:booking_app/home/domain/entities/category_entity.dart';
import 'package:booking_app/home/domain/usecases/get_categories_usecase.dart';
import 'package:booking_app/providers/presentation/bloc/providers_bloc.dart';
import 'package:booking_app/providers/presentation/widgets/provider_filter_sheet.dart';
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

  List<CategoryEntity> _categories = [];
  FilterProviders _filter = const FilterProviders();

  @override
  void initState() {
    super.initState();
    _bloc.add(const LoadAllProviders());
    _loadCategories();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    final categories = await sl<GetCategoriesUseCase>()();
    if (mounted) setState(() => _categories = categories);
  }

  Future<void> _openFilters() async {
    final filter = await showModalBottomSheet<FilterProviders>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) =>
          ProviderFilterSheet(categories: _categories, current: _filter),
    );
    if (filter == null) return;
    setState(() => _filter = filter);
    _bloc.add(filter);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Providers'),
          actions: [
            IconButton(onPressed: _openFilters, icon: const Icon(Icons.tune)),
          ],
        ),
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
