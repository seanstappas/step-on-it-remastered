/* FUN_1001a4b8 @ 0x1001a4b8  depth=1 */

void FUN_1001a4b8(void)

{
  undefined4 *puVar1;
  int local_3c;
  undefined1 auStack_16 [14];
  
  .glue::MaxApplZone();
  *(undefined1 *)(local_3c + 0x5324) = 0;
  FUN_1001a618();
  .glue::Gestalt(0x6b626420,auStack_16);
  puVar1 = (undefined4 *).glue::GetCursor(4);
  .glue::SetCursor(*puVar1);
  .glue::FreeMem();
  FUN_1001fcb0();
  FUN_1001ff7c();
  FUN_1001b3b0();
  FUN_10028670();
  .glue::FreeMem();
  FUN_10026918();
  .glue::FreeMem();
  FUN_10018394();
  FUN_10026090();
  *(undefined2 *)(local_3c + 0x613e) = 1;
  FUN_10026340();
  FUN_10028824();
  FUN_10024bb0();
  if (*(char *)(local_3c + 0x4fe5) != '\0') {
    FUN_10018414(5);
    FUN_1001882c(1);
  }
  .glue::InitCursor();
  FUN_10026580();
  FUN_1001b780();
  FUN_10026b04();
  FUN_100204c8();
  FUN_1001fbc4();
  return;
}

