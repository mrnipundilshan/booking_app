enum BookingStatus {
  pending('Pending', isUpcoming: true),
  confirmed('Confirmed', isUpcoming: true),
  inProgress('In Progress', isUpcoming: true),
  completed('Completed', isUpcoming: false),
  cancelled('Cancelled', isUpcoming: false),
  rejected('Rejected', isUpcoming: false);

  const BookingStatus(this.label, {required this.isUpcoming});

  final String label;
  final bool isUpcoming;
}
