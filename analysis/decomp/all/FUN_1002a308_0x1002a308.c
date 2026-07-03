
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002a308(void)

{
  int iVar1;
  int iVar2;
  char cVar3;
  short sVar4;
  bool bVar5;
  int unaff_r26;
  int unaff_r27;
  int local_6c;
  
  FUN_10020f5c();
  DAT_1003ab01 = '\0';
  DAT_1003ab00 = '\0';
  uRam1003b260 = 0xffff;
  uRam1003b25e = 0xffff;
  _DAT_1003b25c = 0xffff;
  _DAT_1003b294 = 0;
  if (DAT_100393d0 != '\0') {
    FUN_10017b68();
  }
  if ((DAT_1003ad0e != '\0') && (DAT_100393d0 == '\0')) {
    FUN_10016c90(1);
  }
  FUN_1002de00();
  FUN_10018c88((int)*(short *)(_DAT_100394a2 * 0x70 + 0x1003a9e8));
  FUN_1001882c(1);
  cRam1003aa4a = cRam1003aa68 != '\0';
  cRam1003aa5a = !(bool)cRam1003aa4a;
  cRam1003aaba = cRam1003aad8 != '\0';
  cRam1003aaca = !(bool)cRam1003aaba;
  iVar1 = FUN_10015fe4();
  do {
    iVar2 = FUN_10015fe4();
  } while (iVar1 == iVar2);
  iVar1 = FUN_10015fe4();
  do {
    iVar2 = FUN_10015fe4();
  } while (iVar1 == iVar2);
  FUN_10015fe4();
  DAT_1003ab04 = 0;
  DAT_100393d0 = 0;
  .glue::FlushEvents(0xffff,0);
  sVar4 = 2;
  bVar5 = false;
  FUN_1001166c(1);
  FUN_100115c0(1);
  FUN_1001166c(2);
  FUN_100115c0(2);
  *(undefined1 *)(local_6c + 0x3bde) = 1;
  while (!bVar5) {
    _DAT_1003b294 = _DAT_1003b294 - 1;
    if ((int)_DAT_1003b294 < 0) {
      if (cRam1003aa5a == '\0') {
        if (cRam1003aaca == '\0') {
          FUN_1000503c((int)sRam1003aa20,(int)sRam1003aa24,(int)sRam1003aa90,(int)sRam1003aa94);
        }
        else {
          FUN_1000503c((int)sRam1003aa20,(int)sRam1003aa24,2000,2000);
        }
      }
      else {
        FUN_1000503c(2000,2000,(int)sRam1003aa90,(int)sRam1003aa94);
      }
    }
    else if ((_DAT_1003b294 & 1) != 0) {
      if (cRam1003aa5a == '\0') {
        if (cRam1003aaca == '\0') {
          FUN_1000503c((int)sRam1003aa20,(int)sRam1003aa24,(int)sRam1003aa90,(int)sRam1003aa94);
        }
        else {
          FUN_1000503c((int)sRam1003aa20,(int)sRam1003aa24,2000,2000);
        }
      }
      else {
        FUN_1000503c(2000,2000,(int)sRam1003aa90,(int)sRam1003aa94);
      }
    }
    sVar4 = sVar4 + -1;
    if (sVar4 < 1) {
      sVar4 = 2;
      FUN_1002d440();
      if (cRam1003aa5a == '\0') {
        FUN_1001166c(1);
      }
      if (cRam1003aaca == '\0') {
        FUN_1001166c(2);
      }
      if ((cRam1003aa48 == '\0') && (cRam1003aa5a == '\0')) {
        FUN_1002bc64(1);
      }
      if ((cRam1003aab8 == '\0') && (cRam1003aaca == '\0')) {
        FUN_1002bc64(2);
      }
    }
    else {
      if ((sRam1003aa7c == 1) && (cRam1003aa5a == '\0')) {
        FUN_1001166c(1);
      }
      if ((sRam1003aaec == 1) && (cRam1003aaca == '\0')) {
        FUN_1001166c(2);
      }
      if ((cRam1003aa48 != '\0') && (cRam1003aa5a == '\0')) {
        FUN_1001166c(1);
      }
      if ((cRam1003aab8 != '\0') && (cRam1003aaca == '\0')) {
        FUN_1001166c(2);
      }
    }
    FUN_10016784();
    FUN_10028958();
    FUN_10004180();
    FUN_1000fd5c(0x1003aa20,1);
    FUN_1000fd5c(0x1003aa90,2);
    FUN_10028060();
    FUN_100283a0();
    FUN_1000efb4();
    FUN_1000f500();
    FUN_10004d14();
    if (cRam1003aa5a == '\0') {
      FUN_100043a0(uRam1003aa2a,(int)sRam1003aa38,(int)sRam1003aa34,(int)sRam1003aa36,uRam1003aa26,
                   (int)sRam1003aa2e,(int)sRam1003aa22,(int)sRam1003aa24);
      FUN_100115c0(1);
      FUN_10014a10(1);
    }
    if (cRam1003aaca == '\0') {
      FUN_100043a0(uRam1003aa9a,(int)sRam1003aaa8,(int)sRam1003aaa4,(int)sRam1003aaa6,uRam1003aa96,
                   (int)sRam1003aa9e,(int)sRam1003aa92,(int)sRam1003aa94);
      FUN_100115c0(2);
      FUN_10014a10(2);
    }
    FUN_100289c0();
    if ((cRam1003aa5a == '\0') && (cRam1003aa48 == '\0')) {
      cVar3 = FUN_100299b4(1);
      if (cVar3 == '\0') {
        if (DAT_1003ab00 == '\0') {
          if (DAT_1003ab01 != '\0') {
            FUN_10012228(1);
            if (sRam1003aa66 < 1) {
              cRam1003aa68 = '\0';
            }
            else {
              FUN_1000e9c8(1,0xffffffff);
            }
          }
        }
        else {
          FUN_10012228(1);
          sRam1003aad6 = 0;
          sRam1003aa66 = 0;
          cRam1003aad8 = '\0';
          cRam1003aa68 = '\0';
          cRam1003aab9 = '\0';
          cRam1003aa49 = '\0';
          DAT_100393d2 = '\x01';
        }
      }
      else if (sRam1003aa7c != 2) {
        FUN_10012228(1);
        if (sRam1003aa66 < 1) {
          cRam1003aa68 = '\0';
        }
        else {
          FUN_1000e9c8(1,0xffffffff);
        }
      }
    }
    if (*(char *)(local_6c + 0x5260) != '\0') {
      FUN_1002707c();
      bVar5 = true;
    }
    if ((cRam1003aaca == '\0') && (cRam1003aab8 == '\0')) {
      cVar3 = FUN_100299b4(2);
      if (cVar3 == '\0') {
        if (DAT_1003ab00 == '\0') {
          if (DAT_1003ab01 != '\0') {
            FUN_10012228(2);
            if (DAT_100370e4 == '\0') {
              if (sRam1003aa66 < 1) {
                cRam1003aad8 = '\0';
              }
              else {
                FUN_1000e9c8(1,0xffffffff);
              }
            }
            else if (sRam1003aad6 < 1) {
              cRam1003aad8 = '\0';
            }
            else {
              FUN_1000e9c8(2,0xffffffff);
            }
          }
        }
        else {
          FUN_10012228(2);
          sRam1003aad6 = 0;
          sRam1003aa66 = 0;
          cRam1003aad8 = '\0';
          cRam1003aa68 = '\0';
          cRam1003aab9 = '\0';
          cRam1003aa49 = '\0';
          DAT_100393d2 = '\x01';
        }
      }
      else if (sRam1003aaec != 2) {
        FUN_10012228(2);
        if (DAT_100370e4 == '\0') {
          if (sRam1003aa66 < 1) {
            cRam1003aad8 = '\0';
          }
          else {
            FUN_1000e9c8(1,0xffffffff);
          }
        }
        else if (sRam1003aad6 < 1) {
          cRam1003aad8 = '\0';
        }
        else {
          FUN_1000e9c8(2,0xffffffff);
        }
      }
    }
    FUN_10018b98();
    do {
      cVar3 = FUN_100193a8();
    } while (cVar3 == '\0');
    FUN_100193c8();
    if ((cRam1003aa5a == '\0') && (cRam1003aa49 != '\0')) {
      cRam1003aa5a = '\x01';
      unaff_r27 = (int)sRam1003aa20;
      unaff_r26 = (int)sRam1003aa24;
      sRam1003aa58 = sRam1003aa58 + 1;
      FUN_10028958();
      FUN_10004cb0(uRam1003ad38,(int)sRam1003aa2e,(int)sRam1003aa34,(int)sRam1003aa24);
      FUN_10014940(1);
      FUN_100289c0();
    }
    if ((cRam1003aaca == '\0') && (cRam1003aab9 != '\0')) {
      cRam1003aaca = '\x01';
      unaff_r27 = (int)sRam1003aa90;
      unaff_r26 = (int)sRam1003aa94;
      sRam1003aac8 = sRam1003aac8 + 1;
      FUN_10028958();
      FUN_10004cb0(uRam1003ad38,(int)sRam1003aa9e,(int)sRam1003aaa4,(int)sRam1003aa94);
      FUN_10014940(2);
      FUN_100289c0();
    }
    if ((cRam1003aa5a != '\0') && (cRam1003aaca != '\0')) {
      if (DAT_100370e4 == '\0') {
        if (cRam1003aa49 == '\0') {
          if (cRam1003aab9 == '\0') {
            if ((cRam1003aa68 == '\0') && (cRam1003aad8 == '\0')) {
              FUN_1001873c(0x14);
              FUN_1002401c(0);
            }
          }
          else {
            FUN_1001873c(0x14);
            FUN_1002b020(0x1f,100);
            FUN_10026bb8(unaff_r27 + 0xc,unaff_r26 + 0x10,1,3);
            if (sRam1003aa66 < 0) {
              sRam1003aa66 = 0;
            }
            if (DAT_1003ad0e == '\0') {
              FUN_100153d0(3);
            }
          }
        }
        else {
          FUN_1001873c(0x14);
          FUN_1002b020(0x1f,100);
          FUN_10026bb8(unaff_r27 + 0xc,unaff_r26 + 0x10,1,3);
          if (sRam1003aa66 < 0) {
            sRam1003aa66 = 0;
          }
          if (DAT_1003ad0e == '\0') {
            FUN_100153d0(3);
          }
        }
      }
      else {
        if ((cRam1003aa68 == '\0') && (cRam1003aad8 == '\0')) {
          if ((cRam1003aa4a == '\0') || (cRam1003aaba == '\0')) {
            if (cRam1003aa4a == '\0') {
              FUN_1001873c(0x14);
              FUN_1002401c(0);
            }
            else {
              FUN_1001873c(0x14);
              FUN_1002401c(0);
            }
          }
          else {
            FUN_1001873c(0x14);
            FUN_1002401c(0);
          }
        }
        else {
          if ((cRam1003aa4a != '\0') && (cRam1003aa68 == '\0')) {
            FUN_1001873c(0x14);
          }
          if ((cRam1003aaba != '\0') && (cRam1003aad8 == '\0')) {
            FUN_1001873c(0x14);
          }
        }
        if (cRam1003aa49 == '\0') {
          if (cRam1003aab9 != '\0') {
            FUN_1001873c(0x14);
            FUN_1002b020(0x1f,100);
            FUN_10026bb8(unaff_r27 + 0xc,unaff_r26 + 0x10,1,3);
            if (DAT_1003ad0e == '\0') {
              FUN_100153d0(3);
            }
          }
        }
        else {
          FUN_1001873c(0x14);
          FUN_1002b020(0x1f,100);
          FUN_10026bb8(unaff_r27 + 0xc,unaff_r26 + 0x10,1,3);
          if (DAT_1003ad0e == '\0') {
            FUN_100153d0(3);
          }
        }
      }
    }
    if ((cRam1003aa5a != '\0') && (cRam1003aaca != '\0')) {
      bVar5 = true;
    }
  }
  if (((*(char *)(local_6c + 0x5260) == '\0') && (DAT_1003ad0e != '\0')) && (DAT_100393d2 == '\0'))
  {
    if ((cRam1003aa49 == '\0') && (cRam1003aab9 == '\0')) {
      sRam1003aa58 = sRam1003aa58 + 1;
      sRam1003aac8 = sRam1003aac8 + 1;
      FUN_10016f80(1,1);
    }
    else {
      FUN_10016f80(0,1);
    }
  }
  if (sRam1003aac8 < sRam1003aa58) {
    sRam1003aac8 = sRam1003aa58;
  }
  if (sRam1003aa58 < sRam1003aac8) {
    sRam1003aa58 = sRam1003aac8;
  }
  .glue::ReleaseResource(*(undefined4 *)(local_6c + 0x61f0));
  FUN_1001873c(0x14);
  return;
}

