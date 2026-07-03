
void FUN_10008618(short param_1)

{
  int iVar1;
  undefined2 uVar4;
  char cVar6;
  undefined4 uVar2;
  undefined4 uVar3;
  short sVar5;
  
  iVar1 = param_1 * 0x46;
  if (*(char *)(iVar1 + 0x10037e67) == '\0') {
    sVar5 = *(short *)(iVar1 + 0x10037e6c);
    *(short *)(iVar1 + 0x10037e6c) = sVar5 + -1;
    if (sVar5 < 1) {
      *(undefined2 *)(iVar1 + 0x10037e6c) = 2;
      if (*(short *)(iVar1 + 0x10037e6e) < 1) {
        if (*(short *)(iVar1 + 0x10037e6e) < 0) {
          *(undefined1 *)(iVar1 + 0x10037e66) = 1;
          sVar5 = *(short *)(iVar1 + 0x10037e56) + 1;
          *(short *)(iVar1 + 0x10037e56) = sVar5;
          if (sVar5 == 0xf) {
            *(undefined1 *)(iVar1 + 0x10037e68) = 1;
            FUN_10005630((int)*(short *)(iVar1 + 0x10037e58),(int)*(short *)(iVar1 + 0x10037e5a),
                         (int)*(short *)(iVar1 + 0x10037e70));
          }
        }
      }
      else if (1 < *(short *)(iVar1 + 0x10037e56)) {
        *(short *)(iVar1 + 0x10037e56) = *(short *)(iVar1 + 0x10037e56) + -1;
        *(undefined1 *)(iVar1 + 0x10037e66) = 1;
      }
      sVar5 = *(short *)(iVar1 + 0x10037e6e);
      *(short *)(iVar1 + 0x10037e6e) = sVar5 + -1;
      if (sVar5 == 0) {
        if (*(short *)(iVar1 + 0x10037e4c) == 2) {
          cVar6 = FUN_1000554c(*(short *)(iVar1 + 0x10037e58) + 0x20,
                               *(short *)(iVar1 + 0x10037e5a) + 10);
          if (cVar6 == '\0') {
            uVar2 = FUN_1002e6f8(*(short *)(iVar1 + 0x10037e5a) + 10);
            uVar3 = FUN_1002e6cc(*(short *)(iVar1 + 0x10037e58) + 0x20);
            cVar6 = FUN_10004650(uVar3,uVar2);
            if (cVar6 == '\0') {
              *(undefined2 *)(iVar1 + 0x10037e4c) = 1;
              *(undefined2 *)(iVar1 + 0x10037e6e) = 0;
            }
            else {
              uVar2 = FUN_100055c8(*(short *)(iVar1 + 0x10037e58) + 0x20,
                                   (int)*(short *)(iVar1 + 0x10037e5a));
              cVar6 = FUN_10009030(uVar2);
              if (cVar6 == '\0') {
                *(undefined2 *)(iVar1 + 0x10037e4c) = 1;
                *(undefined2 *)(iVar1 + 0x10037e6e) = 0;
              }
              else {
                sVar5 = FUN_10005948();
                *(short *)(sVar5 * 0x46 + 0x10037e58) = *(short *)(iVar1 + 0x10037e58) + 0x20;
                *(undefined2 *)(sVar5 * 0x46 + 0x10037e5a) = *(undefined2 *)(iVar1 + 0x10037e5a);
                *(undefined2 *)(sVar5 * 0x46 + 0x10037e4c) = 2;
                *(undefined2 *)(sVar5 * 0x46 + 0x10037e4a) = 0x10;
                *(undefined4 *)(sVar5 * 0x46 + 0x10037e52) = uRam1003a354;
                *(undefined2 *)(sVar5 * 0x46 + 0x10037e56) = 0xf;
                *(undefined4 *)(sVar5 * 0x46 + 0x10037e5c) = 0;
                *(undefined1 *)(sVar5 * 0x46 + 0x10037e66) = 0;
                *(undefined2 *)(sVar5 * 0x46 + 0x10037e50) = *(undefined2 *)(iVar1 + 0x10037e50);
              }
            }
          }
          else {
            *(undefined2 *)(iVar1 + 0x10037e4c) = 1;
            *(undefined2 *)(iVar1 + 0x10037e6e) = 0;
          }
        }
        else if (*(short *)(iVar1 + 0x10037e4c) == 1) {
          cVar6 = FUN_1000554c(*(short *)(iVar1 + 0x10037e58) + -1,
                               *(short *)(iVar1 + 0x10037e5a) + 10);
          if (cVar6 == '\0') {
            uVar2 = FUN_1002e6f8(*(short *)(iVar1 + 0x10037e5a) + 10);
            uVar3 = FUN_1002e6cc(*(short *)(iVar1 + 0x10037e58) + -0x10);
            cVar6 = FUN_10004650(uVar3,uVar2);
            if (cVar6 == '\0') {
              *(undefined2 *)(iVar1 + 0x10037e4c) = 2;
              *(undefined2 *)(iVar1 + 0x10037e6e) = 0;
            }
            else {
              uVar2 = FUN_100055c8(*(short *)(iVar1 + 0x10037e58) + -0x20,
                                   (int)*(short *)(iVar1 + 0x10037e5a));
              cVar6 = FUN_10009030(uVar2);
              if (cVar6 == '\0') {
                *(undefined2 *)(iVar1 + 0x10037e4c) = 2;
                *(undefined2 *)(iVar1 + 0x10037e6e) = 0;
              }
              else {
                sVar5 = FUN_10005948();
                *(short *)(sVar5 * 0x46 + 0x10037e58) = *(short *)(iVar1 + 0x10037e58) + -0x20;
                *(undefined2 *)(sVar5 * 0x46 + 0x10037e5a) = *(undefined2 *)(iVar1 + 0x10037e5a);
                *(undefined2 *)(sVar5 * 0x46 + 0x10037e4c) = 1;
                *(undefined2 *)(sVar5 * 0x46 + 0x10037e4a) = 0x10;
                *(undefined4 *)(sVar5 * 0x46 + 0x10037e52) = uRam1003a354;
                *(undefined2 *)(sVar5 * 0x46 + 0x10037e56) = 0xf;
                *(undefined4 *)(sVar5 * 0x46 + 0x10037e5c) = 0;
                *(undefined1 *)(sVar5 * 0x46 + 0x10037e66) = 0;
                *(undefined2 *)(sVar5 * 0x46 + 0x10037e50) = *(undefined2 *)(iVar1 + 0x10037e50);
              }
            }
          }
          else {
            *(undefined2 *)(iVar1 + 0x10037e4c) = 2;
            *(undefined2 *)(iVar1 + 0x10037e6e) = 0;
          }
        }
      }
    }
  }
  else {
    *(undefined1 *)(iVar1 + 0x10037e67) = 0;
    *(short *)(iVar1 + 0x10037e6e) = *(short *)(iVar1 + 0x10037e50) * 3;
    *(undefined2 *)(iVar1 + 0x10037e6c) = 1;
    *(undefined4 *)(iVar1 + 0x10037e52) = uRam1003a354;
    *(undefined4 *)(iVar1 + 0x10037e5c) = 0;
    *(undefined2 *)(iVar1 + 0x10037e56) = 0xf;
    *(undefined1 *)(iVar1 + 0x10037e66) = 1;
    uVar4 = FUN_100055c8((int)*(short *)(param_1 * 0x46 + 0x10037e58),
                         (int)*(short *)(param_1 * 0x46 + 0x10037e5a));
    *(undefined2 *)(param_1 * 0x46 + 0x10037e70) = uVar4;
    FUN_10005630((int)*(short *)(param_1 * 0x46 + 0x10037e58),
                 (int)*(short *)(param_1 * 0x46 + 0x10037e5a),
                 (int)*(short *)(param_1 * 0x46 + 0x10037e70) | 0x300);
  }
  return;
}

