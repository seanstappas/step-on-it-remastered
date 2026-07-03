
undefined4 FUN_100191f8(int param_1,undefined4 param_2,short param_3,short param_4)

{
  undefined4 uVar1;
  short sVar2;
  uint uVar3;
  uint uVar4;
  undefined4 uStack0000001c;
  short sStack00000022;
  short sStack00000026;
  int local_3c;
  short local_18;
  short local_16;
  short local_14;
  short local_12;
  
  uStack0000001c = param_2;
  sStack00000022 = param_3;
  sStack00000026 = param_4;
  .glue::GetMovieBox(param_1,&local_18);
  .glue::OffsetRect(&local_18,-(int)local_16,-(int)local_18);
  uVar3 = (uint)local_12;
  uVar4 = (uint)local_14;
  .glue::OffsetRect(&local_18,
                    (int)sStack00000022 -
                    (((int)uVar3 >> 1) + (uint)((int)uVar3 < 0 && (uVar3 & 1) != 0)),
                    (int)sStack00000026 -
                    (((int)uVar4 >> 1) + (uint)((int)uVar4 < 0 && (uVar4 & 1) != 0)));
  .glue::SetMovieBox(param_1,&local_18);
  if (param_1 == 0) {
    uVar1 = 0xffffffff;
  }
  else {
    .glue::SetMovieGWorld(param_1,uStack0000001c,0);
    sVar2 = .glue::GetMoviesError();
    if (sVar2 != 0) {
      .glue::DebugStr(local_3c + 0xaca);
    }
    FUN_10018918(param_1);
    .glue::StartMovie(param_1);
    uVar1 = 0;
  }
  return uVar1;
}

