
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1000503c(undefined2 param_1,undefined2 param_2,undefined2 param_3,undefined2 param_4)

{
  short sVar1;
  short sVar2;
  int iVar3;
  undefined2 uStack0000001a;
  undefined2 uStack0000001e;
  undefined2 uStack00000022;
  undefined2 uStack00000026;
  
  _DAT_10037d50 = param_4;
  _DAT_10037d52 = param_3;
  _DAT_10037d54 = param_2;
  _DAT_10037d56 = param_1;
  uStack0000001a = param_1;
  uStack0000001e = param_2;
  uStack00000022 = param_3;
  uStack00000026 = param_4;
  for (sVar2 = _DAT_1003a36a; iVar3 = (int)sVar2, sVar2 != 0;
      sVar2 = *(short *)(sVar2 * 0x46 + 0x10037e86)) {
    sVar1 = *(short *)(sVar2 * 0x46 + 0x10037e4a);
    if (sVar1 == 0x13) {
      FUN_10009778(iVar3,*(short *)(sVar2 * 0x46 + 0x10037e58) + 0x20,
                   *(short *)(sVar2 * 0x46 + 0x10037e5a) + -0x20);
    }
    else if (sVar1 < 0x13) {
      if (sVar1 == 9) {
        FUN_1000d490(iVar3);
      }
      else if (sVar1 < 9) {
        if (sVar1 == 4) {
          FUN_1000dd4c(iVar3);
        }
        else if (sVar1 < 4) {
          if (sVar1 == 2) {
            FUN_10009e98(iVar3);
            FUN_10009e98(iVar3);
          }
          else if (sVar1 < 2) {
            if (0 < sVar1) {
              FUN_100071a0(iVar3);
            }
          }
          else {
            FUN_10009e98(iVar3);
          }
        }
        else if (sVar1 == 7) {
          FUN_10006378(iVar3);
        }
        else if (sVar1 < 7) {
          if (sVar1 < 6) {
            FUN_10007efc(iVar3);
          }
          else {
            FUN_100076a8(iVar3);
          }
        }
        else {
          FUN_10006840(iVar3);
        }
      }
      else if (sVar1 == 0xe) {
        FUN_1000adc4(iVar3);
      }
      else if (sVar1 < 0xe) {
        if (sVar1 == 0xc) {
          FUN_10005d30(iVar3);
        }
        else if (sVar1 < 0xc) {
          if (sVar1 < 0xb) {
            FUN_1000d5d4(iVar3);
          }
          else {
            FUN_1000ce34(iVar3);
          }
        }
        else {
          FUN_1000c2e8(iVar3);
        }
      }
      else if (sVar1 == 0x11) {
        FUN_10008b18(iVar3);
      }
      else if (sVar1 < 0x11) {
        if (sVar1 < 0x10) {
          FUN_1000a780(iVar3);
        }
        else {
          FUN_10008618(iVar3);
        }
      }
      else {
        FUN_100090a4(iVar3);
      }
    }
    else if (sVar1 == 0x6f) {
      FUN_1000d130(iVar3);
    }
    else if (sVar1 < 0x6f) {
      if (sVar1 == 0x6a) {
        FUN_10007998(iVar3);
      }
      else if (sVar1 < 0x6a) {
        if (sVar1 == 0x68) {
          FUN_1000e3c0(iVar3);
        }
        else if (sVar1 < 0x68) {
          if (sVar1 == 0x65) {
            FUN_1000744c(iVar3);
          }
        }
        else {
          FUN_100081f8(iVar3);
        }
      }
      else if (sVar1 != 0x6d) {
        if (sVar1 < 0x6d) {
          if (sVar1 < 0x6c) {
            FUN_10006d44(iVar3);
          }
          else {
            FUN_10006f6c(iVar3);
          }
        }
        else {
          FUN_1000d8c4(iVar3);
        }
      }
    }
    else if (sVar1 == 0x76) {
      FUN_100093a0(iVar3);
    }
    else if (sVar1 < 0x76) {
      if (sVar1 == 0x72) {
        FUN_1000b0a4(iVar3);
      }
      else if (sVar1 < 0x72) {
        if (sVar1 < 0x71) {
          FUN_1000602c(iVar3);
        }
        else {
          FUN_1000c544(iVar3);
        }
      }
    }
    else if (sVar1 == 200) {
      FUN_1000b6a0(iVar3);
    }
    else if ((sVar1 < 200) && (sVar1 < 0x78)) {
      FUN_10009a78(iVar3);
    }
  }
  return;
}

