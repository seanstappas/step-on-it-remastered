
void .glue::SystemClick(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x1003247c. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::SystemClick)();
  return;
}

