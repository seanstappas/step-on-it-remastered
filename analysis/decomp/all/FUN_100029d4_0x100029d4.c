
void FUN_100029d4(int *param_1,int param_2,undefined4 *param_3,int param_4,undefined4 *param_5,
                 int *param_6,undefined4 *param_7,short *param_8)

{
  byte bVar1;
  uint uVar2;
  int iVar3;
  uint *puVar4;
  byte *pbVar5;
  short sVar7;
  uint uVar6;
  uint *puVar8;
  uint uVar9;
  uint *puVar10;
  int iVar11;
  uint *puVar12;
  short sVar13;
  short in_stack_0000003a;
  short in_stack_0000003e;
  ushort in_stack_00000042;
  
  uVar9 = *(uint *)*param_7;
  iVar3 = (param_2 - in_stack_0000003e) / 4;
  iVar11 = (param_4 - in_stack_0000003e) / 4;
  puVar4 = (uint *)*param_1;
  puVar12 = (uint *)*param_3;
  pbVar5 = (byte *)*param_5;
  puVar8 = (uint *)*param_6;
  sVar13 = ((short)in_stack_00000042 >> 2) +
           (ushort)((short)in_stack_00000042 < 0 && (in_stack_00000042 & 3) != 0);
  puVar10 = (uint *)*param_7 + 1;
  for (sVar7 = 0; sVar7 < sVar13; sVar7 = sVar7 + 1) {
    if ((uVar9 & 1) != 0) {
      *puVar4 = *puVar12;
    }
    puVar12 = puVar12 + 1;
    puVar4 = puVar4 + 1;
    uVar9 = (int)uVar9 >> 1;
  }
  sVar7 = *param_8;
  if (sVar7 != 1) {
    if (sVar7 == 2) goto LAB_10002b3c;
    if (sVar7 == 3) goto LAB_10002b94;
    bVar1 = *pbVar5;
    pbVar5 = pbVar5 + 1;
    if (bVar1 != 0) goto LAB_10002b3c;
  }
LAB_10002ad4:
  do {
    bVar1 = *pbVar5;
    uVar6 = (int)(uint)bVar1 >> 1;
    pbVar5 = pbVar5 + 1;
    if (uVar6 == 0) {
      if ((bVar1 & 1) == 0) goto LAB_10002cc8;
      goto LAB_10002bc4;
    }
    if ((bVar1 & 1) == 1) goto LAB_10002b60;
LAB_10002afc:
    uVar9 = (int)uVar9 >> (uVar6 & 0x3f);
    while (uVar2 = uVar6 & 0xff, uVar6 = uVar6 - 1, uVar2 != 0) {
      *puVar4 = *puVar12 & *puVar8 | puVar8[1];
      puVar12 = puVar12 + 1;
      puVar8 = puVar8 + 2;
      puVar4 = puVar4 + 1;
    }
LAB_10002b3c:
    while( true ) {
      bVar1 = *pbVar5;
      uVar6 = (int)(uint)bVar1 >> 1;
      pbVar5 = pbVar5 + 1;
      if (uVar6 == 0) break;
      if ((bVar1 & 1) == 0) goto LAB_10002ac4;
LAB_10002b60:
      uVar9 = (int)uVar9 >> (uVar6 & 0x3f);
      puVar12 = puVar12 + uVar6;
      while (uVar2 = uVar6 & 0xff, uVar6 = uVar6 - 1, uVar2 != 0) {
        *puVar4 = *puVar8;
        puVar8 = puVar8 + 1;
        puVar4 = puVar4 + 1;
      }
LAB_10002b94:
      bVar1 = *pbVar5;
      uVar6 = (int)(uint)bVar1 >> 1;
      pbVar5 = pbVar5 + 1;
      if (uVar6 != 0) goto code_r0x10002bb0;
      if ((bVar1 & 1) == 0) goto LAB_10002c48;
LAB_10002cc8:
      in_stack_0000003a = in_stack_0000003a + -1;
      puVar4 = puVar4 + iVar3;
      puVar12 = puVar12 + iVar11;
      if (in_stack_0000003a < 1) {
        *param_8 = 2;
        goto LAB_10002d3c;
      }
      uVar9 = *puVar10;
      puVar10 = puVar10 + 1;
      for (sVar7 = 0; sVar7 < sVar13; sVar7 = sVar7 + 1) {
        if ((uVar9 & 1) != 0) {
          *puVar4 = *puVar12;
        }
        puVar12 = puVar12 + 1;
        puVar4 = puVar4 + 1;
        uVar9 = (int)uVar9 >> 1;
      }
    }
    if ((bVar1 & 1) == 1) {
LAB_10002bc4:
      in_stack_0000003a = in_stack_0000003a + -1;
      puVar4 = puVar4 + iVar3;
      puVar12 = puVar12 + iVar11;
      if (in_stack_0000003a < 1) {
        *param_8 = 3;
        goto LAB_10002d3c;
      }
      uVar9 = *puVar10;
      puVar10 = puVar10 + 1;
      for (sVar7 = 0; sVar7 < sVar13; sVar7 = sVar7 + 1) {
        if ((uVar9 & 1) != 0) {
          *puVar4 = *puVar12;
        }
        puVar12 = puVar12 + 1;
        puVar4 = puVar4 + 1;
        uVar9 = (int)uVar9 >> 1;
      }
      goto LAB_10002b94;
    }
LAB_10002c48:
    in_stack_0000003a = in_stack_0000003a + -1;
    puVar4 = puVar4 + iVar3;
    puVar12 = puVar12 + iVar11;
    if (in_stack_0000003a < 1) {
      *param_8 = 1;
LAB_10002d3c:
      *param_1 = (int)puVar4;
      *param_3 = puVar12;
      *param_5 = pbVar5;
      *param_6 = (int)puVar8;
      *param_7 = puVar10;
      return;
    }
    uVar9 = *puVar10;
    puVar10 = puVar10 + 1;
    for (sVar7 = 0; sVar7 < sVar13; sVar7 = sVar7 + 1) {
      if ((uVar9 & 1) != 0) {
        *puVar4 = *puVar12;
      }
      puVar12 = puVar12 + 1;
      puVar4 = puVar4 + 1;
      uVar9 = (int)uVar9 >> 1;
    }
  } while( true );
code_r0x10002bb0:
  if ((bVar1 & 1) == 0) goto LAB_10002ac4;
  goto LAB_10002afc;
LAB_10002ac4:
  while (uVar2 = uVar6 & 0xff, uVar6 = uVar6 - 1, uVar2 != 0) {
    if ((uVar9 & 1) != 0) {
      *puVar4 = *puVar12;
    }
    puVar12 = puVar12 + 1;
    puVar4 = puVar4 + 1;
    uVar9 = (int)uVar9 >> 1;
  }
  goto LAB_10002ad4;
}

