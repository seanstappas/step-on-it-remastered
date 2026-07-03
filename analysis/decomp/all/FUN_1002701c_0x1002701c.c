
undefined4 FUN_1002701c(byte *param_1,byte *param_2)

{
  byte bVar1;
  byte bVar2;
  byte bVar3;
  byte bVar4;
  
  bVar1 = *param_1;
  bVar4 = 0;
  while( true ) {
    if (bVar1 < bVar4) {
      return 1;
    }
    bVar2 = *param_2;
    bVar3 = *param_1;
    param_2 = param_2 + 1;
    param_1 = param_1 + 1;
    if (bVar2 != bVar3) break;
    bVar4 = bVar4 + 1;
  }
  return 0;
}

