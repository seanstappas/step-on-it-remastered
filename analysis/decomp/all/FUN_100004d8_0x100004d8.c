
void FUN_100004d8(short param_1,short param_2,char param_3,undefined4 param_4,undefined2 param_5,
                 int *param_6,int *param_7,int *param_8)

{
  uint *puVar1;
  short sVar2;
  uint uVar3;
  int *piVar4;
  char *pcVar5;
  short sVar6;
  uint uVar7;
  short unaff_r30;
  char unaff_r31;
  undefined4 uStack00000024;
  int local_58;
  int local_54;
  undefined2 local_50;
  short local_4e [7];
  
  pcVar5 = (char *)*param_6;
  piVar4 = (int *)*param_7;
  puVar1 = (uint *)*param_8;
  uStack00000024 = param_4;
  local_50 = param_5;
  local_4e[0] = param_1;
  for (sVar2 = 0; sVar2 < param_2; sVar2 = sVar2 + 1) {
    sVar6 = param_1;
    if (param_3 != '\0') {
      sVar6 = param_1 + 4;
    }
    uVar3 = 0;
    uVar7 = 1;
    if (sVar2 == 0) {
      FUN_10000884(&local_50,local_4e,&stack0x0000003b,&stack0x00000043,&stack0x0000003c,
                   &stack0x00000024,&local_54,&local_58);
      if (local_58 == -1) {
        unaff_r31 = '\x01';
        unaff_r30 = 0;
      }
      else {
        unaff_r31 = '\0';
        unaff_r30 = 1;
      }
    }
    while (sVar6 != 0) {
      if (local_58 == -1) {
        uVar7 = uVar7 << 1;
        if (unaff_r30 == 1) {
          unaff_r31 = unaff_r31 + '\x02';
        }
        else {
          *pcVar5 = unaff_r31;
          pcVar5 = pcVar5 + 1;
          unaff_r31 = '\x02';
          unaff_r30 = 1;
        }
        sVar6 = sVar6 + -4;
        if (sVar6 == 0) {
          *pcVar5 = unaff_r31;
          pcVar5 = pcVar5 + 1;
          local_50 = param_5;
          local_4e[0] = param_1;
          FUN_10000884(&local_50,local_4e,&stack0x0000003b,&stack0x00000043,&stack0x0000003c,
                       &stack0x00000024,&local_54,&local_58);
          if (local_58 == 0) {
            unaff_r31 = '\0';
            unaff_r30 = 0;
          }
          else {
            unaff_r31 = '\x01';
            unaff_r30 = 2;
          }
        }
        else {
          FUN_10000884(&local_50,local_4e,&stack0x0000003b,&stack0x00000043,&stack0x0000003c,
                       &stack0x00000024,&local_54,&local_58);
        }
      }
      else if (local_58 == 0) {
        *piVar4 = local_54;
        uVar3 = uVar3 | uVar7;
        piVar4 = piVar4 + 1;
        uVar7 = uVar7 << 1;
        if (unaff_r30 == 2) {
          unaff_r31 = unaff_r31 + '\x02';
        }
        else {
          *pcVar5 = unaff_r31;
          pcVar5 = pcVar5 + 1;
          unaff_r31 = '\x03';
          unaff_r30 = 2;
        }
        sVar6 = sVar6 + -4;
        if (sVar6 == 0) {
          *pcVar5 = unaff_r31;
          pcVar5 = pcVar5 + 1;
          local_50 = param_5;
          local_4e[0] = param_1;
          FUN_10000884(&local_50,local_4e,&stack0x0000003b,&stack0x00000043,&stack0x0000003c,
                       &stack0x00000024,&local_54,&local_58);
          if (local_58 == -1) {
            unaff_r31 = '\x01';
            unaff_r30 = 0;
          }
          else {
            unaff_r31 = '\0';
            unaff_r30 = 1;
          }
        }
        else {
          FUN_10000884(&local_50,local_4e,&stack0x0000003b,&stack0x00000043,&stack0x0000003c,
                       &stack0x00000024,&local_54,&local_58);
        }
      }
      else {
        *piVar4 = local_58;
        uVar3 = uVar3 | uVar7;
        piVar4[1] = local_54;
        piVar4 = piVar4 + 2;
        uVar7 = uVar7 << 1;
        if (unaff_r30 == 0) {
          unaff_r31 = unaff_r31 + '\x02';
        }
        else {
          *pcVar5 = unaff_r31;
          pcVar5 = pcVar5 + 1;
          if (unaff_r30 == 1) {
            unaff_r31 = '\x02';
          }
          else {
            unaff_r31 = '\x03';
          }
          unaff_r30 = 0;
        }
        sVar6 = sVar6 + -4;
        if (sVar6 == 0) {
          *pcVar5 = unaff_r31;
          pcVar5 = pcVar5 + 1;
          local_50 = param_5;
          local_4e[0] = param_1;
          FUN_10000884(&local_50,local_4e,&stack0x0000003b,&stack0x00000043,&stack0x0000003c,
                       &stack0x00000024,&local_54,&local_58);
          if (local_58 == 0) {
            unaff_r31 = '\0';
            unaff_r30 = 1;
          }
          else {
            unaff_r31 = '\x01';
            unaff_r30 = 2;
          }
        }
        else {
          FUN_10000884(&local_50,local_4e,&stack0x0000003b,&stack0x00000043,&stack0x0000003c,
                       &stack0x00000024,&local_54,&local_58);
        }
      }
    }
    *puVar1 = uVar3;
    puVar1 = puVar1 + 1;
  }
  *param_6 = (int)pcVar5;
  *param_7 = (int)piVar4;
  *param_8 = (int)puVar1;
  return;
}

