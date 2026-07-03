
void FUN_1000744c(short param_1)

{
  undefined4 uVar1;
  undefined4 uVar2;
  int iVar3;
  short sVar4;
  short sStack0000001a;
  
  iVar3 = param_1 * 0x46;
  sVar4 = *(short *)(iVar3 + 0x10037e6c);
  *(short *)(iVar3 + 0x10037e6c) = sVar4 + -1;
  if (sVar4 < 1) {
    *(undefined2 *)(iVar3 + 0x10037e6c) = 0;
    if (*(short *)(iVar3 + 0x10037e4c) == 2) {
      sVar4 = *(short *)(iVar3 + 0x10037e56) + 1;
      *(short *)(iVar3 + 0x10037e56) = sVar4;
      if (0x16 < sVar4) {
        *(undefined2 *)(iVar3 + 0x10037e56) = 3;
      }
    }
    else {
      sVar4 = *(short *)(iVar3 + 0x10037e56) + -1;
      *(short *)(iVar3 + 0x10037e56) = sVar4;
      if (sVar4 < 3) {
        *(undefined2 *)(iVar3 + 0x10037e56) = 0x16;
      }
    }
    sStack0000001a = param_1;
    if (*(short *)(iVar3 + 0x10037e4c) == 2) {
      if (*(char *)(iVar3 + 0x10037e67) == '\0') {
        *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) + 4;
      }
      else {
        *(short *)(iVar3 + 0x10037e80) = *(short *)(iVar3 + 0x10037e5a) + 2;
        *(short *)(iVar3 + 0x10037e7e) = *(short *)(iVar3 + 0x10037e5a) + 0xe;
      }
      *(undefined1 *)(iVar3 + 0x10037e67) = 0;
      uVar1 = FUN_1002e6cc(*(short *)(iVar3 + 0x10037e58) + 0x10);
      uVar2 = FUN_1002e6f8(*(short *)(iVar3 + 0x10037e5a) + 8);
      if ((*(uint *)(&DAT_1003ad68 + (short)uVar1 * 0x3c + (short)uVar2 * 4) & 0x200) == 0) {
        *(short *)(iVar3 + 0x10037e82) = *(short *)(iVar3 + 0x10037e58) + 2;
        *(short *)(iVar3 + 0x10037e84) = *(short *)(iVar3 + 0x10037e58) + 0xe;
        *(undefined1 *)(iVar3 + 0x10037e66) = 1;
      }
      else {
        *(undefined1 *)(iVar3 + 0x10037e68) = 1;
        FUN_10027d84(uVar1,uVar2);
      }
    }
    else {
      if (*(char *)(iVar3 + 0x10037e67) == '\0') {
        *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) + -4;
      }
      else {
        *(short *)(iVar3 + 0x10037e80) = *(short *)(iVar3 + 0x10037e5a) + 2;
        *(short *)(iVar3 + 0x10037e7e) = *(short *)(iVar3 + 0x10037e5a) + 0xe;
      }
      *(undefined1 *)(iVar3 + 0x10037e67) = 0;
      uVar1 = FUN_1002e6cc(*(short *)(iVar3 + 0x10037e58) + -1);
      uVar2 = FUN_1002e6f8(*(short *)(iVar3 + 0x10037e5a) + 8);
      if ((*(uint *)(&DAT_1003ad68 + (short)uVar1 * 0x3c + (short)uVar2 * 4) & 0x200) == 0) {
        *(short *)(iVar3 + 0x10037e82) = *(short *)(iVar3 + 0x10037e58) + 2;
        *(short *)(iVar3 + 0x10037e84) = *(short *)(iVar3 + 0x10037e58) + 0xe;
        *(undefined1 *)(iVar3 + 0x10037e66) = 1;
      }
      else {
        *(undefined1 *)(iVar3 + 0x10037e68) = 1;
        FUN_10027ecc(uVar1,uVar2);
      }
    }
  }
  return;
}

