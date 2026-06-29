enum CalculationMethodEntity {
  muslimWorldLeague,
  egyptian,
  karachi,
  ummAlQura,
  dubai,
  moonSightingCommittee,
  northAmerica,
  kuwait,
  qatar,
  singapore,
  tehran,
  turkey,
  other;

  String get nameInAdhan {
    return switch (this) {
      CalculationMethodEntity.muslimWorldLeague => 'muslim_world_league',
      CalculationMethodEntity.egyptian => 'egyptian',
      CalculationMethodEntity.karachi => 'karachi',
      CalculationMethodEntity.ummAlQura => 'umm_al_qura',
      CalculationMethodEntity.dubai => 'dubai',
      CalculationMethodEntity.moonSightingCommittee =>
        'moon_sighting_committee',
      CalculationMethodEntity.northAmerica => 'north_america',
      CalculationMethodEntity.kuwait => 'kuwait',
      CalculationMethodEntity.qatar => 'qatar',
      CalculationMethodEntity.singapore => 'singapore',
      CalculationMethodEntity.tehran => 'tehran',
      CalculationMethodEntity.turkey => 'turkey',
      CalculationMethodEntity.other => 'other',
    };
  }
}

enum MadhabEntity {
  shafi,
  hanafi;

  String get nameInAdhan {
    return switch (this) {
      MadhabEntity.shafi => 'shafi',
      MadhabEntity.hanafi => 'hanafi',
    };
  }
}
