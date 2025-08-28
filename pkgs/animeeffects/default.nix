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
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "AnimeEffectsDevs";
    repo = "AnimeEffects";
    rev = "v1.7";
    hash = "sha256-1LLzASyvvJnJVe/tU3iZBuvMEOyijrti7yv6y3wvDww=";
  };

  # TODO: Upstream this
  patches = [
    ./use-tmp-to-check-ffmpeg.patch
  ];

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = with qt6; [
    qt5compat
    qtmultimedia
    qtimageformats
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
