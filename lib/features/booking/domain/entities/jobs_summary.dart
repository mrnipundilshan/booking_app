import 'package:booking_app/features/booking/domain/entities/booking_cost.dart';
import 'package:booking_app/features/booking/domain/entities/booking_entity.dart';
import 'package:booking_app/features/booking/domain/entities/booking_status.dart';

class JobsSummary {
  const JobsSummary({required this.pendingCount, required this.totalEarnings});

  factory JobsSummary.from(
    List<BookingEntity> jobs, {
    required int hourlyRate,
  }) {
    return JobsSummary(
      pendingCount: jobs.where((j) => j.status == BookingStatus.pending).length,
      totalEarnings: jobs
          .where((j) => j.status == BookingStatus.completed)
          .fold(
            0,
            (sum, j) =>
                sum +
                BookingCost.calculate(
                  hourlyRate: hourlyRate,
                  hours: j.estimatedHours,
                  date: j.date,
                ).total,
          ),
    );
  }

  final int pendingCount;
  final double totalEarnings;
}
