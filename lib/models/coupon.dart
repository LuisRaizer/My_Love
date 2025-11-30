class Coupon {
  final String title;
  final String description;
  final String icon;
  bool isUsed;

  Coupon({
    required this.title,
    required this.description,
    required this.icon,
    this.isUsed = false,
  });
}