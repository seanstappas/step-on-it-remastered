
void FUN_1002b060(undefined2 param_1)

{
  short sVar1;
  
  for (sVar1 = 1; sVar1 < 3; sVar1 = sVar1 + 1) {
    if (DAT_1003935c == '\0') {
      *(undefined4 *)(sVar1 * 0x70 + 0x1003a9ec) = 0;
      *(undefined2 *)(sVar1 * 0x70 + 0x1003a9f6) = 2;
      *(undefined2 *)(sVar1 * 0x70 + 0x1003a9fa) = 1;
      *(undefined2 *)(sVar1 * 0x70 + 0x1003a9fc) = 1;
      *(undefined1 *)(sVar1 * 0x70 + 0x1003a9db) = 0;
      *(undefined1 *)(sVar1 * 0x70 + 0x1003a9f8) = 1;
      *(undefined2 *)(sVar1 * 0x70 + 0x1003a9e8) = param_1;
    }
  }
  if ((DAT_100370e4 == '\0') && (DAT_1003935c == '\0')) {
    uRam1003aa66 = 4;
    uRam1003aad6 = 0xffff;
    uRam1003aa6a = 2;
    uRam1003aa6c = 2;
  }
  DAT_1003935c = 0;
  return;
}

