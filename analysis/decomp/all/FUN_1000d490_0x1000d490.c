
void FUN_1000d490(short param_1)

{
  char cVar1;
  int iVar2;
  short sVar3;
  short sStack0000001a;
  
  iVar2 = param_1 * 0x46;
  if (*(char *)(iVar2 + 0x10037e67) != '\0') {
    *(undefined1 *)(iVar2 + 0x10037e67) = 0;
    *(undefined1 *)(iVar2 + 0x10037e66) = 0;
    *(undefined4 *)(iVar2 + 0x10037e52) = uRam1003a338;
    *(undefined4 *)(iVar2 + 0x10037e5c) = 0;
    *(undefined2 *)(iVar2 + 0x10037e56) = 1;
    *(undefined2 *)(iVar2 + 0x10037e6c) = 1;
    *(short *)(iVar2 + 0x10037e58) = *(short *)(iVar2 + 0x10037e58) + 4;
    *(short *)(iVar2 + 0x10037e5a) = *(short *)(iVar2 + 0x10037e5a) + 6;
  }
  sVar3 = *(short *)(iVar2 + 0x10037e6c);
  *(short *)(iVar2 + 0x10037e6c) = sVar3 + -1;
  if (sVar3 == 0) {
    *(undefined2 *)(iVar2 + 0x10037e6c) = 1;
    *(undefined1 *)(iVar2 + 0x10037e66) = 1;
    sVar3 = *(short *)(iVar2 + 0x10037e56) + 1;
    *(short *)(iVar2 + 0x10037e56) = sVar3;
    if (0x10 < sVar3) {
      *(undefined2 *)(iVar2 + 0x10037e56) = 1;
    }
    sStack0000001a = param_1;
    cVar1 = FUN_10005750(*(short *)(iVar2 + 0x10037e58) + 4,*(short *)(iVar2 + 0x10037e58) + 0x14,
                         *(short *)(iVar2 + 0x10037e5a) + 0x1b);
    if (cVar1 != '\0') {
      *(short *)(iVar2 + 0x10037e5a) = *(short *)(iVar2 + 0x10037e5a) + 4;
    }
    *(short *)(iVar2 + 0x10037e82) = *(short *)(iVar2 + 0x10037e58) + 1;
    *(short *)(iVar2 + 0x10037e84) = *(short *)(iVar2 + 0x10037e58) + 0x17;
    *(short *)(iVar2 + 0x10037e80) = *(short *)(iVar2 + 0x10037e5a) + 0xc;
    *(short *)(iVar2 + 0x10037e7e) = *(short *)(iVar2 + 0x10037e5a) + 0x1a;
  }
  return;
}

