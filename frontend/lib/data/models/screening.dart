import 'package:frontend/core/constants/enums.dart';

class Screening {
  const Screening({
    required this.id,
    required this.donationId,
    required this.testedOn,
    required this.testedByUserId,
    required this.result,
    this.hbLevel,
    this.bp,
    this.hepatitisB = true,
    this.hepatitisC = true,
    this.hiv = true,
    this.malaria = true,
  });

  final int id;
  final int donationId;
  final DateTime testedOn;
  final int testedByUserId;
  final ScreeningResult result;
  final double? hbLevel;
  final String? bp;
  final bool hepatitisB;
  final bool hepatitisC;
  final bool hiv;
  final bool malaria;

  bool get allDiseaseTestsPass =>
      hepatitisB && hepatitisC && hiv && malaria;
}
