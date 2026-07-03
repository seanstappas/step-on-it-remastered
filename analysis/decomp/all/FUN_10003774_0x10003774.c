
uint FUN_10003774(int param_1)

{
  bool bVar1;
  uint uVar2;
  uint uVar3;
  
  uVar3 = (param_1 << 5) >> 1;
  bVar1 = false;
  do {
    while( true ) {
      if (bVar1) {
        return uVar3;
      }
      uVar2 = (uint)(param_1 << 10) / uVar3;
      if (uVar2 < uVar3) break;
      bVar1 = true;
    }
    uVar3 = uVar3 + uVar2 >> 1;
  } while (0xf < uVar3);
  return 0x20;
}

