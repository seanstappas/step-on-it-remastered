
void FUN_10002770(int *param_1,int param_2,undefined4 *param_3,int param_4,undefined4 *param_5,
                 int *param_6,undefined4 *param_7,short *param_8)

{
  byte bVar1;
  short sVar2;
  uint uVar3;
  int iVar4;
  uint *puVar5;
  byte *pbVar6;
  uint uVar7;
  uint *puVar8;
  uint uVar9;
  uint *puVar10;
  int iVar11;
  uint *puVar12;
  short in_stack_0000003a;
  short in_stack_0000003e;
  
  sVar2 = *param_8;
  uVar9 = *(uint *)*param_7;
  iVar4 = (param_2 - in_stack_0000003e) / 4;
  iVar11 = (param_4 - in_stack_0000003e) / 4;
  puVar5 = (uint *)*param_1;
  puVar12 = (uint *)*param_3;
  pbVar6 = (byte *)*param_5;
  puVar8 = (uint *)*param_6;
  puVar10 = (uint *)*param_7 + 1;
  if (sVar2 != 1) {
    if (sVar2 == 2) goto LAB_10002884;
    if (sVar2 == 3) goto LAB_100028dc;
    bVar1 = *pbVar6;
    pbVar6 = pbVar6 + 1;
    if (bVar1 != 0) goto LAB_10002884;
  }
LAB_1000281c:
  bVar1 = *pbVar6;
  uVar7 = (int)(uint)bVar1 >> 1;
  pbVar6 = pbVar6 + 1;
  if (uVar7 == 0) {
    if ((bVar1 & 1) == 0) goto LAB_10002988;
    goto LAB_1000290c;
  }
  if ((bVar1 & 1) == 1) goto LAB_100028a8;
LAB_10002844:
  uVar9 = (int)uVar9 >> (uVar7 & 0x3f);
  while (uVar3 = uVar7 & 0xff, uVar7 = uVar7 - 1, uVar3 != 0) {
    *puVar5 = *puVar12 & *puVar8 | puVar8[1];
    puVar12 = puVar12 + 1;
    puVar8 = puVar8 + 2;
    puVar5 = puVar5 + 1;
  }
LAB_10002884:
  do {
    bVar1 = *pbVar6;
    uVar7 = (int)(uint)bVar1 >> 1;
    pbVar6 = pbVar6 + 1;
    if (uVar7 == 0) {
      if ((bVar1 & 1) == 1) {
LAB_1000290c:
        in_stack_0000003a = in_stack_0000003a + -1;
        puVar5 = puVar5 + iVar4;
        puVar12 = puVar12 + iVar11;
        if (in_stack_0000003a < 1) {
          *param_8 = 3;
          goto LAB_100029b8;
        }
        uVar9 = *puVar10;
        puVar10 = puVar10 + 1;
        goto LAB_100028dc;
      }
LAB_1000294c:
      in_stack_0000003a = in_stack_0000003a + -1;
      puVar5 = puVar5 + iVar4;
      puVar12 = puVar12 + iVar11;
      if (in_stack_0000003a < 1) {
        *param_8 = 1;
LAB_100029b8:
        *param_1 = (int)puVar5;
        *param_3 = puVar12;
        *param_5 = pbVar6;
        *param_6 = (int)puVar8;
        *param_7 = puVar10;
        return;
      }
      uVar9 = *puVar10;
      puVar10 = puVar10 + 1;
      goto LAB_1000281c;
    }
    if ((bVar1 & 1) == 0) goto LAB_1000280c;
LAB_100028a8:
    uVar9 = (int)uVar9 >> (uVar7 & 0x3f);
    puVar12 = puVar12 + uVar7;
    while (uVar3 = uVar7 & 0xff, uVar7 = uVar7 - 1, uVar3 != 0) {
      *puVar5 = *puVar8;
      puVar8 = puVar8 + 1;
      puVar5 = puVar5 + 1;
    }
LAB_100028dc:
    bVar1 = *pbVar6;
    uVar7 = (int)(uint)bVar1 >> 1;
    pbVar6 = pbVar6 + 1;
    if (uVar7 != 0) break;
    if ((bVar1 & 1) == 0) goto LAB_1000294c;
LAB_10002988:
    in_stack_0000003a = in_stack_0000003a + -1;
    puVar5 = puVar5 + iVar4;
    puVar12 = puVar12 + iVar11;
    if (in_stack_0000003a < 1) {
      *param_8 = 2;
      goto LAB_100029b8;
    }
    uVar9 = *puVar10;
    puVar10 = puVar10 + 1;
  } while( true );
  if ((bVar1 & 1) == 0) goto LAB_1000280c;
  goto LAB_10002844;
LAB_1000280c:
  while (uVar3 = uVar7 & 0xff, uVar7 = uVar7 - 1, uVar3 != 0) {
    if ((uVar9 & 1) != 0) {
      *puVar5 = *puVar12;
    }
    puVar12 = puVar12 + 1;
    puVar5 = puVar5 + 1;
    uVar9 = (int)uVar9 >> 1;
  }
  goto LAB_1000281c;
}

