
void FUN_10026014(void)

{
  int local_3c;
  undefined4 local_18;
  undefined2 local_14;
  undefined2 local_12;
  undefined2 local_10;
  
  .glue::GetPort(&local_18);
  .glue::SetPort(*(undefined4 *)(local_3c + 0x7534));
  local_12 = 0;
  local_14 = 0;
  local_10 = 0;
  .glue::RGBForeColor(&local_14);
  .glue::PaintRect(*(int *)(local_3c + 0x7534) + 0x10);
  .glue::SetPort(local_18);
  return;
}

