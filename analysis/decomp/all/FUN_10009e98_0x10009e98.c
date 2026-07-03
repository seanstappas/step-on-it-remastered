
void FUN_10009e98(short param_1)

{
  int iVar1;
  char cVar2;
  int iVar3;
  short sVar4;
  short sStack0000001a;
  
  iVar3 = param_1 * 0x46;
  if (*(char *)(iVar3 + 0x10037e67) == '\0') {
    sVar4 = *(short *)(iVar3 + 0x10037e6c);
    *(short *)(iVar3 + 0x10037e6c) = sVar4 + -1;
    if (sVar4 < 1) {
      *(undefined1 *)(iVar3 + 0x10037e66) = 1;
      sStack0000001a = param_1;
      if (0 < *(short *)(iVar3 + 0x10037e88)) {
        FUN_1002b020(0xb,5);
        *(undefined1 *)(iVar3 + 0x10037e68) = 1;
        FUN_10028014(*(undefined4 *)(iVar3 + 0x10037e52),(int)*(short *)(iVar3 + 0x10037e56),
                     (int)*(short *)(iVar3 + 0x10037e58),(int)*(short *)(iVar3 + 0x10037e5a),1);
        iVar1 = *(short *)(iVar3 + 0x10037e88) * 0x70;
        *(int *)(iVar1 + 0x1003a9ec) =
             *(int *)(iVar1 + 0x1003a9ec) + (int)*(short *)(iVar3 + 0x10037e8a);
      }
      if (*(short *)(iVar3 + 0x10037e4a) == 2) {
        *(undefined2 *)(iVar3 + 0x10037e6c) = 0;
        sVar4 = 2;
      }
      else {
        *(undefined2 *)(iVar3 + 0x10037e6c) = 1;
        sVar4 = 1;
      }
      if (*(short *)(iVar3 + 0x10037e6e) == 2) {
        *(short *)(iVar3 + 0x10037e56) = *(short *)(iVar3 + 0x10037e56) + sVar4;
        if (0x18 < *(short *)(iVar3 + 0x10037e56)) {
          *(undefined2 *)(iVar3 + 0x10037e56) = 1;
        }
        if (*(short *)(iVar3 + 0x10037e4c) == 1) {
          cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + -1,
                               *(short *)(iVar3 + 0x10037e5a) + 0x10);
          if (cVar2 == '\0') {
            cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x1d,
                                 *(short *)(iVar3 + 0x10037e5a) + -1);
            if (cVar2 == '\0') {
              cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + -1,
                                   *(short *)(iVar3 + 0x10037e5a) + -1);
              if (cVar2 == '\0') {
                cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x1e,
                                     *(short *)(iVar3 + 0x10037e5a) + -1);
                if (cVar2 == '\0') {
                  *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) - sVar4;
                }
                else {
                  *(undefined2 *)(iVar3 + 0x10037e4c) = 8;
                }
              }
              else {
                *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) - sVar4;
              }
            }
            else {
              *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) - sVar4;
            }
          }
          else {
            *(undefined2 *)(iVar3 + 0x10037e4c) = 9;
          }
        }
        else if (*(short *)(iVar3 + 0x10037e4c) == 8) {
          cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x10,
                               *(short *)(iVar3 + 0x10037e5a) + -1);
          if (cVar2 == '\0') {
            cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x1e,
                                 *(short *)(iVar3 + 0x10037e5a) + 0x1d);
            if (cVar2 == '\0') {
              cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x1e,
                                   *(short *)(iVar3 + 0x10037e5a) + -1);
              if (cVar2 == '\0') {
                cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x1e,
                                     *(short *)(iVar3 + 0x10037e5a) + 0x1e);
                if (cVar2 == '\0') {
                  *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e5a) - sVar4;
                }
                else {
                  *(undefined2 *)(iVar3 + 0x10037e4c) = 2;
                }
              }
              else {
                *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e5a) - sVar4;
              }
            }
            else {
              *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e5a) - sVar4;
            }
          }
          else {
            *(undefined2 *)(iVar3 + 0x10037e4c) = 1;
          }
        }
        else if (*(short *)(iVar3 + 0x10037e4c) == 2) {
          cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x1e,
                               *(short *)(iVar3 + 0x10037e5a) + 0x10);
          if (cVar2 == '\0') {
            cVar2 = FUN_1000554c((int)*(short *)(iVar3 + 0x10037e58),
                                 *(short *)(iVar3 + 0x10037e5a) + 0x1e);
            if (cVar2 == '\0') {
              cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x1e,
                                   *(short *)(iVar3 + 0x10037e5a) + 0x1e);
              if (cVar2 == '\0') {
                cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + -1,
                                     *(short *)(iVar3 + 0x10037e5a) + 0x1e);
                if (cVar2 == '\0') {
                  *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) + sVar4;
                }
                else {
                  *(undefined2 *)(iVar3 + 0x10037e4c) = 9;
                }
              }
              else {
                *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) + sVar4;
              }
            }
            else {
              *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) + sVar4;
            }
          }
          else {
            *(undefined2 *)(iVar3 + 0x10037e4c) = 8;
          }
        }
        else if (*(short *)(iVar3 + 0x10037e4c) == 9) {
          cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x10,
                               *(short *)(iVar3 + 0x10037e5a) + 0x1e);
          if (cVar2 == '\0') {
            cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + -1,
                                 (int)*(short *)(iVar3 + 0x10037e5a));
            if (cVar2 == '\0') {
              cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + -1,
                                   *(short *)(iVar3 + 0x10037e5a) + 0x1e);
              if (cVar2 == '\0') {
                cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + -1,
                                     *(short *)(iVar3 + 0x10037e5a) + -1);
                if (cVar2 == '\0') {
                  *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e5a) + sVar4;
                }
                else {
                  *(undefined2 *)(iVar3 + 0x10037e4c) = 1;
                }
              }
              else {
                *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e5a) + sVar4;
              }
            }
            else {
              *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e5a) + sVar4;
            }
          }
          else {
            *(undefined2 *)(iVar3 + 0x10037e4c) = 2;
          }
        }
      }
      if (*(short *)(iVar3 + 0x10037e6e) == 1) {
        *(short *)(iVar3 + 0x10037e56) = *(short *)(iVar3 + 0x10037e56) - sVar4;
        if (*(short *)(iVar3 + 0x10037e56) < 1) {
          *(undefined2 *)(iVar3 + 0x10037e56) = 0x18;
        }
        if (*(short *)(iVar3 + 0x10037e4c) == 1) {
          cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + -1,
                               *(short *)(iVar3 + 0x10037e5a) + 0x10);
          if (cVar2 == '\0') {
            cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x1d,
                                 *(short *)(iVar3 + 0x10037e5a) + 0x1e);
            if (cVar2 == '\0') {
              cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + -1,
                                   *(short *)(iVar3 + 0x10037e5a) + 0x1e);
              if (cVar2 == '\0') {
                cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x1e,
                                     *(short *)(iVar3 + 0x10037e5a) + 0x1e);
                if (cVar2 == '\0') {
                  *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) - sVar4;
                }
                else {
                  *(undefined2 *)(iVar3 + 0x10037e4c) = 9;
                }
              }
              else {
                *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) - sVar4;
              }
            }
            else {
              *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) - sVar4;
            }
          }
          else {
            *(undefined2 *)(iVar3 + 0x10037e4c) = 8;
          }
        }
        else if (*(short *)(iVar3 + 0x10037e4c) == 8) {
          cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x10,
                               *(short *)(iVar3 + 0x10037e5a) + -1);
          if (cVar2 == '\0') {
            cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + -1,
                                 *(short *)(iVar3 + 0x10037e5a) + 0x1d);
            if (cVar2 == '\0') {
              cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + -1,
                                   *(short *)(iVar3 + 0x10037e5a) + -1);
              if (cVar2 == '\0') {
                cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + -1,
                                     *(short *)(iVar3 + 0x10037e5a) + 0x1e);
                if (cVar2 == '\0') {
                  *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e5a) - sVar4;
                }
                else {
                  *(undefined2 *)(iVar3 + 0x10037e4c) = 1;
                }
              }
              else {
                *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e5a) - sVar4;
              }
            }
            else {
              *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e5a) - sVar4;
            }
          }
          else {
            *(undefined2 *)(iVar3 + 0x10037e4c) = 2;
          }
        }
        else if (*(short *)(iVar3 + 0x10037e4c) == 2) {
          cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x1e,
                               *(short *)(iVar3 + 0x10037e5a) + 0x10);
          if (cVar2 == '\0') {
            cVar2 = FUN_1000554c((int)*(short *)(iVar3 + 0x10037e58),
                                 *(short *)(iVar3 + 0x10037e5a) + -1);
            if (cVar2 == '\0') {
              cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x1e,
                                   *(short *)(iVar3 + 0x10037e5a) + -1);
              if (cVar2 == '\0') {
                cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + -1,
                                     *(short *)(iVar3 + 0x10037e5a) + -1);
                if (cVar2 == '\0') {
                  *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) + sVar4;
                }
                else {
                  *(undefined2 *)(iVar3 + 0x10037e4c) = 8;
                }
              }
              else {
                *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) + sVar4;
              }
            }
            else {
              *(short *)(iVar3 + 0x10037e58) = *(short *)(iVar3 + 0x10037e58) + sVar4;
            }
          }
          else {
            *(undefined2 *)(iVar3 + 0x10037e4c) = 9;
          }
        }
        else if (*(short *)(iVar3 + 0x10037e4c) == 9) {
          cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0xc,
                               *(short *)(iVar3 + 0x10037e5a) + 0x1e);
          if (cVar2 == '\0') {
            cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x1e,
                                 (int)*(short *)(iVar3 + 0x10037e5a));
            if (cVar2 == '\0') {
              cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x1e,
                                   *(short *)(iVar3 + 0x10037e5a) + 0x1e);
              if (cVar2 == '\0') {
                cVar2 = FUN_1000554c(*(short *)(iVar3 + 0x10037e58) + 0x1e,
                                     *(short *)(iVar3 + 0x10037e5a) + -1);
                if (cVar2 == '\0') {
                  *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e5a) + sVar4;
                }
                else {
                  *(undefined2 *)(iVar3 + 0x10037e4c) = 2;
                }
              }
              else {
                *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e5a) + sVar4;
              }
            }
            else {
              *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e5a) + sVar4;
            }
          }
          else {
            *(undefined2 *)(iVar3 + 0x10037e4c) = 1;
          }
        }
      }
      *(short *)(iVar3 + 0x10037e82) = *(short *)(iVar3 + 0x10037e58) + 4;
      *(short *)(iVar3 + 0x10037e84) = *(short *)(iVar3 + 0x10037e58) + 0x1a;
      *(short *)(iVar3 + 0x10037e80) = *(short *)(iVar3 + 0x10037e5a) + 4;
      *(short *)(iVar3 + 0x10037e7e) = *(short *)(iVar3 + 0x10037e5a) + 0x1a;
    }
  }
  else {
    *(undefined1 *)(iVar3 + 0x10037e67) = 0;
    *(undefined2 *)(iVar3 + 0x10037e6c) = 1;
    *(undefined2 *)(iVar3 + 0x10037e76) = 0;
    *(undefined4 *)(iVar3 + 0x10037e52) = uRam1003a31c;
    *(undefined4 *)(iVar3 + 0x10037e5c) = 0;
    *(undefined2 *)(iVar3 + 0x10037e56) = 1;
    *(short *)(iVar3 + 0x10037e5a) = *(short *)(iVar3 + 0x10037e5a) + 2;
    *(undefined1 *)(iVar3 + 0x10037e66) = 1;
    *(undefined2 *)(iVar3 + 0x10037e6e) = *(undefined2 *)(iVar3 + 0x10037e4c);
    *(undefined2 *)(iVar3 + 0x10037e8a) = 300;
  }
  return;
}

