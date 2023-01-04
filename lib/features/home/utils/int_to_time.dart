extension NumToTime on Duration {
  String toTimeNonHour() {
    String h = inHours.remainder(24).toString();
    return '${(h != "0") ? '${h.padLeft(2, '0')}:' : ''}${inMinutes.remainder(60).toString().padLeft(2, '0')}:${inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }

  String toTimePadHour() {
    return '${inHours.remainder(24).toString().padLeft(2, '0')}:${inMinutes.remainder(60).toString().padLeft(2, '0')}:${inSeconds.remainder(60).toString().padLeft(2, '0')}';
  }
}
