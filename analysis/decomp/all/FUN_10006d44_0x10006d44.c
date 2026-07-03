
void FUN_10006d44(short param_1)

{
  short sVar1;
  int iVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  short sStack0000001a;
  
  iVar2 = param_1 * 0x46;
  sStack0000001a = param_1;
  if (*(char *)(iVar2 + 0x10037e67) != '\0') {
    *(undefined1 *)(iVar2 + 0x10037e67) = 0;
    *(undefined1 *)(iVar2 + 0x10037e66) = 0;
    *(undefined4 *)(iVar2 + 0x10037e52) = uRam1003a330;
    *(undefined4 *)(iVar2 + 0x10037e5c) = 0;
    *(undefined2 *)(iVar2 + 0x10037e6c) = 1;
    *(undefined2 *)(iVar2 + 0x10037e6e) = 1;
    FUN_1002b020(0x12,4);
  }
  sVar1 = *(short *)(iVar2 + 0x10037e6c);
  *(short *)(iVar2 + 0x10037e6c) = sVar1 + -1;
  if (sVar1 == 0) {
    *(undefined2 *)(iVar2 + 0x10037e6c) = 1;
    *(undefined1 *)(iVar2 + 0x10037e66) = 1;
    if (*(short *)(iVar2 + 0x10037e4c) == 2) {
      *(short *)(iVar2 + 0x10037e56) =
           *(short *)(iVar2 + 0x10037e56) + *(short *)(iVar2 + 0x10037e6e);
      if (0x10 < *(short *)(iVar2 + 0x10037e56)) {
        *(undefined2 *)(iVar2 + 0x10037e56) = 0xf;
        *(undefined2 *)(iVar2 + 0x10037e6e) = 0xffff;
        uVar3 = FUN_1002e6f8((int)*(short *)(iVar2 + 0x10037e5a));
        uVar4 = FUN_1002e6cc(*(short *)(iVar2 + 0x10037e58) + 0x10);
        FUN_100279c4(uVar4,uVar3);
      }
      if (*(short *)(iVar2 + 0x10037e56) < 1) {
        *(undefined2 *)(iVar2 + 0x10037e56) = 1;
        *(undefined1 *)(iVar2 + 0x10037e68) = 1;
        *(undefined2 *)(*(short *)(iVar2 + 0x10037e78) * 0x46 + 0x10037e7a) = 0;
      }
    }
    else {
      *(short *)(iVar2 + 0x10037e56) =
           *(short *)(iVar2 + 0x10037e56) + *(short *)(iVar2 + 0x10037e6e);
      if (0x30 < *(short *)(iVar2 + 0x10037e56)) {
        *(undefined2 *)(iVar2 + 0x10037e56) = 0x2f;
        *(undefined2 *)(iVar2 + 0x10037e6e) = 0xffff;
        uVar3 = FUN_1002e6f8((int)*(short *)(iVar2 + 0x10037e5a));
        uVar4 = FUN_1002e6cc((int)*(short *)(iVar2 + 0x10037e58));
        FUN_100279c4(uVar4,uVar3);
      }
      if (*(short *)(iVar2 + 0x10037e56) < 0x21) {
        *(undefined2 *)(iVar2 + 0x10037e56) = 0x21;
        *(undefined1 *)(iVar2 + 0x10037e68) = 1;
        *(undefined2 *)(*(short *)(iVar2 + 0x10037e78) * 0x46 + 0x10037e7a) = 0;
      }
    }
    *(short *)(iVar2 + 0x10037e82) = *(short *)(iVar2 + 0x10037e58) + 4;
    *(short *)(iVar2 + 0x10037e84) = *(short *)(iVar2 + 0x10037e58) + 0x1c;
    *(short *)(iVar2 + 0x10037e80) = *(short *)(iVar2 + 0x10037e5a) + 5;
    *(short *)(iVar2 + 0x10037e7e) = *(short *)(iVar2 + 0x10037e5a) + 0xf;
  }
  return;
}

