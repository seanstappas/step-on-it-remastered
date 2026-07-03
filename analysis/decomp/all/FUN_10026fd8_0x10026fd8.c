
void FUN_10026fd8(byte *param_1,byte *param_2)

{
  byte bVar1;
  byte bVar2;
  
  bVar1 = *param_1;
  for (bVar2 = 0; bVar2 <= bVar1; bVar2 = bVar2 + 1) {
    *param_2 = *param_1;
    param_1 = param_1 + 1;
    param_2 = param_2 + 1;
  }
  return;
}

