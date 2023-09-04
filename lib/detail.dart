import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surveillance_poids/chart/chart_container.dart';
import 'package:surveillance_poids/chart/line_chart.dart';
import 'package:surveillance_poids/form/editable_label.dart';
import 'package:surveillance_poids/patient.dart';

class PatientDetailPage extends StatefulWidget {
  const PatientDetailPage({super.key, required this.patient});

  final Patient patient;
  @override
  _PatientDetailState createState() => _PatientDetailState();
}

class _PatientDetailState extends State<PatientDetailPage> {
  final TextEditingController _weightController = TextEditingController();

  void _addWeight() {
    if (RegExp(_getRegexString()).hasMatch(_weightController.text)) {
      setState(() {
        widget.patient.weigths.add(double.parse(_weightController.text));
        _weightController.clear();
      });
    }
  }

  void _changeName(String name) {
    setState(() {
      widget.patient.name = name;
    });
  }

  String _getRegexString() => r'[0-9]+[,.]{0,1}[0-9]*';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text(widget.patient.name),
        leading: BackButton(
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
      body: Row(children: [
        Expanded(flex: 2, child: Container()),
        Expanded(
          flex: 6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: EditableLabel(
                    text: widget.patient.name, onChanged: _changeName),
              ),

              Expanded(
                flex: 5,
                child: TextField(
                  controller: _weightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp(_getRegexString())),
                    TextInputFormatter.withFunction(
                      (oldValue, newValue) => newValue.copyWith(
                        text: newValue.text.replaceAll(',', '.'),
                      ),
                    ),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Ajouter un poids',
                    suffixIcon: TextButton(
                      onPressed: _addWeight,
                      child: const Icon(Icons.add),
                    ),
                  ),
                  onSubmitted: (_) => _addWeight(),
                ),
              ),
              ChartContainer(
                title: '2colution du poids',
                chart: LineChartContent(data: widget.patient.weigths),
              ),
              Text('Patient Name: ${widget.patient.name}'),
              Text(widget.patient.weigths.join(", ")),

              // Vous pouvez ajouter d'autres détails du patient ici si nécessaire
            ],
          ),
        ),
        Expanded(flex: 2, child: Container()),
      ]),
    ));
  }
}
