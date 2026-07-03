
void FUN_1002117c(void)

{
  undefined2 uVar1;
  undefined4 *puVar2;
  undefined4 *puVar3;
  undefined4 *puVar4;
  undefined4 *puVar5;
  undefined4 uVar6;
  short unaff_r31;
  int iVar7;
  int local_9c;
  undefined1 local_70 [4];
  char local_6c;
  char local_6b;
  undefined4 local_66 [3];
  undefined2 local_5a [29];
  short local_20;
  
  local_70 = (undefined1  [4])0xffffffff;
  if (DAT_100393d0 != '\0') {
    if (DAT_1003944d == '\0') {
      .glue::CustomPutFile(&DAT_10034f40,&DAT_10034f4e,&local_6c,0x1ae,0xffffffff,0,0,0);
    }
    else {
      .glue::CustomPutFile(&DAT_10034f40,0x10039454,&local_6c,0x1ae,0xffffffff,0,0,0);
    }
    if (local_6c != '\0') {
      if (local_6b == '\0') {
        unaff_r31 = .glue::FSpCreate(local_66,0x53734170,0x53735347,(int)local_20);
      }
      if (unaff_r31 == 0) {
        iVar7 = 8;
        puVar2 = (undefined4 *)(local_9c + 0x52d6);
        puVar3 = (undefined4 *)(local_70 + 2);
        do {
          puVar5 = puVar3;
          puVar4 = puVar2;
          uVar6 = puVar5[3];
          puVar4[2] = puVar5[2];
          puVar4[3] = uVar6;
          iVar7 = iVar7 + -1;
          puVar2 = puVar4 + 2;
          puVar3 = puVar5 + 2;
        } while (iVar7 != 0);
        uVar1 = *(undefined2 *)(puVar5 + 5);
        puVar4[4] = puVar5[4];
        *(undefined2 *)(puVar4 + 5) = uVar1;
        *(undefined1 *)(local_9c + 0x52dd) = 1;
        FUN_10020ff8();
      }
    }
  }
  return;
}

