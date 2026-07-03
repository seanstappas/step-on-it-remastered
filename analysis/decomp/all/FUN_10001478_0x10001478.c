
void FUN_10001478(undefined4 *param_1,undefined4 param_2,short param_3,short param_4,int param_5,
                 short param_6,int param_7,short param_8)

{
  short sVar1;
  int iVar2;
  uint *puVar3;
  short *psVar4;
  undefined4 *puVar5;
  undefined4 *puVar6;
  uint uVar7;
  short sVar8;
  short sVar9;
  short sStack00000022;
  int local_28 [4];
  
  if (param_1 != (undefined4 *)0x0) {
    iVar2 = (int)(short)param_2;
    psVar4 = (short *)*param_1;
    if ((0 < iVar2) && (iVar2 <= *psVar4)) {
      iVar2 = *(int *)(psVar4 + iVar2 * 2 + 4);
      sStack00000022 = param_3;
      FUN_10001348(param_1,param_2,&stack0x00000022,local_28);
      sVar1 = *(short *)((int)psVar4 + iVar2);
      puVar3 = (uint *)(local_28[0] + *(int *)(local_28[0] + 4));
      puVar5 = (undefined4 *)(param_7 + (int)param_4 * (int)param_8 + (int)sStack00000022);
      puVar6 = (undefined4 *)(param_5 + (int)param_4 * (int)param_6 + (int)sStack00000022);
      for (sVar9 = ((short *)((int)psVar4 + iVar2))[1]; 0 < sVar9; sVar9 = sVar9 + -1) {
        uVar7 = *puVar3;
        puVar3 = puVar3 + 1;
        for (sVar8 = 0; sVar8 < sVar1 / 4; sVar8 = sVar8 + 1) {
          if ((uVar7 & 1) != 0) {
            *puVar6 = *puVar5;
          }
          puVar6 = puVar6 + 1;
          puVar5 = puVar5 + 1;
          uVar7 = (int)uVar7 >> 1;
        }
        puVar6 = puVar6 + ((int)param_6 - (int)sVar1) / 4;
        puVar5 = puVar5 + ((int)param_8 - (int)sVar1) / 4;
      }
    }
  }
  return;
}

