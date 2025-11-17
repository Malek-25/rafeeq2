import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/utils/distance_policy.dart';
import '../core/utils/app_localizations.dart';
import '../core/providers/app_provider.dart';

class HousingListScreen extends StatelessWidget {
  const HousingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    final appState = context.watch<AppState>();
    final listings = [
      {'title':'Modern Studio near ASU','price':250,'lat':32.0100,'lng':35.8443,'rating':4.6},
      {'title':'2BR Apartment','price':380,'lat':32.0110,'lng':35.8451,'rating':4.3},
      {'title':'Cozy Room','price':180,'lat':32.0250,'lng':35.8600,'rating':3.9},
    ].where((it)=>DistancePolicy.isAllowed(it['lat'] as double, it['lng'] as double)).toList();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.housingWithin2km)),
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
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text('${it['title']}'),
                    subtitle: Text('USD ${it['price']} / mo • ★ ${it['rating']}'),
                    trailing: FilledButton(onPressed: (){}, child: Text(l10n.details)),
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
