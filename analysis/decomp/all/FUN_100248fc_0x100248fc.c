
undefined4 FUN_100248fc(void)

{
  char cVar2;
  undefined4 uVar1;
  int local_18;
  int local_14;
  int local_10;
  int local_c;
  
  cVar2 = .glue::Button();
  if (cVar2 == '\0') {
    .glue::GetKeys(&local_18);
    if (local_18 == 0) {
      if (local_14 == 0) {
        if (local_10 == 0) {
          if (local_c == 0) {
            uVar1 = 0;
          }
          else {
            uVar1 = 1;
          }
        }
        else {
          uVar1 = 1;
        }
      }
      else {
        uVar1 = 1;
      }
    }
    else {
      uVar1 = 1;
    }
  }
  else {
    uVar1 = 1;
  }
  return uVar1;
}

