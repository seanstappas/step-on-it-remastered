
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1000b44c(short param_1,short param_2,short param_3)

{
  short sVar2;
  short sVar3;
  int iVar1;
  int iVar4;
  int iVar5;
  short sVar6;
  short sVar7;
  short sStack00000022;
  
  sStack00000022 = param_3;
  FUN_1002b020(0x13,4);
  sVar7 = _DAT_10037d52;
  sVar6 = _DAT_10037d50;
  if (((_DAT_10037d56 < 0x3e9) &&
      (sVar7 = _DAT_10037d56, sVar6 = _DAT_10037d54, _DAT_10037d52 < 0x3e9)) &&
     (sVar2 = FUN_1000c278(100), sVar7 = _DAT_10037d52, sVar6 = _DAT_10037d50, 0x32 < sVar2)) {
    sVar7 = _DAT_10037d56;
    sVar6 = _DAT_10037d54;
  }
  sVar2 = FUN_10005ac8((int)sStack00000022);
  *(short *)(sVar2 * 0x46 + 0x10037e58) = param_1;
  *(short *)(sVar2 * 0x46 + 0x10037e5a) = param_2;
  sVar3 = FUN_1000c278(100);
  if (_DAT_1003b290 < sVar3) {
    *(undefined2 *)(sVar2 * 0x46 + 0x10037e8a) = 1;
    *(undefined2 *)(sVar2 * 0x46 + 0x10037e56) = 0x1f;
  }
  else {
    *(undefined2 *)(sVar2 * 0x46 + 0x10037e8a) = 2;
    *(undefined2 *)(sVar2 * 0x46 + 0x10037e56) = 1;
  }
  *(undefined2 *)(sVar2 * 0x46 + 0x10037e4a) = 0x72;
  *(undefined4 *)(sVar2 * 0x46 + 0x10037e52) = _DAT_1003ad14;
  *(undefined4 *)(sVar2 * 0x46 + 0x10037e5c) = 0;
  iVar5 = (int)sVar7 - (int)param_1;
  iVar4 = (int)sVar6 - (int)param_2;
  *(undefined1 *)(sVar2 * 0x46 + 0x10037e66) = 0;
  *(undefined2 *)(sVar2 * 0x46 + 0x10037e6c) = 1;
  iVar1 = FUN_10003774(iVar5 * iVar5 + iVar4 * iVar4);
  *(short *)(sVar2 * 0x46 + 0x10037e70) = (short)((iVar5 * 0x1000) / iVar1);
  *(short *)(sVar2 * 0x46 + 0x10037e72) = (short)((iVar4 * 0x1000) / iVar1);
  *(short *)(sVar2 * 0x46 + 0x10037e74) = (short)((int)param_1 << 5);
  *(short *)(sVar2 * 0x46 + 0x10037e76) = (short)((int)param_2 << 5);
  return;
}

