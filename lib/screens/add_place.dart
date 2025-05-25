import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:favorite_places/models/place.dart";
import "package:favorite_places/providers/places_provider.dart";
import "package:favorite_places/widgets/image_input.dart";
import "package:favorite_places/widgets/location_input.dart";

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() {
    return AddPlaceScreenState();
  }
}

class AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _titleController = TextEditingController();
  File? _selectedImage;
  PlaceLocation? _selectedLocation;

  void _savePlace() {
    final enteredTitle = _titleController.text;

    if (enteredTitle.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      return;
    }
    ref
        .read(placesProvider.notifier)
        .addPlace(
          Place(
            title: enteredTitle,
            image: _selectedImage!,
            location: _selectedLocation!,
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add new place")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "Title"),
              controller: _titleController,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            const SizedBox(height: 10),
            ImageInput(
              onPickImage: (File image) {
                _selectedImage = image;
              },
            ),
            const SizedBox(height: 10),
            LocationInput(
              onSelectLocation: (PlaceLocation location) {
                _selectedLocation = location;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _savePlace,
              icon: const Icon(Icons.add),
              label: const Text("Add place"),
            ),
          ],
        ),
      ),
    );
  }
}
