
int FUN_10028788(short param_1,int param_2)

{
  int iVar1;
  int iVar2;
  short sStack0000001a;
  
  sStack0000001a = param_1;
  .glue::UseResFile((int)param_1);
  iVar2 = 0;
  iVar1 = .glue::Get1Resource(0x424f5244,param_2);
  while (iVar1 != 0) {
    .glue::ReleaseResource(iVar1);
    iVar2 = iVar2 + 1;
    iVar1 = .glue::Get1Resource(0x424f5244,param_2 + iVar2);
  }
  return iVar2;
}

