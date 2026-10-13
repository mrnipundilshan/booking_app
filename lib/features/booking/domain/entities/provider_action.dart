import 'package:booking_app/features/booking/domain/entities/booking_status.dart';

enum ProviderAction {
  accept('Accept', from: BookingStatus.pending, to: BookingStatus.confirmed),
  reject('Reject', from: BookingStatus.pending, to: BookingStatus.rejected),
  start(
    'Start job',
    from: BookingStatus.confirmed,
    to: BookingStatus.inProgress,
  ),
  complete(
    'Mark complete',
    from: BookingStatus.inProgress,
    to: BookingStatus.completed,
  );

  const ProviderAction(this.label, {required this.from, required this.to});

  final String label;
  final BookingStatus from;
  final BookingStatus to;

  bool canApplyTo(BookingStatus status) => status == from;

  static List<ProviderAction> availableFor(BookingStatus status) =>
      values.where((a) => a.canApplyTo(status)).toList();
}
