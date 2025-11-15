import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../core/utils/distance_policy.dart';
import '../core/utils/app_localizations.dart';

class ProviderAddHousingScreen extends StatefulWidget {
  const ProviderAddHousingScreen({super.key});
  @override
  State<ProviderAddHousingScreen> createState() => _ProviderAddHousingScreenState();
}

class _ProviderAddHousingScreenState extends State<ProviderAddHousingScreen> {
  final title = TextEditingController();
  final price = TextEditingController();
  final lat = TextEditingController(text: '32.0100');
  final lng = TextEditingController(text: '35.8443');
  final ImagePicker _picker = ImagePicker();
  final List<String> photos = [];
  double? okFlag;

  @override
  void dispose() {
    title.dispose();
    price.dispose();
    lat.dispose();
    lng.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addHousing)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if(okFlag != null) Container(
            padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(color: okFlag == 1 ? Colors.green.withOpacity(.12) : Colors.red.withOpacity(.12), borderRadius: BorderRadius.circular(8)),
            child: Row(children: [
              Icon(okFlag == 1 ? Icons.check_circle : Icons.error, color: okFlag == 1 ? Colors.green : Colors.red),
              const SizedBox(width: 8),
              Expanded(child: Text(okFlag == 1 ? l10n.allowedWithin2km : l10n.blockedExceeds2km)),
            ]),
          ),
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
              final la = double.tryParse(lat.text) ?? 0;
              final lo = double.tryParse(lng.text) ?? 0;
              final allowed = DistancePolicy.isAllowed(la, lo);
              setState(()=> okFlag = allowed ? 1 : -1);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(allowed ? l10n.allowedWithin2km : l10n.rejectedExceeds2km)),
              );
            }, 
            child: Text(l10n.computeDistance),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: okFlag == 1 ? (){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.housingSaved)));
              Navigator.pop(context);
            } : null, 
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }
}
