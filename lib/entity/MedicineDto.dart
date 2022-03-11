class MedicineDto {
  final String barcode;
  final String medicineName;
  final String useType;
  final String period;
  final int dose;

  MedicineDto(
      this.barcode, this.medicineName, this.useType, this.period, this.dose);

  Map<String, dynamic> toJson() => {
        'barcode': barcode,
        'medicineName': medicineName,
        'useType': useType,
        'period': period,
        'dose': dose
      };
}
