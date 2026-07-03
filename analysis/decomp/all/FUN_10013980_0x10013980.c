
void FUN_10013980(undefined4 param_1)

{
  short sVar1;
  short sVar2;
  
  FUN_10014744(param_1);
  sVar2 = (short)param_1;
  *(ushort *)(&DAT_1003a9b0 + sVar2 * 0x70) = *(ushort *)(&DAT_1003a9b0 + sVar2 * 0x70) & 0xfffc;
  *(undefined2 *)(sVar2 * 0x70 + 0x1003a9b2) = *(undefined2 *)(&DAT_1003a9b0 + sVar2 * 0x70);
  if (*(char *)(sVar2 * 0x70 + 0x1003a9ce) != '\0') {
    *(undefined2 *)(sVar2 * 0x70 + 0x1003a9e4) = 1;
  }
  if (*(char *)(sVar2 * 0x70 + 0x1003a9cf) != '\0') {
    *(undefined2 *)(sVar2 * 0x70 + 0x1003a9e4) = 0xffff;
  }
  if (*(short *)(sVar2 * 0x70 + 0x1003a9e2) == 0) {
    *(short *)(sVar2 * 0x70 + 0x1003a9e2) = *(short *)(sVar2 * 0x70 + 0x1003a9e2) + 1;
    if (*(short *)(sVar2 * 0x70 + 0x1003a9e4) == 1) {
      *(undefined2 *)(sVar2 * 0x70 + 0x1003a9be) = 0x42;
    }
    else {
      *(undefined2 *)(sVar2 * 0x70 + 0x1003a9be) = 0x49;
    }
  }
  if (*(short *)(sVar2 * 0x70 + 0x1003a9e4) == 1) {
    if (*(char *)(sVar2 * 0x70 + 0x1003a9d0) == '\0') {
      sVar1 = *(short *)(sVar2 * 0x70 + 0x1003a9be) + 1;
      *(short *)(sVar2 * 0x70 + 0x1003a9be) = sVar1;
      if (sVar1 < 0x49) {
        *(undefined4 *)(sVar2 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + sVar2 * 4);
      }
      else {
        *(undefined2 *)(sVar2 * 0x70 + 0x1003a9cc) = 0;
      }
    }
    else {
      *(undefined2 *)(sVar2 * 0x70 + 0x1003a9cc) = 2;
      *(undefined2 *)(sVar2 * 0x70 + 0x1003a9e2) = 0;
    }
  }
  else if (*(char *)(sVar2 * 0x70 + 0x1003a9d0) == '\0') {
    sVar1 = *(short *)(sVar2 * 0x70 + 0x1003a9be) + -1;
    *(short *)(sVar2 * 0x70 + 0x1003a9be) = sVar1;
    if (sVar1 < 0x43) {
      *(undefined2 *)(sVar2 * 0x70 + 0x1003a9cc) = 0;
    }
    else {
      *(undefined4 *)(sVar2 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + sVar2 * 4);
    }
  }
  else {
    *(undefined2 *)(sVar2 * 0x70 + 0x1003a9cc) = 2;
    *(undefined2 *)(sVar2 * 0x70 + 0x1003a9e2) = 0;
  }
  return;
}

