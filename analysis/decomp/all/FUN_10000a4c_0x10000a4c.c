
void FUN_10000a4c(void)

{
  int *piVar1;
  int *piVar2;
  int local_3c;
  undefined2 local_18;
  undefined2 local_16;
  undefined2 local_14;
  undefined4 local_12 [2];
  
  local_16 = 0;
  local_14 = 0;
  local_18 = 0;
  .glue::RGBForeColor(&local_18);
  piVar2 = *(int **)(**(int **)(local_3c + 0x756c) + 0x16);
  piVar1 = *(int **)(**(int **)(local_3c + 0x7564) + 0x16);
  .glue::DisposeHandle(*(undefined4 *)(*piVar2 + 0x2a));
  local_12[0] = *(undefined4 *)(*piVar1 + 0x2a);
  .glue::HandToHand(local_12);
  *(undefined4 *)(*piVar2 + 0x2a) = local_12[0];
  return;
}

