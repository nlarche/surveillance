class Patient {
  final String id;
  String name;
  bool isArchived = false;
  bool isVisible = true;

  final List<double> weigths = [1.3];

  Patient({required this.id, required this.name});
}
