
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_100054a4(short param_1)

{
  undefined4 uVar1;
  short sVar2;
  short sVar3;
  
  sVar3 = _DAT_10037d56 - param_1;
  if (sVar3 < 0) {
    sVar3 = -sVar3;
  }
  sVar2 = _DAT_10037d52 - param_1;
  if (sVar2 < 0) {
    sVar2 = -sVar2;
  }
  if (sVar3 < sVar2) {
    if (param_1 < _DAT_10037d56) {
      uVar1 = 2;
    }
    else {
      uVar1 = 1;
    }
  }
  else if (param_1 < _DAT_10037d52) {
    uVar1 = 2;
  }
  else {
    uVar1 = 1;
  }
  return uVar1;
}

