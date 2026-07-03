
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10028958(void)

{
  undefined **ppuVar1;
  undefined **local_2c;
  
  ppuVar1 = &_toc;
  if (_DAT_1003b698 == 0) {
    .glue::ShieldCursor(&DAT_1003b6b4,_DAT_1003b6b0);
    *(undefined1 *)((int)local_2c + 0x752a) = 1;
    *(undefined1 *)((int)local_2c + 0x752a) = 1;
    ppuVar1 = local_2c;
  }
  *(short *)(ppuVar1 + 0x1d4a) = *(short *)(ppuVar1 + 0x1d4a) + 1;
  return;
}

