
void FUN_10012228(undefined4 param_1)

{
  short sVar1;
  
  sVar1 = (short)param_1;
  if (*(char *)(sVar1 * 0x70 + 0x1003a9d8) == '\0') {
    FUN_10018a18(param_1);
    FUN_1002b020(0x21,100);
    *(undefined1 *)(sVar1 * 0x70 + 0x1003a9d8) = 1;
    *(undefined2 *)(sVar1 * 0x70 + 0x1003a9e2) = 0;
    *(short *)(sVar1 * 0x70 + 0x1003a9e4) = *(short *)(sVar1 * 0x70 + 0x1003a9b4) + -3;
    *(undefined2 *)(sVar1 * 0x70 + 0x1003a9be) = 0x75;
    *(undefined2 *)(sVar1 * 0x70 + 0x1003a9de) = 0xffff;
    *(undefined4 *)(sVar1 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + sVar1 * 4);
    *(ushort *)(sVar1 * 0x70 + 0x1003a9b2) = *(short *)(&DAT_1003a9b0 + sVar1 * 0x70) - 4U & 0xfffc;
  }
  return;
}

