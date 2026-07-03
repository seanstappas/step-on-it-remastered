
void FUN_100093a0(short param_1)

{
  char cVar2;
  short sVar1;
  int iVar3;
  int iVar4;
  uint uVar5;
  short sStack0000001a;
  
  iVar3 = param_1 * 0x46;
  if (*(char *)(iVar3 + 0x10037e67) == '\0') {
    sVar1 = *(short *)(iVar3 + 0x10037e6c);
    *(short *)(iVar3 + 0x10037e6c) = sVar1 + -1;
    if (sVar1 == 0) {
      *(undefined1 *)(iVar3 + 0x10037e66) = 1;
      sVar1 = *(short *)(iVar3 + 0x10037e74);
      *(short *)(iVar3 + 0x10037e74) = sVar1 + -1;
      if (sVar1 < 1) {
        *(undefined1 *)(iVar3 + 0x10037e68) = 1;
      }
      sStack0000001a = param_1;
      if (0 < *(short *)(iVar3 + 0x10037e88)) {
        FUN_1002b020(0xf,5);
        *(undefined1 *)(iVar3 + 0x10037e68) = 1;
        FUN_10028014(*(undefined4 *)(iVar3 + 0x10037e52),(int)*(short *)(iVar3 + 0x10037e56),
                     (int)*(short *)(iVar3 + 0x10037e58),(int)*(short *)(iVar3 + 0x10037e5a),1);
        iVar4 = *(short *)(iVar3 + 0x10037e88) * 0x70;
        *(int *)(iVar4 + 0x1003a9ec) =
             *(int *)(iVar4 + 0x1003a9ec) + (int)*(short *)(iVar3 + 0x10037e8a);
      }
      *(undefined2 *)(iVar3 + 0x10037e6c) = 1;
      cVar2 = FUN_10005750(*(short *)(iVar3 + 0x10037e58) + 8,*(short *)(iVar3 + 0x10037e58) + 0x1e,
                           *(short *)(iVar3 + 0x10037e5a) + 0x1e);
      if (cVar2 == '\0') {
        if (*(short *)(iVar3 + 0x10037e4c) == 2) {
          cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x24,
                               *(short *)(iVar3 + 0x10037e5a) + 10);
          if (cVar2 == '\0') {
            *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) + 2;
            uVar5 = (uint)*(short *)(iVar3 + 0x10037e58);
            *(undefined2 *)(iVar3 + 0x10037e56) =
                 *(undefined2 *)
                  (&DAT_10034430 +
                  (uVar5 + (((int)uVar5 >> 5) + (uint)((int)uVar5 < 0 && (uVar5 & 0x1f) != 0)) *
                           -0x20) * 2);
          }
          else {
            *(undefined2 *)(iVar3 + 0x10037e4c) = 5;
            *(undefined2 *)(iVar3 + 0x10037e56) = 0x18;
          }
        }
        else if (*(short *)(iVar3 + 0x10037e4c) == 1) {
          cVar2 = FUN_1000554c((int)*(short *)(iVar3 + 0x10037e58),
                               *(short *)(iVar3 + 0x10037e5a) + 10);
          if (cVar2 == '\0') {
            *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) + -2;
            uVar5 = (uint)*(short *)(iVar3 + 0x10037e58);
            *(undefined2 *)(iVar3 + 0x10037e56) =
                 *(undefined2 *)
                  (&DAT_10034470 +
                  (uVar5 + (((int)uVar5 >> 5) + (uint)((int)uVar5 < 0 && (uVar5 & 0x1f) != 0)) *
                           -0x20) * 2);
          }
          else {
            *(undefined2 *)(iVar3 + 0x10037e4c) = 6;
            *(undefined2 *)(iVar3 + 0x10037e56) = 9;
          }
        }
        else if (*(short *)(iVar3 + 0x10037e4c) == 6) {
          sVar1 = *(short *)(iVar3 + 0x10037e56) + 1;
          *(short *)(iVar3 + 0x10037e56) = sVar1;
          if (0x18 < sVar1) {
            *(undefined2 *)(iVar3 + 0x10037e4c) = 2;
          }
        }
        else if ((*(short *)(iVar3 + 0x10037e4c) == 5) &&
                (sVar1 = *(short *)(iVar3 + 0x10037e56) + -1, *(short *)(iVar3 + 0x10037e56) = sVar1
                , sVar1 < 9)) {
          *(undefined2 *)(iVar3 + 0x10037e4c) = 1;
        }
      }
      else {
        *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e5a) + 4;
        cVar2 = FUN_10005750(*(short *)(iVar3 + 0x10037e58) + 8,
                             *(short *)(iVar3 + 0x10037e58) + 0x1e,
                             *(short *)(iVar3 + 0x10037e5a) + 0x1e);
        if (cVar2 == '\0') {
          if ((*(short *)(iVar3 + 0x10037e4c) == 2) &&
             (sVar1 = FUN_100054a4((int)*(short *)(iVar3 + 0x10037e58)), sVar1 == 1)) {
            *(undefined2 *)(iVar3 + 0x10037e4c) = 5;
            *(undefined2 *)(iVar3 + 0x10037e56) = 0x18;
          }
          else if ((*(short *)(iVar3 + 0x10037e4c) == 1) &&
                  (sVar1 = FUN_100054a4((int)*(short *)(iVar3 + 0x10037e58)), sVar1 == 2)) {
            *(undefined2 *)(iVar3 + 0x10037e4c) = 6;
            *(undefined2 *)(iVar3 + 0x10037e56) = 9;
          }
        }
      }
      *(short *)(iVar3 + 0x10037e82) = *(short *)(iVar3 + 0x10037e58) + 8;
      *(short *)(iVar3 + 0x10037e84) = *(short *)(iVar3 + 0x10037e58) + 0x1e;
      *(short *)(iVar3 + 0x10037e80) = *(short *)(iVar3 + 0x10037e5a) + 2;
      *(short *)(iVar3 + 0x10037e7e) = *(short *)(iVar3 + 0x10037e5a) + 0x1e;
    }
  }
  else {
    *(undefined1 *)(iVar3 + 0x10037e67) = 0;
    *(undefined2 *)(iVar3 + 0x10037e6c) = 1;
    if (*(short *)(iVar3 + 0x10037e4c) == 2) {
      uVar5 = (uint)*(short *)(iVar3 + 0x10037e58);
      *(undefined2 *)(iVar3 + 0x10037e56) =
           *(undefined2 *)
            (&DAT_10034430 +
            (uVar5 + (((int)uVar5 >> 5) + (uint)((int)uVar5 < 0 && (uVar5 & 0x1f) != 0)) * -0x20) *
            2);
    }
    else {
      uVar5 = (uint)*(short *)(iVar3 + 0x10037e58);
      *(undefined2 *)(iVar3 + 0x10037e56) =
           *(undefined2 *)
            (&DAT_10034470 +
            (uVar5 + (((int)uVar5 >> 5) + (uint)((int)uVar5 < 0 && (uVar5 & 0x1f) != 0)) * -0x20) *
            2);
    }
    *(undefined1 *)(iVar3 + 0x10037e66) = 1;
    *(undefined2 *)(iVar3 + 0x10037e8a) = 100;
  }
  return;
}

