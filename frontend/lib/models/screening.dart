class Screening {
  final String screeningResultID;
  final double hbLevel;
  final String bp;
  final bool hepatitisB;
  final bool hepatitisC;
  final bool hiv;
  final bool malaria;
  final String testedOn;
  final String testedBy;
  final String result;
  final String donation;

  const Screening({
    required this.screeningResultID,
    required this.hbLevel,
    required this.bp,
    required this.hepatitisB,
    required this.hepatitisC,
    required this.hiv,
    required this.malaria,
    required this.testedOn,
    required this.testedBy,
    required this.result,
    required this.donation,
  });

  factory Screening.fromJson(Map<String, dynamic> json) {
    return Screening(
      screeningResultID: json['screening_result_ID'] as String,
      hbLevel: (json['hb_level'] as num).toDouble(),
      bp: json['bp'] as String,
      hepatitisB: json['hepatitis_b'] as bool,
      hepatitisC: json['hepatitis_c'] as bool,
      hiv: json['hiv'] as bool,
      malaria: json['malaria'] as bool,
      testedOn: json['tested_on'] as String,
      testedBy: json['tested_by'] as String,
      result: json['result'] as String,
      donation: json['donation'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hb_level': hbLevel,
      'bp': bp,
      'hepatitis_b': hepatitisB,
      'hepatitis_c': hepatitisC,
      'hiv': hiv,
      'malaria': malaria,
      'tested_on': testedOn,
      'tested_by': testedBy,
      'result': result,
      'donation': donation,
    };
  }
}