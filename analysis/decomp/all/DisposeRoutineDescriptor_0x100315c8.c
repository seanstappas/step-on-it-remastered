
void .glue::DisposeRoutineDescriptor(void)

{
  undefined **ppuStack00000014;
  
  ppuStack00000014 = &_toc;
                    /* WARNING: Could not recover jumptable at 0x100315dc. Too many branches */
                    /* WARNING: Treating indirect jump as call */
  (**(code **).TVect::DisposeRoutineDescriptor)();
  return;
}

