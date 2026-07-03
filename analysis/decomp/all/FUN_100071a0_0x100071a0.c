
void FUN_100071a0(short param_1)

{
  int iVar1;
  short sVar2;
  short sVar3;
  short sStack0000001a;
  
  iVar1 = param_1 * 0x46;
  sStack0000001a = param_1;
  if (*(char *)(iVar1 + 0x10037e67) == '\0') {
    if (DAT_10037d4e != '\0') {
      if (*(short *)(iVar1 + 0x10037e4c) == 2) {
        FUN_10004108(uRam1003a318,1,(int)*(short *)(iVar1 + 0x10037e58),
                     (int)*(short *)(iVar1 + 0x10037e5a));
      }
      else {
        FUN_10004108(uRam1003a318,2,(int)*(short *)(iVar1 + 0x10037e58),
                     (int)*(short *)(iVar1 + 0x10037e5a));
      }
    }
  }
  else {
    *(undefined1 *)(iVar1 + 0x10037e67) = 0;
    *(undefined1 *)(iVar1 + 0x10037e7d) = 1;
    *(short *)(iVar1 + 0x10037e6c) = *(short *)(iVar1 + 0x10037e4e) * 6;
    if (*(short *)(iVar1 + 0x10037e4c) == 2) {
      FUN_10004108(uRam1003a318,1,(int)*(short *)(iVar1 + 0x10037e58),
                   (int)*(short *)(iVar1 + 0x10037e5a));
    }
    else {
      FUN_10004108(uRam1003a318,2,(int)*(short *)(iVar1 + 0x10037e58),
                   (int)*(short *)(iVar1 + 0x10037e5a));
    }
    sVar2 = FUN_1002e6f8(*(short *)(iVar1 + 0x10037e5a) + 10);
    sVar3 = FUN_1002e6cc(*(short *)(iVar1 + 0x10037e58) + 10);
    *(undefined4 *)(&DAT_1003ad68 + sVar3 * 0x3c + sVar2 * 4) = 0x300;
    *(undefined2 *)(iVar1 + 0x10037e80) = 1000;
    *(undefined1 *)(iVar1 + 0x10037e66) = 0;
  }
  sVar2 = *(short *)(iVar1 + 0x10037e6c);
  *(short *)(iVar1 + 0x10037e6c) = sVar2 + -1;
  if (sVar2 == 0) {
    FUN_1002b020(0x10,4);
    sVar2 = FUN_10005948();
    if (*(short *)(iVar1 + 0x10037e4c) == 2) {
      *(short *)(sVar2 * 0x46 + 0x10037e58) = *(short *)(iVar1 + 0x10037e58) + 0x1c;
      *(short *)(sVar2 * 0x46 + 0x10037e5a) = *(short *)(iVar1 + 0x10037e5a) + 8;
      *(undefined2 *)(sVar2 * 0x46 + 0x10037e4c) = 2;
    }
    else {
      *(short *)(sVar2 * 0x46 + 0x10037e58) = *(short *)(iVar1 + 0x10037e58) + -0xc;
      *(short *)(sVar2 * 0x46 + 0x10037e5a) = *(short *)(iVar1 + 0x10037e5a) + 8;
      *(undefined2 *)(sVar2 * 0x46 + 0x10037e4c) = 1;
    }
    *(undefined2 *)(sVar2 * 0x46 + 0x10037e4a) = 0x65;
    *(undefined4 *)(sVar2 * 0x46 + 0x10037e52) = uRam1003a318;
    *(undefined2 *)(sVar2 * 0x46 + 0x10037e56) = 3;
    *(undefined4 *)(sVar2 * 0x46 + 0x10037e5c) = 0;
    *(undefined1 *)(sVar2 * 0x46 + 0x10037e66) = 0;
    *(undefined2 *)(sVar2 * 0x46 + 0x10037e6c) = 1;
    *(short *)(iVar1 + 0x10037e6c) = *(short *)(iVar1 + 0x10037e50) * 6;
    *(undefined2 *)(iVar1 + 0x10037e6e) = 0;
  }
  return;
}

