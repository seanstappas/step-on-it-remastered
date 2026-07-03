
void FUN_1000195c(undefined4 *param_1,undefined4 param_2,short param_3,short param_4,int param_5,
                 short param_6)

{
  byte bVar1;
  uint uVar2;
  int iVar3;
  uint *puVar4;
  short sVar5;
  int iVar6;
  byte *pbVar7;
  short *psVar8;
  uint uVar9;
  uint *puVar10;
  short sStack00000022;
  int *local_18 [2];
  
  iVar6 = (int)(short)param_2;
  psVar8 = (short *)*param_1;
  if ((iVar6 < 1) || (*psVar8 < iVar6)) {
    return;
  }
  iVar6 = *(int *)(psVar8 + iVar6 * 2 + 4);
  sStack00000022 = param_3;
  FUN_10001348(param_1,param_2,&stack0x00000022,local_18);
  iVar3 = ((int)param_6 - (int)*(short *)((int)psVar8 + iVar6)) / 4;
  sVar5 = ((short *)((int)psVar8 + iVar6))[1];
  puVar4 = (uint *)(param_5 + (int)param_4 * (int)param_6 + (int)sStack00000022);
  puVar10 = (uint *)((int)local_18[0] + *local_18[0]);
  pbVar7 = (byte *)((int)local_18[0] + 9);
  if (*(char *)(local_18[0] + 2) != '\0') goto LAB_10001a80;
LAB_10001a24:
  bVar1 = *pbVar7;
  uVar9 = (int)(uint)bVar1 >> 1;
  pbVar7 = pbVar7 + 1;
  if (uVar9 == 0) {
    if ((bVar1 & 1) == 0) goto LAB_10001b3c;
    goto LAB_10001af8;
  }
  if ((bVar1 & 1) == 1) goto LAB_10001ab8;
LAB_10001a70:
  while (uVar2 = uVar9 & 0xff, uVar9 = uVar9 - 1, uVar2 != 0) {
    *puVar4 = *puVar4 & *puVar10 | puVar10[1];
    puVar10 = puVar10 + 2;
    puVar4 = puVar4 + 1;
  }
LAB_10001a80:
  do {
    bVar1 = *pbVar7;
    uVar9 = (int)(uint)bVar1 >> 1;
    pbVar7 = pbVar7 + 1;
    if (uVar9 == 0) {
      if ((bVar1 & 1) == 1) {
LAB_10001af8:
        sVar5 = sVar5 + -1;
        puVar4 = puVar4 + iVar3;
        if (sVar5 < 1) {
          return;
        }
        goto LAB_10001ac8;
      }
LAB_10001b1c:
      sVar5 = sVar5 + -1;
      puVar4 = puVar4 + iVar3;
      if (sVar5 < 1) {
        return;
      }
      goto LAB_10001a24;
    }
    if ((bVar1 & 1) == 0) goto LAB_10001a18;
LAB_10001ab8:
    while (uVar2 = uVar9 & 0xff, uVar9 = uVar9 - 1, uVar2 != 0) {
      *puVar4 = *puVar10;
      puVar10 = puVar10 + 1;
      puVar4 = puVar4 + 1;
    }
LAB_10001ac8:
    bVar1 = *pbVar7;
    uVar9 = (int)(uint)bVar1 >> 1;
    pbVar7 = pbVar7 + 1;
    if (uVar9 != 0) break;
    if ((bVar1 & 1) == 0) goto LAB_10001b1c;
LAB_10001b3c:
    sVar5 = sVar5 + -1;
    puVar4 = puVar4 + iVar3;
    if (sVar5 < 1) {
      return;
    }
  } while( true );
  if ((bVar1 & 1) == 0) goto LAB_10001a18;
  goto LAB_10001a70;
LAB_10001a18:
  puVar4 = puVar4 + uVar9;
  goto LAB_10001a24;
}

