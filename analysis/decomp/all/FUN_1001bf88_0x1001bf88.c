
void FUN_1001bf88(int param_1)

{
  char cVar1;
  int iVar2;
  
  iVar2 = *(int *)(param_1 + 2);
  cVar1 = FUN_1001ed20(iVar2);
  if (cVar1 != '\0') {
    .glue::BeginUpdate(iVar2);
    cVar1 = .glue::EmptyRgn(*(undefined4 *)(iVar2 + 0x18));
    if (cVar1 == '\0') {
      .glue::SetPort(iVar2);
      FUN_1001ef70(param_1);
    }
    .glue::EndUpdate(iVar2);
  }
  return;
}

