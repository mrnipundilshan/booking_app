import 'package:booking_app/core/di/di.dart';
import 'package:booking_app/features/home/domain/entities/category_entity.dart';
import 'package:booking_app/features/home/domain/usecases/get_categories_usecase.dart';
import 'package:booking_app/features/providers/presentation/bloc/providers_bloc.dart';
import 'package:booking_app/features/providers/presentation/widgets/provider_filter_sheet.dart';
import 'package:booking_app/features/providers/presentation/provider_details_page.dart';
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
          ProviderFilterSheet(categories: _categories, current: _bloc.filter),
    );
    if (filter != null) _bloc.add(filter);
  }

  PopupMenuItem<String> _sortItem(String sortBy, String label) {
    return CheckedPopupMenuItem(
      value: sortBy,
      checked: (_bloc.sortBy ?? 'default') == sortBy,
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Providers'),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.sort),
              onSelected: (sortBy) =>
                  _bloc.add(SortProviders(sortBy == 'default' ? null : sortBy)),
              itemBuilder: (_) => [
                _sortItem('default', 'Default'),
                _sortItem('rating', 'Rating: high to low'),
                _sortItem('hourlyRate', 'Rate: low to high'),
                _sortItem('experience', 'Experience: high to low'),
              ],
            ),
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
                      itemBuilder: (_, i) => ProviderCard(
                        provider: loaded.providers[i],
                        onTap: () => Navigator.of(
                          context,
                        ).push(ProviderDetailsPage.route(loaded.providers[i])),
                      ),
                    ),
          },
        ),
      ),
    );
  }
}
