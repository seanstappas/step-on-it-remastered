
void FUN_100024d8(int *param_1,int param_2,int *param_3,int param_4,undefined4 *param_5,
                 undefined4 *param_6,short *param_7,short param_8)

{
  byte bVar1;
  short sVar2;
  uint uVar3;
  int iVar4;
  uint *puVar5;
  byte *pbVar6;
  uint *puVar7;
  uint uVar8;
  short in_stack_0000003a;
  
  iVar4 = (param_2 - in_stack_0000003a) / 4;
  puVar5 = (uint *)*param_1;
  pbVar6 = (byte *)*param_5;
  puVar7 = (uint *)*param_6;
  *param_3 = *param_3 + param_4 * param_8;
  sVar2 = *param_7;
  if (sVar2 != 1) {
    if (sVar2 == 2) goto LAB_100025ac;
    if (sVar2 == 3) goto LAB_100025f4;
    bVar1 = *pbVar6;
    pbVar6 = pbVar6 + 1;
    if (bVar1 != 0) goto LAB_100025ac;
  }
LAB_10002550:
  bVar1 = *pbVar6;
  uVar8 = (int)(uint)bVar1 >> 1;
  pbVar6 = pbVar6 + 1;
  if (uVar8 == 0) {
    if ((bVar1 & 1) == 0) goto LAB_10002678;
    goto LAB_10002624;
  }
  if ((bVar1 & 1) == 1) goto LAB_100025e4;
LAB_1000259c:
  while (uVar3 = uVar8 & 0xff, uVar8 = uVar8 - 1, uVar3 != 0) {
    *puVar5 = *puVar5 & *puVar7 | puVar7[1];
    puVar7 = puVar7 + 2;
    puVar5 = puVar5 + 1;
  }
LAB_100025ac:
  do {
    bVar1 = *pbVar6;
    uVar8 = (int)(uint)bVar1 >> 1;
    pbVar6 = pbVar6 + 1;
    if (uVar8 == 0) {
      if ((bVar1 & 1) == 1) {
LAB_10002624:
        param_8 = param_8 + -1;
        puVar5 = puVar5 + iVar4;
        if (param_8 < 1) {
          *param_7 = 3;
          goto LAB_10002694;
        }
        goto LAB_100025f4;
      }
LAB_10002650:
      param_8 = param_8 + -1;
      puVar5 = puVar5 + iVar4;
      if (param_8 < 1) {
        *param_7 = 1;
        goto LAB_10002694;
      }
      goto LAB_10002550;
    }
    if ((bVar1 & 1) == 0) goto LAB_10002544;
LAB_100025e4:
    while (uVar3 = uVar8 & 0xff, uVar8 = uVar8 - 1, uVar3 != 0) {
      *puVar5 = *puVar7;
      puVar7 = puVar7 + 1;
      puVar5 = puVar5 + 1;
    }
LAB_100025f4:
    bVar1 = *pbVar6;
    uVar8 = (int)(uint)bVar1 >> 1;
    pbVar6 = pbVar6 + 1;
    if (uVar8 != 0) break;
    if ((bVar1 & 1) == 0) goto LAB_10002650;
LAB_10002678:
    param_8 = param_8 + -1;
    puVar5 = puVar5 + iVar4;
    if (param_8 < 1) {
      *param_7 = 2;
LAB_10002694:
      *param_1 = (int)puVar5;
      *param_5 = pbVar6;
      *param_6 = puVar7;
      return;
    }
  } while( true );
  if ((bVar1 & 1) == 0) goto LAB_10002544;
  goto LAB_1000259c;
LAB_10002544:
  puVar5 = puVar5 + uVar8;
  goto LAB_10002550;
}

