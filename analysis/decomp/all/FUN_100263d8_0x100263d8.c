
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100263d8(short param_1)

{
  short sStack0000001a;
  
  sStack0000001a = param_1;
  if (param_1 == 3) {
    _DAT_1003b70e = 2;
    _DAT_100394a2 = 1;
    DAT_1003ab6e = 1;
    DAT_1003ab6c = 0;
    DAT_100370e4 = 0;
    if (_DAT_1003b6a8 != 3) {
      FUN_10023a64((int)_DAT_1003b6a8);
      _DAT_1003b6a8 = 3;
      FUN_100239f8(3);
    }
  }
  else if (param_1 < 3) {
    if (param_1 == 1) {
      _DAT_1003b70e = 1;
      _DAT_100394a2 = 1;
      DAT_1003ab6e = 0;
      DAT_1003ab6c = 0;
      DAT_100370e4 = 1;
      if (_DAT_1003b6a8 != 1) {
        FUN_10023a64((int)_DAT_1003b6a8);
        _DAT_1003b6a8 = 1;
        FUN_100239f8(1);
      }
    }
    else if (0 < param_1) {
      _DAT_1003b70e = 2;
      _DAT_100394a2 = 1;
      DAT_1003ab6e = 0;
      DAT_1003ab6c = 0;
      DAT_100370e4 = 1;
      if (_DAT_1003b6a8 != 2) {
        FUN_10023a64((int)_DAT_1003b6a8);
        _DAT_1003b6a8 = 2;
        FUN_100239f8(2);
      }
    }
  }
  else if (param_1 < 5) {
    _DAT_1003b70e = 2;
    _DAT_100394a2 = 1;
    DAT_1003ab6e = 1;
    DAT_1003ab6c = 1;
    DAT_100370e4 = 1;
    if (_DAT_1003b6a8 != 4) {
      FUN_10023a64((int)_DAT_1003b6a8);
      _DAT_1003b6a8 = 4;
      FUN_100239f8(4);
    }
  }
  return;
}

