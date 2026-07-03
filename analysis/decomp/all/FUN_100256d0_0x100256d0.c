
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100256d0(void)

{
  undefined4 local_18 [4];
  
  FUN_10021938(0);
  .glue::GetPort(local_18);
  .glue::SetPort(_DAT_1003b6a0);
  .glue::ShowHide(_DAT_1003b6a0,0);
  .glue::SizeWindow(_DAT_1003b6a0,(int)sRam100394b4 - (int)sRam100394b0,
                    (int)sRam100394b2 - (int)_DAT_100394ae,0);
  .glue::MoveWindow(_DAT_1003b6a0,(int)sRam100394b0,(int)_DAT_100394ae,0);
  .glue::ShowHide(_DAT_1003b6a0,1);
  .glue::InvalRect(_DAT_1003b6a0 + 0x10);
  .glue::SelectWindow(_DAT_1003b6a0);
  .glue::SetPort(local_18[0]);
  return;
}

