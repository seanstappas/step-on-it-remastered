
void FUN_1000189c(short *param_1,int param_2,int param_3,int param_4,int param_5)

{
  bool bVar1;
  uint uVar2;
  uint uVar3;
  int iVar4;
  int iVar5;
  int iVar6;
  undefined4 *puVar7;
  undefined4 *puVar8;
  
  iVar5 = (int)*param_1;
  iVar4 = (int)(short)(param_1[1] & 0xfffc);
  iVar6 = (short)(param_1[3] + 3U & 0xfffc) - iVar4;
  uVar3 = param_3 - iVar6;
  uVar2 = param_5 - iVar6;
  puVar7 = (undefined4 *)(param_2 + iVar4 + param_3 * iVar5);
  puVar8 = (undefined4 *)(param_4 + iVar4 + param_5 * iVar5);
  iVar4 = (param_1[2] - iVar5) + 1;
  while (bVar1 = 0 < iVar4, iVar4 = iVar4 + -1, bVar1) {
    for (iVar5 = 0; iVar5 < iVar6 / 4; iVar5 = iVar5 + 1) {
      *puVar8 = *puVar7;
      puVar7 = puVar7 + 1;
      puVar8 = puVar8 + 1;
    }
    puVar8 = puVar8 + ((int)uVar2 >> 2) + (uint)((int)uVar2 < 0 && (uVar2 & 3) != 0);
    puVar7 = puVar7 + ((int)uVar3 >> 2) + (uint)((int)uVar3 < 0 && (uVar3 & 3) != 0);
  }
  return;
}

