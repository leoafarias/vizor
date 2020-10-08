import 'dart:async';

String _replaceCharAt(String oldString, int index, String newChar) {
  final start = oldString.substring(0, index);
  final end = oldString.substring(index + 1);
  return start + newChar + end;
}

String _removeLastChar(String str) {
  return str.substring(0, str.length - 1);
}

/// Typing effect
class TextTypingController {
  /// Callback function for update
  final Function(String) _fn;

  final _emptyText = ' ';

  bool _cancel = false;

  /// Current text displayed
  String _data;

  /// Delay between letters
  Duration _delay;

  /// Total animation duration
  final Duration _duration;

  /// Constructor
  TextTypingController(Function(String) fn, {Duration duration})
      : _fn = fn,
        _duration = duration ?? const Duration(milliseconds: 500);

  // Create delay based on text length
  Duration _calculateDelay(String text) {
    final steps = text.length * 2;
    // Convert to int
    final delayInMicroSeconds = _duration.inMicroseconds ~/ steps;
    return Duration(microseconds: delayInMicroSeconds);
  }

  void dispose() {
    _cancel = true;
  }

  /// Sets initial text
  void setData(String newText, {bool removeFirst = false}) async {
    _delay = _calculateDelay(newText);

    // Remove data first
    if (removeFirst) await removeData();

    /// Removes text
    /// Needs to have length > 0

    _data = ' ';
    await _update();

    final chars = newText.split('');

    for (var i = 0; i < chars.length; i++) {
      // final start = '$currentText█';
      // final end = '$currentText${chars[i]}';

      await _update();
      _data = _replaceCharAt(_data, i, chars[i]);
      if (i < chars.length - 1) {
        _data = '$_data█';
      }
      await _update();
    }
  }

  /// Removes text
  Future<void> removeData() async {
    for (var i = _data.length - 1; i >= 0; i--) {
      // Return if its empty
      if (_data.isEmpty) return;
      _data = _replaceCharAt(_data, i, '█');
      // One less delay when removing so * 2
      await Future.delayed(_delay * 2, _update);

      // Remove character for next run
      _data = _removeLastChar(_data);
      // If no more charactersto remove update
      if (i == 0) {
        await _update();
        _data = _emptyText;
      }
    }
  }

  /// Updates text
  Future<void> _update() async {
    if (_cancel) return;
    await Future.delayed(_delay, _fn(_data));
  }
}
