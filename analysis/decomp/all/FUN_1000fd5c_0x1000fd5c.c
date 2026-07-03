
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1000fd5c(int param_1,undefined2 param_2)

{
  short sVar1;
  short sVar2;
  short sVar3;
  short sVar4;
  short sVar5;
  
  if (*(short *)(param_1 + 0x4e) != 0) {
    if (*(short *)(param_1 + 0x54) == 1) {
      sVar2 = FUN_100030ac((int)*(short *)(param_1 + 0x4e),*(short *)(param_1 + 0x50) + 1,
                           *(short *)(param_1 + 0x4e) + 0xf,*(short *)(param_1 + 0x50) + 5);
      if (sVar2 != 0) {
        *(undefined1 *)(param_1 + 0x58) = 1;
        if (DAT_100370e4 == '\0') {
          *(undefined2 *)(sVar2 * 0x46 + 0x10037e88) = 1;
        }
        else {
          *(undefined2 *)(sVar2 * 0x46 + 0x10037e88) = param_2;
        }
      }
      if (*(short *)(param_1 + 0x52) == 1) {
        sVar2 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0x18);
        sVar3 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 3);
        if (((*(uint *)(&DAT_1003ad68 + sVar2 * 0x3c + sVar3 * 4) & 0x200) == 0) &&
           (*(char *)(param_1 + 0x58) == '\0')) {
          FUN_100043a0(_DAT_1003ad20,10,(int)*(short *)(param_1 + 0x4e),
                       (int)*(short *)(param_1 + 0x50),_DAT_1003ad20,10,
                       *(short *)(param_1 + 0x4e) + 4,(int)*(short *)(param_1 + 0x50));
          *(short *)(param_1 + 0x4e) = *(short *)(param_1 + 0x4e) + 4;
        }
        else {
          FUN_10004cb0(_DAT_1003ad20,10,(int)*(short *)(param_1 + 0x4e),
                       (int)*(short *)(param_1 + 0x50));
          *(undefined2 *)(param_1 + 0x4e) = 0;
        }
      }
      else {
        sVar2 = FUN_1002e6cc((int)*(short *)(param_1 + 0x4e));
        sVar3 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 3);
        if (((*(uint *)(&DAT_1003ad68 + sVar2 * 0x3c + sVar3 * 4) & 0x200) == 0) &&
           (*(char *)(param_1 + 0x58) == '\0')) {
          FUN_100043a0(_DAT_1003ad20,9,(int)*(short *)(param_1 + 0x4e),
                       (int)*(short *)(param_1 + 0x50),_DAT_1003ad20,9,
                       *(short *)(param_1 + 0x4e) + -4,(int)*(short *)(param_1 + 0x50));
          *(short *)(param_1 + 0x4e) = *(short *)(param_1 + 0x4e) + -4;
        }
        else {
          FUN_10004cb0(_DAT_1003ad20,9,(int)*(short *)(param_1 + 0x4e),
                       (int)*(short *)(param_1 + 0x50));
          *(undefined2 *)(param_1 + 0x4e) = 0;
        }
      }
    }
    else if (*(short *)(param_1 + 0x54) == 2) {
      sVar2 = *(short *)(param_1 + 0x4e);
      sVar3 = *(short *)(param_1 + 0x50);
      sVar1 = *(short *)(param_1 + 0x5a);
      sVar5 = *(short *)(param_1 + 0x5a) + 1;
      *(short *)(param_1 + 0x5a) = sVar5;
      if (8 < sVar5) {
        *(undefined2 *)(param_1 + 0x5a) = 1;
      }
      sVar5 = FUN_100030ac(*(short *)(param_1 + 0x4e) + 1,*(short *)(param_1 + 0x50) + 1,
                           *(short *)(param_1 + 0x4e) + 0x17,*(short *)(param_1 + 0x50) + 0x17);
      if (sVar5 != 0) {
        if (DAT_100370e4 == '\0') {
          *(undefined2 *)(sVar5 * 0x46 + 0x10037e88) = 1;
        }
        else {
          *(undefined2 *)(sVar5 * 0x46 + 0x10037e88) = param_2;
        }
      }
      if (*(short *)(param_1 + 0x52) == 1) {
        sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0xc);
        sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + -2);
        if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
          sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + -2);
          sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0x17);
          if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
            sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + -2);
            sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + -2);
            if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
              sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + -2);
              sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0x19);
              if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
                *(short *)(param_1 + 0x4e) = *(short *)(param_1 + 0x4e) + -2;
              }
              else {
                *(undefined2 *)(param_1 + 0x52) = 2;
              }
            }
            else {
              *(short *)(param_1 + 0x4e) = *(short *)(param_1 + 0x4e) + -2;
            }
          }
          else {
            *(short *)(param_1 + 0x4e) = *(short *)(param_1 + 0x4e) + -2;
          }
        }
        else {
          *(undefined2 *)(param_1 + 0x52) = 4;
        }
      }
      else if (*(short *)(param_1 + 0x52) == 2) {
        sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + -2);
        sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0xc);
        if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
          sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0x17);
          sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0x19);
          if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
            sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + -2);
            sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 5);
            if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
              sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0x19);
              sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0x19);
              if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
                *(short *)(param_1 + 0x50) = *(short *)(param_1 + 0x50) + -2;
              }
              else {
                *(undefined2 *)(param_1 + 0x52) = 3;
              }
            }
            else {
              *(short *)(param_1 + 0x50) = *(short *)(param_1 + 0x50) + -2;
            }
          }
          else {
            *(short *)(param_1 + 0x50) = *(short *)(param_1 + 0x50) + -2;
          }
        }
        else {
          *(undefined2 *)(param_1 + 0x52) = 1;
        }
      }
      else if (*(short *)(param_1 + 0x52) == 3) {
        sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0xc);
        sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0x19);
        if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
          sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0x19);
          sVar4 = FUN_1002e6cc((int)*(short *)(param_1 + 0x4e));
          if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
            sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0x19);
            sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0x19);
            if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
              sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0x19);
              sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + -2);
              if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
                *(short *)(param_1 + 0x4e) = *(short *)(param_1 + 0x4e) + 2;
              }
              else {
                *(undefined2 *)(param_1 + 0x52) = 4;
              }
            }
            else {
              *(short *)(param_1 + 0x4e) = *(short *)(param_1 + 0x4e) + 2;
            }
          }
          else {
            *(short *)(param_1 + 0x4e) = *(short *)(param_1 + 0x4e) + 2;
          }
        }
        else {
          *(undefined2 *)(param_1 + 0x52) = 2;
        }
      }
      else if (*(short *)(param_1 + 0x52) == 4) {
        sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0x19);
        sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0xc);
        if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
          sVar5 = FUN_1002e6f8((int)*(short *)(param_1 + 0x50));
          sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + -2);
          if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
            sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0x19);
            sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + -2);
            if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
              sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + -2);
              sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + -2);
              if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
                *(short *)(param_1 + 0x50) = *(short *)(param_1 + 0x50) + 2;
              }
              else {
                *(undefined2 *)(param_1 + 0x52) = 1;
              }
            }
            else {
              *(short *)(param_1 + 0x50) = *(short *)(param_1 + 0x50) + 2;
            }
          }
          else {
            *(short *)(param_1 + 0x50) = *(short *)(param_1 + 0x50) + 2;
          }
        }
        else {
          *(undefined2 *)(param_1 + 0x52) = 3;
        }
      }
      sVar5 = *(short *)(param_1 + 0x56) + 1;
      *(short *)(param_1 + 0x56) = sVar5;
      if (sVar5 < 500) {
        FUN_100043a0(_DAT_1003ad20,(int)sVar1,(int)sVar2,(int)sVar3,_DAT_1003ad20,
                     (int)*(short *)(param_1 + 0x5a),(int)*(short *)(param_1 + 0x4e),
                     (int)*(short *)(param_1 + 0x50));
      }
      else {
        FUN_10004cb0(_DAT_1003ad20,(int)sVar1,(int)sVar2,(int)sVar3);
        *(undefined2 *)(param_1 + 0x4e) = 0;
      }
    }
    if (*(short *)(param_1 + 0x54) == 3) {
      sVar2 = *(short *)(param_1 + 0x4e);
      sVar3 = *(short *)(param_1 + 0x50);
      sVar1 = *(short *)(param_1 + 0x5a);
      sVar5 = *(short *)(param_1 + 0x5a) + -1;
      *(short *)(param_1 + 0x5a) = sVar5;
      if (sVar5 < 1) {
        *(undefined2 *)(param_1 + 0x5a) = 8;
      }
      sVar5 = FUN_100030ac(*(short *)(param_1 + 0x4e) + 1,*(short *)(param_1 + 0x50) + 1,
                           *(short *)(param_1 + 0x4e) + 0x17,*(short *)(param_1 + 0x50) + 0x17);
      if (sVar5 != 0) {
        if (DAT_100370e4 == '\0') {
          *(undefined2 *)(sVar5 * 0x46 + 0x10037e88) = 1;
        }
        else {
          *(undefined2 *)(sVar5 * 0x46 + 0x10037e88) = param_2;
        }
      }
      if (*(short *)(param_1 + 0x52) == 1) {
        sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0xc);
        sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + -2);
        if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
          sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0x19);
          sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0x17);
          if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
            sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0x19);
            sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + -2);
            if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
              sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0x19);
              sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0x19);
              if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
                *(short *)(param_1 + 0x4e) = *(short *)(param_1 + 0x4e) + -2;
              }
              else {
                *(undefined2 *)(param_1 + 0x52) = 4;
              }
            }
            else {
              *(short *)(param_1 + 0x4e) = *(short *)(param_1 + 0x4e) + -2;
            }
          }
          else {
            *(short *)(param_1 + 0x4e) = *(short *)(param_1 + 0x4e) + -2;
          }
        }
        else {
          *(undefined2 *)(param_1 + 0x52) = 2;
        }
      }
      else if (*(short *)(param_1 + 0x52) == 2) {
        sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + -2);
        sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0xc);
        if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
          sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0x17);
          sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + -2);
          if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
            sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + -2);
            sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + -2);
            if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
              sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0x19);
              sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + -2);
              if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
                *(short *)(param_1 + 0x50) = *(short *)(param_1 + 0x50) + -2;
              }
              else {
                *(undefined2 *)(param_1 + 0x52) = 1;
              }
            }
            else {
              *(short *)(param_1 + 0x50) = *(short *)(param_1 + 0x50) + -2;
            }
          }
          else {
            *(short *)(param_1 + 0x50) = *(short *)(param_1 + 0x50) + -2;
          }
        }
        else {
          *(undefined2 *)(param_1 + 0x52) = 3;
        }
      }
      else if (*(short *)(param_1 + 0x52) == 3) {
        sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0xc);
        sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0x19);
        if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
          sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + -2);
          sVar4 = FUN_1002e6cc((int)*(short *)(param_1 + 0x4e));
          if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
            sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + -2);
            sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0x19);
            if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
              sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + -2);
              sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + -2);
              if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
                *(short *)(param_1 + 0x4e) = *(short *)(param_1 + 0x4e) + 2;
              }
              else {
                *(undefined2 *)(param_1 + 0x52) = 2;
              }
            }
            else {
              *(short *)(param_1 + 0x4e) = *(short *)(param_1 + 0x4e) + 2;
            }
          }
          else {
            *(short *)(param_1 + 0x4e) = *(short *)(param_1 + 0x4e) + 2;
          }
        }
        else {
          *(undefined2 *)(param_1 + 0x52) = 4;
        }
      }
      else if (*(short *)(param_1 + 0x52) == 4) {
        sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0x18);
        sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0xc);
        if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
          sVar5 = FUN_1002e6f8((int)*(short *)(param_1 + 0x50));
          sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0x19);
          if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
            sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + 0x18);
            sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0x19);
            if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
              sVar5 = FUN_1002e6f8(*(short *)(param_1 + 0x50) + -2);
              sVar4 = FUN_1002e6cc(*(short *)(param_1 + 0x4e) + 0x19);
              if ((*(uint *)(&DAT_1003ad68 + sVar4 * 0x3c + sVar5 * 4) & 0x200) == 0) {
                *(short *)(param_1 + 0x50) = *(short *)(param_1 + 0x50) + 2;
              }
              else {
                *(undefined2 *)(param_1 + 0x52) = 3;
              }
            }
            else {
              *(short *)(param_1 + 0x50) = *(short *)(param_1 + 0x50) + 2;
            }
          }
          else {
            *(short *)(param_1 + 0x50) = *(short *)(param_1 + 0x50) + 2;
          }
        }
        else {
          *(undefined2 *)(param_1 + 0x52) = 1;
        }
      }
      sVar5 = *(short *)(param_1 + 0x56) + 1;
      *(short *)(param_1 + 0x56) = sVar5;
      if (sVar5 < 500) {
        FUN_100043a0(_DAT_1003ad20,(int)sVar1,(int)sVar2,(int)sVar3,_DAT_1003ad20,
                     (int)*(short *)(param_1 + 0x5a),(int)*(short *)(param_1 + 0x4e),
                     (int)*(short *)(param_1 + 0x50));
      }
      else {
        FUN_10004cb0(_DAT_1003ad20,(int)sVar1,(int)sVar2,(int)sVar3);
        *(undefined2 *)(param_1 + 0x4e) = 0;
      }
    }
  }
  return;
}

