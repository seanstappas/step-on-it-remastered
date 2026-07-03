
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_10022dfc(short param_1)

{
  short sVar2;
  uint uVar1;
  int iVar3;
  int iVar4;
  int local_4c;
  undefined4 local_28 [2];
  
  if (*(char *)(param_1 * 0x70 + 0x1003a9db) == '\0') {
    iVar3 = 0;
    for (iVar4 = 10; 0 < (short)iVar4; iVar4 = iVar4 + -1) {
      if (*(int *)((short)iVar4 * 0x104 + 0x10039882) < *(int *)(param_1 * 0x70 + 0x1003a9ec)) {
        iVar3 = iVar4;
      }
    }
    if ((short)iVar3 != 0) {
      FUN_10018214(0x36);
      FUN_1002b020(0x36,100);
      FUN_10022d2c(iVar3);
      *(undefined4 *)((short)iVar3 * 0x104 + 0x10039882) =
           *(undefined4 *)(param_1 * 0x70 + 0x1003a9ec);
      FUN_10025cf4();
      FUN_10024b1c();
      FUN_10025c98();
      FUN_100258e0();
      _DAT_1003a2ae = 3;
      FUN_10025fb8();
      FUN_10025f18();
      .glue::GetPort(local_28);
      .glue::SetPort(*(undefined4 *)(local_4c + 30000));
      .glue::TextSize(0x12);
      .glue::TextFace(1);
      .glue::TextFont(0x14);
      uRam1003b260 = 0;
      uRam1003b25e = 0;
      _DAT_1003b25c = 50000;
      .glue::RGBForeColor(&DAT_1003b25c);
      if (param_1 == 1) {
        sVar2 = .glue::StringWidth(local_4c + 0x2e5b);
        uVar1 = (uint)sVar2;
        .glue::MoveTo(0xba - (((int)uVar1 >> 1) + (uint)((int)uVar1 < 0 && (uVar1 & 1) != 0)),0x60);
        .glue::DrawString(local_4c + 0x2e5b);
      }
      else {
        sVar2 = .glue::StringWidth(local_4c + 0x2e77);
        uVar1 = (uint)sVar2;
        .glue::MoveTo(0xba - (((int)uVar1 >> 1) + (uint)((int)uVar1 < 0 && (uVar1 & 1) != 0)),0x60);
        .glue::DrawString(local_4c + 0x2e77);
      }
      *(undefined1 *)(local_4c + 0x523e) = 1;
      FUN_10023050(iVar3);
      .glue::SetPort(local_28[0]);
    }
    FUN_10019cb8(0x36);
  }
  return 0;
}

