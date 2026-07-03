
void .glue::FlushEvents(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x1003217c. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::FlushEvents)();
  return;
}

