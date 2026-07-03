
undefined4 .debug::_IndexedSearch(int param_1,undefined4 param_2)

{
  undefined **ppuVar1;
  undefined4 uVar2;
  undefined *puVar3;
  undefined4 uVar4;
  int iVar5;
  short unaff_r29;
  int *piVar6;
  undefined **local_14c;
  undefined1 auStack_128 [64];
  char local_e8;
  undefined1 local_e7;
  undefined1 local_e6 [2];
  int local_e4;
  undefined1 auStack_e0 [18];
  undefined1 *local_ce;
  short local_ca;
  short local_c4;
  byte local_c2;
  undefined4 local_b0;
  undefined1 auStack_74 [64];
  short local_34;
  undefined1 auStack_32 [6];
  undefined4 local_2c;
  char local_1c;
  
  local_1c = '\0';
  ppuVar1 = &_toc;
  if (*(int *)(param_1 + 0x30) != 0) {
    local_2c = .glue::NewRoutineDescriptor(PTR_PTR_LAB_10034128,0xb802,1);
    .glue::InsTime(auStack_32);
    .glue::PrimeTime(auStack_32,*(undefined4 *)(param_1 + 0x30));
    ppuVar1 = local_14c;
  }
  uVar2 = _VerifyUserPB(param_1,local_e6,&local_e7,&local_e8);
  if ((short)uVar2 == 0) {
    *(undefined4 *)(param_1 + 0x20) = 0;
    if (local_e8 != '\0') {
      .glue::BlockMoveData
                (*(undefined4 *)(*(int *)(param_1 + 0x28) + 0x12),auStack_128,
                 **(byte **)(*(int *)(param_1 + 0x28) + 0x12) + 1);
      .glue::UpperString(auStack_128,1);
      ppuVar1 = local_14c;
    }
    piVar6 = (int *)(param_1 + 0x34);
    if (ppuVar1[-2] == (undefined *)0x0) {
      puVar3 = (undefined *).glue::NewHandle(200);
      local_14c[-2] = puVar3;
      ppuVar1 = local_14c;
    }
    if (ppuVar1[-2] == (undefined *)0x0) {
      uVar2 = 0xffffff94;
    }
    else {
      puVar3 = (undefined *).glue::GetHandleSize(ppuVar1[-2]);
      local_14c[-3] = puVar3;
      if (*piVar6 == 0) {
        uVar2 = _CheckVol(*(undefined4 *)(param_1 + 0x12),(int)*(short *)(param_1 + 0x16),&local_34,
                          piVar6);
        if ((short)uVar2 == 0) {
          *(undefined2 *)(param_1 + 0x38) = 0;
          unaff_r29 = -1;
        }
      }
      else {
        uVar2 = _CheckVol(*(undefined4 *)(param_1 + 0x12),(int)*(short *)(param_1 + 0x16),&local_34,
                          &local_e4);
        if ((short)uVar2 == 0) {
          if (*piVar6 == local_e4) {
            if (*(short *)(param_1 + 0x38) == 0) {
              uVar2 = 0xffffffce;
            }
            else {
              *(short *)(param_1 + 0x38) = *(short *)(param_1 + 0x38) + -1;
              param_2 = *(undefined4 *)
                         (*(int *)local_14c[-2] + 4 + (uint)*(ushort *)(param_1 + 0x38) * 10);
              unaff_r29 = *(short *)(*(int *)local_14c[-2] + 8 +
                                    (uint)*(ushort *)(param_1 + 0x38) * 10);
              iVar5 = _GetDirModDate((int)local_34,param_2);
              if (iVar5 != *(int *)(*(int *)local_14c[-2] + (uint)*(ushort *)(param_1 + 0x38) * 10))
              {
                uVar2 = 0xfffffae8;
              }
            }
          }
          else {
            uVar2 = 0xfffffae8;
          }
        }
      }
      if ((short)uVar2 == 0) {
        local_ce = auStack_74;
        local_ca = local_34;
        do {
          local_c4 = unaff_r29;
          local_b0 = param_2;
          uVar2 = .glue::PBGetCatInfoSync(auStack_e0);
          if (unaff_r29 == -1) {
            if ((short)uVar2 == 0) {
              _CheckForMatches(auStack_e0,param_1,auStack_128,local_e6[0],local_e7);
              unaff_r29 = 1;
            }
          }
          else if ((short)uVar2 == 0) {
            _CheckForMatches(auStack_e0,param_1,auStack_128,local_e6[0],local_e7);
            unaff_r29 = unaff_r29 + 1;
            if ((local_c2 & 0x10) != 0) {
              uVar2 = _CheckStack(*(undefined2 *)(param_1 + 0x38),local_14c[-2],local_14c + -3);
              if ((short)uVar2 == 0) {
                *(undefined4 *)(*(int *)local_14c[-2] + 4 + (uint)*(ushort *)(param_1 + 0x38) * 10)
                     = param_2;
                *(short *)(*(int *)local_14c[-2] + 8 + (uint)*(ushort *)(param_1 + 0x38) * 10) =
                     unaff_r29;
                uVar4 = _GetDirModDate((int)local_34,param_2);
                *(undefined4 *)(*(int *)local_14c[-2] + (uint)*(ushort *)(param_1 + 0x38) * 10) =
                     uVar4;
                *(short *)(param_1 + 0x38) = *(short *)(param_1 + 0x38) + 1;
                unaff_r29 = 1;
                param_2 = local_b0;
              }
            }
          }
          else if (*(short *)(param_1 + 0x38) == 0) {
            uVar2 = 0xffffffd9;
          }
          else {
            *(short *)(param_1 + 0x38) = *(short *)(param_1 + 0x38) + -1;
            param_2 = *(undefined4 *)
                       (*(int *)local_14c[-2] + 4 + (uint)*(ushort *)(param_1 + 0x38) * 10);
            unaff_r29 = *(short *)(*(int *)local_14c[-2] + 8 +
                                  (uint)*(ushort *)(param_1 + 0x38) * 10);
            iVar5 = _GetDirModDate((int)local_34,param_2);
            if (iVar5 == *(int *)(*(int *)local_14c[-2] + (uint)*(ushort *)(param_1 + 0x38) * 10)) {
              uVar2 = 0;
            }
            else {
              uVar2 = 0xfffffae8;
            }
          }
          if ((local_1c != '\0') || ((short)uVar2 != 0)) break;
        } while (*(int *)(param_1 + 0x20) < *(int *)(param_1 + 0x1c));
        if ((short)uVar2 == 0) {
          uVar2 = _CheckStack(*(undefined2 *)(param_1 + 0x38),local_14c[-2],local_14c + -3);
          if ((short)uVar2 == 0) {
            *(undefined4 *)(*(int *)local_14c[-2] + 4 + (uint)*(ushort *)(param_1 + 0x38) * 10) =
                 param_2;
            *(short *)(*(int *)local_14c[-2] + 8 + (uint)*(ushort *)(param_1 + 0x38) * 10) =
                 unaff_r29;
            uVar4 = _GetDirModDate((int)local_34,param_2);
            *(undefined4 *)(*(int *)local_14c[-2] + (uint)*(ushort *)(param_1 + 0x38) * 10) = uVar4;
            *(short *)(param_1 + 0x38) = *(short *)(param_1 + 0x38) + 1;
          }
        }
      }
    }
  }
  if (*(int *)(param_1 + 0x30) != 0) {
    .glue::RmvTime(auStack_32);
    .glue::DisposeRoutineDescriptor(local_2c);
  }
  return uVar2;
}

