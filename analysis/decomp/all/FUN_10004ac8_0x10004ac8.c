
void FUN_10004ac8(void)

{
  int local_3c;
  undefined2 local_18;
  undefined2 local_16;
  undefined2 local_14;
  undefined4 local_12 [3];
  
  .glue::GetPort(local_12);
  .glue::SetPort(*(undefined4 *)(local_3c + 0x7570));
  .glue::SetGDevice(*(undefined4 *)(local_3c + 0x756c));
  .glue::QDError();
  local_14 = 0;
  local_16 = 0;
  local_18 = 0;
  .glue::RGBForeColor(&local_18);
  .glue::PaintRect(local_3c + 0x7584);
  if (*(char *)(local_3c + 0x342e) != '\0') {
    .glue::SetPort(*(undefined4 *)(local_3c + 0x6be4));
    .glue::SetGDevice(*(undefined4 *)(local_3c + 0x6be0));
    .glue::PaintRect(local_3c + 0x7584);
  }
  .glue::SetPort(local_12[0]);
  .glue::SetGDevice(*(undefined4 *)(local_3c + 0x7564));
  return;
}

