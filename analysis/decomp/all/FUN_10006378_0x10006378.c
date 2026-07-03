
void FUN_10006378(short param_1)

{
  int iVar1;
  char cVar4;
  undefined2 uVar2;
  short sVar3;
  uint uVar5;
  int iVar6;
  
  iVar1 = param_1 * 0x46;
  if (*(char *)(iVar1 + 0x10037e67) != '\0') {
    *(undefined1 *)(iVar1 + 0x10037e67) = 0;
    *(undefined1 *)(iVar1 + 0x10037e66) = 0;
    *(undefined4 *)(iVar1 + 0x10037e52) = uRam1003a330;
    *(undefined4 *)(iVar1 + 0x10037e5c) = 0;
    *(undefined2 *)(iVar1 + 0x10037e6c) = 1;
    *(short *)(iVar1 + 0x10037e58) = *(short *)(iVar1 + 0x10037e58) + 4;
    *(short *)(iVar1 + 0x10037e5a) = *(short *)(iVar1 + 0x10037e5a) + 2;
    *(undefined2 *)(iVar1 + 0x10037e7a) = 0;
    *(undefined2 *)(iVar1 + 0x10037e8a) = 0x2ee;
  }
  sVar3 = *(short *)(iVar1 + 0x10037e6c);
  *(short *)(iVar1 + 0x10037e6c) = sVar3 + -1;
  if (sVar3 == 0) {
    *(undefined2 *)(iVar1 + 0x10037e6c) = 1;
    *(undefined1 *)(iVar1 + 0x10037e66) = 1;
    if (0 < *(short *)(iVar1 + 0x10037e88)) {
      FUN_1002b020(7,5);
      *(undefined1 *)(iVar1 + 0x10037e68) = 1;
      FUN_10028014(*(undefined4 *)(iVar1 + 0x10037e52),(int)*(short *)(iVar1 + 0x10037e56),
                   (int)*(short *)(iVar1 + 0x10037e58),(int)*(short *)(iVar1 + 0x10037e5a),1);
      iVar6 = *(short *)(iVar1 + 0x10037e88) * 0x70;
      *(int *)(iVar6 + 0x1003a9ec) =
           *(int *)(iVar6 + 0x1003a9ec) + (int)*(short *)(iVar1 + 0x10037e8a);
    }
    if (*(short *)(iVar1 + 0x10037e4c) == 2) {
      if (*(short *)(iVar1 + 0x10037e7a) == 0) {
        cVar4 = FUN_1000554c(*(short *)(iVar1 + 0x10037e58) + 0x1c,
                             *(short *)(iVar1 + 0x10037e5a) + 10);
        if (cVar4 == '\0') {
          *(short *)(iVar1 + 0x10037e58) = *(short *)(iVar1 + 0x10037e58) + 2;
          uVar5 = (uint)*(short *)(iVar1 + 0x10037e58);
          *(undefined2 *)(iVar1 + 0x10037e56) =
               *(undefined2 *)
                (&DAT_10034270 +
                (uVar5 + (((int)uVar5 >> 5) + (uint)((int)uVar5 < 0 && (uVar5 & 0x1f) != 0)) * -0x20
                ) * 2);
        }
        else {
          cVar4 = FUN_100056d4(*(short *)(iVar1 + 0x10037e58) + 0x1c,
                               *(short *)(iVar1 + 0x10037e5a) + 10);
          if (cVar4 == '\0') {
            uVar2 = FUN_10005948();
            *(undefined2 *)(iVar1 + 0x10037e7a) = uVar2;
            *(short *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e78) = param_1;
            *(short *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e58) =
                 *(short *)(iVar1 + 0x10037e58) + 0x1c;
            *(short *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e5a) =
                 *(short *)(iVar1 + 0x10037e5a) + 3;
            *(undefined2 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e4c) = 2;
            *(undefined2 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e56) = 1;
            *(undefined2 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e4a) = 0x6b;
            *(undefined4 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e52) = uRam1003a330;
            *(undefined4 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e5c) = 0;
            *(undefined1 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e66) = 0;
          }
          else {
            *(undefined2 *)(iVar1 + 0x10037e4c) = 5;
            *(undefined2 *)(iVar1 + 0x10037e6e) = 0;
          }
        }
      }
    }
    else if (*(short *)(iVar1 + 0x10037e4c) == 1) {
      if (*(short *)(iVar1 + 0x10037e7a) == 0) {
        cVar4 = FUN_1000554c((int)*(short *)(iVar1 + 0x10037e58),*(short *)(iVar1 + 0x10037e5a) + 10
                            );
        if (cVar4 == '\0') {
          *(short *)(iVar1 + 0x10037e58) = *(short *)(iVar1 + 0x10037e58) + -2;
          uVar5 = (uint)*(short *)(iVar1 + 0x10037e58);
          *(undefined2 *)(iVar1 + 0x10037e56) =
               *(undefined2 *)
                (&DAT_100342b0 +
                (uVar5 + (((int)uVar5 >> 5) + (uint)((int)uVar5 < 0 && (uVar5 & 0x1f) != 0)) * -0x20
                ) * 2);
        }
        else {
          cVar4 = FUN_100056d4((int)*(short *)(iVar1 + 0x10037e58),
                               *(short *)(iVar1 + 0x10037e5a) + 10);
          if (cVar4 == '\0') {
            uVar2 = FUN_10005948();
            *(undefined2 *)(iVar1 + 0x10037e7a) = uVar2;
            *(short *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e78) = param_1;
            *(short *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e58) =
                 *(short *)(iVar1 + 0x10037e58) + -0x18;
            *(short *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e5a) =
                 *(short *)(iVar1 + 0x10037e5a) + 2;
            *(undefined2 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e4c) = 1;
            *(undefined2 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e56) = 0x20;
            *(undefined2 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e4a) = 0x6b;
            *(undefined4 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e52) = uRam1003a330;
            *(undefined4 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e5c) = 0;
            *(undefined1 *)(*(short *)(iVar1 + 0x10037e7a) * 0x46 + 0x10037e66) = 0;
          }
          else {
            *(undefined2 *)(iVar1 + 0x10037e4c) = 6;
            *(undefined2 *)(iVar1 + 0x10037e6e) = 0xf;
          }
        }
      }
    }
    else if (*(short *)(iVar1 + 0x10037e4c) == 6) {
      *(undefined2 *)(iVar1 + 0x10037e56) =
           *(undefined2 *)(&DAT_100342f0 + *(short *)(iVar1 + 0x10037e6e) * 2);
      sVar3 = *(short *)(iVar1 + 0x10037e6e) + -1;
      *(short *)(iVar1 + 0x10037e6e) = sVar3;
      if (sVar3 < 0) {
        *(undefined2 *)(iVar1 + 0x10037e4c) = 2;
      }
    }
    else if (*(short *)(iVar1 + 0x10037e4c) == 5) {
      *(undefined2 *)(iVar1 + 0x10037e56) =
           *(undefined2 *)(&DAT_100342f0 + *(short *)(iVar1 + 0x10037e6e) * 2);
      sVar3 = *(short *)(iVar1 + 0x10037e6e) + 1;
      *(short *)(iVar1 + 0x10037e6e) = sVar3;
      if (sVar3 == 0x10) {
        *(undefined2 *)(iVar1 + 0x10037e4c) = 1;
      }
    }
    *(short *)(iVar1 + 0x10037e82) = *(short *)(iVar1 + 0x10037e58) + 6;
    *(short *)(iVar1 + 0x10037e84) = *(short *)(iVar1 + 0x10037e58) + 0x18;
    *(short *)(iVar1 + 0x10037e80) = *(short *)(iVar1 + 0x10037e5a) + 2;
    *(short *)(iVar1 + 0x10037e7e) = *(short *)(iVar1 + 0x10037e5a) + 0x1c;
  }
  return;
}

