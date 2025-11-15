import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/theme_provider.dart';
import '../core/providers/locale_provider.dart';
import '../core/providers/app_provider.dart';
import '../core/utils/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final locale = context.watch<LocaleProvider>();
    final app = context.watch<AppState>();
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ListTile(title: Text(l10n.general, style: const TextStyle(fontWeight: FontWeight.bold))),
          ListTile(
            title: Text(l10n.language), 
            subtitle: Text(l10n.switchAppLanguage),
            trailing: const Icon(Icons.chevron_right), 
            onTap: ()=>Navigator.pushNamed(context, '/language'),
          ),
          Row(children: [
            TextButton(onPressed: ()=>locale.setEnglish(), child: const Text('English')),
            TextButton(onPressed: ()=>locale.setArabic(), child: const Text('العربية')),
          ]),
          SwitchListTile(
            title: Text(l10n.darkMode), 
            value: theme.mode==ThemeMode.dark, 
            onChanged: (v)=>theme.setMode(v?ThemeMode.dark:ThemeMode.light),
          ),
          const Divider(),

          ListTile(title: Text(l10n.payments, style: const TextStyle(fontWeight: FontWeight.bold))),
          ListTile(
            leading: const Icon(Icons.credit_card), 
            title: Text(l10n.addCard), 
            onTap: () async {
              final holder = TextEditingController(); 
              final last4 = TextEditingController(); 
              String brand = 'VISA';
              await showDialog(context: context, builder: (_)=>AlertDialog(
                title: Text(l10n.addCard),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  TextField(controller: holder, decoration: InputDecoration(labelText: l10n.cardHolder)),
                  TextField(controller: last4, decoration: InputDecoration(labelText: l10n.last4Digits)),
                  DropdownButton<String>(value: brand, items: const [
                    DropdownMenuItem(value: 'VISA', child: Text('VISA')),
                    DropdownMenuItem(value: 'MC', child: Text('Mastercard')),
                  ], onChanged: (v){ brand = v ?? 'VISA'; }),
                ]),
                actions: [
                  TextButton(onPressed: ()=>Navigator.pop(context), child: Text(l10n.cancel)),
                  FilledButton(
                    onPressed: (){ 
                      if(last4.text.trim().length==4){ 
                        context.read<AppState>().addCard(CardItem(
                          id: DateTime.now().toString(), 
                          holder: holder.text.trim(), 
                          last4: last4.text.trim(), 
                          brand: brand,
                        )); 
                        Navigator.pop(context);
                      }
                    }, 
                    child: Text(l10n.save),
                  ),
                ],
              ));
            },
          ),
          if(app.cards.isNotEmpty) ...[
            const SizedBox(height: 8), 
            Text(l10n.savedCards),
            ...app.cards.map((c)=>ListTile(title: Text('${c.brand} •••• ${c.last4}'), subtitle: Text(c.holder))),
          ],
          const Divider(),

          ListTile(title: Text(l10n.notifications, style: const TextStyle(fontWeight: FontWeight.bold))),
          SwitchListTile(title: Text(l10n.orderUpdates), value: true, onChanged: (_)=>{}),
          SwitchListTile(title: Text(l10n.messages), value: true, onChanged: (_)=>{}),
          const Divider(),

          ListTile(title: Text(l10n.legal, style: const TextStyle(fontWeight: FontWeight.bold))),
          ListTile(leading: const Icon(Icons.privacy_tip_outlined), title: Text(l10n.privacyPolicy)),
          ListTile(leading: const Icon(Icons.description_outlined), title: Text(l10n.termsOfService)),
          const Divider(),

          ListTile(title: Text(l10n.about), subtitle: Text('${l10n.appName} • ASU')),
          const Divider(),
          
          // Account Section
          ListTile(title: Text('Account', style: const TextStyle(fontWeight: FontWeight.bold))),
          if (app.userEmail != null)
            ListTile(
              leading: const Icon(Icons.email_outlined),
              title: Text('Email'),
              subtitle: Text(app.userEmail!),
            ),
          if (app.userName != null)
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text('Name'),
              subtitle: Text(app.userName!),
            ),
          ListTile(
            leading: const Icon(Icons.badge_outlined),
            title: Text('Role'),
            subtitle: Text(app.role == UserRole.provider ? l10n.provider : l10n.student),
          ),
          const Divider(),
          
          // Logout Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: FilledButton.icon(
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Sign Out'),
                    content: Text('Are you sure you want to sign out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text(l10n.cancel),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Sign Out'),
                      ),
                    ],
                  ),
                );
                
                if (confirm == true && context.mounted) {
                  await app.signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/auth/sign-in',
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout),
              label: Text('Sign Out'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
