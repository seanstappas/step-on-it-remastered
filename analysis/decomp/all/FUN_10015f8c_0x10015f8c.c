
void FUN_10015f8c(int param_1)

{
  int iVar1;
  uint uVar2;
  uint uVar3;
  int iStack00000018;
  
  iStack00000018 = param_1;
  iVar1 = .glue::TickCount();
  uVar3 = iStack00000018 + iVar1;
  do {
    uVar2 = .glue::TickCount();
  } while (uVar2 < uVar3);
  return;
}

