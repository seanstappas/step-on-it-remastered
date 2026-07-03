
undefined4 FUN_1002f338(undefined4 param_1,undefined4 param_2,int param_3)

{
  undefined2 uVar1;
  bool bVar2;
  undefined4 *puVar3;
  undefined4 *puVar4;
  short sVar6;
  undefined4 uVar5;
  char cVar7;
  undefined4 *puVar8;
  undefined4 *puVar9;
  undefined4 uVar10;
  int iVar11;
  undefined4 uStack_7c;
  int local_78;
  undefined1 auStack_74 [4];
  undefined4 auStack_70 [2];
  undefined2 local_68 [29];
  short local_2e;
  undefined4 local_2c;
  int local_28 [3];
  
  if (param_3 == 0) {
    uVar5 = 0xffffffce;
  }
  else {
    bVar2 = false;
    sVar6 = .glue::FindFolder(0xffff8000,0x70726566,1,&local_2e,&local_2c);
    uVar5 = .glue::FindFolder(0xffff8000,0x6d616373,0,&local_2e,local_28);
    if ((short)uVar5 == 0) {
      uVar10 = 1;
      if (sVar6 == 0) {
        do {
          uVar5 = .debug::_CreatorTypeFileSearch
                            (0,(int)local_2e,param_1,param_2,auStack_74,1,&local_78,uVar10);
          uVar10 = 0;
          if ((local_78 == 1) &&
             (cVar7 = FUN_1002f538((int)local_2e,stack0xffffff8e,local_2c), cVar7 != '\0')) {
            bVar2 = true;
            break;
          }
        } while (((short)uVar5 == 0) || ((short)uVar5 == -0x518));
      }
      if (!bVar2) {
        uVar10 = 1;
        do {
          uVar5 = .debug::_CreatorTypeFileSearch
                            (0,(int)local_2e,param_1,param_2,auStack_74,1,&local_78,uVar10);
          uVar10 = 0;
          if ((local_78 == 1) && (stack0xffffff8e == local_28[0])) {
            bVar2 = true;
            break;
          }
        } while (((short)uVar5 == 0) || ((short)uVar5 == -0x518));
      }
      if (bVar2) {
        iVar11 = 8;
        puVar3 = (undefined4 *)(param_3 + -8);
        puVar4 = &uStack_7c;
        do {
          puVar9 = puVar4;
          puVar8 = puVar3;
          uVar10 = puVar9[3];
          puVar8[2] = puVar9[2];
          puVar8[3] = uVar10;
          iVar11 = iVar11 + -1;
          puVar3 = puVar8 + 2;
          puVar4 = puVar9 + 2;
        } while (iVar11 != 0);
        uVar1 = *(undefined2 *)(puVar9 + 5);
        puVar8[4] = puVar9[4];
        *(undefined2 *)(puVar8 + 5) = uVar1;
      }
      else {
        uVar5 = 0xffffffd5;
      }
    }
  }
  return uVar5;
}

