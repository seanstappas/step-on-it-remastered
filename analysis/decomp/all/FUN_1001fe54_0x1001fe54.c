
undefined4 FUN_1001fe54(void)

{
  char cVar4;
  undefined4 uVar1;
  short sVar3;
  int iVar2;
  undefined4 local_28;
  undefined4 local_24;
  undefined4 local_20;
  undefined4 local_1c;
  undefined4 local_18;
  int local_14 [4];
  
  cVar4 = FUN_1001ff30();
  if (cVar4 == '\0') {
    uVar1 = 0;
  }
  else {
    sVar3 = .glue::Gestalt(0x7174696d,local_14);
    if (sVar3 == 0) {
      if (local_14[0] < 0x2000000) {
        uVar1 = 0;
      }
      else {
        local_28 = 0x696e7374;
        local_24 = 0x73732020;
        local_20 = 0x6170706c;
        local_1c = 0;
        local_18 = 0;
        iVar2 = .glue::FindNextComponent(0,&local_28);
        if (iVar2 == 0) {
          uVar1 = 0;
        }
        else {
          uVar1 = 1;
        }
      }
    }
    else {
      uVar1 = 0;
    }
  }
  return uVar1;
}

