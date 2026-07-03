
undefined4 FUN_10018918(undefined4 param_1)

{
  undefined4 uVar1;
  undefined4 uVar2;
  
  uVar1 = .glue::GetMovieTime(param_1,0);
  .glue::GetMovieDuration(param_1);
  uVar2 = .glue::GetMoviePreferredRate(param_1);
  uVar1 = .glue::PrerollMovie(param_1,uVar1,uVar2);
  return uVar1;
}

