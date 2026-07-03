
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_10023ad0(int param_1,int param_2)

{
  char cVar2;
  int iVar1;
  uint uVar3;
  bool bVar4;
  undefined4 unaff_r31;
  int local_4c;
  undefined1 auStack_28 [12];
  
  .glue::SetRect(auStack_28,param_1 + 0x46,param_2 + -10,param_1 + 0x79,param_2 + 3);
  .glue::RGBForeColor(local_4c + 0x5608);
  .glue::PaintRect(auStack_28);
  uRam1003b25e = 0;
  uRam1003b260 = 0;
  _DAT_1003b25c = 0xffff;
  .glue::RGBForeColor(&DAT_1003b25c);
  .glue::MoveTo(param_1 + 0x46,param_2);
  .glue::TextSize(0xc);
  .glue::TextFace(1);
  .glue::TextFont(0x14);
  .glue::DrawString(local_4c + 0x2e93);
  bVar4 = false;
  while (!bVar4) {
    unaff_r31 = FUN_1002d2d4();
    if (((short)unaff_r31 != -1) && ((short)unaff_r31 != -1)) {
      cVar2 = FUN_10023c90(unaff_r31);
      if (cVar2 == '\0') {
        .glue::SysBeep(1);
      }
      else {
        bVar4 = true;
      }
    }
  }
  do {
    iVar1 = FUN_1002d2d4();
  } while (-1 < iVar1);
  .glue::RGBForeColor(local_4c + 0x5608);
  .glue::PaintRect(auStack_28);
  uRam1003b25e = 0;
  _DAT_1003b25c = 0;
  uRam1003b260 = 0;
  .glue::RGBForeColor(&DAT_1003b25c);
  .glue::TextFace(0);
  .glue::MoveTo(param_1 + 0x46,param_2);
  uVar3 = (uint)(short)unaff_r31;
  .glue::DrawString(local_4c + 0xdf2 +
                    (((int)uVar3 >> 8) + (uint)((int)uVar3 < 0 && (uVar3 & 0xff) != 0)) * 0x40);
  return unaff_r31;
}

