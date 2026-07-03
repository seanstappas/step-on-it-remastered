
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10025cf4(void)

{
  uint uVar1;
  int local_6c;
  undefined1 auStack_48 [64];
  
  if (DAT_100394b6 == '\0') {
    FUN_10025e08(400);
    .glue::SetPort(_DAT_1003b6e0);
    .glue::SetGDevice(*(undefined4 *)(local_6c + 0x756c));
    uRam1003b260 = 0;
    uRam1003b25e = 0;
    _DAT_1003b25c = 0;
    .glue::RGBForeColor(&DAT_1003b25c);
    .glue::TextSize(10);
    .glue::TextFace(0);
    .glue::TextFont(0x14);
    .glue::MoveTo(0x17c,0x50);
    uVar1 = .glue::FreeMem();
    .glue::NumToString(((int)uVar1 >> 10) + (uint)((int)uVar1 < 0 && (uVar1 & 0x3ff) != 0),
                       auStack_48);
    .glue::SetPort(*(undefined4 *)(local_6c + 0x7568));
    .glue::SetGDevice(*(undefined4 *)(local_6c + 0x7564));
    *(undefined1 *)(local_6c + 0x5346) = 1;
  }
  return;
}

