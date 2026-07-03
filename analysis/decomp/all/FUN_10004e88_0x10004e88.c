
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10004e88(void)

{
  short sVar1;
  int iVar2;
  int iVar3;
  
  FUN_100037e4();
  sVar1 = _DAT_1003a36a;
  while (iVar3 = (int)sVar1, sVar1 != 0) {
    iVar2 = sVar1 * 0x46;
    if (*(char *)(iVar2 + 0x10037e69) == '\0') {
      if (*(char *)(iVar2 + 0x10037e66) != '\0') {
        if (*(char *)(iVar2 + 0x10037e68) == '\0') {
          if (*(int *)(iVar2 + 0x10037e5c) == 0) {
            FUN_10004bb4(*(undefined4 *)(iVar2 + 0x10037e52),(int)*(short *)(iVar2 + 0x10037e56),
                         (int)*(short *)(iVar2 + 0x10037e58),(int)*(short *)(iVar2 + 0x10037e5a));
          }
          else {
            FUN_100043a0(*(undefined4 *)(iVar2 + 0x10037e5c),(int)*(short *)(iVar2 + 0x10037e60),
                         (int)*(short *)(iVar2 + 0x10037e62),(int)*(short *)(iVar2 + 0x10037e64),
                         *(undefined4 *)(iVar2 + 0x10037e52),(int)*(short *)(iVar2 + 0x10037e56),
                         (int)*(short *)(iVar2 + 0x10037e58),(int)*(short *)(iVar2 + 0x10037e5a));
          }
        }
        else {
          FUN_10004cb0(*(undefined4 *)(iVar2 + 0x10037e5c),(int)*(short *)(iVar2 + 0x10037e60),
                       (int)*(short *)(iVar2 + 0x10037e62),(int)*(short *)(iVar2 + 0x10037e64));
        }
        *(undefined4 *)(iVar2 + 0x10037e5c) = *(undefined4 *)(iVar2 + 0x10037e52);
        *(undefined2 *)(iVar2 + 0x10037e60) = *(undefined2 *)(iVar2 + 0x10037e56);
        *(undefined2 *)(iVar2 + 0x10037e62) = *(undefined2 *)(iVar2 + 0x10037e58);
        *(undefined2 *)(iVar2 + 0x10037e64) = *(undefined2 *)(iVar2 + 0x10037e5a);
      }
    }
    else {
      if (*(char *)(iVar2 + 0x10037e68) == '\0') {
        FUN_10004c5c(*(undefined4 *)(iVar2 + 0x10037e52),(int)*(short *)(iVar2 + 0x10037e56),
                     (int)*(short *)(iVar2 + 0x10037e58),(int)*(short *)(iVar2 + 0x10037e5a));
      }
      else {
        FUN_10004cb0(*(undefined4 *)(iVar2 + 0x10037e5c),(int)*(short *)(iVar2 + 0x10037e60),
                     (int)*(short *)(iVar2 + 0x10037e62),(int)*(short *)(iVar2 + 0x10037e64));
      }
      *(undefined4 *)(iVar2 + 0x10037e5c) = *(undefined4 *)(iVar2 + 0x10037e52);
      *(undefined2 *)(iVar2 + 0x10037e60) = *(undefined2 *)(iVar2 + 0x10037e56);
      *(undefined2 *)(iVar2 + 0x10037e62) = *(undefined2 *)(iVar2 + 0x10037e58);
      *(undefined2 *)(iVar2 + 0x10037e64) = *(undefined2 *)(iVar2 + 0x10037e5a);
    }
    sVar1 = *(short *)(iVar2 + 0x10037e86);
    if (*(char *)(iVar2 + 0x10037e68) != '\0') {
      FUN_10005c64(iVar3);
    }
  }
  FUN_10003f7c();
  DAT_10037d4e = 0;
  return;
}

