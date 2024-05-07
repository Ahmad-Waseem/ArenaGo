
class BookingInfo {
  final String bookingId;
  final String arenaId;
  final String fieldId;
  final String image;
  final int price;
  final DateTime timestamp;
  final SelectedTimeSlot selectedTimeSlot;
  final String userId;


  BookingInfo({
    required this.bookingId,
    required this.arenaId,
    required this.fieldId,
    required this.image,
    required this.price,
    required this.timestamp,
    required this.selectedTimeSlot,
    required this.userId,
  });
}

class SelectedTimeSlot {
  final DateTime startTime;
  final DateTime endTime;

  SelectedTimeSlot({
    required this.startTime,
    required this.endTime,
  });
}
