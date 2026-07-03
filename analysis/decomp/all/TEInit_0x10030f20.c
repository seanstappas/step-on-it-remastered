
void .glue::TEInit(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x10030f34. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::TEInit)();
  return;
}

