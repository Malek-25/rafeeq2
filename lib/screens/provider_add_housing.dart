import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../core/utils/app_localizations.dart';
import '../core/providers/housing_provider.dart';
import '../core/providers/app_provider.dart';
import '../core/models/housing.dart';

class ProviderAddHousingScreen extends StatefulWidget {
  const ProviderAddHousingScreen({super.key});
  @override
  State<ProviderAddHousingScreen> createState() => _ProviderAddHousingScreenState();
}

class _ProviderAddHousingScreenState extends State<ProviderAddHousingScreen> {
  final title = TextEditingController();
  final price = TextEditingController();
  final description = TextEditingController();
  final lat = TextEditingController(text: '32.0100');
  final lng = TextEditingController(text: '35.8443');
  final ImagePicker _picker = ImagePicker();
  final List<String> photos = [];
  String? selectedGender; // 'M' for Male, 'F' for Female, null for both
  Housing? editingHousing; // If editing, this will be set

  @override
  void initState() {
    super.initState();
    // Check if we're editing an existing housing
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Housing) {
      editingHousing = args;
      title.text = args.title;
      price.text = args.price.toString();
      description.text = args.description ?? '';
      lat.text = args.lat.toString();
      lng.text = args.lng.toString();
      selectedGender = args.gender;
      photos.addAll(args.photos);
    }
  }

  @override
  void dispose() {
    title.dispose();
    price.dispose();
    description.dispose();
    lat.dispose();
    lng.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    
    return Scaffold(
      appBar: AppBar(title: Text(editingHousing != null ? 'Edit Housing' : l10n.addHousing)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(spacing: 8, children: [
            ...photos.map((p)=>ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(p), width: 64, height: 64, fit: BoxFit.cover))).toList(),
            OutlinedButton.icon(
              onPressed: () async { 
                final x = await _picker.pickMultiImage(); 
                if(x!=null){ 
                  setState(()=>photos.addAll(x.map((e)=>e.path))); 
                } 
              }, 
              icon: const Icon(Icons.add_a_photo), 
              label: Text(l10n.addPhotos),
            ),
          ]),
          const SizedBox(height: 12),
          TextField(controller: title, decoration: InputDecoration(labelText: l10n.title, border: const OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(
            controller: description,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Describe the housing, amenities, location details...',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Text('Gender Preference', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String?>(
                  title: const Text('Male Only'),
                  value: 'M',
                  groupValue: selectedGender,
                  onChanged: (value) => setState(() => selectedGender = value),
                ),
              ),
              Expanded(
                child: RadioListTile<String?>(
                  title: const Text('Female Only'),
                  value: 'F',
                  groupValue: selectedGender,
                  onChanged: (value) => setState(() => selectedGender = value),
                ),
              ),
            ],
          ),
          RadioListTile<String?>(
            title: const Text('Both (No Preference)'),
            value: null,
            groupValue: selectedGender,
            onChanged: (value) => setState(() => selectedGender = value),
          ),
          const SizedBox(height: 12),
          TextField(controller: price, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l10n.pricePerMonth, border: const OutlineInputBorder())),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: lat, decoration: InputDecoration(labelText: l10n.lat, border: const OutlineInputBorder()))),
            const SizedBox(width: 8),
            Expanded(child: TextField(controller: lng, decoration: InputDecoration(labelText: l10n.lng, border: const OutlineInputBorder()))),
          ]),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: (){
              if (title.text.trim().isEmpty || price.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in title and price')),
                );
                return;
              }
              
              final priceValue = double.tryParse(price.text) ?? 0.0;
              final latValue = double.tryParse(lat.text) ?? 32.0100;
              final lngValue = double.tryParse(lng.text) ?? 35.8443;
              final appState = context.read<AppState>();
              
              if (editingHousing != null) {
                // Update existing housing
                final updatedHousing = Housing(
                  id: editingHousing!.id,
                  title: title.text.trim(),
                  price: priceValue,
                  lat: latValue,
                  lng: lngValue,
                  photos: photos,
                  providerName: appState.userName ?? 'Provider',
                  providerEmail: appState.userEmail ?? '',
                  description: description.text.trim().isEmpty ? null : description.text.trim(),
                  gender: selectedGender,
                  rating: editingHousing!.rating,
                );
                
                context.read<HousingProvider>().updateHousing(updatedHousing);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Housing updated successfully')),
                );
              } else {
                // Add new housing
                final newHousing = Housing(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: title.text.trim(),
                  price: priceValue,
                  lat: latValue,
                  lng: lngValue,
                  photos: photos,
                  providerName: appState.userName ?? 'Provider',
                  providerEmail: appState.userEmail ?? '',
                  description: description.text.trim().isEmpty ? null : description.text.trim(),
                  gender: selectedGender,
                );
                
                context.read<HousingProvider>().addHousing(newHousing);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.housingSaved)),
                );
              }
              
              Navigator.pop(context);
            }, 
            child: Text(editingHousing != null ? 'Update' : l10n.save),
          ),
        ],
      ),
    );
  }
}
