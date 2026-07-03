
bool FUN_1000cafc(undefined2 *param_1,undefined2 *param_2)

{
  char cVar1;
  short sVar2;
  bool bVar3;
  undefined4 unaff_r30;
  undefined4 unaff_r31;
  undefined2 *puStack00000018;
  undefined2 *puStack0000001c;
  
  sVar2 = 0;
  bVar3 = false;
  puStack00000018 = param_1;
  puStack0000001c = param_2;
  while ((!bVar3 && (sVar2 < 10))) {
    unaff_r31 = FUN_1000cbe0(0x13);
    unaff_r30 = FUN_1000cbe0(0xd);
    if ((*(int *)(&DAT_1003ad68 + (short)unaff_r31 * 0x3c + (short)unaff_r30 * 4) == 0) &&
       (cVar1 = FUN_1000cc50(unaff_r31,unaff_r30), cVar1 != '\0')) {
      bVar3 = true;
    }
    else {
      sVar2 = sVar2 + 1;
    }
  }
  if (bVar3) {
    *puStack00000018 = (short)unaff_r31;
    *puStack0000001c = (short)unaff_r30;
  }
  return bVar3;
}

