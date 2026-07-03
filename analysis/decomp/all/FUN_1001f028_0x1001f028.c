
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001f028(undefined4 param_1)

{
  char cVar1;
  short sVar2;
  
  sVar2 = (short)param_1;
  switch(sVar2) {
  case 1:
  case 2:
  case 3:
  case 4:
    if ((DAT_100393d0 == '\0') || (cVar1 = FUN_1001db00(), cVar1 != '\0')) {
      if ((sVar2 == 3) || (sVar2 == 4)) {
        FUN_1001ded4();
      }
      FUN_100263d8(param_1);
      DAT_100393d0 = '\0';
      FUN_10024b1c();
      FUN_100238b4(5);
      FUN_10023770(5);
    }
    else {
      FUN_10023a64(param_1);
    }
    break;
  case 5:
    if (_DAT_1003ad0c == -1) {
      .glue::Alert(0x19d,0);
      FUN_100239dc(5);
      FUN_100238b4(5);
      FUN_10023770(5);
    }
    else {
      sVar2 = _DAT_1003b29c;
      if ((DAT_1003ab6e != '\0') && (DAT_100370e4 != '\0')) {
        sVar2 = _DAT_1003b29a;
      }
      if (sVar2 < 1) {
        .glue::Alert(0x19e,0);
        FUN_100239dc(5);
        FUN_100238b4(5);
        FUN_10023770(5);
      }
      else {
        FUN_100239dc(param_1);
        FUN_1001f3c0();
        FUN_10024c58();
      }
    }
    break;
  case 6:
    FUN_100239dc(param_1);
    FUN_10024a54();
    break;
  case 7:
    FUN_100239dc(param_1);
    FUN_10024ab8();
    break;
  case 8:
    DAT_100393d3 = 1;
    break;
  case 9:
    FUN_100239dc(param_1);
    FUN_100251d8();
    FUN_10024bb0();
    break;
  case 10:
    FUN_10024e70(1);
    FUN_10023a64(param_1);
    cVar1 = FUN_10024f40();
    if (cVar1 != '\0') {
      .glue::Alert(0x19a,0);
    }
    break;
  case 0xb:
    FUN_10024e70(2);
    FUN_10023a64(param_1);
    cVar1 = FUN_10024f40();
    if (cVar1 != '\0') {
      .glue::Alert(0x19a,0);
    }
    break;
  case 0xc:
    FUN_100254a0();
    FUN_10023a64(param_1);
    break;
  case 0xd:
    FUN_100239dc(param_1);
    FUN_10024bb0();
    break;
  case 0x14:
    FUN_100239dc(param_1);
    FUN_10024bb0();
    break;
  case 0x15:
    FUN_100239dc(param_1);
    FUN_1001f43c();
    FUN_10024bb0();
    break;
  case 0x16:
    FUN_100239dc(param_1);
    FUN_10024a54();
    break;
  case 0x17:
    FUN_100239dc(param_1);
    FUN_10024bb0();
    break;
  case 0x18:
    FUN_100239dc(param_1);
    if (_DAT_1003a2ae == 6) {
      FUN_100249f8();
    }
    else {
      FUN_10024994();
    }
    break;
  case 0x19:
    FUN_100239dc(param_1);
    FUN_10024a54();
    break;
  case 0x1e:
    FUN_100239dc(param_1);
    FUN_1001f43c();
    FUN_10024bb0();
  }
  return;
}

