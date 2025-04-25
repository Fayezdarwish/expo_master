class Exhibition {
  final String name;
  final String description;
  final String startDate;
  final String endDate;

  Exhibition({
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}
