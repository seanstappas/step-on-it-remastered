
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10030db0(void)

{
  undefined4 *puVar1;
  
  while (_DAT_1003baa0 != (int *)0x0) {
    puVar1 = _DAT_1003baa0 + 2;
    _DAT_1003baa0 = (int *)*_DAT_1003baa0;
    FUN_100326a8(*puVar1,0xffffffff);
  }
  return;
}

