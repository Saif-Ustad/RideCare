class ServiceOption {
  final String name;
  final double price;
  final String description;
  bool isSelected;

  ServiceOption({
    required this.name,
    required this.price,
    required this.isSelected,
    required this.description
  });
}