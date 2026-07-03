
undefined4 * FUN_10019894(short param_1,char param_2)

{
  int *piVar1;
  int iVar2;
  int *piVar3;
  undefined4 *unaff_r25;
  short *psVar4;
  int iVar5;
  undefined1 *puVar6;
  short sStack0000001a;
  
  sStack0000001a = param_1;
  piVar1 = (int *).glue::GetResource(0x736e6420,(int)param_1);
  .glue::MoveHHi(piVar1);
  .glue::HLock(piVar1);
  psVar4 = (short *)*piVar1;
  if ((((*psVar4 == 1) && (psVar4[1] == 1)) && (psVar4[5] == 1)) && (psVar4[6] == -0x7faf)) {
    iVar2 = *piVar1 + *(int *)(psVar4 + 8);
    unaff_r25 = (undefined4 *).glue::NewHandle(*(int *)(iVar2 + 4) + 0x412);
    if (unaff_r25 == (undefined4 *)0x0) {
      .glue::HUnlock(piVar1);
      .glue::ReleaseResource(piVar1);
      return (undefined4 *)0x0;
    }
    .glue::MoveHHi(unaff_r25);
    .glue::HLock(unaff_r25);
    piVar3 = (int *)*unaff_r25;
    *piVar3 = *(int *)(iVar2 + 4);
    piVar3[1] = (int)param_2;
    iVar5 = *piVar3;
    puVar6 = (undefined1 *)(iVar2 + 0x16);
    piVar3 = piVar3 + 4;
    if ((iVar5 < 100000) && (0 < iVar5)) {
      for (iVar2 = 0; iVar2 < iVar5; iVar2 = iVar2 + 1) {
        *(undefined1 *)piVar3 = *puVar6;
        puVar6 = puVar6 + 1;
        piVar3 = (int *)((int)piVar3 + 1);
      }
      for (iVar2 = 0; iVar2 < 0x200; iVar2 = iVar2 + 1) {
        *(undefined1 *)piVar3 = 0x80;
        piVar3 = (int *)((int)piVar3 + 1);
      }
    }
  }
  .glue::HUnlock(piVar1);
  .glue::ReleaseResource(piVar1);
  .glue::HUnlock(unaff_r25);
  return unaff_r25;
}

