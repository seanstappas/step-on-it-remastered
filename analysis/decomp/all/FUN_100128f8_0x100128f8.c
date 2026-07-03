
void FUN_100128f8(undefined4 param_1)

{
  char cVar1;
  short sVar2;
  
  FUN_10014744(param_1);
  sVar2 = (short)param_1;
  *(undefined4 *)(sVar2 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + sVar2 * 4);
  *(ushort *)(&DAT_1003a9b0 + sVar2 * 0x70) = *(ushort *)(&DAT_1003a9b0 + sVar2 * 0x70) & 0xfffc;
  *(undefined2 *)(sVar2 * 0x70 + 0x1003a9b2) = *(undefined2 *)(&DAT_1003a9b0 + sVar2 * 0x70);
  if (*(short *)(sVar2 * 0x70 + 0x1003a9e4) == 1) {
    *(undefined2 *)(sVar2 * 0x70 + 0x1003a9be) = 0x3d;
  }
  else {
    *(undefined2 *)(sVar2 * 0x70 + 0x1003a9be) = 0x34;
  }
  cVar1 = FUN_10012348(param_1);
  if (cVar1 == '\0') {
    *(undefined2 *)(sVar2 * 0x70 + 0x1003a9cc) = 3;
  }
  else if (*(char *)(sVar2 * 0x70 + 0x1003a9d0) == '\0') {
    if (*(char *)(sVar2 * 0x70 + 0x1003a9ce) == '\0') {
      if (*(char *)(sVar2 * 0x70 + 0x1003a9cf) == '\0') {
        FUN_100137f8(param_1);
        *(undefined4 *)(sVar2 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + sVar2 * 4);
        *(ushort *)(&DAT_1003a9b0 + sVar2 * 0x70) =
             *(ushort *)(&DAT_1003a9b0 + sVar2 * 0x70) & 0xfffc;
        *(undefined2 *)(sVar2 * 0x70 + 0x1003a9b2) = *(undefined2 *)(&DAT_1003a9b0 + sVar2 * 0x70);
      }
      else {
        FUN_100137f8(param_1);
        if (*(short *)(sVar2 * 0x70 + 0x1003a9e4) == -1) {
          *(undefined2 *)(sVar2 * 0x70 + 0x1003a9cc) = 1;
          *(undefined2 *)(sVar2 * 0x70 + 0x1003a9e2) = 0;
        }
        else {
          *(undefined2 *)(sVar2 * 0x70 + 0x1003a9cc) = 10;
          *(undefined2 *)(sVar2 * 0x70 + 0x1003a9e2) = 0;
          *(undefined2 *)(sVar2 * 0x70 + 0x1003a9e4) = 0xffff;
        }
      }
    }
    else {
      FUN_100137f8(param_1);
      if (*(short *)(sVar2 * 0x70 + 0x1003a9e4) == 1) {
        *(undefined2 *)(sVar2 * 0x70 + 0x1003a9cc) = 1;
        *(undefined2 *)(sVar2 * 0x70 + 0x1003a9e2) = 0;
      }
      else {
        *(undefined2 *)(sVar2 * 0x70 + 0x1003a9cc) = 9;
        *(undefined2 *)(sVar2 * 0x70 + 0x1003a9e2) = 0;
        *(undefined2 *)(sVar2 * 0x70 + 0x1003a9e4) = 1;
      }
    }
  }
  else {
    FUN_100137f8(param_1);
    *(undefined2 *)(sVar2 * 0x70 + 0x1003a9cc) = 2;
    *(undefined2 *)(sVar2 * 0x70 + 0x1003a9e2) = 0;
  }
  return;
}

