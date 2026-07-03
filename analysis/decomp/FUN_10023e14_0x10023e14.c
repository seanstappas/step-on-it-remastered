/* FUN_10023e14 @ 0x10023e14  calls: TickCount */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10023e14(void)

{
  undefined4 uVar1;
  undefined4 local_2c;
  
  _DAT_100394ca = 0xa9;
  _DAT_100394c8 = 0x85;
  _DAT_100394c6 = 0x1a6;
  _DAT_100394c4 = 0x92;
  uVar1 = .glue::TickCount();
  *(undefined4 *)(local_2c + 0x5350) = uVar1;
  return;
}

