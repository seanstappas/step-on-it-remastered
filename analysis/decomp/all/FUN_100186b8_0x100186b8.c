
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100186b8(short param_1)

{
  short sStack0000001a;
  
  if (((DAT_1003904a != '\0') && (DAT_10039048 != '\0')) && (_DAT_1003904e != 0)) {
    sStack0000001a = param_1;
    .glue::SetMovieVolume(_DAT_10039054,((int)param_1 * (int)_DAT_1003904c) / 0x100);
  }
  return;
}

