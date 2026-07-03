/* Random @ 0x100321b0  calls: Random */

void .glue::Random(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x100321c4. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::Random)();
  return;
}

