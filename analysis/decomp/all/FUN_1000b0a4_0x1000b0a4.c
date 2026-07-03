
void FUN_1000b0a4(short param_1)

{
  undefined4 uVar1;
  undefined4 uVar2;
  int iVar3;
  short sVar4;
  short sVar5;
  short sStack0000001a;
  
  iVar3 = param_1 * 0x46;
  if (*(short *)(iVar3 + 0x10037e8a) == 1) {
    sVar4 = *(short *)(iVar3 + 0x10037e56) + 1;
    *(short *)(iVar3 + 0x10037e56) = sVar4;
    if (0x2d < sVar4) {
      *(undefined2 *)(iVar3 + 0x10037e56) = 0x1f;
    }
  }
  else {
    sVar4 = *(short *)(iVar3 + 0x10037e56) + 1;
    *(short *)(iVar3 + 0x10037e56) = sVar4;
    if (0xf < sVar4) {
      *(undefined2 *)(iVar3 + 0x10037e56) = 1;
    }
  }
  *(short *)(iVar3 + 0x10037e74) = *(short *)(iVar3 + 0x10037e74) + *(short *)(iVar3 + 0x10037e70);
  *(short *)(iVar3 + 0x10037e76) = *(short *)(iVar3 + 0x10037e76) + *(short *)(iVar3 + 0x10037e72);
  *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e74) >> 5;
  *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e76) >> 5;
  sStack0000001a = param_1;
  uVar1 = FUN_1002e6cc(*(short *)(iVar3 + 0x10037e58) + 6);
  uVar2 = FUN_1002e6f8(*(short *)(iVar3 + 0x10037e5a) + 2);
  sVar5 = (short)uVar1;
  sVar4 = (short)uVar2;
  if ((*(uint *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar4 * 4) & 0x200) != 0) {
    if ((*(uint *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar4 * 4) & 0x100) == 0) {
      FUN_10027c34(uVar1,uVar2,*(short *)(iVar3 + 0x10037e70) * 10 >> 5,
                   *(short *)(iVar3 + 0x10037e72) * 10 >> 5);
      if (*(short *)(iVar3 + 0x10037e8a) == 1) {
        *(undefined1 *)(iVar3 + 0x10037e68) = 1;
      }
    }
    else if (((ushort)*(undefined4 *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar4 * 4) & 0xff) != 0x8b) {
      *(undefined1 *)(iVar3 + 0x10037e68) = 1;
    }
  }
  uVar1 = FUN_1002e6cc(*(short *)(iVar3 + 0x10037e58) + 0x13);
  uVar2 = FUN_1002e6f8(*(short *)(iVar3 + 0x10037e5a) + 0x13);
  sVar5 = (short)uVar1;
  sVar4 = (short)uVar2;
  if ((*(uint *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar4 * 4) & 0x200) != 0) {
    if ((*(uint *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar4 * 4) & 0x100) == 0) {
      FUN_10027c34(uVar1,uVar2,*(short *)(iVar3 + 0x10037e70) * 10 >> 5,
                   *(short *)(iVar3 + 0x10037e72) * 10 >> 5);
      if (*(short *)(iVar3 + 0x10037e8a) == 1) {
        *(undefined1 *)(iVar3 + 0x10037e68) = 1;
      }
    }
    else if (((ushort)*(undefined4 *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar4 * 4) & 0xff) != 0x8b) {
      *(undefined1 *)(iVar3 + 0x10037e68) = 1;
    }
  }
  uVar1 = FUN_1002e6cc(*(short *)(iVar3 + 0x10037e58) + 5);
  uVar2 = FUN_1002e6f8(*(short *)(iVar3 + 0x10037e5a) + 0x13);
  sVar5 = (short)uVar1;
  sVar4 = (short)uVar2;
  if ((*(uint *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar4 * 4) & 0x200) != 0) {
    if ((*(uint *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar4 * 4) & 0x100) == 0) {
      FUN_10027c34(uVar1,uVar2,*(short *)(iVar3 + 0x10037e70) * 10 >> 5,
                   *(short *)(iVar3 + 0x10037e72) * 10 >> 5);
      if (*(short *)(iVar3 + 0x10037e8a) == 1) {
        *(undefined1 *)(iVar3 + 0x10037e68) = 1;
      }
    }
    else if (((ushort)*(undefined4 *)(&DAT_1003ad68 + sVar5 * 0x3c + sVar4 * 4) & 0xff) != 0x8b) {
      *(undefined1 *)(iVar3 + 0x10037e68) = 1;
    }
  }
  if (*(char *)(iVar3 + 0x10037e68) == '\0') {
    *(short *)(iVar3 + 0x10037e80) = *(short *)(iVar3 + 0x10037e5a) + 2;
    *(short *)(iVar3 + 0x10037e7e) = *(short *)(iVar3 + 0x10037e5a) + 0x14;
    *(short *)(iVar3 + 0x10037e82) = *(short *)(iVar3 + 0x10037e58) + 2;
    *(short *)(iVar3 + 0x10037e84) = *(short *)(iVar3 + 0x10037e58) + 0x14;
    *(undefined1 *)(iVar3 + 0x10037e66) = 1;
  }
  return;
}

