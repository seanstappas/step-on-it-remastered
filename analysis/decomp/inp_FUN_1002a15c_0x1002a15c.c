/* FUN_1002a15c @ 0x1002a15c */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002a15c(void)

{
  int iVar1;
  uint uVar2;
  char cVar3;
  
  if (DAT_100393d0 == '\0') {
    cVar3 = '\0';
    if (cRam1003aa3e != '\0') {
      cVar3 = '\x02';
    }
    if (cRam1003aa3f != '\0') {
      cVar3 = cVar3 + '\x01';
    }
    if (cRam1003aa40 != '\0') {
      cVar3 = cVar3 + '\x04';
    }
    if (cRam1003aa41 != '\0') {
      cVar3 = cVar3 + '\b';
    }
    if (cRam1003aa42 != '\0') {
      cVar3 = cVar3 + '\x10';
    }
    if (cRam1003aa43 != '\0') {
      cVar3 = cVar3 + '@';
    }
    if (cRam1003aa44 != '\0') {
      cVar3 = cVar3 + ' ';
    }
    if (*_DAT_1003b6cc == -1) {
      _DAT_1003b6cc = _DAT_1003b6cc + 2;
      *_DAT_1003b6cc = '\x01';
      _DAT_1003b6cc[1] = cVar3;
    }
    else if (_DAT_1003b6cc[1] == cVar3) {
      *_DAT_1003b6cc = *_DAT_1003b6cc + '\x01';
    }
    else {
      _DAT_1003b6cc = _DAT_1003b6cc + 2;
      *_DAT_1003b6cc = '\x01';
      _DAT_1003b6cc[1] = cVar3;
    }
  }
  else {
    _DAT_1003b6cc = _DAT_1003b6cc + 2;
    *_DAT_1003b6cc = '\0';
    _DAT_1003b6cc[1] = '\0';
    _DAT_1003b6cc = _DAT_1003b6cc + 2;
    *_DAT_1003b6cc = '\x01';
    _DAT_1003b6cc[1] = '\0';
    DAT_100393d0 = '\0';
    iVar1 = .glue::TickCount();
    do {
      uVar2 = .glue::TickCount();
    } while (uVar2 < iVar1 + 0x78U);
  }
  return;
}

