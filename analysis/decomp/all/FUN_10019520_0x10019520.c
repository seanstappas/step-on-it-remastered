
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10019520(void)

{
  char cVar3;
  undefined4 uVar1;
  undefined2 uVar2;
  short sVar4;
  int iVar5;
  int local_4c;
  
  cVar3 = FUN_1001977c();
  if (cVar3 == '\0') {
    FUN_100192f8(6);
  }
  _DAT_100390c0 = 0;
  _DAT_10039060 = 1;
  uRam10039062 = 8;
  uRam10039064 = 0;
  uRam10039066 = 0;
  uRam10039068 = 0x56ee8ba3;
  uRam10039074 = .glue::NewRoutineDescriptor(PTR_PTR_LAB_10033e58,0x3c0,1);
  for (sVar4 = 0; sVar4 < 2; sVar4 = sVar4 + 1) {
    uVar1 = .glue::NewPtr(0x41a);
    *(undefined4 *)(sVar4 * 4 + 0x1003906c) = uVar1;
    if (*(int *)(sVar4 * 4 + 0x1003906c) == 0) {
      FUN_100192f8(6);
    }
    **(undefined4 **)(sVar4 * 4 + 0x1003906c) = 0x400;
    *(undefined4 *)(*(int *)(sVar4 * 4 + 0x1003906c) + 4) = 1;
    *(undefined **)(*(int *)(sVar4 * 4 + 0x1003906c) + 8) = &DAT_10039078;
    for (iVar5 = 0; iVar5 < 0x401; iVar5 = iVar5 + 1) {
      *(undefined1 *)(*(int *)(sVar4 * 4 + 0x1003906c) + 0x10 + iVar5) = 0x80;
    }
  }
  _DAT_10039078 = &DAT_100390c4;
  uRam1003907c = 0;
  uRam1003907d = 1;
  for (sVar4 = 0; sVar4 < 4; sVar4 = sVar4 + 1) {
    *(undefined4 *)(sVar4 * 0x24 + 0x100390cc) = 1;
    *(undefined4 *)(sVar4 * 0x24 + 0x100390c8) = 0;
    *(undefined4 *)(sVar4 * 0x24 + 0x100390d8) = 0;
    *(undefined4 *)(sVar4 * 0x24 + 0x100390e4) = 0;
    *(undefined4 *)(sVar4 * 0x24 + 0x100390d4) = 0;
  }
  _DAT_1003905c = 0;
  uVar2 = .glue::SndNewChannel(&DAT_1003905c,5,0x80,0);
  *(undefined2 *)(local_4c + 0x4eea) = uVar2;
  *(undefined **)(_DAT_1003905c + 0xc) = &DAT_10039078;
  .glue::SndPlayDoubleBuffer(_DAT_1003905c,&DAT_10039060);
  FUN_1001a2c8(*(undefined4 *)(local_4c + 0x4f4c));
  return;
}

