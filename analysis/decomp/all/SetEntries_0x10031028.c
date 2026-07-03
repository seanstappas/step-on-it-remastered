
void .glue::SetEntries(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x1003103c. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::SetEntries)();
  return;
}

