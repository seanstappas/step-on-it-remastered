
void FUN_1001166c(undefined4 param_1)

{
  undefined4 uVar1;
  undefined4 uVar2;
  short sVar3;
  short sVar4;
  
  FUN_100147b8(param_1);
  sVar4 = (short)param_1;
  *(undefined4 *)(sVar4 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + sVar4 * 4);
  if (*(char *)(sVar4 * 0x70 + 0x1003a9d8) == '\0') {
    if (*(char *)(sVar4 * 0x70 + 0x1003a9d5) == '\0') {
      if (*(char *)(sVar4 * 0x70 + 0x1003a9d1) == '\0') {
        if (*(char *)(sVar4 * 0x70 + 0x1003a9d2) == '\0') {
          if (*(char *)(sVar4 * 0x70 + 0x1003a9d4) == '\0') {
            if (*(char *)(sVar4 * 0x70 + 0x1003a9d3) != '\0') {
              FUN_10014700(param_1);
              *(undefined1 *)(sVar4 * 0x70 + 0x1003a9d5) = 1;
              if (*(short *)(sVar4 * 0x70 + 0x1003a9e4) == 1) {
                *(undefined2 *)(sVar4 * 0x70 + 0x1003a9e0) = 3;
              }
              else {
                *(undefined2 *)(sVar4 * 0x70 + 0x1003a9e0) = 1;
              }
              *(undefined2 *)(sVar4 * 0x70 + 0x1003a9dc) = 0;
              *(undefined2 *)(sVar4 * 0x70 + 0x1003a9de) = 2;
            }
          }
          else {
            FUN_10014700(param_1);
            *(undefined1 *)(sVar4 * 0x70 + 0x1003a9d5) = 1;
            if (*(short *)(sVar4 * 0x70 + 0x1003a9e4) == 1) {
              *(undefined2 *)(sVar4 * 0x70 + 0x1003a9e0) = 3;
            }
            else {
              *(undefined2 *)(sVar4 * 0x70 + 0x1003a9e0) = 1;
            }
            *(undefined2 *)(sVar4 * 0x70 + 0x1003a9dc) = 0;
            *(undefined2 *)(sVar4 * 0x70 + 0x1003a9de) = 3;
          }
        }
        else {
          FUN_10014700(param_1);
          *(undefined1 *)(sVar4 * 0x70 + 0x1003a9d5) = 1;
          if (*(short *)(sVar4 * 0x70 + 0x1003a9e4) == 1) {
            *(undefined2 *)(sVar4 * 0x70 + 0x1003a9e0) = 4;
          }
          else {
            *(undefined2 *)(sVar4 * 0x70 + 0x1003a9e0) = 2;
          }
          *(undefined2 *)(sVar4 * 0x70 + 0x1003a9dc) = 0;
          *(undefined2 *)(sVar4 * 0x70 + 0x1003a9de) = 1;
        }
      }
      else {
        FUN_10014700(param_1);
        *(undefined1 *)(sVar4 * 0x70 + 0x1003a9d5) = 1;
        if (*(short *)(sVar4 * 0x70 + 0x1003a9e4) == 1) {
          *(undefined2 *)(sVar4 * 0x70 + 0x1003a9e0) = 3;
        }
        else {
          *(undefined2 *)(sVar4 * 0x70 + 0x1003a9e0) = 1;
        }
        *(undefined2 *)(sVar4 * 0x70 + 0x1003a9dc) = 0;
        *(undefined2 *)(sVar4 * 0x70 + 0x1003a9de) = 1;
      }
    }
    else {
      *(undefined2 *)(sVar4 * 0x70 + 0x1003a9b2) = *(undefined2 *)(&DAT_1003a9b0 + sVar4 * 0x70);
      if (*(short *)(sVar4 * 0x70 + 0x1003a9e0) == 3) {
        sVar3 = *(short *)(sVar4 * 0x70 + 0x1003a9dc) + 1;
        *(short *)(sVar4 * 0x70 + 0x1003a9dc) = sVar3;
        if (sVar3 < 7) {
          *(undefined4 *)(sVar4 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + sVar4 * 4);
          *(wchar_t *)(sVar4 * 0x70 + 0x1003a9be) =
               u______________0_______________0___100346ac
               [*(short *)(sVar4 * 0x70 + 0x1003a9dc) + 0x20];
        }
        else {
          *(undefined1 *)(sVar4 * 0x70 + 0x1003a9d5) = 0;
        }
        if (*(short *)(sVar4 * 0x70 + 0x1003a9dc) == 5) {
          if (*(short *)(sVar4 * 0x70 + 0x1003a9de) == 1) {
            uVar1 = FUN_1002e6f8(*(short *)(sVar4 * 0x70 + 0x1003a9b4) + 0x10);
            uVar2 = FUN_1002e6cc(*(short *)(&DAT_1003a9b0 + sVar4 * 0x70) + 0x30);
            FUN_1002d04c(uVar2,uVar1,param_1);
          }
          else if (*(short *)(sVar4 * 0x70 + 0x1003a9de) == 3) {
            FUN_100110b4(param_1);
          }
          else if (*(short *)(sVar4 * 0x70 + 0x1003a9de) == 2) {
            FUN_10010d30(param_1);
          }
        }
      }
      else if (*(short *)(sVar4 * 0x70 + 0x1003a9e0) == 1) {
        sVar3 = *(short *)(sVar4 * 0x70 + 0x1003a9dc) + 1;
        *(short *)(sVar4 * 0x70 + 0x1003a9dc) = sVar3;
        if (sVar3 < 7) {
          *(undefined4 *)(sVar4 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + sVar4 * 4);
          *(undefined2 *)(sVar4 * 0x70 + 0x1003a9be) =
               *(undefined2 *)(&DAT_100346fa + *(short *)(sVar4 * 0x70 + 0x1003a9dc) * 2);
        }
        else {
          *(undefined1 *)(sVar4 * 0x70 + 0x1003a9d5) = 0;
        }
        if (*(short *)(sVar4 * 0x70 + 0x1003a9dc) == 5) {
          if (*(short *)(sVar4 * 0x70 + 0x1003a9de) == 1) {
            uVar1 = FUN_1002e6f8(*(short *)(sVar4 * 0x70 + 0x1003a9b4) + 0x10);
            uVar2 = FUN_1002e6cc(*(short *)(&DAT_1003a9b0 + sVar4 * 0x70) + -0x12);
            FUN_1002cf08(uVar2,uVar1,param_1);
          }
          else if (*(short *)(sVar4 * 0x70 + 0x1003a9de) == 3) {
            FUN_100110b4(param_1);
          }
          else if (*(short *)(sVar4 * 0x70 + 0x1003a9de) == 2) {
            FUN_10010d30(param_1);
          }
        }
      }
      else if (*(short *)(sVar4 * 0x70 + 0x1003a9e0) == 4) {
        sVar3 = *(short *)(sVar4 * 0x70 + 0x1003a9dc) + 1;
        *(short *)(sVar4 * 0x70 + 0x1003a9dc) = sVar3;
        if (sVar3 < 7) {
          *(undefined4 *)(sVar4 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + sVar4 * 4);
          *(undefined2 *)(sVar4 * 0x70 + 0x1003a9be) =
               *(undefined2 *)(&DAT_10034708 + *(short *)(sVar4 * 0x70 + 0x1003a9dc) * 2);
        }
        else {
          *(undefined1 *)(sVar4 * 0x70 + 0x1003a9d5) = 0;
        }
        if ((*(short *)(sVar4 * 0x70 + 0x1003a9dc) == 5) &&
           (*(short *)(sVar4 * 0x70 + 0x1003a9de) == 1)) {
          uVar1 = FUN_1002e6f8(*(short *)(sVar4 * 0x70 + 0x1003a9b4) + 0x1f);
          uVar2 = FUN_1002e6cc(*(short *)(&DAT_1003a9b0 + sVar4 * 0x70) + 0x30);
          FUN_1002d190(uVar2,uVar1,param_1);
        }
      }
      else if (*(short *)(sVar4 * 0x70 + 0x1003a9e0) == 2) {
        sVar3 = *(short *)(sVar4 * 0x70 + 0x1003a9dc) + 1;
        *(short *)(sVar4 * 0x70 + 0x1003a9dc) = sVar3;
        if (sVar3 < 7) {
          *(undefined4 *)(sVar4 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + sVar4 * 4);
          *(undefined2 *)(sVar4 * 0x70 + 0x1003a9be) =
               *(undefined2 *)(&DAT_10034716 + *(short *)(sVar4 * 0x70 + 0x1003a9dc) * 2);
        }
        else {
          *(undefined1 *)(sVar4 * 0x70 + 0x1003a9d5) = 0;
        }
        if ((*(short *)(sVar4 * 0x70 + 0x1003a9dc) == 5) &&
           (*(short *)(sVar4 * 0x70 + 0x1003a9de) == 1)) {
          uVar1 = FUN_1002e6f8(*(short *)(sVar4 * 0x70 + 0x1003a9b4) + 0x1f);
          uVar2 = FUN_1002e6cc(*(short *)(&DAT_1003a9b0 + sVar4 * 0x70) + -0x12);
          FUN_1002d190(uVar2,uVar1,param_1);
        }
      }
    }
    if (*(char *)(sVar4 * 0x70 + 0x1003a9d5) == '\0') {
      switch(*(undefined2 *)(sVar4 * 0x70 + 0x1003a9cc)) {
      case 0:
        FUN_100128f8(param_1);
        break;
      case 1:
        FUN_10012bf4(param_1);
        break;
      case 2:
        FUN_10013404(param_1);
        break;
      case 3:
        FUN_1001386c(param_1);
        break;
      case 4:
        FUN_10014524(param_1);
        break;
      case 5:
        FUN_10013980(param_1);
        break;
      case 9:
        FUN_10013ddc(param_1);
        break;
      case 10:
        FUN_10013f68(param_1);
        break;
      case 0xb:
        FUN_10013c18(param_1);
        break;
      case 0xc:
        FUN_100140f4(param_1);
        break;
      case 0xd:
        FUN_1001431c(param_1);
      }
    }
  }
  else {
    FUN_10011fcc(param_1);
  }
  return;
}

