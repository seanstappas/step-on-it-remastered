
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

short * FUN_100048b4(short *param_1)

{
  short sVar1;
  short sVar2;
  short *psVar3;
  int iVar4;
  short sVar5;
  short *psVar6;
  undefined1 *puVar7;
  short sVar8;
  
  sVar1 = param_1[1];
  sVar2 = param_1[3];
  iVar4 = *(int *)**(undefined4 **)(_DAT_1003b6a4 + 2);
  psVar3 = (short *).glue::NewPtr((int)(short)(param_1[2] - *param_1) * (int)(short)(sVar2 - sVar1)
                                  + 10);
  if (psVar3 == (short *)0x0) {
    FUN_100192f8(6);
  }
  *psVar3 = param_1[1];
  psVar3[1] = *param_1;
  psVar3[2] = param_1[3];
  psVar3[3] = param_1[2];
  psVar6 = psVar3 + 4;
  for (sVar5 = *param_1; sVar5 < param_1[2]; sVar5 = sVar5 + 1) {
    puVar7 = (undefined1 *)(iVar4 + (int)sVar5 * (int)_DAT_1003ad40 + (int)param_1[1]);
    for (sVar8 = 0; sVar8 < (short)(sVar2 - sVar1); sVar8 = sVar8 + 1) {
      *(undefined1 *)psVar6 = *puVar7;
      puVar7 = puVar7 + 1;
      psVar6 = (short *)((int)psVar6 + 1);
    }
  }
  return psVar3;
}

