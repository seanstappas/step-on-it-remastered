
void FUN_1001b2c0(int param_1)

{
  char cVar2;
  undefined4 *puVar1;
  undefined1 auStack_28 [8];
  undefined1 auStack_20 [4];
  undefined1 auStack_1c [2];
  undefined4 local_1a [3];
  
  .glue::GetDialogItem(param_1,*(short *)(param_1 + 0xa4) + 1,auStack_1c,auStack_20,auStack_28);
  .glue::GetMouse(local_1a);
  cVar2 = .glue::PtInRect(local_1a[0],auStack_28);
  if (cVar2 == '\0') {
    .glue::InitCursor();
  }
  else {
    puVar1 = (undefined4 *).glue::GetCursor(1);
    .glue::SetCursor(*puVar1);
  }
  return;
}

