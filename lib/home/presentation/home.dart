import 'package:booking_app/core/di/di.dart';
import 'package:booking_app/home/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _bloc = sl<HomeBloc>();

  @override
  void initState() {
    super.initState();
    _bloc.add(const LoadCategories());
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
        appBar: AppBar(title: const Text('Categories')),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) => switch (state) {
            HomeLoading() => const Center(child: CircularProgressIndicator()),

            HomeError error => Center(child: Text(error.message)),

            HomeLoaded loaded => ListView.builder(
              itemCount: loaded.categories.length,
              itemBuilder: (_, i) =>
                  ListTile(title: Text(loaded.categories[i].name)),
            ),
          },
        ),
      ),
    );
  }
}
