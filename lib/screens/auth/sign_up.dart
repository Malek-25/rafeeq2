import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../core/providers/app_provider.dart';
import '../../core/utils/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final pass = TextEditingController();
  UserRole roleChoice = UserRole.student;

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context) ?? AppLocalizations(const Locale('en'));
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.createAccount)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(l10n.chooseRole),
          Row(children: [
            Expanded(child: RadioListTile<UserRole>(
              value: UserRole.student, 
              groupValue: roleChoice, 
              onChanged: (v){ setState(() { roleChoice = v!; }); }, 
              title: Text(l10n.student),
            )),
            Expanded(child: RadioListTile<UserRole>(
              value: UserRole.provider, 
              groupValue: roleChoice, 
              onChanged: (v){ setState(() { roleChoice = v!; }); }, 
              title: Text(l10n.provider),
            )),
          ]),
          const SizedBox(height: 8),
          TextField(controller: name,
              decoration: InputDecoration(labelText: l10n.fullName, border: const OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: email,
              decoration: InputDecoration(labelText: l10n.email, border: const OutlineInputBorder())),
          const SizedBox(height: 12),
          IntlPhoneField(controller: phone,
              decoration: InputDecoration(labelText: l10n.phoneNumber, border: const OutlineInputBorder()),
              initialCountryCode: 'JO'),
          const SizedBox(height: 12),
          TextField(controller: pass, obscureText: true,
              decoration: InputDecoration(labelText: l10n.passwordStrong, border: const OutlineInputBorder())),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              if (name.text.trim().isEmpty || email.text.trim().isEmpty || pass.text.length < 8) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please fill all fields. Password must be at least 8 characters.'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              final appState = context.read<AppState>();
              final success = await appState.signUp(
                email.text.trim(),
                pass.text,
                name.text.trim(),
                roleChoice,
              );
              
              if (context.mounted) {
                if (success) {
                  Navigator.pushReplacementNamed(context, '/');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error creating account. Please try again.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            }, 
            child: Text(l10n.signUp),
          ),
        ],
      ),
    );
  }
}
