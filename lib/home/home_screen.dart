import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/auth/models/trip.dart';
import 'package:travel_app/home/home_controller.dart';
import 'package:travel_app/core/image_render.dart';
import 'package:travel_app/shared/glass_surface.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, this.onOpenMenu});
  final VoidCallback? onOpenMenu;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

//homescreenstate
class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  late final String _uid;
  late final HomeController _c;

  @override
  void initState() {
    super.initState();
    _uid = _auth.currentUser!.uid;
    _c = HomeController()
      ..onFavoritesChanged = () {
        if (mounted) setState(() {});
      };
    _c.init(_uid).then((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trips = _c.filteredTrips();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trips'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: ()=> widget.onOpenMenu?.call(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _c.toggleView();
              });
            },
            icon: Icon(
              _c.viewMode == ViewMode.list
                  ? Icons.grid_view_rounded
                  : Icons.view_list_rounded,
            ),
          ),
        ],
      ),
      body: trips.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : (_c.viewMode == ViewMode.list
                ? _TripList(
                    trips: trips,
                    isFav: _c.isFav,
                    onFav: (t) async {
                      await _c.toggleFavorite(_uid, t);
                      setState(() {});
                    },
                  )
                : _TripGrid(
                    trips: trips,
                    isFav: _c.isFav,
                    onFav: (t) async {
                      await _c.toggleFavorite(_uid, t);
                      setState(() {});
                    },
                  )),
    );
  }
}

// list görünmü
class _TripList extends StatelessWidget {
  final List<Trip> trips;
  final bool Function(String id) isFav;
  final Future<void> Function(Trip t) onFav;
  const _TripList({
    required this.trips,
    required this.isFav,
    required this.onFav,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: trips.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final t = trips[i];
        final fav = isFav(t.id);

        return GlassSurface(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            title: Text(t.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              '${t.country} ${t.region}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
              onPressed: () => onFav(t),
              icon: Icon(
                fav ? Icons.favorite : Icons.favorite_border,
                color: fav ? Colors.red : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

// grid görünmü
class _TripGrid extends StatelessWidget {
  final List<Trip> trips;
  final bool Function(String id) isFav;
  final Future<void> Function(Trip t) onFav;
  const _TripGrid({
    required this.trips,
    required this.isFav,
    required this.onFav,
  });

  String fmt(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y.$m.$day';
  }

  @override
  Widget build(BuildContext context) {
    final cross = MediaQuery.of(context).size.width > 600 ? 3 : 2;
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cross,
        mainAxisSpacing: 2,
        crossAxisSpacing: 12,
        childAspectRatio: .65,
      ),
      itemCount: trips.length,
      itemBuilder: (context, i) {
        final t = trips[i];
        final fav = isFav(t.id);

        final theme = Theme.of(context);
        return GlassSurface(
          padding: const EdgeInsets.all(12),
          radius: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: AspectRatio(
                  aspectRatio: 16 / 10,
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
                      '${t.country} ${t.region}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color.fromARGB(255, 8, 8, 8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${fmt(t.startDate)}-${fmt(t.endDate)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: const Color.fromARGB(255, 8, 8, 8),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            t.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium,
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
