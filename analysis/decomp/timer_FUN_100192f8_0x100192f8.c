/* FUN_100192f8 @ 0x100192f8 */

/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_100192f8(short param_1)

{
  short sStack0000001a;
  int local_12c;
  undefined1 auStack_108 [256];
  undefined2 local_8;
  
  sStack0000001a = param_1;
  FUN_10021c14();
  .glue::LMSetMBarHeight((int)_DAT_1003b69c);
  FUN_1001600c();
  FUN_100194dc();
  FUN_10019848();
  .glue::SetCursor(local_12c + 0x7992);
  .glue::ShowCursor();
  .glue::GetIndString(auStack_108,0x80,(int)sStack0000001a);
  .glue::ParamText(auStack_108,0,0,0);
  local_8 = .glue::Alert(0x81,0);
  .glue::ExitToShell();
  return;
}

