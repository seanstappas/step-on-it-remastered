
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10021854(void)

{
  char cVar1;
  bool bVar2;
  short local_28 [12];
  
  bVar2 = false;
  .glue::FlushEvents(0xffff,0);
  while (!bVar2) {
    cVar1 = .glue::WaitNextEvent(0xffff,local_28,0x3c,0);
    if ((cVar1 != '\0') && ((local_28[0] == 1 || (local_28[0] == 3)))) {
      bVar2 = true;
    }
    if (_DAT_10039050 != 0) {
      .glue::MoviesTask(_DAT_10039050,5000);
    }
  }
  .glue::FlushEvents(0xffff,0);
  return;
}

