
void .glue::BringToFront(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x1003229c. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::BringToFront)();
  return;
}

