
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002a09c(void)

{
  int local_2c;
  
  _DAT_1003b6d0 = (undefined4 *).glue::GetResource(0x444d4b59,1000);
  if (_DAT_1003b6d0 == (undefined4 *)0x0) {
    FUN_100192f8(5);
  }
  .glue::MoveHHi(_DAT_1003b6d0);
  .glue::HLock(_DAT_1003b6d0);
  _DAT_1003b6cc = (undefined1 *)*_DAT_1003b6d0;
  *(undefined1 *)(local_2c + 0x7558) = *_DAT_1003b6cc;
  _DAT_1003b6cc = _DAT_1003b6cc + 1;
  *(undefined1 *)(local_2c + 0x7559) = *_DAT_1003b6cc;
  _DAT_1003b6cc = _DAT_1003b6cc + 1;
  return;
}

