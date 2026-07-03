
void FUN_10013ddc(undefined4 param_1)

{
  short sVar1;
  short sVar2;
  
  FUN_10014744(param_1);
  sVar2 = (short)param_1;
  *(undefined4 *)(sVar2 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + sVar2 * 4);
  *(undefined2 *)(sVar2 * 0x70 + 0x1003a9b2) = *(undefined2 *)(&DAT_1003a9b0 + sVar2 * 0x70);
  *(undefined2 *)(sVar2 * 0x70 + 0x1003a9e4) = 1;
  sVar1 = *(short *)(sVar2 * 0x70 + 0x1003a9e2);
  *(short *)(sVar2 * 0x70 + 0x1003a9e2) = sVar1 + 1;
  if (sVar1 == 0) {
    *(undefined2 *)(sVar2 * 0x70 + 0x1003a9be) = 0x5a;
  }
  if (*(char *)(sVar2 * 0x70 + 0x1003a9d0) == '\0') {
    sVar1 = *(short *)(sVar2 * 0x70 + 0x1003a9be) + 1;
    *(short *)(sVar2 * 0x70 + 0x1003a9be) = sVar1;
    if (0x5d < sVar1) {
      if (*(char *)(sVar2 * 0x70 + 0x1003a9ce) == '\0') {
        *(undefined2 *)(sVar2 * 0x70 + 0x1003a9cc) = 0;
      }
      else {
        *(undefined2 *)(sVar2 * 0x70 + 0x1003a9cc) = 1;
        *(undefined2 *)(sVar2 * 0x70 + 0x1003a9be) = 0x27;
      }
    }
  }
  else {
    *(undefined2 *)(sVar2 * 0x70 + 0x1003a9cc) = 2;
    *(undefined2 *)(sVar2 * 0x70 + 0x1003a9e2) = 0;
  }
  return;
}

