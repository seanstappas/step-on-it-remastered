
void FUN_1000c2e8(undefined4 param_1)

{
  short sVar1;
  short sVar2;
  int iVar3;
  
  iVar3 = (short)param_1 * 0x46;
  if (*(char *)(iVar3 + 0x10037e67) == '\0') {
    sVar1 = *(short *)(iVar3 + 0x10037e6c);
    *(short *)(iVar3 + 0x10037e6c) = sVar1 + -1;
    if (sVar1 < 1) {
      *(undefined1 *)(iVar3 + 0x10037e66) = 1;
      if (*(short *)(iVar3 + 0x10037e6e) == 1) {
        *(undefined2 *)(iVar3 + 0x10037e6c) = 5;
        if (*(short *)(iVar3 + 0x10037e56) < 0x11) {
          *(short *)(iVar3 + 0x10037e56) = *(short *)(iVar3 + 0x10037e56) + 1;
        }
        else {
          *(undefined2 *)(iVar3 + 0x10037e6e) = 3;
          *(short *)(iVar3 + 0x10037e70) = (short)((*(short *)(iVar3 + 0x10037e4e) * 6) / 5);
        }
      }
      else if (*(short *)(iVar3 + 0x10037e6e) == 3) {
        *(undefined2 *)(iVar3 + 0x10037e6c) = 3;
        *(undefined2 *)(iVar3 + 0x10037e56) = 0x10;
        sVar1 = *(short *)(iVar3 + 0x10037e70) + -1;
        *(short *)(iVar3 + 0x10037e70) = sVar1;
        if (sVar1 < 1) {
          *(undefined2 *)(iVar3 + 0x10037e6e) = 2;
        }
      }
      else {
        if (*(short *)(iVar3 + 0x10037e6e) != 2) {
          return;
        }
        *(undefined2 *)(iVar3 + 0x10037e6c) = 3;
        if (*(short *)(iVar3 + 0x10037e56) < 0x41) {
          *(short *)(iVar3 + 0x10037e56) = *(short *)(iVar3 + 0x10037e56) + 1;
        }
        else {
          *(undefined2 *)(iVar3 + 0x10037e6e) = 3;
          *(short *)(iVar3 + 0x10037e70) = (short)((*(short *)(iVar3 + 0x10037e50) * 6) / 5);
          *(undefined2 *)(iVar3 + 0x10037e56) = 0x10;
          FUN_1000c8bc(*(short *)(iVar3 + 0x10037e58) + 0x1e,*(short *)(iVar3 + 0x10037e5a) + -8,1,
                       param_1);
        }
      }
      *(short *)(iVar3 + 0x10037e82) = *(short *)(iVar3 + 0x10037e58) + 9;
      *(short *)(iVar3 + 0x10037e84) = *(short *)(iVar3 + 0x10037e58) + 0x19;
      *(short *)(iVar3 + 0x10037e80) = *(short *)(iVar3 + 0x10037e5a) + 6;
      *(short *)(iVar3 + 0x10037e7e) = *(short *)(iVar3 + 0x10037e5a) + 0x1e;
    }
  }
  else {
    *(undefined1 *)(iVar3 + 0x10037e67) = 0;
    *(undefined2 *)(iVar3 + 0x10037e6c) = 2;
    *(undefined2 *)(iVar3 + 0x10037e6e) = 1;
    *(undefined4 *)(iVar3 + 0x10037e52) = uRam1003a348;
    *(undefined4 *)(iVar3 + 0x10037e5c) = 0;
    *(undefined2 *)(iVar3 + 0x10037e56) = 1;
    sVar1 = FUN_1002e6f8((int)*(short *)(iVar3 + 0x10037e5a));
    sVar2 = FUN_1002e6cc((int)*(short *)(iVar3 + 0x10037e58));
    *(undefined4 *)(&DAT_1003ad68 + sVar2 * 0x3c + sVar1 * 4) = 0x40d;
    *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e5a) + -0x30;
    *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) + -0x10;
    *(undefined1 *)(iVar3 + 0x10037e66) = 1;
    *(undefined2 *)(iVar3 + 0x10037e8a) = 1000;
  }
  return;
}

