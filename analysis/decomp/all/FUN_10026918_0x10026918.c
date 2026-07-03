
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10026918(void)

{
  uint uVar1;
  int *piVar2;
  int local_4c;
  
  DAT_1003944d = 0;
  DAT_1003935c = 0;
  _DAT_1003b298 = 1;
  _DAT_1003b698 = 0;
  .glue::GetDefaultOutputVolume(&DAT_1003b6ac);
  .glue::SetDefaultOutputVolume(0x1000100);
  piVar2 = *(int **)(**(int **)(local_4c + 0x51e8) + 0x16);
  _DAT_1003b6b4 = *(undefined4 *)(*piVar2 + 6);
  uRam1003b6b8 = *(undefined4 *)(*piVar2 + 10);
  *(undefined2 *)(local_4c + 0x7540) = 0;
  *(undefined2 *)(local_4c + 0x7542) = 0;
  uRam1003b6f6 = 0;
  _DAT_1003b6f4 = 0;
  uRam1003b6fa = 0x280;
  uRam1003b6f8 = 0x1e0;
  uVar1 = (int)uRam1003b6b8._2_2_ - 0x280;
  sRam1003b6ee = (short)((int)uVar1 >> 1) + (ushort)((int)uVar1 < 0 && (uVar1 & 1) != 0);
  uVar1 = (int)uRam1003b6b8._0_2_ - 0x1e0;
  _DAT_1003b6ec = (short)((int)uVar1 >> 1) + (ushort)((int)uVar1 < 0 && (uVar1 & 1) != 0);
  sRam1003b6f2 = sRam1003b6ee + 0x280;
  sRam1003b6f0 = _DAT_1003b6ec + 0x1e0;
  *(undefined4 *)(local_4c + 0x7578) = 0;
  FUN_10016008();
  FUN_10019520();
  FUN_10019428();
  *(undefined4 *)(local_4c + 0x6bd4) = *(undefined4 *)*piVar2;
  *(ushort *)(local_4c + 0x6bd0) = *(ushort *)(*piVar2 + 4) & 0x7fff;
  *(int *)(local_4c + 0x6bd4) =
       *(int *)(local_4c + 0x6bd4) +
       (int)sRam1003b6ee + (int)_DAT_1003b6ec * (int)*(short *)(local_4c + 0x6bd0);
  FUN_100271ac();
  *(undefined2 *)(local_4c + 0x759e) = 1;
  *(undefined2 *)(local_4c + 0x5332) = 1;
  *(undefined1 *)(local_4c + 0x69fe) = 0;
  *(undefined1 *)(local_4c + 0x69fc) = 0;
  *(undefined1 *)(local_4c + 0x2f74) = 1;
  *(undefined2 *)(local_4c + 0x7538) = 1;
  *(undefined2 *)(local_4c + 0x5334) = 0;
  return;
}

