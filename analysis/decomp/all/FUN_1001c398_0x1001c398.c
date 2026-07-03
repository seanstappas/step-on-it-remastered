
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001c398(uint param_1,int param_2)

{
  uint uVar1;
  undefined4 uVar2;
  char cVar3;
  short sVar4;
  uint uStack00000018;
  int iStack0000001c;
  undefined1 auStack_158 [256];
  undefined2 local_58;
  
  local_58 = (undefined2)(param_1 >> 0x10);
  uVar1 = param_1 & 0xffff;
  sVar4 = (short)param_1;
  uStack00000018 = param_1;
  iStack0000001c = param_2;
  switch(local_58) {
  case 100:
    if (sVar4 == 3) {
      uRam1003b286 = 0xe;
      .glue::CheckItem(_DAT_100393cc,(int)_DAT_100393c8,0);
      .glue::CheckItem(_DAT_100393cc,uVar1,1);
      _DAT_100393c8 = sVar4;
    }
    else if (sVar4 < 3) {
      if (sVar4 == 1) {
        uRam1003b286 = 9;
        .glue::CheckItem(_DAT_100393cc,(int)_DAT_100393c8,0);
        .glue::CheckItem(_DAT_100393cc,uVar1,1);
        _DAT_100393c8 = sVar4;
      }
      else if (0 < sVar4) {
        uRam1003b286 = 0xb;
        .glue::CheckItem(_DAT_100393cc,(int)_DAT_100393c8,0);
        .glue::CheckItem(_DAT_100393cc,uVar1,1);
        _DAT_100393c8 = sVar4;
      }
    }
    else if (sVar4 < 5) {
      uRam1003b286 = 0x12;
      .glue::CheckItem(_DAT_100393cc,(int)_DAT_100393c8,0);
      .glue::CheckItem(_DAT_100393cc,uVar1,1);
      _DAT_100393c8 = sVar4;
    }
    DAT_100393b0 = 1;
    break;
  case 0x65:
    if (sVar4 == 2) {
      FUN_100190d8(0x200);
      .glue::CheckItem(_DAT_100393bc,(int)_DAT_100393b8,0);
      .glue::CheckItem(_DAT_100393bc,uVar1,1);
      _DAT_100393b8 = sVar4;
    }
    else if (sVar4 < 2) {
      if (0 < sVar4) {
        FUN_100190d8(0x600);
        .glue::CheckItem(_DAT_100393bc,(int)_DAT_100393b8,0);
        .glue::CheckItem(_DAT_100393bc,uVar1,1);
        _DAT_100393b8 = sVar4;
      }
    }
    else if (sVar4 < 4) {
      FUN_100190d8(0x80);
      .glue::CheckItem(_DAT_100393bc,(int)_DAT_100393b8,0);
      .glue::CheckItem(_DAT_100393bc,uVar1,1);
      _DAT_100393b8 = sVar4;
    }
    DAT_100393b0 = 1;
    break;
  case 0x66:
    switch(sVar4) {
    case 1:
      FUN_10024d00(7);
      .glue::CheckItem(_DAT_100393b4,(int)_DAT_100393b2,0);
      .glue::CheckItem(_DAT_100393b4,uVar1,1);
      _DAT_100393b2 = sVar4;
      break;
    case 2:
      FUN_10024d00(6);
      .glue::CheckItem(_DAT_100393b4,(int)_DAT_100393b2,0);
      .glue::CheckItem(_DAT_100393b4,uVar1,1);
      _DAT_100393b2 = sVar4;
      break;
    case 3:
      FUN_10024d00(5);
      .glue::CheckItem(_DAT_100393b4,(int)_DAT_100393b2,0);
      .glue::CheckItem(_DAT_100393b4,uVar1,1);
      _DAT_100393b2 = sVar4;
      break;
    case 4:
      FUN_10024d00(4);
      .glue::CheckItem(_DAT_100393b4,(int)_DAT_100393b2,0);
      .glue::CheckItem(_DAT_100393b4,uVar1,1);
      _DAT_100393b2 = sVar4;
      break;
    case 5:
      FUN_10024d00(3);
      .glue::CheckItem(_DAT_100393b4,(int)_DAT_100393b2,0);
      .glue::CheckItem(_DAT_100393b4,uVar1,1);
      _DAT_100393b2 = sVar4;
      break;
    case 6:
      FUN_10024d00(2);
      .glue::CheckItem(_DAT_100393b4,(int)_DAT_100393b2,0);
      .glue::CheckItem(_DAT_100393b4,uVar1,1);
      _DAT_100393b2 = sVar4;
      break;
    case 7:
      FUN_10024d00(1);
      .glue::CheckItem(_DAT_100393b4,(int)_DAT_100393b2,0);
      .glue::CheckItem(_DAT_100393b4,uVar1,1);
      _DAT_100393b2 = sVar4;
      break;
    case 8:
      FUN_10024d00(0);
      .glue::CheckItem(_DAT_100393b4,(int)_DAT_100393b2,0);
      .glue::CheckItem(_DAT_100393b4,uVar1,1);
      _DAT_100393b2 = sVar4;
    }
    DAT_100393b0 = 1;
    break;
  case 0x68:
    if (sVar4 == 2) {
      .glue::CheckItem(_DAT_100393c4,(int)_DAT_100393c0,0);
      .glue::CheckItem(_DAT_100393c4,uVar1,1);
      DAT_10039154 = 1;
      _DAT_100393c0 = sVar4;
      if (DAT_10039155 == '\0') {
        DAT_10039155 = 1;
        FUN_10018414(5);
        FUN_1001882c(1);
      }
      DAT_10039155 = '\x01';
    }
    else if (sVar4 < 2) {
      if (0 < sVar4) {
        .glue::CheckItem(_DAT_100393c4,(int)_DAT_100393c0,0);
        .glue::CheckItem(_DAT_100393c4,uVar1,1);
        DAT_10039154 = 0;
        _DAT_100393c0 = sVar4;
        if (DAT_10039155 == '\0') {
          DAT_10039155 = 1;
          FUN_10018414(5);
          FUN_1001882c(1);
        }
        DAT_10039155 = '\x01';
      }
    }
    else if (sVar4 < 4) {
      .glue::CheckItem(_DAT_100393c4,(int)_DAT_100393c0,0);
      .glue::CheckItem(_DAT_100393c4,uVar1,1);
      _DAT_100393c0 = sVar4;
      if (DAT_10039155 != '\0') {
        FUN_100189ac();
      }
      DAT_10039155 = '\0';
      DAT_10039154 = 0;
    }
    DAT_100393b0 = 1;
    break;
  case 0x80:
    if (sVar4 == 2) {
      FUN_10024a54();
    }
    else if ((sVar4 < 2) && (0 < sVar4)) {
      FUN_10024ab8();
    }
    else {
      uVar2 = .glue::GetMenuHandle(0x80);
      .glue::GetMenuItemText(uVar2,uVar1,auStack_158);
      .glue::OpenDeskAcc(auStack_158);
    }
    break;
  case 0x81:
    switch(sVar4) {
    case 1:
      if (DAT_100393d0 == '\0') {
        FUN_1001f400();
        FUN_10024c58();
      }
      else {
        cVar3 = FUN_1001dde8();
        if (cVar3 != '\0') {
          FUN_1001f400();
          FUN_10024c58();
        }
      }
      break;
    case 2:
      FUN_1001fba4();
      FUN_10024c58();
      break;
    case 3:
      if (DAT_100393d0 == '\0') {
        FUN_10021378();
      }
      else {
        cVar3 = FUN_1001dbf8();
        if (cVar3 != '\0') {
          FUN_10021378();
        }
      }
      break;
    case 4:
      FUN_10020eb0();
      break;
    case 5:
      FUN_1002117c();
      break;
    case 7:
      if (DAT_100393d0 == '\0') {
        FUN_1002168c();
      }
      else {
        cVar3 = FUN_1001dcf0();
        if ((cVar3 != '\0') && (cVar3 = FUN_1002168c(), cVar3 != '\0')) {
          DAT_100393d0 = '\0';
          FUN_10024b1c();
          FUN_100238b4(5);
          FUN_10023770(5);
        }
      }
      break;
    case 8:
      if ((*(ushort *)(param_2 + 0xe) & 0x800) == 0) {
        if ((DAT_1003ab6e == '\0') || (DAT_100370e4 == '\0')) {
          if (DAT_1003944c == '\0') {
            FUN_1001cd20();
          }
          else {
            FUN_1001d538();
          }
        }
        else {
          FUN_1001cd20();
        }
      }
      else {
        FUN_1001cd20();
      }
      break;
    case 10:
      DAT_100393d3 = 1;
    }
    break;
  case 0x82:
    if (sVar4 != 2) {
      if (sVar4 < 2) {
        if (sVar4 < 1) break;
      }
      else if (6 < sVar4) break;
      .glue::SystemEdit(uVar1 - 1);
    }
    break;
  case 0x83:
    if (sVar4 == 2) {
      DAT_1003759e = DAT_1003759e == '\0';
      uVar2 = .glue::GetMenuHandle(0x83);
      .glue::CheckItem(uVar2,uVar1,DAT_1003759e);
      DAT_100393b0 = 1;
    }
    else if (sVar4 < 2) {
      if (0 < sVar4) {
        DAT_100393ad = DAT_100393ad == '\0';
        uVar2 = .glue::GetMenuHandle(0x83);
        .glue::CheckItem(uVar2,uVar1,DAT_100393ad);
        DAT_100393b0 = 1;
      }
    }
    else if (sVar4 < 4) {
      FUN_10021938(0);
      FUN_1001d2c8();
    }
    break;
  case 0x84:
    if (sVar4 == 2) {
      cVar3 = FUN_1001d8e4();
      if (cVar3 != '\0') {
        FUN_10022cc0();
        FUN_10024c58();
      }
    }
    else if ((sVar4 < 2) && (0 < sVar4)) {
      FUN_10024c58();
    }
    break;
  case 0x85:
  }
  .glue::HiliteMenu(0);
  return;
}

