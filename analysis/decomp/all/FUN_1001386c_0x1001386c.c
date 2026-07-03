
void FUN_1001386c(undefined4 param_1)

{
  char cVar1;
  short sVar2;
  
  FUN_10014744(param_1);
  FUN_10012554(param_1);
  sVar2 = (short)param_1;
  *(ushort *)(sVar2 * 0x70 + 0x1003a9b2) = *(ushort *)(&DAT_1003a9b0 + sVar2 * 0x70) & 0xfffc;
  *(undefined4 *)(sVar2 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + sVar2 * 4);
  if (*(short *)(sVar2 * 0x70 + 0x1003a9e4) == 1) {
    *(undefined2 *)(sVar2 * 0x70 + 0x1003a9be) = 0x3d;
  }
  else {
    *(undefined2 *)(sVar2 * 0x70 + 0x1003a9be) = 0x34;
  }
  *(short *)(sVar2 * 0x70 + 0x1003a9b4) = *(short *)(sVar2 * 0x70 + 0x1003a9b4) + 4;
  cVar1 = FUN_10012348(param_1);
  if (cVar1 != '\0') {
    FUN_100137f8(param_1);
    *(undefined2 *)(sVar2 * 0x70 + 0x1003a9cc) = 0;
  }
  return;
}

