{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,
  qt6,
  ffmpeg,
  withFfmpeg ? true,
}:
stdenv.mkDerivation {
  pname = "animeeffects";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "AnimeEffectsDevs";
    repo = "AnimeEffects";
    rev = "v1.6";
    hash = "sha256-YTtLa4v5jXAE+62F9dmkkBE4MRGSM3CTMuMrNoQE6Gc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs =
    with qt6;
    [
      qtbase
      qt5compat
      qtmultimedia
      qtimageformats
    ]
    ++ lib.optionals withFfmpeg [
      ffmpeg
    ];

  propagateBuildInputs = with qt6; [
    qtsvg
  ];

  hardeningDisable = [ "format" ];

  installPhase = ''
    runHook preInstall

    pushd src/gui
    mkdir -p $out/bin
    cp -pr --reflink=auto -- AnimeEffects $out/bin
    cp -pr --reflink=auto -- data $out/bin/data
    popd

    icon_out=$out/share/icons/hicolor/256x256/apps
    mkdir -p $icon_out
    install -Dm0644 ../dist/AnimeEffects.png "$icon_out/AnimeEffects.png"

    desktop_entry_out=$out/share/applications
    mkdir -p $desktop_entry_out
    install -Dm0655 ../dist/AnimeEffects.desktop "$desktop_entry_out/AnimeEffects.desktop"

    runHook postInstall
  '';

  meta = {
    license = lib.licenses.gpl3Only;
    description = "2D Animation Tool";
    mainProgram = "AnimeEffects";
  };
}
