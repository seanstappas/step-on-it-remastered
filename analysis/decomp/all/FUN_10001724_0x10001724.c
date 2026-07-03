
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10001724(undefined4 *param_1,undefined4 param_2,short param_3,short param_4)

{
  short sVar1;
  int iVar2;
  int iVar3;
  short *psVar4;
  uint uVar5;
  int iVar6;
  uint *puVar7;
  short sVar8;
  int iVar9;
  undefined4 *puVar10;
  undefined4 *puVar11;
  int iVar12;
  undefined4 *puVar13;
  short sVar14;
  short sStack00000022;
  int local_28 [3];
  
  iVar3 = (int)(short)param_2;
  psVar4 = (short *)*param_1;
  if ((0 < iVar3) && (iVar3 <= *psVar4)) {
    iVar3 = *(int *)(psVar4 + iVar3 * 2 + 4);
    sStack00000022 = param_3;
    FUN_10001348(param_1,param_2,&stack0x00000022,local_28);
    iVar12 = (int)param_4;
    sVar1 = *(short *)((int)psVar4 + iVar3);
    iVar6 = (int)_DAT_1003ad40;
    iVar2 = (_DAT_1003b254 - sVar1) / 4;
    iVar9 = (int)sStack00000022;
    puVar11 = (undefined4 *)(_DAT_1003b258 + _DAT_1003b254 * iVar12 + iVar9);
    puVar7 = (uint *)(local_28[0] + *(int *)(local_28[0] + 4));
    puVar13 = (undefined4 *)(_DAT_1003ad44 + iVar12 * iVar6 + iVar9);
    puVar10 = (undefined4 *)(_DAT_1003ad4c + _DAT_1003ad48 * iVar12 + iVar9);
    for (sVar14 = ((short *)((int)psVar4 + iVar3))[1]; 0 < sVar14; sVar14 = sVar14 + -1) {
      uVar5 = *puVar7;
      puVar7 = puVar7 + 1;
      for (sVar8 = 0; sVar8 < sVar1 / 4; sVar8 = sVar8 + 1) {
        if ((uVar5 & 1) != 0) {
          *puVar10 = 0xffffffff;
          *puVar11 = 0xffffffff;
          *puVar13 = 0xffffffff;
        }
        puVar13 = puVar13 + 1;
        puVar11 = puVar11 + 1;
        puVar10 = puVar10 + 1;
        uVar5 = (int)uVar5 >> 1;
      }
      puVar13 = puVar13 + (iVar6 - sVar1) / 4;
      puVar11 = puVar11 + iVar2;
      puVar10 = puVar10 + iVar2;
    }
  }
  return;
}

