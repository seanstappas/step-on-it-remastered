
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10016544(undefined2 param_1,undefined4 param_2,undefined4 param_3)

{
  undefined4 uVar1;
  undefined4 uVar2;
  undefined4 unaff_r29;
  short unaff_r30;
  int iVar3;
  undefined2 uStack0000001a;
  
  switch(param_1) {
  case 0x24:
    unaff_r29 = 0x25;
    unaff_r30 = 0;
    break;
  case 0x25:
    unaff_r29 = 0x24;
    unaff_r30 = 0;
    break;
  case 0x26:
    unaff_r29 = 0x27;
    unaff_r30 = 1;
    break;
  case 0x27:
    unaff_r29 = 0x26;
    unaff_r30 = 1;
    break;
  case 0x28:
    unaff_r29 = 0x29;
    unaff_r30 = 2;
    break;
  case 0x29:
    unaff_r29 = 0x28;
    unaff_r30 = 2;
    break;
  case 0x2a:
    unaff_r29 = 0x2b;
    unaff_r30 = 3;
    break;
  case 0x2b:
    unaff_r29 = 0x2a;
    unaff_r30 = 3;
    break;
  case 0x2c:
    unaff_r29 = 0x2d;
    unaff_r30 = 4;
    break;
  case 0x2d:
    unaff_r29 = 0x2c;
    unaff_r30 = 4;
  }
  uStack0000001a = param_1;
  for (iVar3 = 0; (short)iVar3 < _DAT_10038ec6; iVar3 = iVar3 + 1) {
    if (unaff_r30 == *(short *)((short)iVar3 * 0xe + 0x10038ed0)) {
      FUN_100166b8(iVar3);
    }
  }
  uVar1 = FUN_1002e6bc(param_3);
  uVar2 = FUN_1002e6ac(param_2);
  FUN_10004108(_DAT_1003ad2c,unaff_r29,uVar2,uVar1);
  *(int *)(&DAT_1003ad68 + (short)param_2 * 0x3c + (short)param_3 * 4) = (short)unaff_r29 + 0x900;
  return;
}

