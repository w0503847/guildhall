import 'role.dart';

/// Playable classes, each with the party roles it is able to fill.
enum WowClass {
  druid('Druid', {Role.tank, Role.healer, Role.dps}),
  hunter('Hunter', {Role.dps}),
  mage('Mage', {Role.dps}),
  paladin('Paladin', {Role.tank, Role.healer, Role.dps}),
  priest('Priest', {Role.healer, Role.dps}),
  rogue('Rogue', {Role.dps}),
  shaman('Shaman', {Role.healer, Role.dps}),
  warlock('Warlock', {Role.dps}),
  warrior('Warrior', {Role.tank, Role.dps});

  const WowClass(this.label, this.possibleRoles);

  final String label;

  /// Roles this class can reasonably play. The character form only offers
  /// these roles, so a Mage can never be saved as a tank.
  final Set<Role> possibleRoles;
}
