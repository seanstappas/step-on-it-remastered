
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100153d0(undefined4 param_1)

{
  int *piVar1;
  int local_4c;
  undefined4 local_28;
  undefined4 local_24;
  undefined2 local_20;
  undefined2 local_1e;
  undefined2 local_1c;
  
  DAT_100394b6 = 0;
  FUN_1002dd90();
  FUN_10021938(1);
  .glue::HideWindow(_DAT_1003b6a0);
  .glue::SetPort(_DAT_1003b6a4);
  local_1c = 0;
  local_1e = 0;
  local_20 = 0;
  .glue::RGBForeColor(&local_20);
  .glue::PaintRect(_DAT_1003b6a4 + 0x10);
  FUN_10021e60(*(undefined4 *)(local_4c + 0x70fc));
  FUN_10004ac8();
  piVar1 = (int *).glue::GetPicture(1000);
  if (piVar1 == (int *)0x0) {
    FUN_100192f8(5);
  }
  FUN_10000a4c();
  .glue::SetPort(*(undefined4 *)(local_4c + 0x7570));
  .glue::SetGDevice(*(undefined4 *)(local_4c + 0x756c));
  .glue::RGBForeColor(&local_20);
  .glue::PaintRect(local_4c + 0x7584);
  local_28 = *(undefined4 *)(*piVar1 + 2);
  local_24 = *(undefined4 *)(*piVar1 + 6);
  .glue::DrawPicture(piVar1,&local_28);
  .glue::ReleaseResource(piVar1);
  if ((short)param_1 == 3) {
    if (*(char *)(local_4c + 0x2f74) == '\0') {
      FUN_100159f4(3,0x140);
    }
    else if ((cRam1003aa49 == '\0') || (cRam1003aab9 == '\0')) {
      if (cRam1003aa49 == '\0') {
        if (cRam1003aab9 != '\0') {
          FUN_100159f4(2,0x140);
        }
      }
      else {
        FUN_100159f4(1,0x140);
      }
    }
    else {
      FUN_100159f4(1,0xc9);
      FUN_100159f4(2,0x1b7);
    }
  }
  else {
    FUN_100159f4(param_1,0x140);
  }
  .glue::SetPort(_DAT_1003b6a4);
  .glue::SetGDevice(*(undefined4 *)(local_4c + 0x7564));
  .glue::CopyBits(*(int *)(local_4c + 0x7570) + 2,_DAT_1003b6a4 + 2,&local_28,local_4c + 0x757c,0,0)
  ;
  FUN_10021c14();
  if ((short)param_1 == 3) {
    if (*(char *)(local_4c + 0x2f74) == '\0') {
      FUN_10015714(3,0x140);
    }
    else if ((cRam1003aa49 == '\0') || (cRam1003aab9 == '\0')) {
      if (cRam1003aa49 == '\0') {
        if (cRam1003aab9 != '\0') {
          FUN_10015714(2,0x140);
        }
      }
      else {
        FUN_10015714(1,0x140);
      }
    }
    else {
      FUN_10015714(1,0xc9);
      FUN_10015714(2,0x1b7);
    }
  }
  else {
    FUN_10015714(param_1,0x140);
  }
  FUN_10021854();
  return;
}

