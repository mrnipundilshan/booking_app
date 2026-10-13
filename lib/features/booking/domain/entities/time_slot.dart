enum TimeSlot {
  slot8to10(8, '8–10 AM'),
  slot10to12(10, '10–12 PM'),
  slot1to3(13, '1–3 PM'),
  slot3to5(15, '3–5 PM');

  const TimeSlot(this.startHour, this.label);

  final int startHour;
  final String label;
}
