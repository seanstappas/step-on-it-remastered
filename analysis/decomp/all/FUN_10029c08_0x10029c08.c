
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10029c08(void)

{
  _DAT_1003b6d0 = (undefined4 *).glue::NewHandle(10000);
  .glue::MoveHHi(_DAT_1003b6d0);
  .glue::HLock(_DAT_1003b6d0);
  if (_DAT_1003b6d0 == (undefined4 *)0x0) {
    FUN_100192f8(6);
  }
  _DAT_1003b6cc = (undefined1 *)*_DAT_1003b6d0;
  *_DAT_1003b6cc = 1;
  _DAT_1003b6cc[1] = 0;
  return;
}

