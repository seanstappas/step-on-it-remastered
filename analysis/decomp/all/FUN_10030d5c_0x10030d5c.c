
int FUN_10030d5c(undefined4 param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4,
                undefined4 param_5,undefined4 param_6,undefined4 param_7)

{
  undefined4 *puVar1;
  int iVar2;
  
  puVar1 = (undefined4 *)&DAT_1003b720;
  iVar2 = 0;
  while( true ) {
    if (0x1f < iVar2) {
      return -1;
    }
    if (puVar1[2] == 0) break;
    iVar2 = iVar2 + 1;
    puVar1 = puVar1 + 7;
  }
  puVar1[2] = param_1;
  puVar1[3] = param_2;
  puVar1[4] = param_3;
  puVar1[5] = param_4;
  *puVar1 = param_5;
  puVar1[1] = param_6;
  puVar1[6] = param_7;
  return iVar2;
}

