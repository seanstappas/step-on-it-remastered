
void FUN_1002082c(void)

{
  int *piVar1;
  undefined4 *puVar2;
  undefined4 *puVar3;
  short sVar5;
  int *piVar4;
  int iVar6;
  undefined4 *puVar7;
  undefined1 *puVar8;
  int local_5c;
  int local_38;
  undefined4 local_34;
  undefined2 local_30;
  short local_2e [5];
  
  .glue::Gestalt(0x6b626420,&local_38);
  piVar1 = (int *).glue::NewHandle(0x20);
  if (piVar1 == (int *)0x0) {
    FUN_100192f8(6);
  }
  puVar2 = (undefined4 *).glue::NewHandle(0x38);
  if (puVar2 == (undefined4 *)0x0) {
    FUN_100192f8(6);
  }
  puVar3 = (undefined4 *).glue::NewHandle(0xa28);
  if (puVar3 == (undefined4 *)0x0) {
    FUN_100192f8(6);
  }
  *(undefined4 *)(local_5c + 0x7116) = 0xe;
  sVar5 = FUN_1002e724(0x53734178,0x53735066,local_5c + 0xd18,local_5c + -0x1c,local_5c + 0xd31);
  if (sVar5 == 0) {
    sVar5 = FUN_1002e990(0x53734178,0x53735066,local_2e);
    if (sVar5 == 0) {
      .glue::UseResFile((int)*(short *)(local_5c + 0x51f0));
      piVar4 = (int *).glue::Get1Resource(0x76657273,1);
      if (piVar4 == (int *)0x0) {
        local_34 = 0x1008006;
        iVar6 = 0;
      }
      else {
        local_34 = *(undefined4 *)*piVar4;
        iVar6 = (int)*(short *)(*piVar4 + 4);
      }
      FUN_1002ecd4((int)local_2e[0],1,&local_34,iVar6,local_5c + -0x1b,local_5c + 0xd3d);
      FUN_1002ecd4((int)local_2e[0],2,&local_34,iVar6,local_5c + -0x1b,local_5c + 0xd64);
      *(undefined2 *)*piVar1 = 3;
      *(undefined1 *)(*piVar1 + 2) = 1;
      *(undefined1 *)(*piVar1 + 0xc) = 0;
      *(undefined1 *)(*piVar1 + 0xd) = 0;
      *(undefined2 *)(*piVar1 + 4) = 0x200;
      *(undefined4 *)(*piVar1 + 6) = 0xe;
      *(undefined1 *)(*piVar1 + 10) = 0;
      *(undefined1 *)(*piVar1 + 0xb) = 1;
      local_30 = 400;
      FUN_1002ef44((int)local_2e[0],0x53735052,&local_30,piVar1);
      .glue::MoveHHi(puVar2);
      .glue::HLock(puVar2);
      puVar7 = (undefined4 *)*puVar2;
      if (local_38 - 4U < 0x15) {
                    /* WARNING: Could not recover jumptable at 0x10020a9c. Too many branches */
                    /* WARNING: Treating indirect jump as call */
        (**(code **)(local_5c + 0xd7c + (local_38 - 4U) * 4))();
        return;
      }
      *puVar7 = 0x5300;
      puVar7[1] = 0x5500;
      puVar7[2] = 0x5700;
      puVar7[3] = 0x4700;
      puVar7[4] = 0x5900;
      puVar7[5] = 0x5100;
      puVar7[6] = 0x5b00;
      puVar7[7] = 0x300;
      puVar7[8] = 0x400;
      puVar7[9] = 0x1100;
      puVar7[10] = 0x3800;
      puVar7[0xb] = 0x3b00;
      puVar7[0xc] = 0x3a00;
      puVar7[0xd] = 0x3700;
      .glue::HUnlock(puVar2);
      local_30 = 400;
      FUN_1002ef44((int)local_2e[0],0x53734b50,&local_30,puVar2);
      .glue::MoveHHi(puVar3);
      .glue::HLock(puVar3);
      puVar8 = (undefined1 *)*puVar3;
      for (sVar5 = 0; sVar5 < 10; sVar5 = sVar5 + 1) {
        *puVar8 = 0;
        puVar8[1] = 0x45;
        puVar8[2] = 0x6c;
        puVar8[3] = 0x76;
        puVar8[4] = 0x69;
        puVar8[5] = 0x73;
        *(undefined4 *)(puVar8 + 0x100) = 5000;
        puVar8 = puVar8 + 0x104;
      }
      .glue::HUnlock(puVar3);
      local_30 = 400;
      FUN_1002ef44((int)local_2e[0],0x53734853,&local_30,puVar3);
      FUN_1002ea68((int)local_2e[0]);
    }
  }
  return;
}

