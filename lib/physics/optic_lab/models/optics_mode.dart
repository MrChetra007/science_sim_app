import '../../../../l10n/generated/app_localizations.dart';

enum OpticsMode { plane, curved, refraction, lens, dispersion }

extension OpticsModeInfo on OpticsMode {
  /// Modes gated behind the Scientific Pro subscription.
  /// Plane Mirror, Curved Mirrors and Thin Lenses are Pro features;
  /// Refraction & Prism Dispersion remain free.
  bool get isPro => switch (this) {
        OpticsMode.plane => true,
        OpticsMode.curved => true,
        OpticsMode.refraction => false,
        OpticsMode.lens => true,
        OpticsMode.dispersion => false,
      };

  String title(AppLocalizations l10n) => switch (this) {
        OpticsMode.plane => l10n.opticModePlaneTitle,
        OpticsMode.curved => l10n.opticModeCurvedTitle,
        OpticsMode.refraction => l10n.opticModeRefractionTitle,
        OpticsMode.lens => l10n.opticModeLensTitle,
        OpticsMode.dispersion => l10n.opticModeDispersionTitle,
      };

  String get emoji => switch (this) {
        OpticsMode.plane => '🪞',
        OpticsMode.curved => '🔍',
        OpticsMode.refraction => '🌊',
        OpticsMode.lens => '👓',
        OpticsMode.dispersion => '🌈',
      };

  String subtitle(AppLocalizations l10n) => switch (this) {
        OpticsMode.plane => l10n.opticModePlaneSubtitle,
        OpticsMode.curved => l10n.opticModeCurvedSubtitle,
        OpticsMode.refraction => l10n.opticModeRefractionSubtitle,
        OpticsMode.lens => l10n.opticModeLensSubtitle,
        OpticsMode.dispersion => l10n.opticModeDispersionSubtitle,
      };

  String tip(AppLocalizations l10n) => switch (this) {
        OpticsMode.plane => l10n.opticModePlaneTip,
        OpticsMode.curved => l10n.opticModeCurvedTip,
        OpticsMode.lens => l10n.opticModeLensTip,
        OpticsMode.refraction => l10n.opticModeRefractionTip,
        OpticsMode.dispersion => l10n.opticModeDispersionTip,
      };
}