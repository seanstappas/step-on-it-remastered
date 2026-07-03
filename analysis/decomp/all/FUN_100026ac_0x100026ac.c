
void FUN_100026ac(undefined4 *param_1,int param_2,undefined4 *param_3,int param_4,
                 undefined4 *param_5,short param_6,short param_7)

{
  bool bVar1;
  undefined4 *puVar2;
  uint uVar3;
  undefined4 *puVar4;
  short sVar5;
  uint uVar6;
  uint *puVar7;
  
  uVar3 = (uint)param_7;
  puVar2 = (undefined4 *)*param_1;
  puVar4 = (undefined4 *)*param_3;
  puVar7 = (uint *)*param_5;
  while (bVar1 = 0 < param_6, param_6 = param_6 + -1, bVar1) {
    uVar6 = *puVar7;
    puVar7 = puVar7 + 1;
    for (sVar5 = 0;
        sVar5 < (short)((short)((int)uVar3 >> 2) + (ushort)((int)uVar3 < 0 && (uVar3 & 3) != 0));
        sVar5 = sVar5 + 1) {
      if ((uVar6 & 1) != 0) {
        *puVar2 = *puVar4;
      }
      puVar4 = puVar4 + 1;
      puVar2 = puVar2 + 1;
      uVar6 = (int)uVar6 >> 1;
    }
    puVar2 = puVar2 + (int)(param_2 - uVar3) / 4;
    puVar4 = puVar4 + (int)(param_4 - uVar3) / 4;
  }
  *param_1 = puVar2;
  *param_3 = puVar4;
  *param_5 = puVar7;
  return;
}

