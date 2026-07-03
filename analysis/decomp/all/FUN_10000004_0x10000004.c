
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 * FUN_10000004(short param_1,short param_2)

{
  undefined4 *puVar1;
  int *piVar2;
  int *piVar3;
  short sVar4;
  int *piVar5;
  int iVar6;
  short sVar7;
  int *piVar8;
  int *piVar9;
  int *piVar10;
  short sStack0000001a;
  int *local_48 [2];
  
  piVar5 = _DAT_1003b258;
  if (_DAT_1003b258 == (int *)0x0) {
    puVar1 = (undefined4 *)0x0;
  }
  else {
    sStack0000001a = param_1;
    piVar2 = (int *).glue::GetResource(0x73737366,(int)param_1);
    if (piVar2 == (int *)0x0) {
      puVar1 = (undefined4 *)0x0;
    }
    else {
      .glue::MoveHHi(piVar2);
      .glue::HLock(piVar2);
      sVar4 = (short)*(undefined4 *)*piVar2;
      *(short *)piVar5 = sVar4;
      *(short *)((int)piVar5 + 2) = param_2;
      piVar5[1] = 0;
      piVar5[2] = 0;
      piVar3 = piVar5 + 3;
      sVar7 = 0;
      piVar8 = piVar5 + sVar4 + 3;
      while( true ) {
        if (sVar4 <= sVar7) break;
        piVar9 = (int *)(*piVar2 + *(int *)(*piVar2 + 0xc + sVar7 * 4));
        *piVar3 = (int)piVar8 - (int)piVar5;
        iVar6 = *piVar9;
        piVar3 = piVar3 + 1;
        if (param_2 != 1) {
          iVar6 = iVar6 + 0x40000;
        }
        *piVar8 = iVar6;
        piVar8[1] = 0;
        piVar8[2] = 0;
        piVar10 = piVar8 + 3;
        local_48[0] = piVar8 + 6;
        if (param_2 == 1) {
          *piVar10 = 0;
          piVar8[4] = 0;
          piVar8[5] = 0;
          FUN_10000358(piVar9,local_48,0,0);
        }
        else if (param_2 == 2) {
          FUN_10000358(piVar9,local_48,0,1);
          *piVar10 = 0;
          piVar8[4] = (int)local_48[0] - (int)piVar8;
          FUN_10000358(piVar9,local_48,2,1);
          piVar8[5] = 0;
        }
        else if (param_2 == 4) {
          FUN_10000358(piVar9,local_48,0,1);
          *piVar10 = (int)local_48[0] - (int)piVar8;
          FUN_10000358(piVar9,local_48,1,1);
          piVar8[4] = (int)local_48[0] - (int)piVar8;
          FUN_10000358(piVar9,local_48,2,1);
          piVar8[5] = (int)local_48[0] - (int)piVar8;
          FUN_10000358(piVar9,local_48,3,1);
        }
        sVar7 = sVar7 + 1;
        piVar8 = local_48[0];
      }
      puVar1 = (undefined4 *).glue::NewHandle((int)piVar8 - (int)piVar5);
      if (puVar1 == (undefined4 *)0x0) {
        .glue::HUnlock(piVar2);
        .glue::ReleaseResource(piVar2);
        puVar1 = (undefined4 *)0xffffffff;
      }
      else {
        .glue::MoveHHi(puVar1);
        .glue::HLock(puVar1);
        piVar3 = (int *)*puVar1;
        for (; piVar5 < piVar8; piVar5 = piVar5 + 1) {
          *piVar3 = *piVar5;
          piVar3 = piVar3 + 1;
        }
        .glue::HUnlock(piVar2);
        .glue::ReleaseResource(piVar2);
        .glue::HUnlock(puVar1);
      }
    }
  }
  return puVar1;
}

