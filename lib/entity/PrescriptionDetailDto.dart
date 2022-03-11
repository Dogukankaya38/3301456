class PrescriptionDetailDto {
  final String barcode, medicineName, useType, period;
  final int dose;

  PrescriptionDetailDto(
      this.barcode, this.medicineName, this.useType, this.period, this.dose);
}
