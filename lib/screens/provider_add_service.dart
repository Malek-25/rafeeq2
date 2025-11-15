import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../core/utils/app_localizations.dart';

class ProviderAddServiceScreen extends StatefulWidget {
  const ProviderAddServiceScreen({super.key});
  @override
  State<ProviderAddServiceScreen> createState()=>_ProviderAddServiceScreenState();
}

class _ProviderAddServiceScreenState extends State<ProviderAddServiceScreen> {
  String? photoPath;
  final ImagePicker _picker = ImagePicker();
  final name = TextEditingController();
  final price = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.addService)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          if(photoPath!=null) ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(File(photoPath!), width: 96, height: 96, fit: BoxFit.cover)),
          OutlinedButton.icon(
            onPressed: () async { 
              final x = await _picker.pickImage(source: ImageSource.gallery); 
              if(x!=null){ 
                setState(()=>photoPath = x.path);
              }
            }, 
            icon: const Icon(Icons.add_a_photo), 
            label: Text(l10n.addPhoto),
          ),
          const SizedBox(height: 12),
          TextField(controller: name, decoration: InputDecoration(labelText: l10n.serviceName, border: const OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: price, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: l10n.price, border: const OutlineInputBorder())),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.serviceCreated)),
              );
              Navigator.pop(context);
            },
            child: Text(l10n.create),
          ),
        ]),
      ),
    );
  }
}
