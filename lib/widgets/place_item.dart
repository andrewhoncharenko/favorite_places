import "package:flutter/material.dart";
import "package:favorite_places/models/place.dart";

class PlaceItem extends StatelessWidget {
  final Place place;
  final void Function(Place place) onSelectPlace;

  const PlaceItem({
    super.key,
    required this.place,
    required this.onSelectPlace,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        place.title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
