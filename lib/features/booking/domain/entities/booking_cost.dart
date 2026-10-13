class BookingCost {
  const BookingCost({
    required this.labour,
    required this.visitingCharge,
    required this.weekendSurcharge,
  });

  static const double visitingChargeLkr = 500;
  static const double weekendSurchargeRate = 0.15;

  factory BookingCost.calculate({
    required int hourlyRate,
    required int hours,
    DateTime? date,
  }) {
    final labour = (hourlyRate * hours).toDouble();
    return BookingCost(
      labour: labour,
      visitingCharge: visitingChargeLkr,
      weekendSurcharge: isSurchargeDay(date)
          ? labour * weekendSurchargeRate
          : 0,
    );
  }

  static bool isSurchargeDay(DateTime? date) =>
      date?.weekday == DateTime.saturday;

  final double labour;
  final double visitingCharge;
  final double weekendSurcharge;

  double get total => labour + visitingCharge + weekendSurcharge;
}
