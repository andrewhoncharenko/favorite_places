import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:favorite_places/models/place.dart";
import "package:favorite_places/providers/places_provider.dart";
import "package:favorite_places/widgets/places_list.dart";
import "package:favorite_places/screens/add_place.dart";

class PlacesScreen extends ConsumerStatefulWidget {
  const PlacesScreen({super.key});
  @override
  ConsumerState<PlacesScreen> createState() {
    return PlacesScreenState();
  }
}

class PlacesScreenState extends ConsumerState<PlacesScreen> {
  late Future<void> _placesFuture;

  @override
  void initState() {
    _placesFuture = ref.read(placesProvider.notifier).loadPlaces();
    super.initState();
  }

  void onAddPlace() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (ctx) => AddPlaceScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final List<Place> places = ref.watch(placesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your favorite places"),
        actions: [IconButton(onPressed: onAddPlace, icon: Icon(Icons.add))],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: FutureBuilder(
          future: _placesFuture,
          builder:
              (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator())
                      : PlacesList(places: places),
        ),
      ),
    );
  }
}
