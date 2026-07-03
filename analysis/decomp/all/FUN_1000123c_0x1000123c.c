
void FUN_1000123c(int param_1,int *param_2)

{
  int *piVar1;
  undefined4 uVar2;
  int local_18 [2];
  
  .glue::GetPort(local_18);
  if (local_18[0] == param_1) {
    .glue::GetCWMgrPort(local_18);
    .glue::SetPort(local_18[0]);
  }
  piVar1 = (int *).glue::GetGDevice();
  if (piVar1 == param_2) {
    uVar2 = .glue::GetMainDevice();
    .glue::SetGDevice(uVar2);
  }
  *(undefined4 *)(*param_2 + 0x16) = 0;
  .glue::DisposeGDevice(param_2);
  .glue::DisposePtr(*(undefined4 *)**(undefined4 **)(param_1 + 2));
  if (*(int *)(**(int **)(param_1 + 2) + 0x2a) != 0) {
    .glue::DisposeCTable(*(undefined4 *)(**(int **)(param_1 + 2) + 0x2a));
  }
  .glue::CloseCPort(param_1);
  .glue::DisposePtr(param_1);
  return;
}

