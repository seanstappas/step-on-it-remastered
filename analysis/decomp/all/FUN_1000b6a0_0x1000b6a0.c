
void FUN_1000b6a0(short param_1)

{
  undefined4 uVar1;
  undefined4 uVar2;
  int iVar3;
  short sVar4;
  short sStack0000001a;
  
  iVar3 = param_1 * 0x46;
  sVar4 = *(short *)(iVar3 + 0x10037e56) + 1;
  *(short *)(iVar3 + 0x10037e56) = sVar4;
  if (0x3c < sVar4) {
    *(undefined2 *)(iVar3 + 0x10037e56) = 0x2e;
  }
  *(short *)(iVar3 + 0x10037e74) = *(short *)(iVar3 + 0x10037e74) + *(short *)(iVar3 + 0x10037e70);
  *(short *)(iVar3 + 0x10037e76) = *(short *)(iVar3 + 0x10037e76) + *(short *)(iVar3 + 0x10037e72);
  *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e74) >> 5;
  *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e76) >> 5;
  sStack0000001a = param_1;
  uVar1 = FUN_1002e6cc(*(short *)(iVar3 + 0x10037e58) + 0xc);
  uVar2 = FUN_1002e6f8(*(short *)(iVar3 + 0x10037e5a) + 0xc);
  if ((*(short *)(iVar3 + 0x10037e80) == (short)uVar2) &&
     (*(short *)(iVar3 + 0x10037e84) == (short)uVar1)) {
    *(undefined1 *)(iVar3 + 0x10037e68) = 1;
    FUN_1000b7dc(uVar1,uVar2);
  }
  *(undefined1 *)(iVar3 + 0x10037e66) = 1;
  *(undefined2 *)(iVar3 + 0x10037e7e) = 0xffff;
  return;
}

