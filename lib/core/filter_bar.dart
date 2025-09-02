import 'package:flutter/material.dart';
import 'package:travel_app/models/trip_filter.dart';

class FilterBar extends StatelessWidget {
  final TripFilter filter;
  final List<String> countries, regions, categories;
  final VoidCallback onClear;
  final ValueChanged<String?> onCountry, onRegion, onCategory;
  final Future<void> Function() onPickDate;
  final ValueChanged<bool> onFavorites;

  const FilterBar({
    super.key,
    required this.filter,
    required this.countries,
    required this.regions,
    required this.categories,
    required this.onClear,
    required this.onCountry,
    required this.onRegion,
    required this.onCategory,
    required this.onPickDate,
    required this.onFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: 12),

          _DropPill(
            hint: 'Country',
            items: countries,
            value: filter.country,
            onChanged: onCountry,
          ),
          const SizedBox(width: 8),

          _DropPill(
            hint: 'Region',
            items: regions,
            value: filter.region,
            onChanged: onRegion,
          ),
          const SizedBox(width: 8),

          _DropPill(
            hint: 'Category',
            items: categories,
            value: filter.category,
            onChanged: onCategory,
          ),
          const SizedBox(width: 8),

          _PillButton(
            text: filter.dateRange == null
                ? 'Date'
                : '${filter.dateRange!.start.year}/${filter.dateRange!.start.month}'
                  ' - ${filter.dateRange!.end.year}/${filter.dateRange!.end.month}',
            onTap: onPickDate,
          ),
          const SizedBox(width: 8),

          _PillToggle(
            text: 'Favorites',
            selected: filter.onlyFavorites,
            onChanged: onFavorites,
          ),

          if (filter.country != null ||
              filter.region != null ||
              filter.category != null ||
              filter.dateRange != null ||
              filter.onlyFavorites) ...[
            const SizedBox(width: 8),
            _PillButton(text: 'Clear', onTap: () async => onClear()),
          ],

          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

const double _kPillHeight = 36;
const double _kPillRadius = 16;
const double _kHPad = 12;
const double _kMinPillWidth = 120;

TextStyle _pillTextStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodyMedium!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.0,
        );

BoxConstraints get _pillConstraints =>
    const BoxConstraints(minHeight: _kPillHeight, minWidth: _kMinPillWidth);

BoxDecoration _pillDecoration(BuildContext context, {bool selected = false}) {
  final theme = Theme.of(context);
  final borderColor = selected
      ? theme.colorScheme.primary.withOpacity(.45)
      : theme.dividerColor.withOpacity(.5);

  return BoxDecoration(
    color: selected ? theme.colorScheme.primary.withOpacity(.08) : Colors.white,
    border: Border.all(color: borderColor),
    borderRadius: BorderRadius.circular(_kPillRadius),
  );
}


class _DropPill extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  const _DropPill({
    required this.hint,
    required this.items,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: _pillConstraints,
      child: Container(
        height: _kPillHeight,
        padding: const EdgeInsets.symmetric(horizontal: _kHPad - 4),
        decoration: _pillDecoration(context),
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isDense: true,
              iconSize: 16,
              menuMaxHeight: 320,
              style: _pillTextStyle(context),
              hint: Text(
                hint,
                style: _pillTextStyle(context)
                    .copyWith(color: Theme.of(context).hintColor),
              ),
              value: (value == null || value!.isEmpty) ? null : value,
              items: [
                const DropdownMenuItem<String>(
                    value: '', child: Text('All')),
                ...items.map((e) =>
                    DropdownMenuItem<String>(value: e, child: Text(e))),
              ],
              onChanged: (v) => onChanged((v ?? '').isEmpty ? null : v),
              borderRadius: BorderRadius.circular(_kPillRadius),
              icon: const Padding(
                padding: EdgeInsets.only(left: 6),
                child: Icon(Icons.arrow_drop_down),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String text;
  final Future<void> Function()? onTap;

  const _PillButton({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(_kPillRadius),
        onTap: onTap,
        child: ConstrainedBox(
          constraints: _pillConstraints,
          child: Container(
            height: _kPillHeight,
            padding: const EdgeInsets.symmetric(horizontal: _kHPad),
            decoration: _pillDecoration(context),
            child: Center(
              child: Text(text, style: _pillTextStyle(context)),
            ),
          ),
        ),
      ),
    );
  }
}

class _PillToggle extends StatelessWidget {
  final String text;
  final bool selected;
  final ValueChanged<bool> onChanged;

  const _PillToggle({
    required this.text,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final style = _pillTextStyle(context).copyWith(
      color:
          selected ? Theme.of(context).colorScheme.primary : null,
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(_kPillRadius),
        onTap: () => onChanged(!selected),
        child: ConstrainedBox(
          constraints: _pillConstraints,
          child: Container(
            height: _kPillHeight,
            padding: const EdgeInsets.symmetric(horizontal: _kHPad),
            decoration: _pillDecoration(context, selected: selected),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  selected ? Icons.favorite : Icons.favorite_border,
                  size: 16,
                  color: selected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).iconTheme.color,
                ),
                const SizedBox(width: 6),
                Text(text, style: style),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
