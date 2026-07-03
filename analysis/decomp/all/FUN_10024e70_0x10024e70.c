
void FUN_10024e70(undefined4 param_1)

{
  int local_3c;
  undefined4 local_18 [5];
  
  .glue::GetPort(local_18);
  .glue::SetPort(*(undefined4 *)(local_3c + 30000));
  if ((short)param_1 == 1) {
    FUN_10023cec(param_1,0x23,0xdc);
  }
  else {
    FUN_10023cec(param_1,0xbf,0xdc);
  }
  .glue::SetPort(*(undefined4 *)(local_3c + 0x7570));
  .glue::SetGDevice(*(undefined4 *)(local_3c + 0x756c));
  FUN_10023534(1,0x23,0xde);
  FUN_10023534(2,0xbf,0xde);
  .glue::SetPort(local_18[0]);
  .glue::SetGDevice(*(undefined4 *)(local_3c + 0x7564));
  return;
}

