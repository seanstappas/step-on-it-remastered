
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

int FUN_10022310(undefined4 param_1)

{
  char cVar1;
  short sVar2;
  undefined4 uStack00000018;
  undefined4 local_28 [5];
  
  uStack00000018 = param_1;
  .glue::SetPort(_DAT_1003b6a0);
  .glue::GlobalToLocal(&stack0x00000018);
  sVar2 = 0;
  while( true ) {
    if (_DAT_100394cc <= sVar2) {
      return -1;
    }
    cVar1 = FUN_10022628(uStack00000018,(int)*(short *)(&DAT_100394ce + sVar2 * 2));
    if (cVar1 != '\0') break;
    sVar2 = sVar2 + 1;
  }
  cVar1 = FUN_100239c4((int)*(short *)(&DAT_100394ce + sVar2 * 2));
  if (cVar1 == '\0') {
    cVar1 = FUN_100239ac((int)*(short *)(&DAT_100394ce + sVar2 * 2));
    if (cVar1 != '\0') {
      return -1;
    }
    while (cVar1 = .glue::Button(), cVar1 != '\0') {
      .glue::GetMouse(local_28);
      cVar1 = FUN_10022628(local_28[0],(int)*(short *)(&DAT_100394ce + sVar2 * 2));
      if (cVar1 == '\0') {
        FUN_10023a64((int)*(short *)(&DAT_100394ce + sVar2 * 2));
      }
      else {
        FUN_100239f8((int)*(short *)(&DAT_100394ce + sVar2 * 2));
      }
    }
    cVar1 = FUN_10022628(local_28[0],(int)*(short *)(&DAT_100394ce + sVar2 * 2));
    if (cVar1 != '\0') {
      return (int)*(short *)(&DAT_100394ce + sVar2 * 2);
    }
    return -1;
  }
  cVar1 = FUN_100239ac((int)*(short *)(&DAT_100394ce + sVar2 * 2));
  if (cVar1 == '\0') {
    while (cVar1 = .glue::Button(), cVar1 != '\0') {
      .glue::GetMouse(&DAT_1003977e);
      cVar1 = FUN_10022628(_DAT_1003977e,(int)*(short *)(&DAT_100394ce + sVar2 * 2));
      if (cVar1 == '\0') {
        FUN_10023a64((int)*(short *)(&DAT_100394ce + sVar2 * 2));
      }
      else {
        FUN_100239f8((int)*(short *)(&DAT_100394ce + sVar2 * 2));
      }
    }
    cVar1 = FUN_10022628(_DAT_1003977e,(int)*(short *)(&DAT_100394ce + sVar2 * 2));
    if (cVar1 != '\0') {
      return (int)*(short *)(&DAT_100394ce + sVar2 * 2);
    }
    return -1;
  }
  while (cVar1 = .glue::Button(), cVar1 != '\0') {
    .glue::GetMouse(&DAT_1003977e);
    cVar1 = FUN_10022628(_DAT_1003977e,(int)*(short *)(&DAT_100394ce + sVar2 * 2));
    if (cVar1 == '\0') {
      FUN_100239f8((int)*(short *)(&DAT_100394ce + sVar2 * 2));
    }
    else {
      FUN_10023a64((int)*(short *)(&DAT_100394ce + sVar2 * 2));
    }
  }
  cVar1 = FUN_10022628(_DAT_1003977e,(int)*(short *)(&DAT_100394ce + sVar2 * 2));
  if (cVar1 != '\0') {
    return (int)*(short *)(&DAT_100394ce + sVar2 * 2);
  }
  return -1;
}

