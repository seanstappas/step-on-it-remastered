
void FUN_10006840(undefined4 param_1)

{
  short sVar1;
  int iVar2;
  char cVar5;
  undefined2 uVar3;
  short sVar4;
  int iVar6;
  
  sVar4 = (short)param_1;
  iVar2 = sVar4 * 0x46;
  if (*(char *)(iVar2 + 0x10037e67) != '\0') {
    *(undefined1 *)(iVar2 + 0x10037e67) = 0;
    *(undefined1 *)(iVar2 + 0x10037e66) = 0;
    *(undefined4 *)(iVar2 + 0x10037e52) = uRam1003a330;
    *(undefined4 *)(iVar2 + 0x10037e5c) = 0;
    *(undefined2 *)(iVar2 + 0x10037e6c) = 1;
    *(short *)(iVar2 + 0x10037e58) = *(short *)(iVar2 + 0x10037e58) + 4;
    *(short *)(iVar2 + 0x10037e5a) = *(short *)(iVar2 + 0x10037e5a) + 2;
    *(undefined2 *)(iVar2 + 0x10037e7a) = 0;
    if (*(short *)(iVar2 + 0x10037e4c) == 2) {
      *(undefined2 *)(iVar2 + 0x10037e4c) = 9;
    }
    else {
      *(undefined2 *)(iVar2 + 0x10037e4c) = 8;
    }
    *(undefined2 *)(iVar2 + 0x10037e8a) = 0x2ee;
  }
  sVar1 = *(short *)(iVar2 + 0x10037e6c);
  *(short *)(iVar2 + 0x10037e6c) = sVar1 + -1;
  if (sVar1 == 0) {
    *(undefined2 *)(iVar2 + 0x10037e6c) = 1;
    *(undefined1 *)(iVar2 + 0x10037e66) = 1;
    if (0 < *(short *)(iVar2 + 0x10037e88)) {
      FUN_1002b020(7,5);
      *(undefined1 *)(iVar2 + 0x10037e68) = 1;
      FUN_10028014(*(undefined4 *)(iVar2 + 0x10037e52),(int)*(short *)(iVar2 + 0x10037e56),
                   (int)*(short *)(iVar2 + 0x10037e58),(int)*(short *)(iVar2 + 0x10037e5a),1);
      iVar6 = *(short *)(iVar2 + 0x10037e88) * 0x70;
      *(int *)(iVar6 + 0x1003a9ec) =
           *(int *)(iVar6 + 0x1003a9ec) + (int)*(short *)(iVar2 + 0x10037e8a);
    }
    if (*(short *)(iVar2 + 0x10037e4c) == 9) {
      if (*(short *)(iVar2 + 0x10037e7a) == 0) {
        cVar5 = FUN_1000554c((int)*(short *)(iVar2 + 0x10037e58),
                             *(short *)(iVar2 + 0x10037e5a) + 0x1e);
        if (cVar5 == '\0') {
          *(short *)(iVar2 + 0x10037e5a) = *(short *)(iVar2 + 0x10037e5a) + 2;
          if (*(short *)(iVar2 + 0x10037e56) < 0x51) {
            *(undefined2 *)(iVar2 + 0x10037e56) = 0x51;
          }
          sVar4 = *(short *)(iVar2 + 0x10037e56) + 1;
          *(short *)(iVar2 + 0x10037e56) = sVar4;
          if (0x58 < sVar4) {
            *(undefined2 *)(iVar2 + 0x10037e56) = 0x51;
          }
        }
        else {
          cVar5 = FUN_100056d4((int)*(short *)(iVar2 + 0x10037e58),
                               *(short *)(iVar2 + 0x10037e5a) + 0x1e);
          if (cVar5 == '\0') {
            uVar3 = FUN_10005ac8(param_1);
            *(undefined2 *)(iVar2 + 0x10037e7a) = uVar3;
            *(short *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e78) = sVar4;
            *(short *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e58) =
                 *(short *)(iVar2 + 0x10037e58) + -4;
            *(short *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e5a) =
                 *(short *)(iVar2 + 0x10037e5a) + 0x12;
            *(undefined2 *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e4c) = 9;
            *(undefined2 *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e56) = 0x10;
            *(undefined2 *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e4a) = 0x6c;
            *(undefined4 *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e52) = uRam1003a330;
            *(undefined4 *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e5c) = 0;
            *(undefined1 *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e66) = 0;
          }
          else {
            *(undefined2 *)(iVar2 + 0x10037e4c) = 10;
            *(undefined2 *)(iVar2 + 0x10037e6e) = 0;
          }
        }
      }
    }
    else if (*(short *)(iVar2 + 0x10037e4c) == 8) {
      if (*(short *)(iVar2 + 0x10037e7a) == 0) {
        cVar5 = FUN_1000554c((int)*(short *)(iVar2 + 0x10037e58),*(short *)(iVar2 + 0x10037e5a) + -1
                            );
        if (cVar5 == '\0') {
          *(short *)(iVar2 + 0x10037e5a) = *(short *)(iVar2 + 0x10037e5a) + -2;
          if (*(short *)(iVar2 + 0x10037e56) < 0x71) {
            *(undefined2 *)(iVar2 + 0x10037e56) = 0x71;
          }
          sVar4 = *(short *)(iVar2 + 0x10037e56) + 1;
          *(short *)(iVar2 + 0x10037e56) = sVar4;
          if (0x78 < sVar4) {
            *(undefined2 *)(iVar2 + 0x10037e56) = 0x71;
          }
        }
        else {
          cVar5 = FUN_100056d4((int)*(short *)(iVar2 + 0x10037e58),
                               *(short *)(iVar2 + 0x10037e5a) + -1);
          if (cVar5 == '\0') {
            uVar3 = FUN_10005948();
            *(undefined2 *)(iVar2 + 0x10037e7a) = uVar3;
            *(short *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e78) = sVar4;
            *(short *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e58) =
                 *(short *)(iVar2 + 0x10037e58) + 4;
            *(short *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e5a) =
                 *(short *)(iVar2 + 0x10037e5a) + -8;
            *(undefined2 *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e4c) = 8;
            *(undefined2 *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e56) = 0x30;
            *(undefined2 *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e4a) = 0x6c;
            *(undefined4 *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e52) = uRam1003a330;
            *(undefined4 *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e5c) = 0;
            *(undefined1 *)(*(short *)(iVar2 + 0x10037e7a) * 0x46 + 0x10037e66) = 0;
          }
          else {
            *(undefined2 *)(iVar2 + 0x10037e4c) = 0xb;
            *(undefined2 *)(iVar2 + 0x10037e6e) = 0xf;
          }
        }
      }
    }
    else if (*(short *)(iVar2 + 0x10037e4c) == 0xb) {
      *(undefined2 *)(iVar2 + 0x10037e56) =
           *(undefined2 *)(&DAT_10034310 + *(short *)(iVar2 + 0x10037e6e) * 2);
      sVar4 = *(short *)(iVar2 + 0x10037e6e) + -1;
      *(short *)(iVar2 + 0x10037e6e) = sVar4;
      if (sVar4 < 0) {
        *(undefined2 *)(iVar2 + 0x10037e4c) = 9;
      }
    }
    else if (*(short *)(iVar2 + 0x10037e4c) == 10) {
      *(undefined2 *)(iVar2 + 0x10037e56) =
           *(undefined2 *)(&DAT_10034310 + *(short *)(iVar2 + 0x10037e6e) * 2);
      sVar4 = *(short *)(iVar2 + 0x10037e6e) + 1;
      *(short *)(iVar2 + 0x10037e6e) = sVar4;
      if (sVar4 == 0x10) {
        *(undefined2 *)(iVar2 + 0x10037e4c) = 8;
      }
    }
    *(short *)(iVar2 + 0x10037e82) = *(short *)(iVar2 + 0x10037e58) + 2;
    *(short *)(iVar2 + 0x10037e84) = *(short *)(iVar2 + 0x10037e58) + 0x16;
    *(short *)(iVar2 + 0x10037e80) = *(short *)(iVar2 + 0x10037e5a) + 2;
    *(short *)(iVar2 + 0x10037e7e) = *(short *)(iVar2 + 0x10037e5a) + 0x1c;
  }
  return;
}

