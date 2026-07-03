
void FUN_10018394(void)

{
  short sVar1;
  undefined4 local_2c;
  
  if (DAT_1003904a != '\0') {
    sVar1 = .glue::EnterMovies();
    if (sVar1 != 0) {
      .glue::ExitToShell();
    }
    *(undefined1 *)(local_2c + 0x4ed8) = 0;
    *(undefined4 *)(local_2c + 0x4ee0) = 0;
    *(undefined4 *)(local_2c + 0x4ee4) = 0;
    *(undefined2 *)(local_2c + 0x4ede) = 0;
  }
  return;
}

