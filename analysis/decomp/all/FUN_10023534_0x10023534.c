
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10023534(short param_1,int param_2,int param_3)

{
  uint uVar1;
  int local_4c;
  undefined1 auStack_28 [16];
  
  .glue::SetRect(auStack_28,param_2 + 0x45,param_3 + -10,param_2 + 0x79,param_3 + 0x4b);
  .glue::RGBForeColor(local_4c + 0x5608);
  .glue::PaintRect(auStack_28);
  .glue::TextSize(0xc);
  .glue::TextFace(0);
  .glue::TextFont(0x14);
  .glue::MoveTo(param_2 + 0x46,param_3);
  uRam1003b260 = 0;
  _DAT_1003b25c = 0;
  uRam1003b25e = 0;
  .glue::RGBForeColor(&DAT_1003b25c);
  uVar1 = *(uint *)(&DAT_1003a2b0 + param_1 * 0x1c);
  .glue::DrawString(&DAT_10034f62 +
                    (((int)uVar1 >> 8) + (uint)((int)uVar1 < 0 && (uVar1 & 0xff) != 0)) * 0x40);
  .glue::MoveTo(param_2 + 0x46,param_3 + 0xc);
  uVar1 = *(uint *)(param_1 * 0x1c + 0x1003a2b4);
  .glue::DrawString(&DAT_10034f62 +
                    (((int)uVar1 >> 8) + (uint)((int)uVar1 < 0 && (uVar1 & 0xff) != 0)) * 0x40);
  .glue::MoveTo(param_2 + 0x46,param_3 + 0x18);
  uVar1 = *(uint *)(param_1 * 0x1c + 0x1003a2b8);
  .glue::DrawString(&DAT_10034f62 +
                    (((int)uVar1 >> 8) + (uint)((int)uVar1 < 0 && (uVar1 & 0xff) != 0)) * 0x40);
  .glue::MoveTo(param_2 + 0x46,param_3 + 0x24);
  uVar1 = *(uint *)(param_1 * 0x1c + 0x1003a2bc);
  .glue::DrawString(&DAT_10034f62 +
                    (((int)uVar1 >> 8) + (uint)((int)uVar1 < 0 && (uVar1 & 0xff) != 0)) * 0x40);
  .glue::MoveTo(param_2 + 0x46,param_3 + 0x30);
  uVar1 = *(uint *)(param_1 * 0x1c + 0x1003a2c0);
  .glue::DrawString(&DAT_10034f62 +
                    (((int)uVar1 >> 8) + (uint)((int)uVar1 < 0 && (uVar1 & 0xff) != 0)) * 0x40);
  .glue::MoveTo(param_2 + 0x46,param_3 + 0x3c);
  uVar1 = *(uint *)(param_1 * 0x1c + 0x1003a2c4);
  .glue::DrawString(&DAT_10034f62 +
                    (((int)uVar1 >> 8) + (uint)((int)uVar1 < 0 && (uVar1 & 0xff) != 0)) * 0x40);
  .glue::MoveTo(param_2 + 0x46,param_3 + 0x48);
  uVar1 = *(uint *)(param_1 * 0x1c + 0x1003a2c8);
  .glue::DrawString(&DAT_10034f62 +
                    (((int)uVar1 >> 8) + (uint)((int)uVar1 < 0 && (uVar1 & 0xff) != 0)) * 0x40);
  return;
}

