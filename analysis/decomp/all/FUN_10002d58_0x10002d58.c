
void FUN_10002d58(int *param_1,int param_2,undefined4 *param_3,int param_4,undefined4 *param_5,
                 int *param_6,undefined4 *param_7,short *param_8)

{
  byte bVar1;
  uint uVar2;
  int iVar3;
  uint *puVar4;
  byte *pbVar5;
  uint uVar6;
  short sVar7;
  uint *puVar8;
  uint uVar9;
  int iVar10;
  int *piVar11;
  int iVar12;
  uint *puVar13;
  short sVar14;
  short in_stack_0000003a;
  short in_stack_0000003e;
  ushort in_stack_00000042;
  
  sVar7 = *param_8;
  sVar14 = ((short)in_stack_00000042 >> 2) +
           (ushort)((short)in_stack_00000042 < 0 && (in_stack_00000042 & 3) != 0);
  iVar3 = (param_2 - in_stack_0000003e) / 4;
  iVar12 = (param_4 - in_stack_0000003e) / 4;
  puVar4 = (uint *)*param_1;
  puVar13 = (uint *)*param_3;
  pbVar5 = (byte *)*param_5;
  puVar8 = (uint *)*param_6;
  piVar11 = (int *)*param_7 + 1;
  uVar9 = *(int *)*param_7 << ((int)sVar14 & 0x3fU);
  if (sVar7 != 1) {
    if (sVar7 == 2) goto LAB_10002e84;
    if (sVar7 == 3) goto LAB_10002edc;
    bVar1 = *pbVar5;
    pbVar5 = pbVar5 + 1;
    if (bVar1 != 0) goto LAB_10002e84;
  }
LAB_10002e1c:
  do {
    bVar1 = *pbVar5;
    uVar6 = (int)(uint)bVar1 >> 1;
    pbVar5 = pbVar5 + 1;
    if (uVar6 == 0) {
      if ((bVar1 & 1) == 0) goto LAB_10003018;
      goto LAB_10002f0c;
    }
    if ((bVar1 & 1) == 1) goto LAB_10002ea8;
LAB_10002e44:
    uVar9 = (int)uVar9 >> (uVar6 & 0x3f);
    while (uVar2 = uVar6 & 0xff, uVar6 = uVar6 - 1, uVar2 != 0) {
      *puVar4 = *puVar13 & *puVar8 | puVar8[1];
      puVar13 = puVar13 + 1;
      puVar8 = puVar8 + 2;
      puVar4 = puVar4 + 1;
    }
LAB_10002e84:
    while( true ) {
      bVar1 = *pbVar5;
      uVar6 = (int)(uint)bVar1 >> 1;
      pbVar5 = pbVar5 + 1;
      if (uVar6 == 0) break;
      if ((bVar1 & 1) == 0) goto LAB_10002e0c;
LAB_10002ea8:
      uVar9 = (int)uVar9 >> (uVar6 & 0x3f);
      puVar13 = puVar13 + uVar6;
      while (uVar2 = uVar6 & 0xff, uVar6 = uVar6 - 1, uVar2 != 0) {
        *puVar4 = *puVar8;
        puVar8 = puVar8 + 1;
        puVar4 = puVar4 + 1;
      }
LAB_10002edc:
      bVar1 = *pbVar5;
      uVar6 = (int)(uint)bVar1 >> 1;
      pbVar5 = pbVar5 + 1;
      if (uVar6 != 0) goto code_r0x10002ef8;
      if ((bVar1 & 1) == 0) goto LAB_10002f94;
LAB_10003018:
      for (sVar7 = 0; (int)sVar7 < (int)sVar14; sVar7 = sVar7 + 1) {
        if ((uVar9 & 1) != 0) {
          *puVar4 = *puVar13;
        }
        puVar13 = puVar13 + 1;
        puVar4 = puVar4 + 1;
        uVar9 = (int)uVar9 >> 1;
      }
      in_stack_0000003a = in_stack_0000003a + -1;
      puVar4 = puVar4 + iVar3;
      puVar13 = puVar13 + iVar12;
      if (in_stack_0000003a < 1) {
        *param_8 = 2;
        goto LAB_10003090;
      }
      iVar10 = *piVar11;
      piVar11 = piVar11 + 1;
      uVar9 = iVar10 << ((int)sVar14 & 0x3fU);
    }
    if ((bVar1 & 1) == 1) {
LAB_10002f0c:
      for (sVar7 = 0; (int)sVar7 < (int)sVar14; sVar7 = sVar7 + 1) {
        if ((uVar9 & 1) != 0) {
          *puVar4 = *puVar13;
        }
        puVar13 = puVar13 + 1;
        puVar4 = puVar4 + 1;
        uVar9 = (int)uVar9 >> 1;
      }
      in_stack_0000003a = in_stack_0000003a + -1;
      puVar4 = puVar4 + iVar3;
      puVar13 = puVar13 + iVar12;
      if (0 < in_stack_0000003a) {
        iVar10 = *piVar11;
        piVar11 = piVar11 + 1;
        uVar9 = iVar10 << ((int)sVar14 & 0x3fU);
        goto LAB_10002edc;
      }
      *param_8 = 3;
      goto LAB_10003090;
    }
LAB_10002f94:
    for (sVar7 = 0; (int)sVar7 < (int)sVar14; sVar7 = sVar7 + 1) {
      if ((uVar9 & 1) != 0) {
        *puVar4 = *puVar13;
      }
      puVar13 = puVar13 + 1;
      puVar4 = puVar4 + 1;
      uVar9 = (int)uVar9 >> 1;
    }
    in_stack_0000003a = in_stack_0000003a + -1;
    puVar4 = puVar4 + iVar3;
    puVar13 = puVar13 + iVar12;
    if (in_stack_0000003a < 1) {
      *param_8 = 1;
LAB_10003090:
      *param_1 = (int)puVar4;
      *param_3 = puVar13;
      *param_5 = pbVar5;
      *param_6 = (int)puVar8;
      *param_7 = piVar11;
      return;
    }
    iVar10 = *piVar11;
    piVar11 = piVar11 + 1;
    uVar9 = iVar10 << ((int)sVar14 & 0x3fU);
  } while( true );
code_r0x10002ef8:
  if ((bVar1 & 1) == 0) goto LAB_10002e0c;
  goto LAB_10002e44;
LAB_10002e0c:
  while (uVar2 = uVar6 & 0xff, uVar6 = uVar6 - 1, uVar2 != 0) {
    if ((uVar9 & 1) != 0) {
      *puVar4 = *puVar13;
    }
    puVar13 = puVar13 + 1;
    puVar4 = puVar4 + 1;
    uVar9 = (int)uVar9 >> 1;
  }
  goto LAB_10002e1c;
}

