/* FUN_1000c278 @ 0x1000c278  calls: Random */

int FUN_1000c278(short param_1)

{
  short sVar1;
  int iVar2;
  
  sVar1 = .glue::Random();
  iVar2 = (int)(((int)sVar1 & 0x7fffU) * (int)param_1) / 0x7fff + 1;
  if (param_1 < iVar2) {
    iVar2 = (int)param_1;
  }
  return iVar2;
}

