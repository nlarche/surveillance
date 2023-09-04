import 'package:flutter/material.dart';
import 'package:surveillance_poids/detail.dart';
import 'package:surveillance_poids/patient.dart';
import 'package:confirm_dialog/confirm_dialog.dart';

class PatientListApp extends StatefulWidget {
  const PatientListApp({super.key, required this.title});

  final String title;
  @override
  PatientListAppState createState() => PatientListAppState();
}

class PatientListAppState extends State<PatientListApp> {
  final List<Patient> patients = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String? errorText;

  void _addPatient() {
    final String name = _nameController.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        var newPatient = Patient(id: DateTime.now().toString(), name: name);
        patients.add(newPatient);
        _nameController.clear();
        errorText = null;
        _showPatientDetail(newPatient);
      });
    } else {
      setState(() {
        errorText = 'Le nom est obligatoire';
      });
    }
  }

  void _searchPatients(String query) {
    // Implement your search logic here
    // For example, filter the patients list based on the query
    setState(() {
      // You can replace this with your own filtering logic
      patients.forEach((patient) {
        patient.name.toLowerCase().contains(query.toLowerCase())
            ? patient.isVisible = true
            : patient.isVisible = false;
      });
    });
  }

  void _showPatientDetail(Patient patient) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => PatientDetailPage(patient: patient),
    ));
  }

  void _archivePatient(Patient patient) {
    setState(() {
      patients.forEach((p) {
        if (p.id == patient.id) {
          patient.isArchived = true;
        }
      });
    });
  }

  void _clearSearch() {
    _searchController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Recherche',
                      suffixIcon: _searchController.text.isNotEmpty
                          ? TextButton(
                              onPressed: _clearSearch,
                              child: const Icon(Icons.clear),
                            )
                          : null,
                    ),
                    onChanged: (_) => _searchPatients(_searchController.text),
                  ),
                ),
                const SizedBox(width: 50.0), // Add spacing between inputs

                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      errorText: errorText,
                      suffixIcon: TextButton(
                        onPressed: _addPatient,
                        child: const Icon(Icons.add),
                      ),
                    ),
                    onSubmitted: (_) => _addPatient(),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: patients.length,
                itemBuilder: (ctx, index) {
                  final patient = patients[index];
                  if (patient.isVisible == false ||
                      patient.isArchived == true) {
                    return const SizedBox.shrink();
                  }
                  return ListTile(
                      title: Text(patient.name),
                      subtitle: Text('ID: ${patient.id}'),
                      trailing: Column(
                        children: [
                          TextButton(
                            onPressed: () async {
                              if (await confirm(context)) {
                                _archivePatient(patient);
                              }
                            },
                            child: const Text(
                              'archiver',
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        _showPatientDetail(patient);
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
