
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1002cc10(undefined4 param_1,undefined4 param_2)

{
  uint uVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  uint uVar4;
  uint uVar5;
  short sVar6;
  short sVar7;
  
  uVar2 = FUN_1002e6ac(param_1);
  uVar3 = FUN_1002e6bc(param_2);
  sVar6 = (short)param_1;
  sVar7 = (short)param_2;
  if (((*(uint *)(&DAT_1003ad68 + sVar6 * 0x3c + sVar7 * 4) & 0x100) == 0) &&
     ((*(uint *)(&DAT_1003ad68 + sVar6 * 0x3c + sVar7 * 4) & 0xff) != 0)) {
    if ((*(uint *)(&DAT_1003ad68 + sVar6 * 0x3c + sVar7 * 4) & 0x1000) == 0) {
      if ((*(uint *)(&DAT_1003ad68 + sVar6 * 0x3c + sVar7 * 4) & 0x4000) == 0) {
        FUN_10004090(_DAT_1003ad30,*(uint *)(&DAT_1003ad68 + sVar6 * 0x3c + sVar7 * 4) & 0xff,uVar2,
                     uVar3);
      }
      else {
        FUN_10004090(_DAT_1003ad30,(*(uint *)(&DAT_1003ad68 + sVar6 * 0x3c + sVar7 * 4) & 0xff) + 1,
                     uVar2,uVar3);
      }
      *(undefined4 *)(&DAT_1003ad68 + sVar6 * 0x3c + sVar7 * 4) = 0;
    }
    else {
      uVar4 = *(uint *)(&DAT_1003ad68 + sVar6 * 0x3c + sVar7 * 4);
      uVar5 = ((int)uVar4 >> 0x10) + (uint)((int)uVar4 < 0 && (uVar4 & 0xffff) != 0);
      uVar4 = *(uint *)(&DAT_1003ad68 + sVar6 * 0x3c + sVar7 * 4) & 0xff;
      uVar1 = uVar5 & 0xff;
      if ((uVar5 & 0x800) == 0) {
        if ((*(uint *)(&DAT_1003ad68 + sVar6 * 0x3c + sVar7 * 4) & 0x4000) == 0) {
          FUN_10004090(_DAT_1003ad30,uVar4,uVar2,uVar3);
          FUN_10004108(_DAT_1003ad30,uVar1,uVar2,uVar3);
        }
        else {
          FUN_10004090(_DAT_1003ad30,uVar4 + 1,uVar2,uVar3);
          FUN_10004108(_DAT_1003ad30,uVar1,uVar2,uVar3);
        }
      }
      else if ((*(uint *)(&DAT_1003ad68 + sVar6 * 0x3c + sVar7 * 4) & 0x4000) == 0) {
        FUN_10004090(_DAT_1003ad30,uVar4,uVar2,uVar3);
        FUN_10004108(_DAT_1003ad2c,uVar1,uVar2,uVar3);
      }
      else {
        FUN_10004090(_DAT_1003ad30,uVar4 + 1,uVar2,uVar3);
        FUN_10004108(_DAT_1003ad2c,uVar1,uVar2,uVar3);
      }
      *(int *)(&DAT_1003ad68 + sVar6 * 0x3c + sVar7 * 4) = (int)(short)uVar5;
    }
  }
  return;
}

