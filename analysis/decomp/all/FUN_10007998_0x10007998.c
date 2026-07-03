
void FUN_10007998(short param_1)

{
  undefined4 uVar1;
  undefined4 uVar2;
  char cVar3;
  int iVar4;
  int iVar5;
  uint uVar6;
  short sVar7;
  short sStack0000001a;
  
  iVar4 = param_1 * 0x46;
  if (*(char *)(iVar4 + 0x10037e67) == '\0') {
    sVar7 = *(short *)(iVar4 + 0x10037e6c);
    *(short *)(iVar4 + 0x10037e6c) = sVar7 + -1;
    if (sVar7 == 0) {
      *(undefined1 *)(iVar4 + 0x10037e66) = 1;
      sVar7 = *(short *)(iVar4 + 0x10037e74) + -1;
      *(short *)(iVar4 + 0x10037e74) = sVar7;
      if (sVar7 < 0) {
        *(undefined1 *)(iVar4 + 0x10037e68) = 1;
      }
      sStack0000001a = param_1;
      if (0 < *(short *)(iVar4 + 0x10037e88)) {
        FUN_1002b020(5,5);
        *(undefined1 *)(iVar4 + 0x10037e68) = 1;
        FUN_10028014(*(undefined4 *)(iVar4 + 0x10037e52),(int)*(short *)(iVar4 + 0x10037e56),
                     (int)*(short *)(iVar4 + 0x10037e58),(int)*(short *)(iVar4 + 0x10037e5a),1);
        iVar5 = *(short *)(iVar4 + 0x10037e88) * 0x70;
        *(int *)(iVar5 + 0x1003a9ec) =
             *(int *)(iVar5 + 0x1003a9ec) + (int)*(short *)(iVar4 + 0x10037e8a);
      }
      *(undefined2 *)(iVar4 + 0x10037e6c) = 1;
      if (*(short *)(iVar4 + 0x10037e6e) < 1) {
        cVar3 = FUN_10005750(*(short *)(iVar4 + 0x10037e58) + 4,
                             *(short *)(iVar4 + 0x10037e58) + 0x1a,
                             *(short *)(iVar4 + 0x10037e5a) + 0x1e);
        if (cVar3 == '\0') {
          if (*(short *)(iVar4 + 0x10037e4c) == 2) {
            cVar3 = FUN_1000554c(*(short *)(iVar4 + 0x10037e58) + 0x1a,
                                 *(short *)(iVar4 + 0x10037e5a) + 10);
            if (cVar3 == '\0') {
              *(short *)(iVar4 + 0x10037e58) = *(short *)(iVar4 + 0x10037e58) + 2;
              uVar6 = (uint)*(short *)(iVar4 + 0x10037e58);
              *(undefined2 *)(iVar4 + 0x10037e56) =
                   *(undefined2 *)
                    (&DAT_10034370 +
                    (uVar6 + (((int)uVar6 >> 5) + (uint)((int)uVar6 < 0 && (uVar6 & 0x1f) != 0)) *
                             -0x20) * 2);
            }
            else {
              cVar3 = FUN_100056d4(*(short *)(iVar4 + 0x10037e58) + 0x1a,
                                   *(short *)(iVar4 + 0x10037e5a) + 10);
              if (cVar3 == '\0') {
                *(undefined2 *)(iVar4 + 0x10037e6e) = 0x41;
                *(short *)(iVar4 + 0x10037e5a) = *(short *)(iVar4 + 0x10037e5a) + -0xb;
                *(undefined2 *)(iVar4 + 0x10037e56) = *(undefined2 *)(iVar4 + 0x10037e6e);
              }
              else {
                *(undefined2 *)(iVar4 + 0x10037e4c) = 5;
                *(undefined2 *)(iVar4 + 0x10037e56) = 0x20;
              }
            }
          }
          else if (*(short *)(iVar4 + 0x10037e4c) == 1) {
            cVar3 = FUN_1000554c(*(short *)(iVar4 + 0x10037e58) + 4,
                                 *(short *)(iVar4 + 0x10037e5a) + 10);
            if (cVar3 == '\0') {
              *(short *)(iVar4 + 0x10037e58) = *(short *)(iVar4 + 0x10037e58) + -2;
              uVar6 = (uint)*(short *)(iVar4 + 0x10037e58);
              *(undefined2 *)(iVar4 + 0x10037e56) =
                   *(undefined2 *)
                    (&DAT_10034330 +
                    (uVar6 + (((int)uVar6 >> 5) + (uint)((int)uVar6 < 0 && (uVar6 & 0x1f) != 0)) *
                             -0x20) * 2);
            }
            else {
              cVar3 = FUN_100056d4(*(short *)(iVar4 + 0x10037e58) + 4,
                                   *(short *)(iVar4 + 0x10037e5a) + 10);
              if (cVar3 == '\0') {
                *(undefined2 *)(iVar4 + 0x10037e6e) = 0x31;
                *(short *)(iVar4 + 0x10037e5a) = *(short *)(iVar4 + 0x10037e5a) + -0xb;
                *(short *)(iVar4 + 0x10037e58) = *(short *)(iVar4 + 0x10037e58) + -0xc;
                *(undefined2 *)(iVar4 + 0x10037e56) = *(undefined2 *)(iVar4 + 0x10037e6e);
              }
              else {
                *(undefined2 *)(iVar4 + 0x10037e4c) = 6;
                *(undefined2 *)(iVar4 + 0x10037e56) = 0x11;
              }
            }
          }
          else if (*(short *)(iVar4 + 0x10037e4c) == 6) {
            sVar7 = *(short *)(iVar4 + 0x10037e56) + 1;
            *(short *)(iVar4 + 0x10037e56) = sVar7;
            if (0x20 < sVar7) {
              *(undefined2 *)(iVar4 + 0x10037e4c) = 2;
            }
          }
          else if ((*(short *)(iVar4 + 0x10037e4c) == 5) &&
                  (sVar7 = *(short *)(iVar4 + 0x10037e56) + -1,
                  *(short *)(iVar4 + 0x10037e56) = sVar7, sVar7 < 0x11)) {
            *(undefined2 *)(iVar4 + 0x10037e4c) = 1;
          }
        }
        else {
          *(short *)(iVar4 + 0x10037e5a) = *(short *)(iVar4 + 0x10037e5a) + 4;
          FUN_10005750(*(short *)(iVar4 + 0x10037e58) + 4,*(short *)(iVar4 + 0x10037e58) + 0x1a,
                       *(short *)(iVar4 + 0x10037e5a) + 0x1e);
        }
      }
      else if (*(short *)(iVar4 + 0x10037e4c) == 2) {
        sVar7 = *(short *)(iVar4 + 0x10037e6e) + 1;
        *(short *)(iVar4 + 0x10037e6e) = sVar7;
        if (sVar7 < 0x51) {
          *(undefined2 *)(iVar4 + 0x10037e56) = *(undefined2 *)(iVar4 + 0x10037e6e);
          if (*(short *)(iVar4 + 0x10037e56) == 0x4b) {
            uVar1 = FUN_1002e6f8(*(short *)(iVar4 + 0x10037e5a) + 10);
            uVar2 = FUN_1002e6cc(*(short *)(iVar4 + 0x10037e58) + 0x1a);
            FUN_10027aec(uVar2,uVar1);
            FUN_1002b020(0x11,4);
          }
        }
        else {
          *(undefined2 *)(iVar4 + 0x10037e6e) = 0;
          uVar6 = (uint)*(short *)(iVar4 + 0x10037e58);
          *(undefined2 *)(iVar4 + 0x10037e56) =
               *(undefined2 *)
                (&DAT_10034370 +
                (uVar6 + (((int)uVar6 >> 5) + (uint)((int)uVar6 < 0 && (uVar6 & 0x1f) != 0)) * -0x20
                ) * 2);
          *(short *)(iVar4 + 0x10037e5a) = *(short *)(iVar4 + 0x10037e5a) + 0xb;
        }
      }
      else {
        sVar7 = *(short *)(iVar4 + 0x10037e6e) + 1;
        *(short *)(iVar4 + 0x10037e6e) = sVar7;
        if (sVar7 < 0x41) {
          *(undefined2 *)(iVar4 + 0x10037e56) = *(undefined2 *)(iVar4 + 0x10037e6e);
          if (*(short *)(iVar4 + 0x10037e56) == 0x3b) {
            uVar1 = FUN_1002e6f8(*(short *)(iVar4 + 0x10037e5a) + 10);
            uVar2 = FUN_1002e6cc(*(short *)(iVar4 + 0x10037e58) + 4);
            FUN_10027aec(uVar2,uVar1);
            FUN_1002b020(0x11,4);
          }
        }
        else {
          *(undefined2 *)(iVar4 + 0x10037e6e) = 0;
          uVar6 = (uint)*(short *)(iVar4 + 0x10037e58);
          *(undefined2 *)(iVar4 + 0x10037e56) =
               *(undefined2 *)
                (&DAT_10034330 +
                (uVar6 + (((int)uVar6 >> 5) + (uint)((int)uVar6 < 0 && (uVar6 & 0x1f) != 0)) * -0x20
                ) * 2);
          *(short *)(iVar4 + 0x10037e5a) = *(short *)(iVar4 + 0x10037e5a) + 0xb;
          *(short *)(iVar4 + 0x10037e58) = *(short *)(iVar4 + 0x10037e58) + 0xc;
        }
      }
      *(short *)(iVar4 + 0x10037e82) = *(short *)(iVar4 + 0x10037e58) + 6;
      *(short *)(iVar4 + 0x10037e84) = *(short *)(iVar4 + 0x10037e58) + 0x18;
      *(short *)(iVar4 + 0x10037e80) = *(short *)(iVar4 + 0x10037e5a) + 6;
      *(short *)(iVar4 + 0x10037e7e) = *(short *)(iVar4 + 0x10037e5a) + 0x1e;
    }
  }
  else {
    *(undefined1 *)(iVar4 + 0x10037e67) = 0;
    *(undefined2 *)(iVar4 + 0x10037e6c) = 1;
    *(undefined2 *)(iVar4 + 0x10037e76) = 0;
    if (*(short *)(iVar4 + 0x10037e4c) == 2) {
      uVar6 = (uint)*(short *)(iVar4 + 0x10037e58);
      *(undefined2 *)(iVar4 + 0x10037e56) =
           *(undefined2 *)
            (&DAT_10034370 +
            (uVar6 + (((int)uVar6 >> 5) + (uint)((int)uVar6 < 0 && (uVar6 & 0x1f) != 0)) * -0x20) *
            2);
    }
    else {
      uVar6 = (uint)*(short *)(iVar4 + 0x10037e58);
      *(undefined2 *)(iVar4 + 0x10037e56) =
           *(undefined2 *)
            (&DAT_10034330 +
            (uVar6 + (((int)uVar6 >> 5) + (uint)((int)uVar6 < 0 && (uVar6 & 0x1f) != 0)) * -0x20) *
            2);
    }
    *(undefined1 *)(iVar4 + 0x10037e66) = 1;
    *(undefined2 *)(iVar4 + 0x10037e6e) = 0;
    *(undefined2 *)(iVar4 + 0x10037e8a) = 500;
  }
  return;
}

