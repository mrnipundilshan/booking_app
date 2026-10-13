import 'package:booking_app/home/domain/entities/category_entity.dart';
import 'package:booking_app/providers/presentation/bloc/providers_bloc.dart';
import 'package:flutter/material.dart';

class ProviderFilterSheet extends StatefulWidget {
  const ProviderFilterSheet({
    super.key,
    required this.categories,
    required this.current,
  });

  final List<CategoryEntity> categories;

  final FilterProviders current;

  @override
  State<ProviderFilterSheet> createState() => _ProviderFilterSheetState();
}

class _ProviderFilterSheetState extends State<ProviderFilterSheet> {
  static const double _lowestRate = 0;
  static const double _highestRate = 5000;

  String? _categoryId;
  double? _minRating;
  late RangeValues _rateRange;
  late bool _availableOnly;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.current.categoryId;
    _minRating = widget.current.minRating;
    _rateRange = RangeValues(
      widget.current.minRate?.toDouble() ?? _lowestRate,
      widget.current.maxRate?.toDouble() ?? _highestRate,
    );
    _availableOnly = widget.current.availableOnly;
  }

  void _apply() {
    Navigator.pop(
      context,
      FilterProviders(
        categoryId: _categoryId,
        minRating: _minRating,
        minRate: _rateRange.start > _lowestRate
            ? _rateRange.start.round()
            : null,
        maxRate: _rateRange.end < _highestRate ? _rateRange.end.round() : null,
        availableOnly: _availableOnly,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Category'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _categoryId == null,
                  onSelected: (_) => setState(() => _categoryId = null),
                ),
                for (final category in widget.categories)
                  ChoiceChip(
                    label: Text(category.name),
                    selected: _categoryId == category.id,
                    onSelected: (_) =>
                        setState(() => _categoryId = category.id),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            const Text('Minimum rating'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('Any'),
                  selected: _minRating == null,
                  onSelected: (_) => setState(() => _minRating = null),
                ),
                ChoiceChip(
                  label: const Text('3+'),
                  selected: _minRating == 3,
                  onSelected: (_) => setState(() => _minRating = 3),
                ),
                ChoiceChip(
                  label: const Text('4+'),
                  selected: _minRating == 4,
                  onSelected: (_) => setState(() => _minRating = 4),
                ),
                ChoiceChip(
                  label: const Text('4.5+'),
                  selected: _minRating == 4.5,
                  onSelected: (_) => setState(() => _minRating = 4.5),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text(
              'Hourly rate: LKR ${_rateRange.start.round()} - ${_rateRange.end.round()}',
            ),
            RangeSlider(
              min: _lowestRate,
              max: _highestRate,
              divisions: 50,
              values: _rateRange,
              onChanged: (values) => setState(() => _rateRange = values),
            ),

            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Available providers only'),
              value: _availableOnly,
              onChanged: (value) => setState(() => _availableOnly = value),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        Navigator.pop(context, const FilterProviders()),
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _apply,
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
