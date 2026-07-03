
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10026b04(void)

{
  undefined4 local_2c;
  
  FUN_10021938(1);
  FUN_1001600c();
  FUN_100194dc();
  FUN_10019848();
  .glue::SetDefaultOutputVolume(_DAT_1003b6ac);
  .glue::FlushEvents(0xffff,0);
  FUN_1000123c(*(undefined4 *)(local_2c + 0x7570),*(undefined4 *)(local_2c + 0x756c));
  .glue::LMSetMBarHeight((int)*(short *)(local_2c + 0x752c));
  .glue::DisposeWindow(*(undefined4 *)(local_2c + 0x7534));
  .glue::DisposeWindow(*(undefined4 *)(local_2c + 30000));
  FUN_10021c14();
  return;
}

