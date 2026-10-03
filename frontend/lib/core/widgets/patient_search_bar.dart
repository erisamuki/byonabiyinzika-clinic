import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';

/// Global search by name, phone or patient number. Always in the top bar.
class PatientSearchBar extends ConsumerWidget {
  const PatientSearchBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.watch(clinicRepositoryProvider);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: SearchAnchor.bar(
        barHintText: 'Search patient by name, phone or number',
        suggestionsBuilder: (context, controller) async {
          final results = await repository.searchPatients(controller.text);
          if (results.isEmpty) {
            return <Widget>[const ListTile(title: Text('No patient found'))];
          }
          return results
              .map<Widget>(
                (patient) => ListTile(
                  title: Text(patient.name),
                  subtitle: Text('${patient.number}  |  ${patient.phone}'),
                  trailing: Text('Age ${patient.age}'),
                  // TODO: open the patient record screen once it exists.
                  onTap: () => controller.closeView(patient.name),
                ),
              )
              .toList();
        },
      ),
    );
  }
}
