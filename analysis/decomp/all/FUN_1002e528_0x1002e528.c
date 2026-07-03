
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002e528(int param_1,int param_2,undefined4 param_3)

{
  int iVar1;
  int iVar2;
  
  if ((short)param_1 < 0) {
    param_1 = -param_1;
  }
  if ((short)param_1 < 1000) {
    iVar2 = (int)(short)param_1 / 100;
    param_1 = param_1 + iVar2 * -100;
    iVar1 = (int)(short)param_1 / 10;
    param_1 = param_1 + iVar1 * -10;
  }
  else {
    iVar2 = 9;
    iVar1 = 9;
    param_1 = 9;
  }
  FUN_10004bb4(_DAT_1003ad28,0x1b,param_2,param_3);
  FUN_10004bb4(_DAT_1003ad28,iVar2 + 5,param_2 + 0x30,param_3);
  FUN_10004bb4(_DAT_1003ad28,iVar1 + 5,param_2 + 0x38,param_3);
  FUN_10004bb4(_DAT_1003ad28,param_1 + 5,param_2 + 0x40,param_3);
  return;
}

