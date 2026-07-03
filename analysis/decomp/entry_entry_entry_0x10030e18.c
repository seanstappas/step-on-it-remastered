/* entry @ 0x10030e18  depth=0 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void entry(void)

{
  undefined4 uVar1;
  undefined4 local_8 [2];
  
  local_8[0] = 0;
  FUN_10030e04();
  uVar1 = FUN_10030e10();
  _DAT_1003416c =
       FUN_10030d5c(_DAT_10034148,_DAT_10034144,&.TVect::SndSoundManagerVersion,&DAT_1003bb72,
                    PTR_DAT_10034138,_DAT_10034134,uVar1);
  FUN_10000000();
  FUN_1001a4b8(0,local_8);
  FUN_10030d30(0);
  return;
}

