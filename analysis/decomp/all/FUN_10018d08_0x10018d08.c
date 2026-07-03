
/* WARNING: Removing unreachable block (ram,0x10018e28) */

undefined4 FUN_10018d08(undefined4 param_1)

{
  undefined4 uVar1;
  short sVar2;
  short sVar3;
  undefined4 uStack00000018;
  int local_17c;
  undefined1 auStack_158 [70];
  undefined2 local_112;
  undefined2 local_110;
  short local_10e;
  undefined1 auStack_10c [264];
  
  local_112 = 0;
  if (DAT_10039049 == '\0') {
    uVar1 = 0;
  }
  else {
    uStack00000018 = param_1;
    FUN_1001913c(&DAT_10034b24,param_1,auStack_10c);
    sVar2 = FUN_100182d0(auStack_10c,auStack_158);
    if (sVar2 == 0) {
      sVar2 = .glue::OpenMovieFile(auStack_158,&local_10e,1);
      sVar3 = .glue::GetMoviesError();
      if (sVar3 == 0) {
        if (sVar2 == 0) {
          local_110 = 0;
          sVar2 = .glue::NewMovieFromFile(local_17c + 0x4ee4,(int)local_10e,&local_110,0,1,0);
          if (sVar2 == 0) {
            sVar2 = .glue::GetMoviesError();
            if (sVar2 == 0) {
              sVar2 = .glue::CloseMovieFile((int)local_10e);
              sVar3 = .glue::GetMoviesError();
              if (sVar3 == 0) {
                if (sVar2 == 0) {
                  uVar1 = 1;
                }
                else {
                  uVar1 = 0;
                }
              }
              else {
                uVar1 = 0;
              }
            }
            else {
              uVar1 = 0;
            }
          }
          else {
            uVar1 = 0;
          }
        }
        else {
          uVar1 = 0;
        }
      }
      else {
        uVar1 = 0;
      }
    }
    else {
      uVar1 = 0;
    }
  }
  return uVar1;
}

