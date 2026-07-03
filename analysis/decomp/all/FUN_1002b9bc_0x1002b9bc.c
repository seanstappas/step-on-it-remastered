
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002b9bc(short param_1,short param_2,short param_3)

{
  short sVar1;
  short sVar2;
  int iVar3;
  int iVar4;
  int iVar5;
  uint uVar6;
  int iVar7;
  int iVar8;
  int iVar9;
  int iVar10;
  int iVar11;
  int iVar12;
  int iVar13;
  short sStack0000001a;
  
  sVar1 = *(short *)(&DAT_1003a9b0 + param_1 * 0x70);
  sVar2 = *(short *)(param_1 * 0x70 + 0x1003a9b4);
  iVar8 = (int)sVar2;
  sStack0000001a = param_1;
  iVar4 = FUN_10015fe4();
  do {
    iVar5 = FUN_10015fe4();
  } while (iVar4 == iVar5);
  iVar4 = FUN_10015fe4();
  do {
    iVar5 = FUN_10015fe4();
  } while (iVar4 == iVar5);
  FUN_1002b020(0x25,100);
  FUN_10028958();
  FUN_10004cb0(*(undefined4 *)(sStack0000001a * 0x70 + 0x1003a9ba),
               (int)*(short *)(sStack0000001a * 0x70 + 0x1003a9c8),
               (int)*(short *)(sStack0000001a * 0x70 + 0x1003a9c4),
               (int)*(short *)(sStack0000001a * 0x70 + 0x1003a9c6));
  FUN_10014940((int)sStack0000001a);
  if (DAT_1003759e != '\0') {
    FUN_10004580();
  }
  FUN_10004bb4(_DAT_1003ad24,1,(int)sVar1,iVar8);
  FUN_100289c0();
  iVar5 = iVar8;
  iVar9 = (int)sVar1;
  iVar13 = 1;
  for (iVar11 = 1; iVar11 < 0xd4; iVar11 = iVar11 + 1) {
    iVar12 = iVar13 + 1;
    uVar6 = (uint)(short)(sVar1 + (short)((iVar11 * ((int)param_2 - (int)sVar1)) / 0xd4));
    iVar3 = (((int)uVar6 >> 1) + (uint)((int)uVar6 < 0 && (uVar6 & 1) != 0)) * 2;
    iVar10 = iVar8 + (iVar11 * ((int)param_3 - (int)sVar2)) / 0xd4;
    if (0xf < (short)iVar12) {
      iVar12 = 1;
    }
    FUN_10018b98();
    do {
      iVar7 = FUN_10015fe4();
    } while (iVar7 < iVar4 + 1);
    iVar4 = FUN_10015fe4();
    FUN_10028958();
    if (DAT_1003759e == '\0') {
      FUN_100043a0(_DAT_1003ad24,iVar13,iVar9,iVar5,_DAT_1003ad24,iVar12,iVar3,iVar10);
    }
    else {
      FUN_10004490(_DAT_1003ad24,iVar13,iVar9,iVar5,_DAT_1003ad24,iVar12,iVar3,iVar10);
    }
    FUN_100289c0();
    iVar5 = iVar10;
    iVar9 = iVar3;
    iVar13 = iVar12;
  }
  FUN_10028958();
  FUN_10004cb0(_DAT_1003ad24,iVar13,iVar9,iVar5);
  if (DAT_1003759e != '\0') {
    FUN_100045e8();
  }
  FUN_100289c0();
  return;
}

