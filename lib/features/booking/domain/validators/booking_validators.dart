import 'dart:math' as math;

import 'package:booking_app/features/booking/domain/entities/time_slot.dart';

class BookingValidators {
  BookingValidators._();

  static const int minNameLength = 3;
  static const int minAddressLength = 10;
  static const int minDescriptionLength = 10;
  static const int maxDescriptionLength = 300;
  static const int minHours = 1;
  static const int maxHours = 8;
  static const int workdayEndHour = 17;
  static const int maxDaysAhead = 30;

  static final _namePattern = RegExp(r'^[A-Za-z ]+$');
  static final _phonePattern = RegExp(r'^(?:0|\+94)7\d{8}$');
  static final _phoneSeparators = RegExp(r'[\s-]');

  static String? name(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) return 'Name is required';
    if (!_namePattern.hasMatch(name)) {
      return 'Use letters and spaces only';
    }
    if (name.length < minNameLength) {
      return 'Name must be at least $minNameLength characters';
    }
    return null;
  }

  static String normalizePhone(String value) =>
      value.replaceAll(_phoneSeparators, '');

  static String? phone(String? value) {
    final phone = normalizePhone(value ?? '');
    if (phone.isEmpty) return 'Phone number is required';
    if (!_phonePattern.hasMatch(phone)) {
      return 'Enter a valid mobile number (07XXXXXXXX or +947XXXXXXXX)';
    }
    return null;
  }

  static String? address(String? value) {
    final address = value?.trim() ?? '';
    if (address.isEmpty) return 'Address is required';
    if (address.length < minAddressLength) {
      return 'Address must be at least $minAddressLength characters';
    }
    return null;
  }

  static DateTime firstBookableDate(DateTime now) =>
      DateTime(now.year, now.month, now.day + 1);

  static DateTime lastBookableDate(DateTime now) =>
      DateTime(now.year, now.month, now.day + maxDaysAhead);

  static bool isBookableDay(DateTime date) => date.weekday != DateTime.sunday;

  static String? date(DateTime? value, {required DateTime now}) {
    if (value == null) return 'Please select a date';
    final day = DateTime(value.year, value.month, value.day);
    if (day.isBefore(firstBookableDate(now)) ||
        day.isAfter(lastBookableDate(now))) {
      return 'Choose a date from tomorrow up to $maxDaysAhead days ahead';
    }
    if (!isBookableDay(day)) return 'Bookings are not available on Sundays';
    return null;
  }

  static String? timeSlot(TimeSlot? value, Set<TimeSlot> bookedSlots) {
    if (value == null) return 'Please select a time slot';
    if (bookedSlots.contains(value)) return 'This slot is already booked';
    return null;
  }

  static int maxHoursFor(TimeSlot? slot) => slot == null
      ? maxHours
      : math.min(maxHours, workdayEndHour - slot.startHour);

  static String? hours(int? value, TimeSlot? slot) {
    if (value == null) return 'Estimated hours is required';
    if (value < minHours || value > maxHours) {
      return 'Estimated hours must be between $minHours and $maxHours';
    }
    final max = maxHoursFor(slot);
    if (slot != null && value > max) {
      return 'Work must end by 5 PM — max $max '
          '${max == 1 ? 'hour' : 'hours'} from ${slot.label}';
    }
    return null;
  }

  static String? description(String? value) {
    final description = value?.trim() ?? '';
    if (description.isEmpty) return 'Job description is required';
    if (description.length < minDescriptionLength) {
      return 'Description must be at least $minDescriptionLength characters';
    }
    if (description.length > maxDescriptionLength) {
      return 'Description must be at most $maxDescriptionLength characters';
    }
    return null;
  }
}
