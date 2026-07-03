
void FUN_1001ec9c(int param_1)

{
  char cVar1;
  
  cVar1 = FUN_1001ed64(param_1);
  if (cVar1 == '\0') {
    cVar1 = FUN_1001ed88(param_1);
    if (cVar1 == '\0') {
      FUN_1001ed20(param_1);
    }
    else {
      .glue::HideWindow(param_1);
    }
  }
  else {
    .glue::CloseDeskAcc((int)*(short *)(param_1 + 0x6c));
  }
  return;
}

