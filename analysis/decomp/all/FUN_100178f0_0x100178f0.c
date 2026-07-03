
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100178f0(short param_1,undefined4 param_2,undefined4 param_3,undefined4 param_4)

{
  bool bVar1;
  
  while( true ) {
    bVar1 = param_1 < 1;
    param_1 = param_1 + -1;
    if (bVar1) break;
    if (0 < _DAT_10038fe2) {
      FUN_10004bb4(param_2,param_3,(int)_DAT_10038fe2,(int)_DAT_10038fe0);
      _DAT_10038fe2 = _DAT_10038fe2 + 0x24;
      if (0x217 < _DAT_10038fe2) {
        _DAT_10038fe2 = 0x68;
        _DAT_10038fe0 = _DAT_10038fe0 + 0x24;
        if (0x17c < _DAT_10038fe0) {
          _DAT_10038fe2 = -1;
        }
      }
    }
    FUN_1002b020(param_4,100);
    FUN_100179c4(0xf);
  }
  return;
}

