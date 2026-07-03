
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10019428(void)

{
  undefined4 uVar1;
  int local_2c;
  
  if (DAT_10039058 == '\0') {
    uVar1 = .glue::NewRoutineDescriptor(PTR__toc_10033e30,0xb802,1);
    *(undefined4 *)(local_2c + -0x24) = uVar1;
    _DAT_1003b270 = 0;
    uRam1003b274 = 0;
    uRam1003b276 = *(undefined4 *)(local_2c + -0x24);
    uRam1003b27a = 0;
    uRam1003b27e = 0;
    uRam1003b282 = 0;
    uRam1003b28a = 0;
    .glue::InsXTime(&DAT_1003b270);
    .glue::PrimeTime(&DAT_1003b270,uRam1003b286);
    *(undefined1 *)(local_2c + 0x4ee8) = 1;
  }
  return;
}

