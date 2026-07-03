
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1000c8bc(short param_1,short param_2,undefined4 param_3,short param_4)

{
  char cVar5;
  undefined4 uVar1;
  short sVar3;
  undefined2 uVar4;
  int iVar2;
  int iVar6;
  int iVar7;
  short sStack00000026;
  short local_28;
  short local_26 [3];
  
  sStack00000026 = param_4;
  cVar5 = FUN_1000cafc(local_26,&local_28);
  if (cVar5 == '\0') {
    uVar1 = FUN_1002e6cc((int)_DAT_10037d56);
    local_26[0] = FUN_1002e6ac(uVar1);
    local_26[0] = local_26[0] + 4;
    uVar1 = FUN_1002e6f8((int)_DAT_10037d54);
    local_28 = FUN_1002e6bc(uVar1);
  }
  else {
    local_26[0] = FUN_1002e6ac((int)local_26[0]);
    local_26[0] = local_26[0] + 4;
    local_28 = FUN_1002e6bc((int)local_28);
  }
  local_28 = local_28 + 4;
  sVar3 = FUN_10005ac8((int)sStack00000026);
  *(short *)(sVar3 * 0x46 + 0x10037e58) = param_1;
  *(short *)(sVar3 * 0x46 + 0x10037e5a) = param_2;
  *(undefined2 *)(sVar3 * 0x46 + 0x10037e4a) = 0x71;
  *(undefined4 *)(sVar3 * 0x46 + 0x10037e52) = _DAT_1003ad14;
  *(undefined2 *)(sVar3 * 0x46 + 0x10037e56) = 0x10;
  *(undefined4 *)(sVar3 * 0x46 + 0x10037e5c) = 0;
  *(undefined1 *)(sVar3 * 0x46 + 0x10037e66) = 0;
  *(undefined2 *)(sVar3 * 0x46 + 0x10037e6c) = 1;
  uVar4 = FUN_1002e6f8((int)local_28);
  *(undefined2 *)(sVar3 * 0x46 + 0x10037e80) = uVar4;
  uVar4 = FUN_1002e6cc((int)local_26[0]);
  *(undefined2 *)(sVar3 * 0x46 + 0x10037e84) = uVar4;
  iVar7 = (int)local_26[0] - (int)param_1;
  iVar6 = (int)local_28 - (int)param_2;
  iVar2 = FUN_10003774(iVar7 * iVar7 + iVar6 * iVar6);
  *(short *)(sVar3 * 0x46 + 0x10037e70) = (short)((iVar7 * 0x1000) / iVar2);
  *(short *)(sVar3 * 0x46 + 0x10037e72) = (short)((iVar6 * 0x1000) / iVar2);
  *(short *)(sVar3 * 0x46 + 0x10037e74) = (short)((int)param_1 << 5);
  *(short *)(sVar3 * 0x46 + 0x10037e76) = (short)((int)param_2 << 5);
  return;
}

