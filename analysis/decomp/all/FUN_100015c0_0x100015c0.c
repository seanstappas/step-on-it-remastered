
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100015c0(undefined4 *param_1,undefined4 param_2,short param_3,short param_4)

{
  short sVar1;
  int iVar2;
  int iVar3;
  uint *puVar4;
  short *psVar5;
  undefined4 *puVar6;
  uint uVar7;
  undefined4 *puVar8;
  short sVar9;
  short sVar10;
  int iVar11;
  short sStack00000022;
  int local_18 [2];
  
  iVar3 = (int)(short)param_2;
  psVar5 = (short *)*param_1;
  if ((0 < iVar3) && (iVar3 <= *psVar5)) {
    iVar3 = *(int *)(psVar5 + iVar3 * 2 + 4);
    sStack00000022 = param_3;
    FUN_10001348(param_1,param_2,&stack0x00000022,local_18);
    sVar1 = *(short *)((int)psVar5 + iVar3);
    iVar2 = (int)_DAT_1003ad40;
    iVar11 = _DAT_1003b254 - sVar1;
    puVar4 = (uint *)(local_18[0] + *(int *)(local_18[0] + 4));
    puVar6 = (undefined4 *)(_DAT_1003b258 + _DAT_1003b254 * param_4 + (int)sStack00000022);
    puVar8 = (undefined4 *)(_DAT_1003ad44 + param_4 * iVar2 + (int)sStack00000022);
    for (sVar9 = ((short *)((int)psVar5 + iVar3))[1]; 0 < sVar9; sVar9 = sVar9 + -1) {
      uVar7 = *puVar4;
      puVar4 = puVar4 + 1;
      for (sVar10 = 0; sVar10 < sVar1 / 4; sVar10 = sVar10 + 1) {
        if ((uVar7 & 1) != 0) {
          *puVar6 = 0xffffffff;
          *puVar8 = 0xffffffff;
        }
        puVar8 = puVar8 + 1;
        puVar6 = puVar6 + 1;
        uVar7 = (int)uVar7 >> 1;
      }
      puVar8 = puVar8 + (iVar2 - sVar1) / 4;
      puVar6 = puVar6 + iVar11 / 4;
    }
  }
  return;
}

