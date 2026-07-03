
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002b810(int param_1,int param_2,undefined4 param_3)

{
  int iVar1;
  
  iVar1 = 9;
  while( true ) {
    if ((short)iVar1 < 0) break;
    FUN_10004bb4(_DAT_1003ad28,*(short *)(param_1 + (short)iVar1 * 2) + 5,param_2 + (9 - iVar1) * 8,
                 param_3);
    iVar1 = iVar1 + -1;
  }
  return;
}

