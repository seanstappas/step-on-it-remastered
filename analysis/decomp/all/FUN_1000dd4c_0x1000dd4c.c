
void FUN_1000dd4c(undefined4 param_1)

{
  int iVar1;
  char cVar3;
  undefined2 uVar2;
  int iVar4;
  uint uVar5;
  short sVar6;
  
  iVar1 = (short)param_1 * 0x46;
  if (*(char *)(iVar1 + 0x10037e67) == '\0') {
    sVar6 = *(short *)(iVar1 + 0x10037e6c);
    *(short *)(iVar1 + 0x10037e6c) = sVar6 + -1;
    if (sVar6 < 1) {
      *(undefined1 *)(iVar1 + 0x10037e66) = 1;
      *(short *)(iVar1 + 0x10037e6e) = *(short *)(iVar1 + 0x10037e6e) + -1;
      if (0 < *(short *)(iVar1 + 0x10037e88)) {
        FUN_1002b020(0xc,5);
        *(undefined1 *)(iVar1 + 0x10037e68) = 1;
        FUN_10028014(*(undefined4 *)(iVar1 + 0x10037e52),(int)*(short *)(iVar1 + 0x10037e56),
                     (int)*(short *)(iVar1 + 0x10037e58),(int)*(short *)(iVar1 + 0x10037e5a),1);
        iVar4 = *(short *)(iVar1 + 0x10037e88) * 0x70;
        *(int *)(iVar4 + 0x1003a9ec) =
             *(int *)(iVar4 + 0x1003a9ec) + (int)*(short *)(iVar1 + 0x10037e8a);
      }
      *(undefined2 *)(iVar1 + 0x10037e6c) = 2;
      cVar3 = FUN_10005750(*(short *)(iVar1 + 0x10037e58) + 8,*(short *)(iVar1 + 0x10037e58) + 0x20,
                           *(short *)(iVar1 + 0x10037e5a) + 0x1a);
      if (cVar3 == '\0') {
        if (*(short *)(iVar1 + 0x10037e4c) == 2) {
          cVar3 = FUN_1000554c(*(short *)(iVar1 + 0x10037e58) + 0x22,
                               *(short *)(iVar1 + 0x10037e5a) + 10);
          if ((cVar3 == '\0') &&
             (cVar3 = FUN_1000554c(*(short *)(iVar1 + 0x10037e58) + 0x22,
                                   *(short *)(iVar1 + 0x10037e5a) + 0x1a), cVar3 != '\0')) {
            *(short *)(iVar1 + 0x10037e58) = *(short *)(iVar1 + 0x10037e58) + 1;
            uVar5 = (uint)*(short *)(iVar1 + 0x10037e58);
            *(wchar_t *)(iVar1 + 0x10037e56) =
                 u______________0_______________0___100346ac
                 [uVar5 + (((int)uVar5 >> 5) + (uint)((int)uVar5 < 0 && (uVar5 & 0x1f) != 0)) *
                          -0x20];
          }
          else {
            *(undefined2 *)(iVar1 + 0x10037e4c) = 5;
            *(undefined2 *)(iVar1 + 0x10037e56) = 0x20;
          }
          cVar3 = FUN_1000e5c8(param_1);
          if (cVar3 != '\0') {
            FUN_1002b020(0x13,4);
            *(short *)(iVar1 + 0x10037e6e) = (short)((int)*(short *)(iVar1 + 0x10037e50) << 2);
            uVar2 = FUN_10005948();
            *(undefined2 *)(iVar1 + 0x10037e7a) = uVar2;
            *(short *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e58) =
                 *(short *)(iVar1 + 0x10037e58) + 0x1e;
            *(short *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e5a) =
                 *(short *)(iVar1 + 0x10037e5a) + 8;
            *(undefined2 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e4c) = 2;
            *(undefined2 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e56) = 0x31;
            *(undefined2 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e4a) = 0x68;
            *(undefined4 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e52) = uRam1003a324;
            *(undefined4 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e5c) = 0;
            *(undefined1 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e66) = 0;
          }
        }
        else if (*(short *)(iVar1 + 0x10037e4c) == 1) {
          cVar3 = FUN_1000554c(*(short *)(iVar1 + 0x10037e58) + 2,
                               *(short *)(iVar1 + 0x10037e5a) + 10);
          if ((cVar3 == '\0') &&
             (cVar3 = FUN_1000554c(*(short *)(iVar1 + 0x10037e58) + 2,
                                   *(short *)(iVar1 + 0x10037e5a) + 0x1a), cVar3 != '\0')) {
            *(short *)(iVar1 + 0x10037e58) = *(short *)(iVar1 + 0x10037e58) + -1;
            uVar5 = (uint)*(short *)(iVar1 + 0x10037e58);
            *(undefined2 *)(iVar1 + 0x10037e56) =
                 *(undefined2 *)
                  (&DAT_1003466c +
                  (uVar5 + (((int)uVar5 >> 5) + (uint)((int)uVar5 < 0 && (uVar5 & 0x1f) != 0)) *
                           -0x20) * 2);
          }
          else {
            *(undefined2 *)(iVar1 + 0x10037e4c) = 6;
            *(undefined2 *)(iVar1 + 0x10037e56) = 0x11;
          }
          cVar3 = FUN_1000e7c8(param_1);
          if (cVar3 != '\0') {
            FUN_1002b020(0x13,4);
            *(short *)(iVar1 + 0x10037e6e) = (short)((int)*(short *)(iVar1 + 0x10037e50) << 2);
            uVar2 = FUN_10005948();
            *(undefined2 *)(iVar1 + 0x10037e7a) = uVar2;
            *(short *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e58) =
                 *(short *)(iVar1 + 0x10037e58) + -8;
            *(short *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e5a) =
                 *(short *)(iVar1 + 0x10037e5a) + 4;
            *(undefined2 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e4c) = 1;
            *(undefined2 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e56) = 0x41;
            *(undefined2 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e4a) = 0x68;
            *(undefined4 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e52) = uRam1003a324;
            *(undefined4 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e5c) = 0;
            *(undefined1 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e66) = 0;
          }
        }
        else if (*(short *)(iVar1 + 0x10037e4c) == 6) {
          sVar6 = *(short *)(iVar1 + 0x10037e56) + 1;
          *(short *)(iVar1 + 0x10037e56) = sVar6;
          if (0x20 < sVar6) {
            *(undefined2 *)(iVar1 + 0x10037e4c) = 2;
            *(short *)(iVar1 + 0x10037e58) = *(short *)(iVar1 + 0x10037e58) + -3;
          }
        }
        else if ((*(short *)(iVar1 + 0x10037e4c) == 5) &&
                (sVar6 = *(short *)(iVar1 + 0x10037e56) + -1, *(short *)(iVar1 + 0x10037e56) = sVar6
                , sVar6 < 0x11)) {
          *(undefined2 *)(iVar1 + 0x10037e4c) = 1;
        }
      }
      else {
        if (*(short *)(iVar1 + 0x10037e8c) == 0) {
          uVar2 = FUN_1000581c((int)*(short *)(iVar1 + 0x10037e58),
                               (int)*(short *)(iVar1 + 0x10037e5a));
          *(undefined2 *)(iVar1 + 0x10037e8c) = uVar2;
        }
        *(undefined2 *)(iVar1 + 0x10037e6c) = 1;
        *(short *)(iVar1 + 0x10037e5a) = *(short *)(iVar1 + 0x10037e5a) + 4;
        *(short *)(iVar1 + 0x10037e56) = *(short *)(iVar1 + 0x10037e56) + 4;
        if (*(short *)(iVar1 + 0x10037e4c) == 2) {
          if (0x30 < *(short *)(iVar1 + 0x10037e56)) {
            *(undefined2 *)(iVar1 + 0x10037e56) = 0x21;
          }
        }
        else if (0x10 < *(short *)(iVar1 + 0x10037e56)) {
          *(undefined2 *)(iVar1 + 0x10037e56) = 1;
        }
        cVar3 = FUN_10005750(*(short *)(iVar1 + 0x10037e58) + 8,
                             *(short *)(iVar1 + 0x10037e58) + 0x20,
                             *(short *)(iVar1 + 0x10037e5a) + 0x1a);
        if (cVar3 == '\0') {
          FUN_1002b020(0xc,5);
          iVar4 = *(short *)(iVar1 + 0x10037e8c) * 0x70;
          *(int *)(iVar4 + 0x1003a9ec) =
               *(int *)(iVar4 + 0x1003a9ec) + (int)*(short *)(iVar1 + 0x10037e8a);
          *(undefined1 *)(iVar1 + 0x10037e68) = 1;
          FUN_10028014(*(undefined4 *)(iVar1 + 0x10037e52),(int)*(short *)(iVar1 + 0x10037e56),
                       (int)*(short *)(iVar1 + 0x10037e58),(int)*(short *)(iVar1 + 0x10037e5a),1);
        }
      }
      *(short *)(iVar1 + 0x10037e82) = *(short *)(iVar1 + 0x10037e58) + 8;
      *(short *)(iVar1 + 0x10037e84) = *(short *)(iVar1 + 0x10037e58) + 0x1e;
      *(short *)(iVar1 + 0x10037e80) = *(short *)(iVar1 + 0x10037e5a) + 4;
      *(short *)(iVar1 + 0x10037e7e) = *(short *)(iVar1 + 0x10037e5a) + 0x18;
    }
  }
  else {
    *(undefined1 *)(iVar1 + 0x10037e67) = 0;
    *(undefined2 *)(iVar1 + 0x10037e6c) = 1;
    *(undefined2 *)(iVar1 + 0x10037e76) = 0;
    *(undefined4 *)(iVar1 + 0x10037e52) = uRam1003a324;
    *(undefined4 *)(iVar1 + 0x10037e5c) = 0;
    if (*(short *)(iVar1 + 0x10037e4c) == 2) {
      uVar5 = (uint)*(short *)(iVar1 + 0x10037e58);
      *(wchar_t *)(iVar1 + 0x10037e56) =
           u______________0_______________0___100346ac
           [uVar5 + (((int)uVar5 >> 5) + (uint)((int)uVar5 < 0 && (uVar5 & 0x1f) != 0)) * -0x20];
    }
    else {
      uVar5 = (uint)*(short *)(iVar1 + 0x10037e58);
      *(undefined2 *)(iVar1 + 0x10037e56) =
           *(undefined2 *)
            (&DAT_1003466c +
            (uVar5 + (((int)uVar5 >> 5) + (uint)((int)uVar5 < 0 && (uVar5 & 0x1f) != 0)) * -0x20) *
            2);
    }
    *(short *)(iVar1 + 0x10037e5a) = *(short *)(iVar1 + 0x10037e5a) + 6;
    *(undefined1 *)(iVar1 + 0x10037e66) = 1;
    *(short *)(iVar1 + 0x10037e6e) = *(short *)(iVar1 + 0x10037e50) * 6;
    *(undefined2 *)(iVar1 + 0x10037e8a) = 0x4e2;
    *(undefined2 *)(iVar1 + 0x10037e8c) = 0;
  }
  return;
}

