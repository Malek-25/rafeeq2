import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/utils/app_localizations.dart';
import '../core/providers/app_provider.dart';
import '../core/providers/housing_provider.dart';

class HousingListScreen extends StatelessWidget {
  const HousingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final appState = context.watch<AppState>();
    final housingProvider = context.watch<HousingProvider>();
    final listings = housingProvider.listings;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.housing ?? 'Housing')),
      body: Column(
        children:[
          Container(padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(top:8, left:16, right:16),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withOpacity(.06), borderRadius: BorderRadius.circular(8)),
            child: Row(children:[const Icon(Icons.info_outline), const SizedBox(width:8), Expanded(child: Text(l10n.housingInfo))]),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: listings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i){
                final it = listings[i];
                final isOwner = appState.role == UserRole.provider && 
                               appState.userEmail == it.providerEmail;
                
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(it.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('USD ${it.price} / mo • ★ ${it.rating}'),
                        if (it.gender != null)
                          Text(
                            it.gender == 'M' ? 'Male Only' : 'Female Only',
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        if (it.description != null && it.description!.isNotEmpty)
                          Text(
                            it.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                      ],
                    ),
                    trailing: isOwner
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/provider/add-housing',
                                    arguments: it,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Delete Housing'),
                                      content: const Text('Are you sure you want to delete this listing?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text(l10n.cancel),
                                        ),
                                        FilledButton(
                                          onPressed: () {
                                            context.read<HousingProvider>().removeHousing(it.id);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Housing deleted')),
                                            );
                                          },
                                          style: FilledButton.styleFrom(backgroundColor: Colors.red),
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : FilledButton(
                            onPressed: (){},
                            child: Text(l10n.details),
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: appState.role == UserRole.provider
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, '/provider/add-housing'),
              icon: const Icon(Icons.add_business),
              label: Text(l10n.addHousingProvider),
            )
          : null,
    );
  }
}
