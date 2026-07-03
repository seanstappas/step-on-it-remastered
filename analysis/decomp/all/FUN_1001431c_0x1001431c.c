
void FUN_1001431c(undefined4 param_1)

{
  short sVar1;
  char cVar2;
  short sVar3;
  
  cVar2 = FUN_100147a0(param_1);
  sVar3 = (short)param_1;
  if (cVar2 == '\0') {
    sVar1 = *(short *)(sVar3 * 0x70 + 0x1003a9e2);
    *(short *)(sVar3 * 0x70 + 0x1003a9e2) = sVar1 + 1;
    if (sVar1 == 0) {
      if (*(short *)(sVar3 * 0x70 + 0x1003a9be) < 5) {
        *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 0x31;
      }
      else if (*(short *)(sVar3 * 0x70 + 0x1003a9be) < 0x11) {
        *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 0x36;
      }
      else if (*(short *)(sVar3 * 0x70 + 0x1003a9be) < 0x1c) {
        *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 0x3a;
      }
      else if (*(short *)(sVar3 * 0x70 + 0x1003a9be) < 0x28) {
        *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 0x3f;
      }
    }
    else {
      *(short *)(sVar3 * 0x70 + 0x1003a9be) = *(short *)(sVar3 * 0x70 + 0x1003a9be) + 1;
    }
    if (2 < *(short *)(sVar3 * 0x70 + 0x1003a9e2)) {
      *(undefined2 *)(sVar3 * 0x70 + 0x1003a9cc) = 0;
      *(undefined2 *)(sVar3 * 0x70 + 0x1003a9e2) = 0;
    }
  }
  else {
    FUN_10014744(param_1);
    *(undefined2 *)(sVar3 * 0x70 + 0x1003a9cc) = 0;
    *(undefined2 *)(sVar3 * 0x70 + 0x1003a9e2) = 0;
    if (*(short *)(sVar3 * 0x70 + 0x1003a9e4) == 1) {
      *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 0x3d;
    }
    else {
      *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 0x34;
    }
  }
  return;
}

