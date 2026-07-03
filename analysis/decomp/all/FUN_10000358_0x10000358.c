
void FUN_10000358(short *param_1,undefined4 *param_2,short param_3,undefined1 param_4)

{
  undefined1 *puVar1;
  int *piVar2;
  int *piVar3;
  int *piVar4;
  short sStack00000022;
  undefined1 uStack00000027;
  int *local_48;
  int *local_44;
  int *local_40 [2];
  
  piVar2 = (int *)*param_2;
  local_48 = piVar2 + 2;
  local_40[0] = piVar2 + 0x100;
  local_44 = piVar2 + 0x900;
  sStack00000022 = param_3;
  uStack00000027 = param_4;
  FUN_100004d8((int)*param_1,(int)param_1[1],param_4,(int)param_1 + *(int *)(param_1 + 4),
               (int)param_3,&local_48,local_40,&local_44);
  *(undefined1 *)local_48 = 0;
  puVar1 = (undefined1 *)((int)local_48 + 2);
  *(undefined1 *)((int)local_48 + 1) = 0;
  piVar3 = (int *)((((int)puVar1 >> 2) + (uint)((int)puVar1 < 0 && ((uint)puVar1 & 3) != 0)) * 4 + 4
                  );
  *piVar2 = (int)piVar3 - (int)piVar2;
  for (piVar4 = piVar2 + 0x100; piVar4 < local_40[0]; piVar4 = piVar4 + 1) {
    *piVar3 = *piVar4;
    piVar3 = piVar3 + 1;
  }
  *piVar3 = *piVar4;
  piVar3 = piVar3 + 1;
  piVar2[1] = (int)piVar3 - (int)piVar2;
  for (piVar2 = piVar2 + 0x900; piVar2 < local_44; piVar2 = piVar2 + 1) {
    *piVar3 = *piVar2;
    piVar3 = piVar3 + 1;
  }
  *piVar3 = *piVar2;
  *param_2 = piVar3 + 1;
  return;
}

