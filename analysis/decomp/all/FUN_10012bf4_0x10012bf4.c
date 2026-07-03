
void FUN_10012bf4(undefined4 param_1)

{
  char cVar1;
  short sVar2;
  short sVar3;
  
  cVar1 = FUN_100147a0(param_1);
  sVar3 = (short)param_1;
  if (((cVar1 == '\0') || (FUN_10014744(param_1), *(char *)(sVar3 * 0x70 + 0x1003a9ce) != '\0')) ||
     (*(char *)(sVar3 * 0x70 + 0x1003a9cf) != '\0')) {
    cVar1 = FUN_10012348(param_1);
    if (cVar1 == '\0') {
      *(undefined2 *)(sVar3 * 0x70 + 0x1003a9cc) = 3;
    }
    else if (*(short *)(sVar3 * 0x70 + 0x1003a9e4) == 1) {
      if (*(short *)(sVar3 * 0x70 + 0x1003a9e2) == 0) {
        if ((*(ushort *)(&DAT_1003a9b0 + sVar3 * 0x70) & 2) == 2) {
          *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 0x1a;
        }
        else {
          *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 0x19;
        }
      }
      if (*(char *)(sVar3 * 0x70 + 0x1003a9d0) == '\0') {
        if ((*(char *)(sVar3 * 0x70 + 0x1003a9ce) == '\0') &&
           ((*(ushort *)(&DAT_1003a9b0 + sVar3 * 0x70) & 2) == 0)) {
          if (*(char *)(sVar3 * 0x70 + 0x1003a9cf) == '\0') {
            *(undefined2 *)(sVar3 * 0x70 + 0x1003a9cc) = 0xc;
            *(undefined2 *)(sVar3 * 0x70 + 0x1003a9e2) = 0;
          }
          else {
            *(undefined2 *)(sVar3 * 0x70 + 0x1003a9cc) = 0xb;
            *(undefined2 *)(sVar3 * 0x70 + 0x1003a9e2) = 0;
            *(undefined2 *)(sVar3 * 0x70 + 0x1003a9e4) = 0xffff;
          }
        }
        else {
          cVar1 = FUN_100127e0(param_1);
          if (cVar1 == '\0') {
            if (*(char *)(sVar3 * 0x70 + 0x1003a9ce) == '\0') {
              *(short *)(&DAT_1003a9b0 + sVar3 * 0x70) =
                   *(short *)(&DAT_1003a9b0 + sVar3 * 0x70) + -2;
              *(ushort *)(sVar3 * 0x70 + 0x1003a9b2) =
                   *(ushort *)(&DAT_1003a9b0 + sVar3 * 0x70) & 0xfffc;
              sVar2 = *(short *)(sVar3 * 0x70 + 0x1003a9be) + 1;
              *(short *)(sVar3 * 0x70 + 0x1003a9be) = sVar2;
              if (0x30 < sVar2) {
                *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 0x19;
              }
            }
            else {
              *(ushort *)(sVar3 * 0x70 + 0x1003a9b2) =
                   *(ushort *)(&DAT_1003a9b0 + sVar3 * 0x70) & 0xfffc;
              if ((*(short *)(sVar3 * 0x70 + 0x1003a9e2) != 0) &&
                 ((*(ushort *)(sVar3 * 0x70 + 0x1003a9e2) & 1) != 0)) {
                sVar2 = *(short *)(sVar3 * 0x70 + 0x1003a9be) + 1;
                *(short *)(sVar3 * 0x70 + 0x1003a9be) = sVar2;
                if (0x30 < sVar2) {
                  *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 0x19;
                }
                sVar2 = *(short *)(sVar3 * 0x70 + 0x1003a9be) + 1;
                *(short *)(sVar3 * 0x70 + 0x1003a9be) = sVar2;
                if (0x30 < sVar2) {
                  *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 0x19;
                }
              }
            }
          }
          else {
            *(short *)(&DAT_1003a9b0 + sVar3 * 0x70) = *(short *)(&DAT_1003a9b0 + sVar3 * 0x70) + 2;
            *(ushort *)(sVar3 * 0x70 + 0x1003a9b2) =
                 *(ushort *)(&DAT_1003a9b0 + sVar3 * 0x70) & 0xfffc;
            sVar2 = *(short *)(sVar3 * 0x70 + 0x1003a9be) + 1;
            *(short *)(sVar3 * 0x70 + 0x1003a9be) = sVar2;
            if (0x30 < sVar2) {
              *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 0x19;
            }
          }
          *(short *)(sVar3 * 0x70 + 0x1003a9e2) = *(short *)(sVar3 * 0x70 + 0x1003a9e2) + 1;
          *(undefined4 *)(sVar3 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + sVar3 * 4);
        }
      }
      else {
        *(undefined2 *)(sVar3 * 0x70 + 0x1003a9cc) = 2;
        *(undefined2 *)(sVar3 * 0x70 + 0x1003a9e2) = 0;
      }
    }
    else if (*(short *)(sVar3 * 0x70 + 0x1003a9e4) == -1) {
      if (*(short *)(sVar3 * 0x70 + 0x1003a9e2) == 0) {
        if ((*(ushort *)(&DAT_1003a9b0 + sVar3 * 0x70) & 2) == 2) {
          *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 1;
        }
        else {
          *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 2;
        }
      }
      if (*(char *)(sVar3 * 0x70 + 0x1003a9d0) == '\0') {
        if ((*(char *)(sVar3 * 0x70 + 0x1003a9cf) == '\0') &&
           ((*(ushort *)(&DAT_1003a9b0 + sVar3 * 0x70) & 2) == 0)) {
          if (*(char *)(sVar3 * 0x70 + 0x1003a9ce) == '\0') {
            *(undefined2 *)(sVar3 * 0x70 + 0x1003a9cc) = 0xc;
            *(undefined2 *)(sVar3 * 0x70 + 0x1003a9e2) = 0;
          }
          else {
            *(undefined2 *)(sVar3 * 0x70 + 0x1003a9cc) = 0xb;
            *(undefined2 *)(sVar3 * 0x70 + 0x1003a9e2) = 0;
            *(undefined2 *)(sVar3 * 0x70 + 0x1003a9e4) = 1;
          }
        }
        else {
          cVar1 = FUN_100126c8(param_1);
          if (cVar1 == '\0') {
            if (*(char *)(sVar3 * 0x70 + 0x1003a9cf) == '\0') {
              *(short *)(&DAT_1003a9b0 + sVar3 * 0x70) =
                   *(short *)(&DAT_1003a9b0 + sVar3 * 0x70) + 2;
              *(ushort *)(sVar3 * 0x70 + 0x1003a9b2) =
                   *(ushort *)(&DAT_1003a9b0 + sVar3 * 0x70) & 0xfffc;
              sVar2 = *(short *)(sVar3 * 0x70 + 0x1003a9be) + 1;
              *(short *)(sVar3 * 0x70 + 0x1003a9be) = sVar2;
              if (0x18 < sVar2) {
                *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 1;
              }
            }
            else {
              *(ushort *)(sVar3 * 0x70 + 0x1003a9b2) =
                   *(ushort *)(&DAT_1003a9b0 + sVar3 * 0x70) & 0xfffc;
              if ((*(short *)(sVar3 * 0x70 + 0x1003a9e2) != 0) &&
                 ((*(ushort *)(sVar3 * 0x70 + 0x1003a9e2) & 1) != 0)) {
                sVar2 = *(short *)(sVar3 * 0x70 + 0x1003a9be) + 1;
                *(short *)(sVar3 * 0x70 + 0x1003a9be) = sVar2;
                if (0x18 < sVar2) {
                  *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 1;
                }
                sVar2 = *(short *)(sVar3 * 0x70 + 0x1003a9be) + 1;
                *(short *)(sVar3 * 0x70 + 0x1003a9be) = sVar2;
                if (0x18 < sVar2) {
                  *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 1;
                }
              }
            }
          }
          else {
            *(short *)(&DAT_1003a9b0 + sVar3 * 0x70) = *(short *)(&DAT_1003a9b0 + sVar3 * 0x70) + -2
            ;
            *(ushort *)(sVar3 * 0x70 + 0x1003a9b2) =
                 *(ushort *)(&DAT_1003a9b0 + sVar3 * 0x70) & 0xfffc;
            sVar2 = *(short *)(sVar3 * 0x70 + 0x1003a9be) + 1;
            *(short *)(sVar3 * 0x70 + 0x1003a9be) = sVar2;
            if (0x18 < sVar2) {
              *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 1;
            }
          }
          *(short *)(sVar3 * 0x70 + 0x1003a9e2) = *(short *)(sVar3 * 0x70 + 0x1003a9e2) + 1;
          *(undefined4 *)(sVar3 * 0x70 + 0x1003a9b6) = *(undefined4 *)(&DAT_1003ad34 + sVar3 * 4);
        }
      }
      else {
        *(undefined2 *)(sVar3 * 0x70 + 0x1003a9cc) = 2;
        *(undefined2 *)(sVar3 * 0x70 + 0x1003a9e2) = 0;
      }
    }
  }
  else {
    *(undefined2 *)(sVar3 * 0x70 + 0x1003a9cc) = 0;
    *(undefined2 *)(sVar3 * 0x70 + 0x1003a9e2) = 0;
    if (*(short *)(sVar3 * 0x70 + 0x1003a9e4) == 1) {
      *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 0x3d;
    }
    else {
      *(undefined2 *)(sVar3 * 0x70 + 0x1003a9be) = 0x34;
    }
  }
  return;
}

