
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_1000e7c8(short param_1)

{
  undefined4 uVar1;
  short sVar2;
  short sVar3;
  int iVar4;
  short sStack0000001a;
  
  iVar4 = param_1 * 0x46;
  if (*(short *)(iVar4 + 0x10037e6e) < 1) {
    sVar2 = *(short *)(iVar4 + 0x10037e5a) - _DAT_10037d54;
    if (sVar2 < 0) {
      sVar2 = -sVar2;
    }
    sVar3 = *(short *)(iVar4 + 0x10037e5a) - _DAT_10037d50;
    if (sVar3 < 0) {
      sVar3 = -sVar3;
    }
    if ((sVar3 < 0x28) || (sVar2 < 0x28)) {
      uVar1 = 1;
    }
    else {
      sStack0000001a = param_1;
      sVar2 = FUN_1002e6cc(*(short *)(iVar4 + 0x10037e58) + -8);
      sVar3 = FUN_1002e6f8((int)*(short *)(iVar4 + 0x10037e5a));
      if ((sVar2 < 1) ||
         (((*(uint *)(&DAT_1003ad68 + sVar2 * 0x3c + sVar3 * 4) & 0x100) != 0 ||
          ((*(uint *)(&DAT_1003ad68 + sVar2 * 0x3c + sVar3 * 4) & 0x200) == 0)))) {
        if ((sVar2 + -1 < 1) ||
           (((*(uint *)(&DAT_1003ad68 + (sVar2 + -1) * 0x3c + sVar3 * 4) & 0x100) != 0 ||
            ((*(uint *)(&DAT_1003ad68 + (sVar2 + -1) * 0x3c + sVar3 * 4) & 0x200) == 0)))) {
          if ((sVar2 + -2 < 1) ||
             (((*(uint *)(&DAT_1003ad68 + (sVar2 + -2) * 0x3c + sVar3 * 4) & 0x100) != 0 ||
              ((*(uint *)(&DAT_1003ad68 + (sVar2 + -2) * 0x3c + sVar3 * 4) & 0x200) == 0)))) {
            if ((sVar2 + -3 < 1) ||
               (((*(uint *)(&DAT_1003ad68 + (sVar2 + -3) * 0x3c + sVar3 * 4) & 0x100) != 0 ||
                ((*(uint *)(&DAT_1003ad68 + (sVar2 + -3) * 0x3c + sVar3 * 4) & 0x200) == 0)))) {
              uVar1 = 0;
            }
            else {
              uVar1 = 1;
            }
          }
          else {
            uVar1 = 1;
          }
        }
        else {
          uVar1 = 1;
        }
      }
      else {
        uVar1 = 1;
      }
    }
  }
  else {
    uVar1 = 0;
  }
  return uVar1;
}

