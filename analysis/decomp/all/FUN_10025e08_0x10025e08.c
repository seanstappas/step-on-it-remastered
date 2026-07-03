
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10025e08(short param_1)

{
  int *piVar1;
  short sStack0000001a;
  int local_3c;
  undefined4 local_18;
  undefined4 local_14;
  
  sStack0000001a = param_1;
  piVar1 = (int *).glue::GetPicture((int)param_1);
  if (piVar1 == (int *)0x0) {
    FUN_100192f8(5);
  }
  else {
    FUN_10000a4c();
    .glue::SetPort(*(undefined4 *)(local_3c + 0x7570));
    .glue::SetGDevice(*(undefined4 *)(local_3c + 0x756c));
    uRam1003b25e = 0;
    _DAT_1003b25c = 0;
    uRam1003b260 = 0;
    .glue::RGBForeColor(&DAT_1003b25c);
    .glue::PaintRect(local_3c + 0x7584);
    local_18 = *(undefined4 *)(*piVar1 + 2);
    local_14 = *(undefined4 *)(*piVar1 + 6);
    FUN_10026344(&local_18);
    .glue::DrawPicture(piVar1,local_3c + 0x5336);
    .glue::ReleaseResource(piVar1);
    .glue::SetPort(*(undefined4 *)(local_3c + 0x7568));
    .glue::SetGDevice(*(undefined4 *)(local_3c + 0x7564));
  }
  return;
}

