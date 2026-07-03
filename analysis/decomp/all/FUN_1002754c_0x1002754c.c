
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002754c(undefined4 param_1,undefined4 param_2,short param_3,undefined2 param_4,
                 undefined4 param_5)

{
  short sVar4;
  undefined4 uVar1;
  undefined4 uVar2;
  short sVar5;
  short sVar6;
  int iVar3;
  int iVar7;
  int iVar8;
  int iVar9;
  int iVar10;
  int iVar11;
  
  sVar4 = FUN_10027834(param_1,param_2);
  sVar5 = _DAT_1003ad5a;
  if (sVar4 == -1) {
    if (_DAT_1003ad5a != -1) {
      iVar3 = (int)_DAT_1003ad5a;
      iVar7 = (int)_DAT_1003ad5a;
      iVar8 = (int)_DAT_1003ad5a;
      iVar9 = (int)_DAT_1003ad5a;
      iVar10 = (int)_DAT_1003ad5a;
      iVar11 = (int)_DAT_1003ad5a;
      _DAT_1003ad5a = *(short *)(_DAT_1003ad5a * 0x10 + 0x1003a37e);
      *(short *)(iVar3 * 0x10 + 0x1003a37e) = _DAT_1003ad58;
      _DAT_1003ad58 = sVar5;
      *(short *)(&DAT_1003a370 + iVar7 * 0x10) = (short)param_1;
      *(short *)(iVar8 * 0x10 + 0x1003a372) = (short)param_2;
      *(undefined2 *)(iVar9 * 0x10 + 0x1003a374) = 0;
      *(undefined4 *)(iVar10 * 0x10 + 0x1003a37a) = param_5;
      *(short *)(iVar11 * 0x10 + 0x1003a376) = param_3;
      if (param_3 == -1) {
        *(undefined2 *)(sVar5 * 0x10 + 0x1003a374) = 6;
        uVar1 = FUN_1002e6f8(param_2);
        uVar2 = FUN_1002e6cc(param_1);
        FUN_1002cc10(uVar2,uVar1);
        sVar4 = FUN_1002e6f8(param_2);
        sVar6 = FUN_1002e6cc(param_1);
        iVar3 = sVar6 * 0x3c + sVar4 * 4;
        *(uint *)(&DAT_1003ad68 + iVar3) = *(uint *)(&DAT_1003ad68 + iVar3) | 0x200;
      }
      else {
        sVar4 = FUN_1002e6f8(param_2);
        sVar6 = FUN_1002e6cc(param_1);
        iVar3 = sVar6 * 0x3c + sVar4 * 4;
        *(uint *)(&DAT_1003ad68 + iVar3) = *(uint *)(&DAT_1003ad68 + iVar3) | 0x300;
      }
      *(undefined2 *)(sVar5 * 0x10 + 0x1003a378) = param_4;
    }
  }
  else {
    *(undefined2 *)(sVar4 * 0x10 + 0x1003a374) = 0;
    *(undefined4 *)(sVar4 * 0x10 + 0x1003a37a) = param_5;
    *(short *)(sVar4 * 0x10 + 0x1003a376) = param_3;
    if (param_3 == -1) {
      *(undefined2 *)(sVar4 * 0x10 + 0x1003a374) = 6;
      uVar1 = FUN_1002e6f8(param_2);
      uVar2 = FUN_1002e6cc(param_1);
      FUN_1002cc10(uVar2,uVar1);
      sVar5 = FUN_1002e6f8(param_2);
      sVar6 = FUN_1002e6cc(param_1);
      iVar3 = sVar6 * 0x3c + sVar5 * 4;
      *(uint *)(&DAT_1003ad68 + iVar3) = *(uint *)(&DAT_1003ad68 + iVar3) | 0x200;
    }
    else {
      sVar5 = FUN_1002e6f8(param_2);
      sVar6 = FUN_1002e6cc(param_1);
      iVar3 = sVar6 * 0x3c + sVar5 * 4;
      *(uint *)(&DAT_1003ad68 + iVar3) = *(uint *)(&DAT_1003ad68 + iVar3) | 0x300;
    }
    *(undefined2 *)(sVar4 * 0x10 + 0x1003a378) = param_4;
  }
  return;
}

