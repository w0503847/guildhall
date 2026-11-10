/// The three party roles used for 5-player dungeon groups.
///
/// Declared in priority order (tank, healer, dps) because tanks and healers
/// are the hardest slots to fill, so code that loops over [Role.values]
/// naturally checks the scarce roles first.
enum Role {
  tank('Tank'),
  healer('Healer'),
  dps('DPS');

  const Role(this.label);

  /// Human-readable name shown in the UI.
  final String label;
}
