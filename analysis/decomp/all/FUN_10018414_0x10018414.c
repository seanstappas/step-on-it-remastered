
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_10018414(short param_1)

{
  undefined **ppuVar1;
  int iVar2;
  undefined4 uVar3;
  undefined4 uVar4;
  char unaff_r27;
  int iVar5;
  undefined **local_5c;
  int local_38 [5];
  
  if (((DAT_10039049 != '\0') && (DAT_10039155 != '\0')) && (_DAT_1003904e != param_1)) {
    ppuVar1 = &_toc;
    if (_DAT_1003904e != 0) {
      FUN_1001873c(0x1e);
      .glue::DisposeMovie(_DAT_10039054);
      _DAT_10039054 = 0;
      ppuVar1 = local_5c;
    }
    if (param_1 == 4) {
      if (DAT_10039154 == '\0') {
        unaff_r27 = FUN_10018d08((int)ppuVar1 + 0x997);
      }
      else {
        unaff_r27 = FUN_10018d08((int)ppuVar1 + 0x99e);
      }
    }
    else if (param_1 < 4) {
      if (param_1 == 2) {
        if (DAT_10039154 == '\0') {
          unaff_r27 = FUN_10018d08((int)ppuVar1 + 0x961);
        }
        else {
          unaff_r27 = FUN_10018d08(ppuVar1 + 0x25a);
        }
      }
      else if (param_1 < 2) {
        if (0 < param_1) {
          if (DAT_10039154 == '\0') {
            unaff_r27 = FUN_10018d08(ppuVar1 + 0x254);
          }
          else {
            unaff_r27 = FUN_10018d08((int)ppuVar1 + 0x956);
          }
        }
      }
      else if (DAT_10039154 == '\0') {
        unaff_r27 = FUN_10018d08(ppuVar1 + 0x25d);
      }
      else {
        unaff_r27 = FUN_10018d08((int)ppuVar1 + 0x983);
      }
    }
    else if (param_1 == 6) {
      unaff_r27 = FUN_10018d08((int)ppuVar1 + 0x9aa);
    }
    else if (param_1 < 6) {
      unaff_r27 = FUN_10018d08(ppuVar1 + 0x254);
    }
    if (unaff_r27 != '\0') {
      _DAT_1003904e = param_1;
      iVar2 = .glue::GetMovieTrackCount(_DAT_10039054);
      for (iVar5 = 1; iVar5 <= iVar2; iVar5 = iVar5 + 1) {
        uVar3 = .glue::GetMovieIndTrack(_DAT_10039054,iVar5);
        uVar4 = .glue::GetTrackMedia(uVar3);
        .glue::GetMediaHandlerDescription(uVar4,local_38,0,0);
        if ((local_38[0] == 0x736f756e) || (local_38[0] == 0x6d757369)) {
          .glue::SetTrackEnabled(uVar3,1);
        }
        else {
          .glue::SetTrackEnabled(uVar3,0);
        }
      }
      .glue::SetMovieGWorld(_DAT_10039054,0,0);
      .glue::SetMovieVolume(_DAT_10039054,(int)*(short *)(local_5c + 0x13b7));
    }
  }
  return;
}

