
void FUN_1001f43c(void)

{
  undefined4 local_2c;
  
  DAT_100393d0 = 0;
  DAT_1003935c = 0;
  .glue::HideCursor();
  FUN_10024cfc();
  FUN_1002b060(0xffffff9c);
  *(undefined2 *)(local_2c + 0x5334) = 1;
  *(undefined2 *)(local_2c + 0x5332) = 1;
  FUN_10029acc((int)*(short *)(local_2c + 0x68e8),1);
  FUN_10029264(1);
  FUN_1002dc44();
  .glue::SetPort(*(undefined4 *)(local_2c + 0x7534));
  .glue::InvalRect(*(int *)(local_2c + 0x7534) + 0x10);
  .glue::ShowCursor();
  return;
}

