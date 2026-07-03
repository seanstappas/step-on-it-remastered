
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001f4f8(void)

{
  undefined4 local_5c;
  
  DAT_100393d2 = '\0';
  .glue::HideCursor();
  FUN_10024cfc();
  FUN_10018bf8();
  if (*(short *)(local_5c + 0x759e) == 1) {
    if ((DAT_100393d0 == '\0') || (DAT_1003935c != '\0')) {
      DAT_100393d0 = '\0';
      if (_DAT_1003b29c < _DAT_1003b298) {
        _DAT_1003b298 = 1;
      }
      FUN_1002b060((int)_DAT_1003b298);
      _DAT_100394a4 = 1;
      _DAT_100394a2 = 1;
    }
    else {
      FUN_10028a0c(1);
    }
    while ((-1 < sRam1003aa66 && (DAT_100393d0 == '\0'))) {
      FUN_10029acc((int)sRam1003aa58,1);
      FUN_10028a0c(1);
      if (_DAT_1003b29c < sRam1003aa58) {
        FUN_1001768c();
        sRam1003aa66 = -1;
      }
    }
    if (DAT_100393d0 == '\0') {
      if ((DAT_100393d3 == '\0') && (sRam1003aa58 < _DAT_1003b29c)) {
        FUN_1002401c(0);
      }
      _DAT_100394bc = uRam1003aa5c;
      FUN_1002dc44();
      if (DAT_100393d2 == '\0') {
        FUN_10022dfc(1);
      }
    }
    else {
      _DAT_100394a4 = 1;
      _DAT_100394bc = uRam1003aa5c;
      FUN_1002dc44();
    }
  }
  else if (*(char *)(local_5c + 0x69fe) == '\0') {
    if ((DAT_100393d0 == '\0') || (DAT_1003935c != '\0')) {
      DAT_100393d0 = '\0';
      if (_DAT_1003b29c < _DAT_1003b298) {
        _DAT_1003b298 = 1;
      }
      FUN_1002b060((int)_DAT_1003b298);
      _DAT_100394a4 = 2;
      _DAT_100394a2 = 2;
    }
    else {
      FUN_10028a0c((int)_DAT_100394a2);
    }
    while (((-1 < sRam1003aa66 || (-1 < sRam1003aad6)) && (DAT_100393d0 == '\0'))) {
      _DAT_100394a2 = _DAT_100394a2 + 1;
      if (2 < _DAT_100394a2) {
        _DAT_100394a2 = 1;
      }
      if (-1 < *(short *)(_DAT_100394a2 * 0x70 + 0x1003a9f6)) {
        FUN_10029acc((int)*(short *)(_DAT_100394a2 * 0x70 + 0x1003a9e8),(int)_DAT_100394a2);
        FUN_10028a0c((int)_DAT_100394a2);
        if (_DAT_1003b29c < *(short *)(_DAT_100394a2 * 0x70 + 0x1003a9e8)) {
          FUN_1001768c();
          *(undefined2 *)(_DAT_100394a2 * 0x70 + 0x1003a9f6) = 0xffff;
        }
        if ((*(short *)(_DAT_100394a2 * 0x70 + 0x1003a9f6) < 0) && (DAT_100393d3 == '\0')) {
          if (*(short *)(_DAT_100394a2 * 0x70 + 0x1003a9e8) < _DAT_1003b29c) {
            FUN_1002401c((int)_DAT_100394a2);
          }
        }
        if (DAT_100393d3 != '\0') {
          sRam1003aad6 = -1;
          sRam1003aa66 = -1;
        }
      }
    }
    if (DAT_100393d0 == '\0') {
      _DAT_100394a4 = 2;
      _DAT_100394bc = uRam1003aa5c;
      _DAT_100394b8 = uRam1003aacc;
      FUN_1002dc44();
      if (DAT_100393d2 == '\0') {
        FUN_10022dfc(1);
        FUN_10022dfc(2);
      }
    }
    else {
      _DAT_100394a4 = 2;
      _DAT_100394bc = uRam1003aa5c;
      _DAT_100394b8 = uRam1003aacc;
      FUN_1002dc44();
    }
  }
  else if (*(char *)(local_5c + 0x69fe) == '\x01') {
    if ((DAT_100393d0 == '\0') || (DAT_1003935c != '\0')) {
      DAT_100393d0 = '\0';
      if (DAT_100370e4 == '\0') {
        if (_DAT_1003b29c < _DAT_1003b298) {
          _DAT_1003b298 = 1;
        }
      }
      else if (_DAT_1003b29a < _DAT_1003b298) {
        _DAT_1003b298 = 1;
      }
      FUN_1002b060((int)_DAT_1003b298);
    }
    else {
      FUN_1002a308();
      if (((DAT_100393d0 == '\0') && (DAT_100370e4 != '\0')) &&
         ((cRam1003aa68 == '\0' || (cRam1003aad8 == '\0')))) {
        if (DAT_100393d2 == '\0') {
          FUN_10014d70();
        }
        cRam1003aad8 = '\0';
        cRam1003aa68 = '\0';
      }
    }
    while (((cRam1003aa68 != '\0' || (cRam1003aad8 != '\0')) && (DAT_100393d0 == '\0'))) {
      _DAT_100394a2 = 1;
      if ((DAT_100370e4 != '\0') && (_DAT_1003b29a < sRam1003aa58)) {
        sRam1003aa58 = 1;
        uRam1003aac8 = 1;
      }
      FUN_10029b18((int)sRam1003aa58);
      FUN_1002a308();
      if (((DAT_100393d0 == '\0') && (DAT_100370e4 != '\0')) &&
         ((cRam1003aa68 == '\0' || (cRam1003aad8 == '\0')))) {
        if (DAT_100393d2 == '\0') {
          FUN_10014d70();
        }
        cRam1003aad8 = '\0';
        cRam1003aa68 = '\0';
      }
      if ((DAT_100370e4 == '\0') && (_DAT_1003b29c < sRam1003aa58)) {
        FUN_1001768c();
        cRam1003aad8 = '\0';
        cRam1003aa68 = '\0';
      }
    }
    if (DAT_100393d0 == '\0') {
      if (DAT_100370e4 == '\0') {
        _DAT_100394a4 = 1;
        _DAT_100394bc = uRam1003aa5c;
        FUN_1002dc44();
        if (DAT_100393d2 == '\0') {
          FUN_10022dfc(1);
        }
      }
      else {
        _DAT_100394a4 = 2;
        _DAT_100394bc = uRam1003aa5c;
        _DAT_100394b8 = uRam1003aacc;
        FUN_1002dc44();
      }
    }
    else if (DAT_100370e4 == '\0') {
      _DAT_100394a4 = 1;
      _DAT_100394bc = uRam1003aa5c;
      FUN_1002dc44();
    }
    else {
      _DAT_100394a4 = 2;
      _DAT_100394bc = uRam1003aa5c;
      _DAT_100394b8 = uRam1003aacc;
      FUN_1002dc44();
    }
  }
  .glue::SetPort(*(undefined4 *)(local_5c + 0x7534));
  .glue::InvalRect(*(int *)(local_5c + 0x7534) + 0x10);
  .glue::ShowCursor();
  FUN_10018c2c();
  return;
}

