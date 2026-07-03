
undefined4 FUN_10009030(ushort param_1)

{
  undefined4 uVar1;
  
  if (param_1 == 0) {
    uVar1 = 1;
  }
  else if (param_1 == 0x197) {
    uVar1 = 1;
  }
  else if ((param_1 & 0x200) == 0) {
    if (((param_1 & 0xff) < 0xd4) && (0x9c < (param_1 & 0xff))) {
      uVar1 = 1;
    }
    else {
      uVar1 = 0;
    }
  }
  else {
    uVar1 = 0;
  }
  return uVar1;
}

