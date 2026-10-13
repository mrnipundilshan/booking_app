import 'package:booking_app/features/booking/domain/entities/booking_cost.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final wednesday = DateTime(2026, 10, 14);
  final saturday = DateTime(2026, 10, 17);
  final sunday = DateTime(2026, 10, 18);

  group('BookingCost.calculate', () {
    test(
      'weekday booking has labour plus visiting charge and no surcharge',
      () {
        final cost = BookingCost.calculate(
          hourlyRate: 1500,
          hours: 3,
          date: wednesday,
        );

        expect(cost.labour, 4500);
        expect(cost.visitingCharge, BookingCost.visitingChargeLkr);
        expect(cost.weekendSurcharge, 0);
        expect(cost.total, 5000);
      },
    );

    test('Saturday booking adds 15% of labour as weekend surcharge', () {
      expect(saturday.weekday, DateTime.saturday);

      final cost = BookingCost.calculate(
        hourlyRate: 1500,
        hours: 3,
        date: saturday,
      );

      expect(cost.labour, 4500);
      expect(cost.visitingCharge, 500);
      expect(cost.weekendSurcharge, 675);
      expect(cost.total, 5675);
    });

    test('surcharge applies to labour only, not the visiting charge', () {
      final cost = BookingCost.calculate(
        hourlyRate: 2000,
        hours: 1,
        date: saturday,
      );

      expect(cost.weekendSurcharge, 2000 * BookingCost.weekendSurchargeRate);
      expect(cost.total, 2000 + 500 + 300);
    });

    test('Sunday booking has no surcharge', () {
      expect(sunday.weekday, DateTime.sunday);

      final cost = BookingCost.calculate(
        hourlyRate: 1500,
        hours: 3,
        date: sunday,
      );

      expect(cost.weekendSurcharge, 0);
      expect(cost.total, 5000);
    });

    test('missing date has no surcharge', () {
      final cost = BookingCost.calculate(hourlyRate: 1500, hours: 3);

      expect(cost.weekendSurcharge, 0);
      expect(cost.total, 5000);
    });
  });
}
