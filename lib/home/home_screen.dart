import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:travel_app/l10n/app_localizations.dart'; 
import 'package:travel_app/models/trip.dart';
import 'package:travel_app/home/home_controller.dart';
import 'package:travel_app/core/image_render.dart';
import 'package:travel_app/models/trip_filter.dart';
import 'package:travel_app/shared/glass_surface.dart';
import 'package:travel_app/core/localization_helper.dart';
import 'package:travel_app/core/filter_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onOpenMenu});
  final VoidCallback? onOpenMenu;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  String? _uid;                       // 
  late final HomeController _c;
  bool _ready = false;                

  @override
  void initState() {
    super.initState();
    _c = HomeController()
      ..onFavoritesChanged = () {
        if (mounted) setState(() {});
      };

    final user = _auth.currentUser;
    if (user != null) {
      _uid = user.uid;
      _c.init(_uid!).then((_) {
        if (mounted) setState(() => _ready = true);
      });
    } else {
      _auth.authStateChanges().first.then((u) async {
        if (!mounted) return;
        if (u == null) {
          setState(() => _ready = true); 
          return;
        }
        _uid = u.uid;
        await _c.init(_uid!);
        if (mounted) setState(() => _ready = true);
      });
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);                
    final trips = _c.filteredTrips() ?? const <Trip>[];    
    final isLoading = !_ready || _c.allTrips == null;      

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
          onPressed: () => setState(() => _c.toggleView()),
            icon: Icon(
              _c.viewMode == ViewMode.list
                  ? Icons.grid_view_rounded
                  : Icons.view_list_rounded,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: FilterBar(
                    filter: _c.filter ?? const TripFilter(),
                    countries: _c.countries ?? const <String>[],
                    regions: _c.regions ?? const <String>[],
                    categories: _c.categories ?? const <String>[],
                    onClear: () => setState(_c.clearFilter),
                    onCountry: (v) => setState(() => _c.setCountry(v)),
                    onRegion: (v) => setState(() => _c.setRegion(v)),
                    onCategory: (v) => setState(() => _c.setCategory(v)),
                    onFavorites: (sel) => setState(() => _c.setOnlyFavorites(sel)),
                    onPickDate: () async {
                      final range = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2015),
                        lastDate: DateTime(2100),
                        initialDateRange: _c.filter?.dateRange,
                        helpText: loc!.help_pickDateRange,
                        locale: const Locale('de'), 
                        builder: (ctx, child) => Localizations.override(
                          context: ctx,
                          locale: const Locale('de'), 
                          child: child,
                        ),
                      );
                      if (!context.mounted) return;
                      if (range != null) setState(() => _c.setDateRange(range));
                    },
                  ),
                ),
                Expanded(
                  child: trips.isEmpty
                      ? Center(child: Text(loc?.empty_no_results ?? 'Keine Ergebnisse'))
                      : (_c.viewMode == ViewMode.list
                          ? _TripList(
                              trips: trips,
                              isFav: _c.isFav,
                              onFav: (t) async {
                                final uid = _uid;
                                if (uid == null) return;                     
                                await _c.toggleFavorite(uid, t);
                                if (mounted) setState(() {});
                              },
                            )
                          : _TripGrid(
                              trips: trips,
                              isFav: _c.isFav,
                              onFav: (t) async {
                                final uid = _uid;
                                if (uid == null) return;                      
                                await _c.toggleFavorite(uid, t);
                                if (mounted) setState(() {});
                              },
                            )),
                ),
              ],
            ),
    );
  }
}

// MARKDOWN: - LIST 
class _TripList extends StatelessWidget {
  final List<Trip> trips;
  final bool Function(String id) isFav;
  final Future<void> Function(Trip t) onFav;

  const _TripList({
    required this.trips,
    required this.isFav,
    required this.onFav,
  });

