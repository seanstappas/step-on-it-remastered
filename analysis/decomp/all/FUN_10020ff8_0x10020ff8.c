
void FUN_10020ff8(void)

{
  short sVar1;
  int local_3c;
  undefined4 local_18;
  short local_14;
  short local_12 [5];
  
  uRam10039406 = FUN_100212d4(&DAT_100393e6);
  FUN_10026fd8(&DAT_1003accc,0x1003940b);
  local_18 = 0x66;
  sVar1 = .glue::FSpOpenDF(&DAT_1003944e,3,local_12);
  if (sVar1 != 0) {
    sVar1 = .glue::SetFPos((int)local_12[0],1,0);
  }
  if (sVar1 == 0) {
    .glue::FSWrite((int)local_12[0],&local_18,&DAT_100393e6);
    sVar1 = .glue::SetEOF((int)local_12[0],local_18);
  }
  if (sVar1 == 0) {
    sVar1 = .glue::GetVRefNum((int)local_12[0],&local_14);
  }
  if (sVar1 == 0) {
    sVar1 = .glue::FlushVol(0,(int)local_14);
  }
  if (sVar1 == 0) {
    sVar1 = .glue::FSClose((int)local_12[0]);
  }
  if (sVar1 == 0) {
    sVar1 = .glue::FlushVol(0,(int)local_14);
  }
  if (sVar1 == 0) {
    *(undefined1 *)(local_3c + 0x5274) = 1;
  }
  else {
    .glue::Alert(0x19f,0);
  }
  return;
}

