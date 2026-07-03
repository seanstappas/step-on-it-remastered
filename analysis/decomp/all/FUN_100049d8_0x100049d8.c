
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100049d8(short *param_1)

{
  short sVar1;
  short sVar2;
  short sVar3;
  int iVar4;
  short sVar5;
  short *psVar6;
  undefined1 *puVar7;
  short sVar8;
  
  sVar1 = *param_1;
  sVar5 = param_1[1];
  sVar2 = param_1[2];
  sVar3 = param_1[3];
  psVar6 = param_1 + 4;
  iVar4 = *(int *)**(undefined4 **)(_DAT_1003b6a4 + 2);
  FUN_10028958();
  for (; sVar5 < sVar3; sVar5 = sVar5 + 1) {
    puVar7 = (undefined1 *)(iVar4 + (int)sVar5 * (int)_DAT_1003ad40 + (int)sVar1);
    for (sVar8 = 0; sVar8 < (short)(sVar2 - sVar1); sVar8 = sVar8 + 1) {
      *puVar7 = *(undefined1 *)psVar6;
      psVar6 = (short *)((int)psVar6 + 1);
      puVar7 = puVar7 + 1;
    }
  }
  FUN_100289c0();
  .glue::DisposePtr(param_1);
  return;
}

