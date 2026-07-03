/* FUN_1001a348 @ 0x1001a348 */

void FUN_1001a348(undefined4 *param_1,undefined4 *param_2)

{
  char cVar1;
  char cVar2;
  undefined4 uVar3;
  undefined4 *puVar4;
  int *piVar5;
  int iVar6;
  int *piVar7;
  short sVar8;
  short sVar9;
  
  .glue::MoveHHi(param_1);
  .glue::HLock(param_1);
  puVar4 = (undefined4 *)*param_1;
  uVar3 = puVar4[1];
  *param_2 = *puVar4;
  param_2[1] = uVar3;
  uVar3 = puVar4[3];
  param_2[2] = puVar4[2];
  param_2[3] = uVar3;
  uVar3 = puVar4[5];
  param_2[4] = puVar4[4];
  param_2[5] = uVar3;
  *(undefined2 *)(param_2 + 6) = *(undefined2 *)(puVar4 + 6);
  iVar6 = puVar4[6];
  piVar5 = puVar4 + 7;
  for (sVar8 = 0; sVar8 < 0x13; sVar8 = sVar8 + 1) {
    for (sVar9 = 0; sVar9 < 0xd; sVar9 = sVar9 + 1) {
      param_2[(int)sVar9 + sVar8 * 0xd + 6] = 0;
    }
  }
  while (iVar6 != 0) {
    cVar1 = *(char *)piVar5;
    cVar2 = *(char *)((int)piVar5 + 1);
    while( true ) {
      piVar7 = (int *)((int)piVar5 + 2);
      if ((cVar1 == 100) || (cVar2 == 100)) break;
      param_2[(int)(short)cVar2 + (short)cVar1 * 0xd + 6] = iVar6;
      cVar1 = *(char *)piVar7;
      cVar2 = (char)*piVar5;
      piVar5 = piVar7;
    }
    piVar5 = (int *)((int)piVar5 + 6);
    iVar6 = *piVar7;
  }
  .glue::HUnlock(param_1);
  return;
}

