class PrescriptionDto{
  final int id;
  final String prescription,prescriptionType,doctor,createdDate;

  PrescriptionDto(this.id, this.prescription, this.prescriptionType,
      this.doctor, this.createdDate);
}