
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10023e70(void)

{
  int local_4c;
  undefined4 local_28;
  undefined1 auStack_24 [16];
  
  _DAT_100394a0 = _DAT_100394a0 + 1;
  .glue::GetPort(&local_28);
  .glue::SetPort(*(undefined4 *)(local_4c + 30000));
  .glue::SetRect(auStack_24,_DAT_100394ca + 1,_DAT_100394c8 + 1,
                 (int)_DAT_100394ca +
                 (((int)*(short *)(local_4c + 0x5356) - (int)_DAT_100394ca) *
                 (int)*(short *)(local_4c + 0x5330)) / 0x3e + -1,*(short *)(local_4c + 0x5354) + -1)
  ;
  uRam1003b260 = 0;
  uRam1003b25e = 0;
  _DAT_1003b25c = 40000;
  .glue::RGBForeColor(&DAT_1003b25c);
  .glue::PaintRect(auStack_24);
  .glue::SetRect(auStack_24,_DAT_100394ca + -0x46,_DAT_100394c8 + 0x1a,_DAT_100394ca + 200,
                 _DAT_100394c8 + 0x24);
  uRam1003977c = 0x7777;
  uRam1003977a = 0x7777;
  _DAT_10039778 = 0x7777;
  .glue::RGBForeColor(&DAT_10039778);
  .glue::PaintRect(auStack_24);
  uRam1003b260 = 0;
  uRam1003b25e = 0;
  _DAT_1003b25c = 0;
  .glue::RGBForeColor(&DAT_1003b25c);
  .glue::MoveTo(_DAT_100394ca + -0x46,_DAT_100394c8 + 0x22);
  .glue::TextSize(10);
  .glue::TextFace(0);
  .glue::TextFont(0x14);
  .glue::SetPort(local_28);
  return;
}

