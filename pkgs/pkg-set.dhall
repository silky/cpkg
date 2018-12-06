let types = https://raw.githubusercontent.com/vmchale/cpkg/master/dhall/cpkg-types.dhall
in

let prelude = https://raw.githubusercontent.com/vmchale/cpkg/master/dhall/cpkg-prelude.dhall
in

let npth =
  λ(v : List Natural) →
    prelude.makeGnuExe { name = "npth", version = v } ⫽
      { pkgUrl = "https://gnupg.org/ftp/gcrypt/npth/npth-${prelude.showVersion v}.tar.bz2"
      }
in

let gnupg =
  λ(v : List Natural) →
    prelude.makeGnuExe { name = "gnupg", version = v } ⫽
      { pkgUrl = "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-${prelude.showVersion v}.tar.bz2"
      , pkgDeps = [ prelude.lowerBound { name = "npth", lower = [1,2] }
                  , prelude.lowerBound { name = "libgpg-error", lower = [1,24] }
                  , prelude.lowerBound { name = "libgcrypt", lower = [1,7,0] }
                  , prelude.lowerBound { name = "libassuan", lower = [2,5,0] }
                  , prelude.lowerBound { name = "libksba", lower = [1,3,4] }
                  ]
      }
in

let musl =
  let muslConfigure =
    λ(cfg : types.ConfigureVars) →
      prelude.mkExes [ "tools/install.sh" ] # prelude.defaultConfigure cfg
  in

  λ(v : List Natural) →
    prelude.defaultPackage ⫽
      { pkgName = "musl"
      , pkgVersion = v
      , pkgUrl = "https://www.musl-libc.org/releases/musl-${prelude.showVersion v}.tar.gz"
      , pkgSubdir = "musl-${prelude.showVersion v}"
      , configureCommand = muslConfigure
      }
in

[ gnupg [2,2,11]
, npth [1,6]
, musl [1,1,20]
]