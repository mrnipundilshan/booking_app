import 'package:booking_app/features/booking/domain/validators/booking_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookingValidators.phone', () {
    test('accepts local and international mobile formats', () {
      expect(BookingValidators.phone('0771234567'), isNull);
      expect(BookingValidators.phone('+94771234567'), isNull);
    });

    test('accepts numbers with spaces and dashes', () {
      expect(BookingValidators.phone('077 123 4567'), isNull);
      expect(BookingValidators.phone('077-123-4567'), isNull);
      expect(BookingValidators.phone('+94 77 123 4567'), isNull);
    });

    test('requires a value', () {
      expect(BookingValidators.phone(null), 'Phone number is required');
      expect(BookingValidators.phone(''), 'Phone number is required');
      expect(BookingValidators.phone('  - '), 'Phone number is required');
    });

    test('rejects invalid numbers', () {
      const error = 'Enter a valid mobile number (07XXXXXXXX or +947XXXXXXXX)';
      expect(BookingValidators.phone('077123456'), error);
      expect(BookingValidators.phone('07712345678'), error);
      expect(BookingValidators.phone('0112345678'), error);
      expect(BookingValidators.phone('94771234567'), error);
      expect(BookingValidators.phone('077123456a'), error);
    });
  });

  group('BookingValidators.date', () {
    final now = DateTime(2026, 10, 13, 10, 30);
    const rangeError = 'Choose a date from tomorrow up to 30 days ahead';

    String? validate(DateTime? value) =>
        BookingValidators.date(value, now: now);

    test('requires a date', () {
      expect(validate(null), 'Please select a date');
    });

    test('accepts tomorrow through 30 days ahead', () {
      expect(validate(DateTime(2026, 10, 14)), isNull);
      expect(validate(DateTime(2026, 10, 14, 23, 59)), isNull);
      expect(validate(DateTime(2026, 11, 12)), isNull);
    });

    test('rejects today, past dates and dates beyond 30 days', () {
      expect(validate(DateTime(2026, 10, 13, 18)), rangeError);
      expect(validate(DateTime(2026, 10, 1)), rangeError);
      expect(validate(DateTime(2026, 11, 13)), rangeError);
    });

    test('rejects Sundays within range', () {
      final sunday = DateTime(2026, 10, 18);
      expect(sunday.weekday, DateTime.sunday);
      expect(validate(sunday), 'Bookings are not available on Sundays');
    });
  });
}
