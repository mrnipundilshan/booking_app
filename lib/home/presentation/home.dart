import 'dart:async';

import 'package:booking_app/core/di/di.dart';
import 'package:booking_app/home/presentation/bloc/home_bloc.dart';
import 'package:booking_app/home/presentation/providers_page.dart';
import 'package:booking_app/home/presentation/widgets/category_card.dart';
import 'package:booking_app/home/presentation/widgets/provider_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _bloc = sl<HomeBloc>();
  Timer? _debounce;

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 400),
      () => _bloc.add(SearchProviders(value)),
    );
  }

  @override
  void initState() {
    super.initState();
    _bloc.add(const LoadCategories());
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Categories')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
              child: TextField(
                onChanged: _onSearchChanged,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search providers by name or skill',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) => switch (state) {
        HomeLoading() => const Center(child: CircularProgressIndicator()),

        HomeError error => Center(child: Text(error.message)),

        HomeLoaded loaded when loaded.isSearching =>
          loaded.results.isEmpty
              ? Center(child: Text('No results for "${loaded.query}"'))
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  itemCount: loaded.results.length,
                  itemBuilder: (_, i) =>
                      ProviderCard(provider: loaded.results[i]),
                ),

        HomeLoaded loaded => GridView.builder(
          padding: const EdgeInsets.all(14),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.3,
          ),
          itemCount: loaded.categories.length,
          itemBuilder: (_, i) => CategoryCard(
            category: loaded.categories[i],
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => ProvidersPage(category: loaded.categories[i]),
              ),
            ),
          ),
        ),
      },
    );
  }
}
