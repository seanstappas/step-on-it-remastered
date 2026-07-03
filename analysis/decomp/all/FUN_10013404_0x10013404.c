
void FUN_10013404(undefined4 param_1)

{
  char cVar1;
  short sVar2;
  short sVar3;
  
  FUN_10014744(param_1);
  sVar3 = (short)param_1;
  if (*(short *)(sVar3 * 0x70 + 0x1003a9e2) == 0) {
    cVar1 = FUN_10012444(param_1);
    if (cVar1 == '\0') {
      *(undefined2 *)(sVar3 * 0x70 + 0x1003a9cc) = 4;
      return;
    }
    if (*(short *)(sVar3 * 0x70 + 0x1003a9e4) == 1) {
      *(undefined2 *)(sVar3 * 0x70 + 0x1003a9c0) = 0x85;
    }
    else {
      *(undefined2 *)(sVar3 * 0x70 + 0x1003a9c0) = 0x7e;
    }
  }
  if (*(short *)(sVar3 * 0x70 + 0x1003a9e2) < 8) {
    cVar1 = FUN_10012444(param_1);
    if (cVar1 == '\0') {
      *(undefined2 *)(sVar3 * 0x70 + 0x1003a9e2) = 0xc;
    }
  }
  else {
    FUN_10012554(param_1);
  }
  sVar2 = *(short *)(sVar3 * 0x70 + 0x1003a9e2) + 1;
  *(short *)(sVar3 * 0x70 + 0x1003a9e2) = sVar2;
  if (0x11 < sVar2) {
    *(undefined2 *)(sVar3 * 0x70 + 0x1003a9e2) = 0x11;
  }
  *(short *)(sVar3 * 0x70 + 0x1003a9b4) =
       *(short *)(sVar3 * 0x70 + 0x1003a9b4) +
       *(short *)(&DAT_1003474c + *(short *)(sVar3 * 0x70 + 0x1003a9e2) * 2);
  *(short *)(sVar3 * 0x70 + 0x1003a9c0) = *(short *)(sVar3 * 0x70 + 0x1003a9c0) + 1;
  if (*(char *)(sVar3 * 0x70 + 0x1003a9ce) == '\0') {
    if ((*(char *)(sVar3 * 0x70 + 0x1003a9cf) != '\0') &&
       (cVar1 = FUN_100126c8(param_1), cVar1 != '\0')) {
      *(short *)(&DAT_1003a9b0 + sVar3 * 0x70) = *(short *)(&DAT_1003a9b0 + sVar3 * 0x70) + -2;
      *(ushort *)(sVar3 * 0x70 + 0x1003a9b2) = *(ushort *)(&DAT_1003a9b0 + sVar3 * 0x70) & 0xfffc;
    }
  }
  else {
    cVar1 = FUN_100127e0(param_1);
    if (cVar1 != '\0') {
      *(short *)(&DAT_1003a9b0 + sVar3 * 0x70) = *(short *)(&DAT_1003a9b0 + sVar3 * 0x70) + 2;
      *(ushort *)(sVar3 * 0x70 + 0x1003a9b2) = *(ushort *)(&DAT_1003a9b0 + sVar3 * 0x70) & 0xfffc;
    }
  }
  if (*(short *)(sVar3 * 0x70 + 0x1003a9e4) == 1) {
    if (0x8d < *(short *)(sVar3 * 0x70 + 0x1003a9c0)) {
      *(undefined2 *)(sVar3 * 0x70 + 0x1003a9c0) = 0x86;
    }
  }
  else if (0x85 < *(short *)(sVar3 * 0x70 + 0x1003a9c0)) {
    *(undefined2 *)(sVar3 * 0x70 + 0x1003a9c0) = 0x7e;
  }
  if ((0xc < *(short *)(sVar3 * 0x70 + 0x1003a9e2)) &&
     (cVar1 = FUN_10012348(param_1), cVar1 != '\0')) {
    FUN_100137f8(param_1);
    *(undefined2 *)(sVar3 * 0x70 + 0x1003a9cc) = 0;
    if ((*(char *)(sVar3 * 0x70 + 0x1003a9ce) != '\0') ||
       (*(char *)(sVar3 * 0x70 + 0x1003a9cf) != '\0')) {
      *(undefined2 *)(sVar3 * 0x70 + 0x1003a9cc) = 1;
      *(undefined2 *)(sVar3 * 0x70 + 0x1003a9e2) = 0;
    }
  }
  *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = *(undefined2 *)(sVar3 * 0x70 + 0x1003a9c0);
  if ((*(ushort *)(&DAT_1003a9b0 + sVar3 * 0x70) & 2) != 0) {
    *(short *)(sVar3 * 0x70 + 0x1003a9be) = *(short *)(sVar3 * 0x70 + 0x1003a9be) + 0x10;
  }
  if (0x1ca < *(short *)(sVar3 * 0x70 + 0x1003a9b4)) {
    *(short *)(sVar3 * 0x70 + 0x1003a9b4) = *(short *)(sVar3 * 0x70 + 0x1003a9b4) + -0x140;
  }
  return;
}