  String _fmt(BuildContext ctx, DateTime d) {
    final tag = Localizations.localeOf(ctx).toLanguageTag();
    return DateFormat.yMMMEd(tag).format(d);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: trips.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final t = trips[i];
        final fav = isFav(t.id);

        final countryText = l == null ? t.country : localizedCountry(t.country, l);
        final regionText  = l == null ? t.region  : localizedRegion(t.region, l);
        final catText     = l == null ? t.category: localizedCategory(t.category, l);
        final desc        = (t.description ).trim();

        return GlassSurface(
          padding: const EdgeInsets.all(12),
          radius: 16,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Başlık
                    Text(
                      t.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),

                    // Ülke + Bölge
                    Text(
                      '$countryText $regionText',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),

                    // Tarih aralığı
                    Text(
                      '${_fmt(context, t.startDate)} – ${_fmt(context, t.endDate)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),

                    _CategoryChip(text: catText),
                    if (desc.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        desc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),

              IconButton(
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                onPressed: () => onFav(t),
                icon: Icon(
                  fav ? Icons.favorite : Icons.favorite_border,
                  color: fav ? Colors.red : null,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String text;
  const _CategoryChip({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: theme.colorScheme.primary.withValues(alpha: .08),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: .25),
          width: 1,
        ),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelMedium,
      ),
    );
  }
}



//GRID
// ==== GRID (slide-up detay panel) ====
class _TripGrid extends StatefulWidget {
  final List<Trip> trips;
  final bool Function(String id) isFav;
  final Future<void> Function(Trip t) onFav;

  const _TripGrid({
    required this.trips,
    required this.isFav,
    required this.onFav,
  });

  @override
  State<_TripGrid> createState() => _TripGridState();
}

class _TripGridState extends State<_TripGrid> {
  final Set<String> _expanded = {};

  String _fmt(BuildContext ctx, DateTime d) {
    final tag = Localizations.localeOf(ctx).toLanguageTag();
    return DateFormat.yMMMEd(tag).format(d);
  }

  void _toggle(String id) {
    setState(() {
      if (_expanded.contains(id)) {
        _expanded.remove(id);
      } else {
        _expanded.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final width = MediaQuery.of(context).size.width;
    final cross = width > 600 ? 3 : 2;

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cross,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        mainAxisExtent: width > 600 ? 280 : 250,
      ),
      itemCount: widget.trips.length,
      itemBuilder: (context, i) {
        final t = widget.trips[i];
        final fav = widget.isFav(t.id);
        final theme = Theme.of(context);

        final countryText = l == null ? t.country : localizedCountry(t.country, l);
        final regionText  = l == null ? t.region  : localizedRegion(t.region, l);
        final catText     = l == null ? t.category: localizedCategory(t.category, l);
        final desc        = (t.description).trim();
        final expanded    = _expanded.contains(t.id);

        return GestureDetector(
          onTap: () => _toggle(t.id),
          onVerticalDragUpdate: (d) {
            if (d.delta.dy < -6 && !expanded) _toggle(t.id);   
            if (d.delta.dy >  6 && expanded)  _toggle(t.id);  
          },
          child: GlassSurface(
            padding: const EdgeInsets.all(12),
            radius: 16,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: AspectRatio(
                        aspectRatio: 16 / 9, 
                        child: tripImage(t.region), 
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            t.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$countryText $regionText',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color.fromARGB(255, 8, 8, 8),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  catText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelMedium,
                                ),
                              ),
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                onPressed: () => widget.onFav(t),
                                icon: Icon(
                                  fav ? Icons.favorite : Icons.favorite_border,
                                  color: fav ? Colors.red : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // slider
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                  left: 12,
                  right: 12,
                  bottom: expanded ? 8 : -140, 
                  child: IgnorePointer(
                    ignoring: !expanded,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black.withValues(alpha: .85)
                        : Colors.white.withValues(alpha: .98),  
                        border: Border.all(
                          color: theme.dividerColor.withValues(alpha: .4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .06),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(minHeight: 110, maxHeight: 140),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_fmt(context, t.startDate)} – ${_fmt(context, t.endDate)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.hintColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Text(
                                desc.isEmpty ? ' ' : desc,
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 20,
                              color: theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
