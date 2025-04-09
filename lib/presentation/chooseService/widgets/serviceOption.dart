class ServiceOption {
  final String serviceId;
  final String name;
  final double price;
  final String description;
  bool isSelected;

  ServiceOption({
    required this.serviceId,
    required this.name,
    required this.price,
    required this.isSelected,
    required this.description
  });
}