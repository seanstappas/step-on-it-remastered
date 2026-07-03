
void .glue::NewHandleClear(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x100317a4. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::NewHandleClear)();
  return;
}

