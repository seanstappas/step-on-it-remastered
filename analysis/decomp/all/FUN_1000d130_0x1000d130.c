
void FUN_1000d130(short param_1)

{
  char cVar3;
  undefined4 uVar1;
  undefined4 uVar2;
  int iVar4;
  int iVar5;
  short sVar6;
  short sStack0000001a;
  
  iVar4 = param_1 * 0x46;
  if (*(char *)(iVar4 + 0x10037e67) == '\0') {
    sVar6 = *(short *)(iVar4 + 0x10037e6c);
    *(short *)(iVar4 + 0x10037e6c) = sVar6 + -1;
    if (sVar6 == 0) {
      *(undefined1 *)(iVar4 + 0x10037e66) = 1;
      sVar6 = *(short *)(iVar4 + 0x10037e74);
      *(short *)(iVar4 + 0x10037e74) = sVar6 + -1;
      if (sVar6 < 1) {
        *(undefined1 *)(iVar4 + 0x10037e68) = 1;
      }
      sStack0000001a = param_1;
      if (0 < *(short *)(iVar4 + 0x10037e88)) {
        FUN_1002b020(6,5);
        *(undefined1 *)(iVar4 + 0x10037e68) = 1;
        FUN_10028014(*(undefined4 *)(iVar4 + 0x10037e52),(int)*(short *)(iVar4 + 0x10037e56),
                     (int)*(short *)(iVar4 + 0x10037e58),(int)*(short *)(iVar4 + 0x10037e5a),1);
        iVar5 = *(short *)(iVar4 + 0x10037e88) * 0x70;
        *(int *)(iVar5 + 0x1003a9ec) =
             *(int *)(iVar5 + 0x1003a9ec) + (int)*(short *)(iVar4 + 0x10037e8a);
      }
      *(undefined2 *)(iVar4 + 0x10037e6c) = 1;
      cVar3 = FUN_10005750(*(short *)(iVar4 + 0x10037e58) + 2,*(short *)(iVar4 + 0x10037e58) + 0x1e,
                           *(short *)(iVar4 + 0x10037e5a) + 0x1e);
      if (cVar3 == '\0') {
        if (*(short *)(iVar4 + 0x10037e4c) == 2) {
          cVar3 = FUN_1000554c(*(short *)(iVar4 + 0x10037e58) + 0x20,
                               *(short *)(iVar4 + 0x10037e5a) + 10);
          if (cVar3 == '\0') {
            *(short *)(iVar4 + 0x10037e58) = *(short *)(iVar4 + 0x10037e58) + 2;
            sVar6 = *(short *)(iVar4 + 0x10037e56) + -1;
            *(short *)(iVar4 + 0x10037e56) = sVar6;
            if (sVar6 < 1) {
              *(undefined2 *)(iVar4 + 0x10037e56) = 0x30;
            }
          }
          else {
            cVar3 = FUN_100056d4(*(short *)(iVar4 + 0x10037e58) + 0x20,
                                 *(short *)(iVar4 + 0x10037e5a) + 10);
            if (cVar3 == '\0') {
              uVar1 = FUN_1002e6f8(*(short *)(iVar4 + 0x10037e5a) + 10);
              uVar2 = FUN_1002e6cc(*(short *)(iVar4 + 0x10037e58) + 0x20);
              FUN_100279c4(uVar2,uVar1);
              *(undefined2 *)(iVar4 + 0x10037e4c) = 1;
            }
            else {
              *(undefined2 *)(iVar4 + 0x10037e4c) = 1;
            }
          }
        }
        else if (*(short *)(iVar4 + 0x10037e4c) == 1) {
          cVar3 = FUN_1000554c((int)*(short *)(iVar4 + 0x10037e58),
                               *(short *)(iVar4 + 0x10037e5a) + 10);
          if (cVar3 == '\0') {
            *(short *)(iVar4 + 0x10037e58) = *(short *)(iVar4 + 0x10037e58) + -2;
            sVar6 = *(short *)(iVar4 + 0x10037e56) + 1;
            *(short *)(iVar4 + 0x10037e56) = sVar6;
            if (0x30 < sVar6) {
              *(undefined2 *)(iVar4 + 0x10037e56) = 1;
            }
          }
          else {
            cVar3 = FUN_100056d4((int)*(short *)(iVar4 + 0x10037e58),
                                 *(short *)(iVar4 + 0x10037e5a) + 10);
            if (cVar3 == '\0') {
              uVar1 = FUN_1002e6f8(*(short *)(iVar4 + 0x10037e5a) + 10);
              uVar2 = FUN_1002e6cc((int)*(short *)(iVar4 + 0x10037e58));
              FUN_100279c4(uVar2,uVar1);
              *(undefined2 *)(iVar4 + 0x10037e4c) = 2;
            }
            else {
              *(undefined2 *)(iVar4 + 0x10037e4c) = 2;
            }
          }
        }
      }
      else {
        *(short *)(iVar4 + 0x10037e5a) = *(short *)(iVar4 + 0x10037e5a) + 4;
        FUN_10005750(*(short *)(iVar4 + 0x10037e58) + 2,*(short *)(iVar4 + 0x10037e58) + 0x1e,
                     *(short *)(iVar4 + 0x10037e5a) + 0x1e);
      }
      *(short *)(iVar4 + 0x10037e82) = *(short *)(iVar4 + 0x10037e58) + 4;
      *(short *)(iVar4 + 0x10037e84) = *(short *)(iVar4 + 0x10037e58) + 0x1e;
      *(short *)(iVar4 + 0x10037e80) = *(short *)(iVar4 + 0x10037e5a) + 4;
      *(short *)(iVar4 + 0x10037e7e) = *(short *)(iVar4 + 0x10037e5a) + 0x1c;
    }
  }
  else {
    *(undefined1 *)(iVar4 + 0x10037e67) = 0;
    *(undefined2 *)(iVar4 + 0x10037e6c) = 1;
    *(undefined2 *)(iVar4 + 0x10037e56) = 1;
    *(undefined1 *)(iVar4 + 0x10037e66) = 1;
    *(undefined2 *)(iVar4 + 0x10037e8a) = 400;
  }
  return;
}

