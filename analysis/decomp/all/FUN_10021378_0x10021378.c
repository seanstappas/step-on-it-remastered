
void FUN_10021378(void)

{
  undefined2 uVar1;
  undefined4 *puVar2;
  undefined4 *puVar3;
  undefined4 uVar4;
  undefined4 *puVar5;
  undefined4 *puVar6;
  short unaff_r31;
  int iVar7;
  int local_ac;
  undefined4 local_74 [3];
  undefined4 uStack_66;
  undefined4 local_5e [3];
  undefined2 local_52 [39];
  
  local_74[0] = 0x53735347;
  .glue::CustomGetFile(0,1,local_74,(int)&uStack_66 + 2,0x1b8,0xffffffff,0,0);
  if (uStack_66._2_1_ != '\0') {
    unaff_r31 = FUN_1002146c(local_5e);
  }
  if (unaff_r31 == 0) {
    iVar7 = 8;
    puVar2 = (undefined4 *)(local_ac + 0x52d6);
    puVar3 = &uStack_66;
    do {
      puVar6 = puVar3;
      puVar5 = puVar2;
      uVar4 = puVar6[3];
      puVar5[2] = puVar6[2];
      puVar5[3] = uVar4;
      iVar7 = iVar7 + -1;
      puVar2 = puVar5 + 2;
      puVar3 = puVar6 + 2;
    } while (iVar7 != 0);
    uVar1 = *(undefined2 *)(puVar6 + 5);
    puVar5[4] = puVar6[4];
    *(undefined2 *)(puVar5 + 5) = uVar1;
    *(undefined1 *)(local_ac + 0x52dd) = 1;
  }
  return;
}

