
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10024c58(void)

{
  int iVar1;
  undefined4 local_2c;
  
  FUN_10024b1c();
  iVar1 = .glue::TickCount();
  *(int *)(local_2c + 0x532c) = iVar1 + 600;
  if (_DAT_1003a2ae == 2) {
    FUN_10025cf4();
    FUN_10025c98();
    FUN_100258e0();
    FUN_10025f18();
    _DAT_1003a2ae = 3;
  }
  else {
    FUN_10025cf4();
    FUN_10025c98();
    FUN_100258e0();
    _DAT_1003a2ae = 3;
    FUN_100221c4();
    FUN_100256d0();
  }
  return;
}

