/* FUN_1001882c @ 0x1001882c  depth=2 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001882c(char param_1)

{
  undefined4 uVar1;
  char cStack0000001b;
  undefined4 local_2c;
  
  if (((DAT_10039049 != '\0') && (DAT_10039155 != '\0')) && (_DAT_1003904e != 0)) {
    cStack0000001b = param_1;
    if (param_1 != '\0') {
      uVar1 = .glue::GetMovieTimeBase(_DAT_10039054);
      .glue::SetTimeBaseFlags(uVar1,1);
      .glue::SetMoviePlayHints(_DAT_10039054,2,2);
    }
    .glue::GoToBeginningOfMovie(_DAT_10039054);
    .glue::SetMovieVolume(_DAT_10039054,(int)*(short *)(local_2c + 0x4edc));
    FUN_10018918(_DAT_10039054);
    .glue::SetMovieRate(_DAT_10039054,0x10000);
    *(undefined1 *)(local_2c + 0x4ed8) = 1;
  }
  return;
}

