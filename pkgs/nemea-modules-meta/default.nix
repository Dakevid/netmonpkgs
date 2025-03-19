{
  pkgs,
  nemea-modules,
  nemea-modules-ng,
  decrypto
}:

pkgs.symlinkJoin {
  name = "nemea-modules-meta";
  paths = [ nemea-modules nemea-modules-ng decrypto ];
}
