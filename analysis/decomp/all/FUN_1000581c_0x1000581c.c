
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_1000581c(short param_1,short param_2)

{
  undefined4 uVar1;
  
  if (((int)_DAT_10037d56 - (int)param_1) * ((int)_DAT_10037d56 - (int)param_1) +
      ((int)_DAT_10037d54 - (int)param_2) * ((int)_DAT_10037d54 - (int)param_2) <
      ((int)_DAT_10037d52 - (int)param_1) * ((int)_DAT_10037d52 - (int)param_1) +
      ((int)_DAT_10037d50 - (int)param_2) * ((int)_DAT_10037d50 - (int)param_2)) {
    uVar1 = 1;
  }
  else {
    uVar1 = 2;
  }
  return uVar1;
}

