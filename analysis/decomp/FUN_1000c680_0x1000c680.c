/* FUN_1000c680 @ 0x1000c680  calls: Random */

void FUN_1000c680(undefined4 param_1,undefined4 param_2)

{
  ushort uVar5;
  int iVar1;
  int iVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  short sVar6;
  short sVar7;
  short sVar8;
  int local_4c;
  
  uVar5 = .glue::Random();
  uVar5 = uVar5 & 0x3f;
  if (uVar5 < 0x40) {
    if (uVar5 < 0x3e) {
      if (uVar5 < 0x3c) {
        if (uVar5 < 0x3a) {
          if (uVar5 < 0x36) {
            if (uVar5 < 0x2e) {
              if (uVar5 < 0x2c) {
                if (uVar5 < 0x2b) {
                  if (uVar5 < 0x2a) {
                    if (uVar5 < 0x29) {
                      if (uVar5 < 0x27) {
                        if (uVar5 < 0x23) {
                          if (uVar5 < 0x1b) {
                            sVar8 = 10;
                          }
                          else {
                            sVar8 = 0x17;
                          }
                        }
                        else {
                          sVar8 = 0x18;
                        }
                      }
                      else {
                        sVar8 = 0x19;
                      }
                    }
                    else {
                      sVar8 = 0x12;
                    }
                  }
                  else {
                    sVar8 = 0x11;
                  }
                }
                else {
                  sVar8 = 0x10;
                }
              }
              else {
                sVar8 = 0x13;
              }
            }
            else {
              sVar8 = 0xc;
            }
          }
          else {
            sVar8 = 0xd;
          }
        }
        else {
          sVar8 = 0xe;
        }
      }
      else {
        sVar8 = 0xf;
      }
    }
    else {
      sVar8 = 0x30;
    }
  }
  else {
    sVar8 = 0x32;
  }
  sVar6 = (short)param_1;
  sVar7 = (short)param_2;
  if (*(int *)(&DAT_1003ad68 + sVar6 * 0x3c + sVar7 * 4) == 0) {
    FUN_1002cc10(param_1,param_2);
    iVar1 = FUN_1002e6bc(param_2);
    iVar2 = FUN_1002e6ac(param_1);
    FUN_10004108(*(undefined4 *)(local_4c + 0x6ba4),0x10,iVar2 + 4,iVar1 + 4);
    *(int *)(&DAT_1003ad68 + sVar6 * 0x3c + sVar7 * 4) = sVar8 * 0x10000 + 0x9ff;
  }
  else {
    *(int *)(&DAT_1003ad68 + sVar6 * 0x3c + sVar7 * 4) = (sVar8 + 0x900) * 0x10000 + 0x1291;
    uVar3 = FUN_1002e6bc(param_2);
    uVar4 = FUN_1002e6ac(param_1);
    FUN_10004108(*(undefined4 *)(local_4c + 0x6bc0),0x91,uVar4,uVar3);
  }
  return;
}

