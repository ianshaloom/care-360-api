import 'dart:math';

/// A class representing a successful response.
class SuccessResponse {
  /// List of success messages for clock in response.
  static final List<String> clockInSuccessMessages = [
    'You’re now clocked in. Have a great shift!',
    'Welcome! Hope you have a smooth and successful shift today.',
    'Let’s get it! Wishing you a great shift ahead.',
    'You’re now clocked in. Enjoy your shift!',
    'Clocked in and ready to roll. You’ve got this!',
    'You’re now clocked in. Have a productive shift!',
  ];

  /// List of success messages for clock out response.
  static final List<String> clockOutSuccessMessages = [
    'Thanks for wrapping up your shift. Have a safe trip home!',
    'You’re all clocked out. Time to head home—safe travels!',
    'Great work today! Get home safe and take care.',
    'Clocked out and ready to relax. You’ve earned it!',
    'You’re now clocked out. Enjoy your time off!',
    'Shift complete! Don’t forget to rest—and travel safely!',
  ];

  /// List of success messages for accepting a shift.
  static final List<String> acceptShiftSuccessMessages = [
    'You have successfully accepted the shift.',
    'Shift accepted! You’re all set to go.',
    'Great choice! You’ve accepted the shift.',
    'Shift accepted. Looking forward to seeing you there!',
    'You’re all set! Shift accepted successfully.',
    'Shift accepted. Let’s make it a great one!',
  ];

  /// a static getter to get a random success message for clock in
  static String get clockInSuccessMessage {
    final random = Random();
    final index = random.nextInt(6);
    return clockInSuccessMessages[index];
  }

  /// a static getter to get a random success message for clock out
  static String get clockOutSuccessMessage {
    final random = Random();
    final index = random.nextInt(6);
    return clockOutSuccessMessages[index];
  }

  /// a static getter to get a random success message for accepting a shift
  static String get acceptShiftSuccessMessage {
    final random = Random();
    final index = random.nextInt(6);
    return acceptShiftSuccessMessages[index];
  }
}
