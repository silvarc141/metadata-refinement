{
  stdenv,
  git,
  automake,
  autoconf,
  libtool,
  libgcc,
  pkg-config,
  zlib,
  fetchFromGitHub,
}: stdenv.mkDerivation rec {
  pname = "bwfmetaedit";
  version = "v24.10";

  src = fetchFromGitHub { 
    owner = "MediaArea";
    repo = "BWFMetaEdit";
    rev = version;
    hash = "sha256-FPkuysprIJbvb8lRrGJjsW6ZqohqtjADRo4VhSS2oMw=";
  };

  buildInputs = [
    git 
    automake
    autoconf
    libtool
    pkg-config
    libgcc
    zlib
  ];

  buildPhase = ''
    cd Project/GNU/CLI
    ./autogen.sh
    ./configure --prefix=$out
    make
  '';

  installPhase = ''
    make install
  '';
}
