
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002e48c(int param_1,int param_2,undefined4 param_3)

{
  int iVar1;
  
  if ((short)param_1 < 100) {
    iVar1 = (int)(short)param_1 / 10;
    param_1 = param_1 + iVar1 * -10;
  }
  else {
    iVar1 = 9;
    param_1 = 9;
  }
  FUN_10028958();
  FUN_10004bb4(_DAT_1003ad28,iVar1 + 5,param_2,param_3);
  FUN_10004bb4(_DAT_1003ad28,param_1 + 5,param_2 + 8,param_3);
  FUN_100289c0();
  return;
}

