enum OpticsMode { plane, curved, refraction, lens, dispersion }

extension OpticsModeInfo on OpticsMode {
  String get title => switch (this) {
        OpticsMode.plane => 'Plane Mirror',
        OpticsMode.curved => 'Curved Mirrors',
        OpticsMode.refraction => 'Refraction & TIR',
        OpticsMode.lens => 'Thin Lenses',
        OpticsMode.dispersion => 'Prism Dispersion',
      };

  String get emoji => switch (this) {
        OpticsMode.plane => '🪞',
        OpticsMode.curved => '🔍',
        OpticsMode.refraction => '🌊',
        OpticsMode.lens => '👓',
        OpticsMode.dispersion => '🌈',
      };

  String get subtitle => switch (this) {
        OpticsMode.plane => 'Law of reflection',
        OpticsMode.curved => 'Concave & convex, ray tracing',
        OpticsMode.refraction => "Snell's law & total internal reflection",
        OpticsMode.lens => 'Convex & concave lens diagrams',
        OpticsMode.dispersion => 'White light into a spectrum',
      };

  String get tip => switch (this) {
        OpticsMode.plane => '💡 Drag the object on the canvas',
        OpticsMode.curved => '💡 Drag the yellow arrow tip',
        OpticsMode.lens => '💡 Drag the yellow arrow tip',
        OpticsMode.refraction => '💡 Drag the laser left/right',
        OpticsMode.dispersion => '💡 Adjust prism parameters below',
      };
}