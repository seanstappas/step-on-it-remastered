
void FUN_1000602c(short param_1)

{
  char cVar1;
  int iVar2;
  short sVar3;
  int iVar4;
  uint uVar5;
  short sStack0000001a;
  
  iVar2 = param_1 * 0x46;
  if (*(char *)(iVar2 + 0x10037e67) == '\0') {
    sVar3 = *(short *)(iVar2 + 0x10037e6c);
    *(short *)(iVar2 + 0x10037e6c) = sVar3 + -1;
    if (sVar3 == 0) {
      *(undefined1 *)(iVar2 + 0x10037e66) = 1;
      sVar3 = *(short *)(iVar2 + 0x10037e74);
      *(short *)(iVar2 + 0x10037e74) = sVar3 + -1;
      if (sVar3 < 1) {
        *(undefined1 *)(iVar2 + 0x10037e68) = 1;
      }
      sStack0000001a = param_1;
      if (0 < *(short *)(iVar2 + 0x10037e88)) {
        FUN_1002b020(0xe,5);
        *(undefined1 *)(iVar2 + 0x10037e68) = 1;
        FUN_10028014(*(undefined4 *)(iVar2 + 0x10037e52),(int)*(short *)(iVar2 + 0x10037e56),
                     (int)*(short *)(iVar2 + 0x10037e58),(int)*(short *)(iVar2 + 0x10037e5a),1);
        iVar4 = *(short *)(iVar2 + 0x10037e88) * 0x70;
        *(int *)(iVar4 + 0x1003a9ec) =
             *(int *)(iVar4 + 0x1003a9ec) + (int)*(short *)(iVar2 + 0x10037e8a);
      }
      *(undefined2 *)(iVar2 + 0x10037e6c) = 1;
      cVar1 = FUN_10005750(*(short *)(iVar2 + 0x10037e58) + 4,*(short *)(iVar2 + 0x10037e58) + 0x20,
                           *(short *)(iVar2 + 0x10037e5a) + 0x10);
      if (cVar1 == '\0') {
        if (*(short *)(iVar2 + 0x10037e4c) == 2) {
          cVar1 = FUN_1000554c(*(short *)(iVar2 + 0x10037e58) + 0x24,
                               *(short *)(iVar2 + 0x10037e5a) + 10);
          if (cVar1 == '\0') {
            *(short *)(iVar2 + 0x10037e58) = *(short *)(iVar2 + 0x10037e58) + 2;
            uVar5 = (uint)*(short *)(iVar2 + 0x10037e58);
            *(undefined2 *)(iVar2 + 0x10037e56) =
                 *(undefined2 *)
                  (&DAT_100341f0 +
                  (uVar5 + (((int)uVar5 >> 5) + (uint)((int)uVar5 < 0 && (uVar5 & 0x1f) != 0)) *
                           -0x20) * 2);
          }
          else {
            *(undefined2 *)(iVar2 + 0x10037e4c) = 5;
            *(undefined2 *)(iVar2 + 0x10037e56) = 0x20;
          }
        }
        else if (*(short *)(iVar2 + 0x10037e4c) == 1) {
          cVar1 = FUN_1000554c((int)*(short *)(iVar2 + 0x10037e58),
                               *(short *)(iVar2 + 0x10037e5a) + 10);
          if (cVar1 == '\0') {
            *(short *)(iVar2 + 0x10037e58) = *(short *)(iVar2 + 0x10037e58) + -2;
            uVar5 = (uint)*(short *)(iVar2 + 0x10037e58);
            *(undefined2 *)(iVar2 + 0x10037e56) =
                 *(undefined2 *)
                  (&DAT_10034230 +
                  (uVar5 + (((int)uVar5 >> 5) + (uint)((int)uVar5 < 0 && (uVar5 & 0x1f) != 0)) *
                           -0x20) * 2);
          }
          else {
            *(undefined2 *)(iVar2 + 0x10037e4c) = 6;
            *(undefined2 *)(iVar2 + 0x10037e56) = 0x11;
          }
        }
        else if (*(short *)(iVar2 + 0x10037e4c) == 6) {
          sVar3 = *(short *)(iVar2 + 0x10037e56) + 1;
          *(short *)(iVar2 + 0x10037e56) = sVar3;
          if (0x20 < sVar3) {
            *(undefined2 *)(iVar2 + 0x10037e4c) = 2;
          }
        }
        else if ((*(short *)(iVar2 + 0x10037e4c) == 5) &&
                (sVar3 = *(short *)(iVar2 + 0x10037e56) + -1, *(short *)(iVar2 + 0x10037e56) = sVar3
                , sVar3 < 0x11)) {
          *(undefined2 *)(iVar2 + 0x10037e4c) = 1;
        }
      }
      else {
        *(short *)(iVar2 + 0x10037e5a) = *(short *)(iVar2 + 0x10037e5a) + 4;
        FUN_10005750(*(short *)(iVar2 + 0x10037e58) + 4,*(short *)(iVar2 + 0x10037e58) + 0x20,
                     *(short *)(iVar2 + 0x10037e5a) + 0x10);
      }
      *(short *)(iVar2 + 0x10037e82) = *(short *)(iVar2 + 0x10037e58) + 6;
      *(short *)(iVar2 + 0x10037e84) = *(short *)(iVar2 + 0x10037e58) + 0x20;
      *(undefined2 *)(iVar2 + 0x10037e80) = *(undefined2 *)(iVar2 + 0x10037e5a);
      *(short *)(iVar2 + 0x10037e7e) = *(short *)(iVar2 + 0x10037e5a) + 0x10;
    }
  }
  else {
    *(undefined1 *)(iVar2 + 0x10037e67) = 0;
    *(undefined2 *)(iVar2 + 0x10037e6c) = 1;
    if (*(short *)(iVar2 + 0x10037e4c) == 2) {
      uVar5 = (uint)*(short *)(iVar2 + 0x10037e58);
      *(undefined2 *)(iVar2 + 0x10037e56) =
           *(undefined2 *)
            (&DAT_100341f0 +
            (uVar5 + (((int)uVar5 >> 5) + (uint)((int)uVar5 < 0 && (uVar5 & 0x1f) != 0)) * -0x20) *
            2);
    }
    else {
      uVar5 = (uint)*(short *)(iVar2 + 0x10037e58);
      *(undefined2 *)(iVar2 + 0x10037e56) =
           *(undefined2 *)
            (&DAT_10034230 +
            (uVar5 + (((int)uVar5 >> 5) + (uint)((int)uVar5 < 0 && (uVar5 & 0x1f) != 0)) * -0x20) *
            2);
    }
    *(undefined1 *)(iVar2 + 0x10037e66) = 1;
    *(undefined2 *)(iVar2 + 0x10037e8a) = 0x32;
  }
  return;
}

