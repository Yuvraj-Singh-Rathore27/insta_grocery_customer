/// Single source of truth for weights (vehicle payload capacity, load weight
/// the customer wants moved, …).
///
/// THE CANONICAL UNIT IS THE KILOGRAM. Every weight is stored and sent to the
/// backend as a plain number of kg — a 2-ton truck is 2000, a 150 kg tempo is
/// 150. The unit is NEVER part of the number: "1 Ton" sent to a float column
/// silently becomes 1, which is exactly the bug that was fixed in the driver
/// app. Convert to kg before sending; convert back only when displaying.
///
/// One Ton means one METRIC ton = 1000 kg, everywhere. The US short ton
/// (907 kg) must never creep in.
class WeightUnits {
  const WeightUnits._();

  static const double kgPerQuintal = 100;
  static const double kgPerTon = 1000; // metric, never 907

  /// Legacy dirty data: because of the old driver-app bug, a goods vehicle
  /// whose payload_capacity is below this was almost certainly typed as tons
  /// and stored unconverted (a "2 Ton" truck sitting in the column as 2).
  /// A real goods vehicle carrying under 50 kg does not exist, so anything
  /// below this on a goods vehicle is read back as tons for DISPLAY only —
  /// the stored value is not touched from here. The row is only truly fixed
  /// when the driver re-saves, or by the one-off backend cleanup.
  static const double goodsDirtyDataTonThreshold = 50;

  /// Reads a weight in kg out of whatever the API sent.
  ///
  /// Accepts a number (the correct shape) and tolerates a numeric string
  /// ("150", "150.00"). As a last resort it also reads a string that carries
  /// its unit inline ("2 Ton", "1.5 quintal") — that shape should never reach
  /// us and the backend ought to reject it, but parsing it beats rendering
  /// "Not available" over data we can clearly understand.
  static double? parseKg(dynamic raw) {
    if (raw == null) return null;
    if (raw is num) return raw.toDouble();

    final String text = raw.toString().trim();
    if (text.isEmpty) return null;

    final double? plain = double.tryParse(text);
    if (plain != null) return plain;

    final Match? number = RegExp(r'-?\d+(\.\d+)?').firstMatch(text);
    if (number == null) return null;

    final double? value = double.tryParse(number.group(0)!);
    if (value == null) return null;

    final String lower = text.toLowerCase();
    if (lower.contains('ton')) return value * kgPerTon;
    if (lower.contains('quintal')) return value * kgPerQuintal;
    return value;
  }

  /// Converts a customer-entered [value] in [unit] to the canonical kg that
  /// gets sent to the backend. Pair a plain number field with a unit dropdown
  /// and run the result through this — never send the unit text along.
  static double toKg(num value, WeightUnit unit) =>
      value.toDouble() * unit.kgFactor;

  /// Display string for a weight held in kg. Conversion happens HERE and
  /// nowhere else, so no two screens can disagree.
  ///
  /// 2000 → "2 Ton", 2500 → "2.5 Ton", 150 → "150 kg".
  ///
  /// [assumeTonsBelow] applies the legacy-data correction described on
  /// [goodsDirtyDataTonThreshold]; pass it only for goods vehicles, where a
  /// value that small cannot be a genuine kg reading. Returns null when there
  /// is no usable value, so callers can hide the row entirely rather than
  /// print "Not available".
  static String? format(dynamic raw, {double? assumeTonsBelow}) {
    double? kg = parseKg(raw);
    if (kg == null || kg <= 0) return null;

    if (assumeTonsBelow != null && kg < assumeTonsBelow) {
      kg = kg * kgPerTon;
    }

    if (kg >= kgPerTon) return "${_trim(kg / kgPerTon)} Ton";
    return "${_trim(kg)} kg";
  }

  /// Drops the noise off a formatted number: 2.00 → "2", 2.50 → "2.5".
  static String _trim(double value) {
    final String text = value.toStringAsFixed(2);
    return text.replaceFirst(RegExp(r'\.?0+$'), '');
  }
}

/// Units a customer may pick from when entering a weight. Storage is always
/// kg — this exists so the input can be converted, not so the choice can be
/// persisted alongside the number.
enum WeightUnit { kilogram, quintal, ton }

extension WeightUnitX on WeightUnit {
  double get kgFactor {
    switch (this) {
      case WeightUnit.kilogram:
        return 1;
      case WeightUnit.quintal:
        return WeightUnits.kgPerQuintal;
      case WeightUnit.ton:
        return WeightUnits.kgPerTon;
    }
  }

  String get label {
    switch (this) {
      case WeightUnit.kilogram:
        return "kg";
      case WeightUnit.quintal:
        return "Quintal";
      case WeightUnit.ton:
        return "Ton";
    }
  }
}
