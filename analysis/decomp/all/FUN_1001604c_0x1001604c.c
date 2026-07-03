
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

undefined4 FUN_1001604c(short param_1,undefined4 param_2,undefined4 param_3)

{
  undefined4 uVar1;
  undefined4 uVar2;
  short sVar3;
  short sVar4;
  
  if ((param_1 < 0x9d) || (0xd3 < param_1)) {
    uVar1 = 0;
  }
  else {
    sVar3 = (short)param_2;
    *(short *)(&DAT_10038ec8 + _DAT_10038ec6 * 0xe) = sVar3;
    sVar4 = (short)param_3;
    *(short *)(_DAT_10038ec6 * 0xe + 0x10038eca) = sVar4;
    *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ece) = 0;
    switch(param_1) {
    case 0x9d:
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ecc) = 2;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed0) = 0;
      *(short *)(_DAT_10038ec6 * 0xe + 0x10038ed2) = param_1;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed4) = 0xa3;
      break;
    case 0xa3:
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ecc) = 1;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed0) = 0;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed2) = 0x9d;
      *(short *)(_DAT_10038ec6 * 0xe + 0x10038ed4) = param_1;
      break;
    case 0xa9:
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ecc) = 2;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed0) = 1;
      *(short *)(_DAT_10038ec6 * 0xe + 0x10038ed2) = param_1;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed4) = 0xaf;
      break;
    case 0xaf:
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ecc) = 1;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed0) = 1;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed2) = 0xa9;
      *(short *)(_DAT_10038ec6 * 0xe + 0x10038ed4) = param_1;
      break;
    case 0xb5:
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ecc) = 2;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed0) = 2;
      *(short *)(_DAT_10038ec6 * 0xe + 0x10038ed2) = param_1;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed4) = 0xbb;
      break;
    case 0xbb:
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ecc) = 1;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed0) = 2;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed2) = 0xb5;
      *(short *)(_DAT_10038ec6 * 0xe + 0x10038ed4) = param_1;
      break;
    case 0xc1:
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ecc) = 2;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed0) = 3;
      *(short *)(_DAT_10038ec6 * 0xe + 0x10038ed2) = param_1;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed4) = 199;
      break;
    case 199:
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ecc) = 1;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed0) = 3;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed2) = 0xc1;
      *(short *)(_DAT_10038ec6 * 0xe + 0x10038ed4) = param_1;
      break;
    case 0xcd:
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ecc) = 2;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed0) = 4;
      *(short *)(_DAT_10038ec6 * 0xe + 0x10038ed2) = param_1;
      *(short *)(_DAT_10038ec6 * 0xe + 0x10038ed4) = param_1;
      break;
    case 0xd3:
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ecc) = 1;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed0) = 4;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed2) = 0xcd;
      *(undefined2 *)(_DAT_10038ec6 * 0xe + 0x10038ed4) = 0xd3;
    }
    if (*(short *)(_DAT_10038ec6 * 0xe + 0x10038ecc) == 2) {
      uVar1 = FUN_1002e6bc(param_3);
      uVar2 = FUN_1002e6ac(param_2);
      FUN_10004108(_DAT_1003ad18,*(short *)(_DAT_10038ec6 * 0xe + 0x10038ed0) * 8 + 1,uVar2,uVar1);
    }
    else {
      uVar1 = FUN_1002e6bc(param_3);
      uVar2 = FUN_1002e6ac(param_2);
      FUN_10004108(_DAT_1003ad18,*(short *)(_DAT_10038ec6 * 0xe + 0x10038ed0) * 8 + 8,uVar2,uVar1);
    }
    if (*(short *)(_DAT_10038ec6 * 0xe + 0x10038ecc) == 1) {
      *(int *)(&DAT_1003ad68 + sVar3 * 0x3c + sVar4 * 4) = param_1 + 0x100;
    }
    else {
      *(int *)(&DAT_1003ad68 + sVar3 * 0x3c + sVar4 * 4) = param_1 + 0x300;
    }
    uVar1 = 1;
    _DAT_10038ec6 = _DAT_10038ec6 + 1;
  }
  return uVar1;
}

