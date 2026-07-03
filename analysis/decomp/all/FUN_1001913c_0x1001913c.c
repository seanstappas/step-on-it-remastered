
void FUN_1001913c(byte *param_1,byte *param_2,byte *param_3)

{
  byte bVar1;
  byte bVar2;
  undefined4 *puVar3;
  undefined4 *puVar4;
  undefined4 uVar5;
  short sVar6;
  int iVar7;
  undefined4 auStack_118 [2];
  undefined4 local_10c [66];
  
  iVar7 = 0x20;
  puVar3 = (undefined4 *)0x10034b32;
  puVar4 = auStack_118;
  do {
    uVar5 = puVar3[3];
    puVar4[2] = puVar3[2];
    puVar4[3] = uVar5;
    iVar7 = iVar7 + -1;
    puVar3 = puVar3 + 2;
    puVar4 = puVar4 + 2;
  } while (iVar7 != 0);
  *param_3 = 0;
  for (sVar6 = 0; sVar6 < (short)(ushort)*param_1; sVar6 = sVar6 + 1) {
    bVar1 = *param_3;
    bVar2 = param_1[sVar6 + 1];
    *param_3 = bVar1 + 1;
    param_3[(byte)(bVar1 + 1)] = bVar2;
  }
  for (sVar6 = 0; sVar6 < (short)(ushort)*param_2; sVar6 = sVar6 + 1) {
    bVar1 = *param_3;
    bVar2 = param_2[sVar6 + 1];
    *param_3 = bVar1 + 1;
    param_3[(byte)(bVar1 + 1)] = bVar2;
  }
  return;
}

