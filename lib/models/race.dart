/// Playable races. The prototype assumes an Alliance guild, plus the new
/// Skyborne race, which can join either faction in WoW: Forever.
enum Race {
  human('Human'),
  dwarf('Dwarf'),
  nightElf('Night Elf'),
  gnome('Gnome'),
  skyborne('Skyborne');

  const Race(this.label);

  final String label;
}
