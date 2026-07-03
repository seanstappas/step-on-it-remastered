
void FUN_1000a780(short param_1)

{
  char cVar4;
  undefined2 uVar3;
  undefined4 uVar1;
  undefined4 uVar2;
  int iVar5;
  int iVar6;
  short sVar7;
  uint uVar8;
  short sStack0000001a;
  
  iVar5 = param_1 * 0x46;
  if (*(char *)(iVar5 + 0x10037e67) == '\0') {
    sVar7 = *(short *)(iVar5 + 0x10037e6c);
    *(short *)(iVar5 + 0x10037e6c) = sVar7 + -1;
    if (sVar7 < 1) {
      *(undefined1 *)(iVar5 + 0x10037e66) = 1;
      sStack0000001a = param_1;
      if (0 < *(short *)(iVar5 + 0x10037e88)) {
        FUN_1002b020(10,5);
        *(undefined1 *)(iVar5 + 0x10037e68) = 1;
        FUN_10028014(*(undefined4 *)(iVar5 + 0x10037e52),(int)*(short *)(iVar5 + 0x10037e56),
                     (int)*(short *)(iVar5 + 0x10037e58),(int)*(short *)(iVar5 + 0x10037e5a),1);
        iVar6 = *(short *)(iVar5 + 0x10037e88) * 0x70;
        *(int *)(iVar6 + 0x1003a9ec) =
             *(int *)(iVar6 + 0x1003a9ec) + (int)*(short *)(iVar5 + 0x10037e8a);
      }
      *(undefined2 *)(iVar5 + 0x10037e6c) = 1;
      cVar4 = FUN_10005750(*(short *)(iVar5 + 0x10037e58) + 6,*(short *)(iVar5 + 0x10037e58) + 0x1a,
                           *(short *)(iVar5 + 0x10037e5a) + 0x1f);
      if (cVar4 == '\0') {
        if (*(short *)(iVar5 + 0x10037e6e) < 1) {
          if (*(short *)(iVar5 + 0x10037e4c) == 2) {
            cVar4 = FUN_1000554c(*(short *)(iVar5 + 0x10037e58) + 0x1c,
                                 *(short *)(iVar5 + 0x10037e5a) + 10);
            if (cVar4 == '\0') {
              cVar4 = FUN_1000554c(*(short *)(iVar5 + 0x10037e58) + 0x1c,
                                   *(short *)(iVar5 + 0x10037e5a) + 0x1f);
              if (cVar4 == '\0') {
                *(undefined2 *)(iVar5 + 0x10037e4c) = 5;
                *(undefined2 *)(iVar5 + 0x10037e56) = 0x31;
              }
              else {
                *(short *)(iVar5 + 0x10037e58) = *(short *)(iVar5 + 0x10037e58) + 2;
                uVar8 = (uint)*(short *)(iVar5 + 0x10037e58);
                *(undefined2 *)(iVar5 + 0x10037e56) =
                     *(undefined2 *)
                      (&DAT_10034570 +
                      (uVar8 + (((int)uVar8 >> 5) + (uint)((int)uVar8 < 0 && (uVar8 & 0x1f) != 0)) *
                               -0x20) * 2);
              }
            }
            else {
              cVar4 = FUN_100056d4(*(short *)(iVar5 + 0x10037e58) + 0x1c,
                                   *(short *)(iVar5 + 0x10037e5a) + 10);
              if (cVar4 == '\0') {
                *(undefined2 *)(iVar5 + 0x10037e6e) = 0x11;
                *(undefined2 *)(iVar5 + 0x10037e56) = *(undefined2 *)(iVar5 + 0x10037e6e);
              }
              else {
                *(undefined2 *)(iVar5 + 0x10037e4c) = 5;
                *(undefined2 *)(iVar5 + 0x10037e56) = 0x31;
              }
            }
          }
          else if (*(short *)(iVar5 + 0x10037e4c) == 1) {
            cVar4 = FUN_1000554c(*(short *)(iVar5 + 0x10037e58) + 4,
                                 *(short *)(iVar5 + 0x10037e5a) + 10);
            if (cVar4 == '\0') {
              cVar4 = FUN_1000554c(*(short *)(iVar5 + 0x10037e58) + 4,
                                   *(short *)(iVar5 + 0x10037e5a) + 0x1f);
              if (cVar4 == '\0') {
                *(undefined2 *)(iVar5 + 0x10037e4c) = 6;
                *(undefined2 *)(iVar5 + 0x10037e56) = 0x40;
              }
              else {
                *(short *)(iVar5 + 0x10037e58) = *(short *)(iVar5 + 0x10037e58) + -2;
                uVar8 = (uint)*(short *)(iVar5 + 0x10037e58);
                *(undefined2 *)(iVar5 + 0x10037e56) =
                     *(undefined2 *)
                      (&DAT_10034530 +
                      (uVar8 + (((int)uVar8 >> 5) + (uint)((int)uVar8 < 0 && (uVar8 & 0x1f) != 0)) *
                               -0x20) * 2);
              }
            }
            else {
              cVar4 = FUN_100056d4(*(short *)(iVar5 + 0x10037e58) + 4,
                                   *(short *)(iVar5 + 0x10037e5a) + 10);
              if (cVar4 == '\0') {
                *(undefined2 *)(iVar5 + 0x10037e6e) = 1;
                *(undefined2 *)(iVar5 + 0x10037e56) = *(undefined2 *)(iVar5 + 0x10037e6e);
              }
              else {
                *(undefined2 *)(iVar5 + 0x10037e4c) = 6;
                *(undefined2 *)(iVar5 + 0x10037e56) = 0x40;
              }
            }
          }
          else if (*(short *)(iVar5 + 0x10037e4c) == 6) {
            sVar7 = *(short *)(iVar5 + 0x10037e56) + -1;
            *(short *)(iVar5 + 0x10037e56) = sVar7;
            if (sVar7 < 0x32) {
              *(undefined2 *)(iVar5 + 0x10037e4c) = 2;
            }
          }
          else if ((*(short *)(iVar5 + 0x10037e4c) == 5) &&
                  (sVar7 = *(short *)(iVar5 + 0x10037e56) + 1,
                  *(short *)(iVar5 + 0x10037e56) = sVar7, 0x3f < sVar7)) {
            *(undefined2 *)(iVar5 + 0x10037e4c) = 1;
          }
        }
        else if (*(short *)(iVar5 + 0x10037e4c) == 2) {
          sVar7 = *(short *)(iVar5 + 0x10037e6e) + 1;
          *(short *)(iVar5 + 0x10037e6e) = sVar7;
          if (sVar7 < 0x21) {
            *(undefined2 *)(iVar5 + 0x10037e56) = *(undefined2 *)(iVar5 + 0x10037e6e);
            if (*(short *)(iVar5 + 0x10037e56) == 0x18) {
              uVar1 = FUN_1002e6f8(*(short *)(iVar5 + 0x10037e5a) + 10);
              uVar2 = FUN_1002e6cc(*(short *)(iVar5 + 0x10037e58) + 0x20);
              FUN_10027d84(uVar2,uVar1);
              FUN_1002b020(0x11,4);
            }
          }
          else {
            *(undefined2 *)(iVar5 + 0x10037e6e) = 0;
            uVar8 = (uint)*(short *)(iVar5 + 0x10037e58);
            *(undefined2 *)(iVar5 + 0x10037e56) =
                 *(undefined2 *)
                  (&DAT_10034570 +
                  (uVar8 + (((int)uVar8 >> 5) + (uint)((int)uVar8 < 0 && (uVar8 & 0x1f) != 0)) *
                           -0x20) * 2);
          }
        }
        else {
          sVar7 = *(short *)(iVar5 + 0x10037e6e) + 1;
          *(short *)(iVar5 + 0x10037e6e) = sVar7;
          if (sVar7 < 0x11) {
            *(undefined2 *)(iVar5 + 0x10037e56) = *(undefined2 *)(iVar5 + 0x10037e6e);
            if (*(short *)(iVar5 + 0x10037e56) == 8) {
              uVar1 = FUN_1002e6f8(*(short *)(iVar5 + 0x10037e5a) + 10);
              uVar2 = FUN_1002e6cc((int)*(short *)(iVar5 + 0x10037e58));
              FUN_10027ecc(uVar2,uVar1);
              FUN_1002b020(0x11,4);
            }
          }
          else {
            *(undefined2 *)(iVar5 + 0x10037e6e) = 0;
            uVar8 = (uint)*(short *)(iVar5 + 0x10037e58);
            *(undefined2 *)(iVar5 + 0x10037e56) =
                 *(undefined2 *)
                  (&DAT_10034530 +
                  (uVar8 + (((int)uVar8 >> 5) + (uint)((int)uVar8 < 0 && (uVar8 & 0x1f) != 0)) *
                           -0x20) * 2);
          }
        }
      }
      else {
        if (*(short *)(iVar5 + 0x10037e8c) == 0) {
          uVar3 = FUN_1000581c((int)*(short *)(iVar5 + 0x10037e58),
                               (int)*(short *)(iVar5 + 0x10037e5a));
          *(undefined2 *)(iVar5 + 0x10037e8c) = uVar3;
        }
        *(short *)(iVar5 + 0x10037e5a) = *(short *)(iVar5 + 0x10037e5a) + 4;
        *(short *)(iVar5 + 0x10037e56) = *(short *)(iVar5 + 0x10037e56) + 2;
        if (*(short *)(iVar5 + 0x10037e4c) == 2) {
          if (0x30 < *(short *)(iVar5 + 0x10037e56)) {
            *(undefined2 *)(iVar5 + 0x10037e56) = 0x21;
          }
        }
        else if (0x50 < *(short *)(iVar5 + 0x10037e56)) {
          *(undefined2 *)(iVar5 + 0x10037e56) = 0x41;
        }
        cVar4 = FUN_10005750(*(short *)(iVar5 + 0x10037e58) + 6,
                             *(short *)(iVar5 + 0x10037e58) + 0x1a,
                             *(short *)(iVar5 + 0x10037e5a) + 0x1f);
        if (cVar4 == '\0') {
          FUN_1002b020(10,5);
          iVar6 = *(short *)(iVar5 + 0x10037e8c) * 0x70;
          *(int *)(iVar6 + 0x1003a9ec) =
               *(int *)(iVar6 + 0x1003a9ec) + (int)*(short *)(iVar5 + 0x10037e8a);
          *(undefined1 *)(iVar5 + 0x10037e68) = 1;
          FUN_10028014(*(undefined4 *)(iVar5 + 0x10037e52),(int)*(short *)(iVar5 + 0x10037e56),
                       (int)*(short *)(iVar5 + 0x10037e58),(int)*(short *)(iVar5 + 0x10037e5a),1);
        }
      }
      *(short *)(iVar5 + 0x10037e82) = *(short *)(iVar5 + 0x10037e58) + 9;
      *(short *)(iVar5 + 0x10037e84) = *(short *)(iVar5 + 0x10037e58) + 0x19;
      *(short *)(iVar5 + 0x10037e80) = *(short *)(iVar5 + 0x10037e5a) + 6;
      *(short *)(iVar5 + 0x10037e7e) = *(short *)(iVar5 + 0x10037e5a) + 0x1e;
    }
  }
  else {
    *(undefined1 *)(iVar5 + 0x10037e67) = 0;
    *(undefined2 *)(iVar5 + 0x10037e6c) = 1;
    *(undefined4 *)(iVar5 + 0x10037e52) = uRam1003a350;
    *(undefined4 *)(iVar5 + 0x10037e5c) = 0;
    if (*(short *)(iVar5 + 0x10037e4c) == 2) {
      uVar8 = (uint)*(short *)(iVar5 + 0x10037e58);
      *(undefined2 *)(iVar5 + 0x10037e56) =
           *(undefined2 *)
            (&DAT_10034570 +
            (uVar8 + (((int)uVar8 >> 5) + (uint)((int)uVar8 < 0 && (uVar8 & 0x1f) != 0)) * -0x20) *
            2);
    }
    else {
      uVar8 = (uint)*(short *)(iVar5 + 0x10037e58);
      *(undefined2 *)(iVar5 + 0x10037e56) =
           *(undefined2 *)
            (&DAT_10034530 +
            (uVar8 + (((int)uVar8 >> 5) + (uint)((int)uVar8 < 0 && (uVar8 & 0x1f) != 0)) * -0x20) *
            2);
    }
    *(short *)(iVar5 + 0x10037e5a) = *(short *)(iVar5 + 0x10037e5a) + 1;
    *(undefined1 *)(iVar5 + 0x10037e66) = 1;
    *(undefined2 *)(iVar5 + 0x10037e6e) = 0;
    *(undefined2 *)(iVar5 + 0x10037e8a) = 1000;
  }
  return;
}

