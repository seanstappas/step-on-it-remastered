/* FUN_1001a618 @ 0x1001a618  depth=2 */

void FUN_1001a618(void)

{
  undefined2 uVar1;
  short sVar2;
  int local_3c;
  undefined1 auStack_18 [16];
  
  .glue::MoreMasters();
  .glue::MoreMasters();
  *(undefined1 *)(local_3c + 0x5261) = 0;
  *(undefined1 *)(local_3c + 0x5263) = 0;
  .glue::InitGraf(local_3c + 0x79fe);
  .glue::InitFonts();
  .glue::InitWindows();
  .glue::InitMenus();
  .glue::TEInit();
  .glue::InitDialogs(0);
  .glue::InitCursor();
  uVar1 = .glue::CurResFile();
  *(undefined2 *)(local_3c + 0x51f0) = uVar1;
  for (sVar2 = 1; sVar2 < 4; sVar2 = sVar2 + 1) {
    .glue::EventAvail(0xffff,auStack_18);
  }
  .glue::SysEnvirons(2,&DAT_100393d4);
  if (sRam100393d6 < 0) {
    FUN_100192f8(1);
  }
  if (sRam100393d8 < 0x700) {
    FUN_100192f8(2);
  }
  if ((uint)(*(int *)(local_3c + -0x1d8) == 0) * 0xa860 != 0) {
    FUN_100192f8(3);
  }
  FUN_1001a76c();
  return;
}

