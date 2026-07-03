
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10019078(void)

{
  char cVar1;
  
  if (_DAT_10039050 != 0) {
    while (cVar1 = .glue::IsMovieDone(_DAT_10039050), cVar1 == '\0') {
      .glue::MoviesTask(_DAT_10039050,0);
    }
  }
  return;
}

