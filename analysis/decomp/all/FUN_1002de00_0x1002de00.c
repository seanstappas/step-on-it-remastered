
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002de00(void)

{
  int iVar1;
  undefined4 uVar2;
  int iVar3;
  int iVar4;
  undefined4 uVar5;
  char cVar6;
  uint uVar7;
  short sVar8;
  int iVar9;
  short sVar10;
  int local_7c;
  undefined2 local_58;
  undefined2 local_56;
  undefined2 local_54;
  undefined1 auStack_52 [10];
  
  FUN_10017b68();
  DAT_100394b6 = 0;
  _DAT_1003a2ae = 8;
  FUN_10004080();
  FUN_1002dd90();
  FUN_10021938(1);
  .glue::HideWindow(_DAT_1003b6a0);
  iVar1 = .glue::GetMBarHeight();
  .glue::SetRect(auStack_52,(int)sRam1003bafc,(int)sRam1003bafa,(int)sRam1003bb00,
                 sRam1003bafa + iVar1);
  uVar2 = .glue::NewRgn();
  .glue::RectRgn(uVar2,auStack_52);
  .glue::RectRgn(*(undefined4 *)(_DAT_1003b6a4 + 0x18),_DAT_1003b6a4 + 0x10);
  .glue::UnionRgn(*(undefined4 *)(_DAT_1003b6a4 + 0x18),uVar2,*(undefined4 *)(_DAT_1003b6a4 + 0x18))
  ;
  .glue::DisposeRgn(uVar2);
  .glue::LMSetMBarHeight(0);
  .glue::SetPort(_DAT_1003b6a4);
  local_54 = 0;
  local_56 = 0;
  local_58 = 0;
  .glue::RGBForeColor(&local_58);
  .glue::PaintRect(_DAT_1003b6a4 + 0x10);
  FUN_10021e60(*(undefined4 *)(local_7c + 0x70fc));
  FUN_10004ac8();
  FUN_10028958();
  if ((*(char *)(local_7c + 0x2f74) == '\0') || (*(char *)(local_7c + 0x69fe) == '\0')) {
    FUN_10004bb4(_DAT_1003ad28,_DAT_100394a2 + 2,0x1e,8);
    FUN_1002b900(*(undefined4 *)(_DAT_100394a2 * 0x70 + 0x1003a9ec),&DAT_1003abc2);
    FUN_1002b810(&DAT_1003abc2,0x50,8);
  }
  else {
    FUN_10004bb4(_DAT_1003ad28,3,0x1e,0);
    FUN_10004bb4(_DAT_1003ad28,4,0x1e,0x10);
    FUN_1002b900(uRam1003aa5c,&DAT_1003abc2);
    FUN_1002b810(&DAT_1003abc2,0x50,0);
    FUN_1002b900(uRam1003aacc,local_7c + 0x6a16);
    FUN_1002b810(local_7c + 0x6a16,0x50,0x10);
  }
  if ((*(char *)(local_7c + 0x2f74) == '\0') || (*(char *)(local_7c + 0x69fe) == '\0')) {
    FUN_10004bb4(_DAT_1003ad28,(int)_DAT_100394a2,200,8);
    FUN_1002b950((int)*(short *)(_DAT_100394a2 * 0x70 + 0x1003a9f0),&DAT_1003abe0);
    FUN_1002b888(&DAT_1003abe0,0xf4,8);
  }
  else {
    FUN_10004bb4(_DAT_1003ad28,1,200,0);
    FUN_1002b950((int)sRam1003aa60,&DAT_1003abe0);
    FUN_1002b888(&DAT_1003abe0,0xf4,0);
    FUN_10004bb4(_DAT_1003ad28,2,200,0x10);
    FUN_1002b950((int)sRam1003aad0,local_7c + 0x6a34);
    FUN_1002b888(local_7c + 0x6a34,0xf4,0x10);
  }
  *(undefined1 *)(local_7c + 0x6a01) = 1;
  *(undefined1 *)(local_7c + 0x6a00) = 1;
  FUN_1001603c();
  FUN_1000fb18();
  FUN_1002e528((int)*(short *)(_DAT_100394a2 * 0x70 + 0x1003a9e8),0x21c,8);
  FUN_1002e344();
  for (iVar1 = 1; sVar8 = (short)iVar1, sVar8 < 0x14; iVar1 = iVar1 + 1) {
    for (iVar9 = 1; sVar10 = (short)iVar9, sVar10 < 0xe; iVar9 = iVar9 + 1) {
      uVar7 = *(uint *)(&DAT_1003ad68 + sVar8 * 0x3c + sVar10 * 4) & 0xff;
      if ((*(uint *)(&DAT_1003ad68 + sVar8 * 0x3c + sVar10 * 4) & 0x800) == 0) {
        if ((((*(uint *)(&DAT_1003ad68 + sVar8 * 0x3c + sVar10 * 4) & 0x400) == 0) &&
            ((short)uVar7 != 0)) && (cVar6 = FUN_1001604c(uVar7,iVar1,iVar9), cVar6 == '\0')) {
          uVar2 = FUN_1002e6bc(iVar9);
          uVar5 = FUN_1002e6ac(iVar1);
          FUN_10004108(_DAT_1003ad30,uVar7,uVar5,uVar2);
        }
      }
      else if ((short)uVar7 == 0xff) {
        iVar3 = FUN_1002e6bc(iVar9);
        iVar4 = FUN_1002e6ac(iVar1);
        FUN_10004108(_DAT_1003ad14,0x10,iVar4 + 4,iVar3 + 4);
      }
      else {
        uVar7 = *(uint *)(&DAT_1003ad68 + sVar8 * 0x3c + sVar10 * 4);
        uVar2 = FUN_1002e6bc(iVar9);
        uVar5 = FUN_1002e6ac(iVar1);
        FUN_10004108(_DAT_1003ad2c,uVar7 & 0xff,uVar5,uVar2);
      }
    }
    FUN_10004180();
  }
  FUN_100289c0();
  FUN_10004080();
  FUN_10021c14();
  return;
}

