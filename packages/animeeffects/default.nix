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
stdenv.mkDerivation (finalAttrs: {
  pname = "animeeffects";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "AnimeEffectsDevs";
    repo = "AnimeEffects";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cOtAMsvbQM+KfsUWw059RteJgWv0gIKFUNZhOneVp5w=";
  };

  # TODO: Add patch to use tmpdir instead of removing checks
  # TODO: Upstream, if possible
  patches = lib.optional withFfmpeg ./ignore-ffmpeg-checks.patch;

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
    ++ lib.optional withFfmpeg ffmpeg;

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
})
