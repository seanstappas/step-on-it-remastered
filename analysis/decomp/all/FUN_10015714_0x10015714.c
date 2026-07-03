
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10015714(short param_1,int param_2)

{
  int iVar1;
  
  if (param_1 == 3) {
    param_1 = 1;
  }
  FUN_10015f8c(0x1e);
  FUN_10015d94((int)*(short *)(param_1 * 0x70 + 0x1003a9f0),param_2 + 0x6d,0x134);
  FUN_1002b020(0x2e,100);
  FUN_10015f8c(0x1e);
  if (*(short *)(param_1 * 0x70 + 0x1003a9f4) == 1) {
    *(int *)(param_1 * 0x70 + 0x1003a9ec) =
         *(int *)(param_1 * 0x70 + 0x1003a9ec) + (int)*(short *)(param_1 * 0x70 + 0x1003a9f0);
    FUN_10015d94(*(undefined4 *)(param_1 * 0x70 + 0x1003a9ec),param_2 + 0x6d,0x17c);
    FUN_1002b020(0x2f,100);
    FUN_10015f8c(0x14);
  }
  else {
    FUN_10004bb4(_DAT_1003ad2c,*(short *)(param_1 * 0x70 + 0x1003a9f4) + 10,param_2 + -0x10,299);
    FUN_1002b020(0x2f,100);
    FUN_10015f8c(0x1e);
    for (iVar1 = 0; (short)iVar1 < *(short *)(param_1 * 0x70 + 0x1003a9f4); iVar1 = iVar1 + 1) {
      *(int *)(param_1 * 0x70 + 0x1003a9ec) =
           *(int *)(param_1 * 0x70 + 0x1003a9ec) + (int)*(short *)(param_1 * 0x70 + 0x1003a9f0);
      FUN_10015d94(*(undefined4 *)(param_1 * 0x70 + 0x1003a9ec),param_2 + 0x6d,0x17c);
      FUN_1002b020(iVar1 + 0x30,100);
      FUN_10015f8c(0x14);
    }
  }
  FUN_10015f8c(0x14);
  if (*(short *)(param_1 * 0x70 + 0x1003a9f2) < 1) {
    FUN_10015d94(0,param_2 + 0x6d,0x158);
    FUN_1002b020(8,100);
    FUN_10015f8c(0x1e);
  }
  else {
    FUN_10015d94((int)*(short *)(param_1 * 0x70 + 0x1003a9f2),param_2 + 0x6d,0x158);
    FUN_1002b020(0x2e,100);
    FUN_10015f8c(0x1e);
    *(int *)(param_1 * 0x70 + 0x1003a9ec) =
         *(int *)(param_1 * 0x70 + 0x1003a9ec) + (int)*(short *)(param_1 * 0x70 + 0x1003a9f2);
    FUN_10015d94(*(undefined4 *)(param_1 * 0x70 + 0x1003a9ec),param_2 + 0x6d,0x17c);
    FUN_1002b020(0x2f,100);
  }
  return;
}

