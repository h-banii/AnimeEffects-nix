{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  ninja,

  wrapQtAppsHook,
  qt5compat,
  qtmultimedia,
  qtimageformats,
  qtwayland,

  ffmpeg,
  withFfmpeg ? true,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "animeeffects";
  version = "1.7.0-unstable-2025-09-03";

  src = fetchFromGitHub {
    owner = "AnimeEffectsDevs";
    repo = "AnimeEffects";
    rev = "24bdd2c6a9b6889caa48828f7b93d0074a337558";
    hash = "sha256-H0+39jkmspes0/eLzmfeigVoMAVytilreNdF4U3gnlY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    wrapQtAppsHook
  ];

  buildInputs = [
    qt5compat
    qtmultimedia
    qtimageformats
    qtwayland
  ];

  installPhase = ''
    runHook preInstall

    pushd src/gui
    mkdir -p $out/bin
    cp -pr --reflink=auto -- AnimeEffects $out/bin
    cp -pr --reflink=auto -- data $out/bin/data
    popd

    install -Dm444 {../dist,"$out/share/icons/hicolor/256x256/apps"}/AnimeEffects.png
    install -Dm444 {../dist,"$out/share/applications"}/AnimeEffects.desktop

    runHook postInstall
  '';

  qtWrapperArgs = lib.optional withFfmpeg "--prefix PATH : ${lib.makeBinPath [ ffmpeg ]}";

  meta = {
    license = lib.licenses.gpl3Only;
    description = "2D Animation Tool";
    mainProgram = "AnimeEffects";
  };
})
