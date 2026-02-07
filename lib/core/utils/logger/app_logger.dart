import 'dart:developer' show log;

/// Enhanced logger with colors, icons, and blinking effects
class AppLogger {
  // ANSI escape codes
  static const _reset = '\x1B[0m';
  static const _blink = '\x1B[5m';
  static const _bold = '\x1B[1m';
  static const _underline = '\x1B[4m';

  // Color codes
  static const _magenta = '\x1B[35m';
  static const _yellow = '\x1B[33m';
  static const _green = '\x1B[32m';
  static const _red = '\x1B[31m';
  static const _white = '\x1B[37m';
  static const _cyan = '\x1B[36m';
  static const _brightRed = '\x1B[91m';
  static const _brightYellow = '\x1B[93m';
  static const _brightGreen = '\x1B[92m';

  // Background colors
  static const _bgRed = '\x1B[41m';
  static const _bgYellow = '\x1B[43m';
  static const _bgGreen = '\x1B[42m';

  // Basic colors
  static void magenta(String message) {
    log('$_magenta$message$_reset');
  }

  static void yellow(String message) {
    log('$_yellow$message$_reset');
  }

  static void green(String message) {
    log('$_green$message$_reset');
  }

  static void red(String message) {
    log('$_red$message$_reset');
  }

  static void white(String message) {
    log('$_white$message$_reset');
  }

  static void cyan(String message) {
    log('$_cyan$message$_reset');
  }

  // Enhanced status methods

  /// Success message with green checkmark and bold text
  static void success(String message) {
    log('$_bold$_brightGreen✓ SUCCESS: $message$_reset');
  }

  /// Success with background highlight
  static void successHighlight(String message) {
    log('$_bgGreen$_white$_bold ✓ $message $_reset');
  }

  /// Warning message with yellow exclamation and blinking effect
  static void warning(String message) {
    log('$_blink$_bold$_brightYellow⚠ WARNING: $message$_reset');
  }

  /// Warning with background (no blink for better readability)
  static void warningHighlight(String message) {
    log('$_bgYellow$_white$_bold ⚠ $message $_reset');
  }

  /// Error message with red X and blinking effect
  static void error(String message) {
    log('$_blink$_bold$_brightRed✗ ERROR: $message$_reset');
  }

  /// Critical error with background and blinking
  static void errorCritical(String message) {
    log('$_blink$_bgRed$_white$_bold ✗ CRITICAL: $message $_reset');
  }

  /// Error with underline (no blink)
  static void errorUnderline(String message) {
    log('$_bold$_underline$_brightRed✗ ERROR: $message$_reset');
  }

  // Additional utility methods

  /// Info message with cyan color
  static void info(String message) {
    log('$_cyan$_bold ℹ INFO: $message$_reset');
  }

  /// Debug message with magenta color
  static void debug(String message) {
    log('$_magenta🔍 DEBUG: $message$_reset');
  }

  /// Separator line
  static void separator([String char = '=']) {
    log('$_white${char * 60}$_reset');
  }

  /// Header with box
  static void header(String title) {
    separator();
    log('$_bold$_cyan  $title$_reset');
    separator();
  }
}
