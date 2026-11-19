import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/products/products_cubit.dart';
import '../../logic/products/products_state.dart';

/// Chip-uri de colectie + butoane Sortare / Pret + numar rezultate.
class FilterBar extends StatelessWidget {
  final ProductsState state;

  const FilterBar({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductsCubit>();
    return Column(
      children: [
        SizedBox(
          height: 42,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: const Text('Toate'),
                  selected: state.collection == null,
                  onSelected: (_) => cubit.setCollection(null),
                ),
              ),
              for (final c in state.collections)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(c),
                    selected: state.collection == c,
                    onSelected: (_) => cubit.setCollection(c),
                  ),
                ),
            ],
          ),
        ),
        Row(
          children: [
            Text('${state.visible.length} produse',
                style: const TextStyle(color: Colors.black54)),
            const Spacer(),
            TextButton.icon(
              onPressed: () => _showSortSheet(context, state.sort),
              icon: const Icon(Icons.sort, size: 18),
              label: Text(state.sort == SortOption.none
                  ? 'Sortare'
                  : state.sort.label),
            ),
            TextButton.icon(
              onPressed: () => _showPriceSheet(context, state),
              icon: Icon(
                Icons.tune,
                size: 18,
                color: state.priceLimit != null ? Colors.red : null,
              ),
              label: const Text('Preț'),
            ),
          ],
        ),
      ],
    );
  }

  void _showSortSheet(BuildContext context, SortOption current) {
    final cubit = context.read<ProductsCubit>();
    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Sortează după',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            for (final option in SortOption.values)
              ListTile(
                title: Text(option.label),
                trailing: option == current
                    ? const Icon(Icons.check, color: Colors.red)
                    : null,
                onTap: () {
                  cubit.setSort(option);
                  Navigator.of(sheetContext).pop();
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showPriceSheet(BuildContext context, ProductsState state) {
    final cubit = context.read<ProductsCubit>();
    final ceiling = state.priceCeiling;
    double value = (state.priceLimit ?? ceiling).clamp(0, ceiling).toDouble();

    showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filtrare după preț',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text('Preț maxim: \$${value.toStringAsFixed(0)}'),
                Slider(
                  min: 0,
                  max: ceiling,
                  divisions: ceiling.toInt(),
                  value: value,
                  label: '\$${value.toStringAsFixed(0)}',
                  onChanged: (v) => setSheetState(() => value = v),
                ),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48)),
                        onPressed: () {
                          cubit.setPriceLimit(null);
                          Navigator.of(sheetContext).pop();
                        },
                        child: const Text('Resetează'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          cubit.setPriceLimit(value >= ceiling ? null : value);
                          Navigator.of(sheetContext).pop();
                        },
                        child: const Text('Aplică'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
