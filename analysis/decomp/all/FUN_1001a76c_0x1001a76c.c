
/* WARNING: Globals starting with '_' overlap smaller symbols at the same address */

void FUN_1001a76c(void)

{
  undefined4 uVar1;
  short sVar2;
  int local_9c;
  uint local_76;
  short local_72;
  uint local_70;
  short local_6c;
  uint local_6a;
  uint local_66;
  uint local_62;
  uint local_5e;
  undefined1 auStack_5a [4];
  short local_56;
  undefined1 auStack_54 [20];
  
  DAT_10039362 = FUN_1001b14c(0xffffaa68);
  _DAT_10039394 = .glue::GetNewDialog(400,0,0xffffffff);
  if (_DAT_10039394 == 0) {
    FUN_100192f8(5);
  }
  uVar1 = .glue::NewRoutineDescriptor(*(undefined4 *)(local_9c + -0x1e4),0xfd0,1);
  *(undefined4 *)(local_9c + 0x520c) = uVar1;
  uRam10039368 = .glue::NewRoutineDescriptor(*(undefined4 *)(local_9c + -0x1ec),0x2c0,1);
  uRam10039364 = .glue::NewRoutineDescriptor(*(undefined4 *)(local_9c + -500),0x2c0,1);
  if (DAT_10039362 == '\0') {
    .glue::GetDialogItem(_DAT_10039394,5,&local_56,auStack_5a,auStack_54);
    .glue::SetDialogItem(_DAT_10039394,5,(int)local_56,uRam10039364,auStack_54);
  }
  else {
    .glue::SetDialogDefaultItem(_DAT_10039394,1);
    .glue::SetDialogCancelItem(_DAT_10039394,2);
    .glue::SetDialogTracksCursor(_DAT_10039394,1);
    sVar2 = .glue::Gestalt(0x6469746c,&local_5e);
    if ((sVar2 == 0) && ((local_5e & 1) != 0)) {
      .glue::ShortenDITL(_DAT_10039394,1);
    }
    else {
      .glue::GetDialogItem(_DAT_10039394,5,&local_56,auStack_5a,auStack_54);
      .glue::SetDialogItem(_DAT_10039394,5,(int)local_56,uRam10039368,auStack_54);
    }
  }
  iRam10039390 = .glue::GetNewDialog(500,0,0xffffffff);
  if (iRam10039390 == 0) {
    FUN_100192f8(5);
  }
  uVar1 = .glue::NewRoutineDescriptor(*(undefined4 *)(local_9c + -0x1fc),0xfd0,1);
  *(undefined4 *)(local_9c + 0x520c) = uVar1;
  uRam10039368 = .glue::NewRoutineDescriptor(*(undefined4 *)(local_9c + -0x1ec),0x2c0,1);
  uRam10039364 = .glue::NewRoutineDescriptor(*(undefined4 *)(local_9c + -500),0x2c0,1);
  if (DAT_10039362 == '\0') {
    .glue::GetDialogItem(iRam10039390,9,&local_56,auStack_5a,auStack_54);
    .glue::SetDialogItem(iRam10039390,9,(int)local_56,uRam10039364,auStack_54);
  }
  else {
    .glue::SetDialogDefaultItem(iRam10039390,1);
    .glue::SetDialogCancelItem(iRam10039390,2);
    .glue::SetDialogTracksCursor(iRam10039390,1);
    sVar2 = .glue::Gestalt(0x6469746c,&local_62);
    if ((sVar2 == 0) && ((local_62 & 1) != 0)) {
      .glue::ShortenDITL(iRam10039390,1);
    }
    else {
      .glue::GetDialogItem(iRam10039390,9,&local_56,auStack_5a,auStack_54);
      .glue::SetDialogItem(iRam10039390,9,(int)local_56,uRam10039368,auStack_54);
    }
  }
  _DAT_1003938c = .glue::GetNewDialog(0x191,0,0xffffffff);
  if (_DAT_1003938c == 0) {
    FUN_100192f8(5);
  }
  uVar1 = .glue::NewRoutineDescriptor(*(undefined4 *)(local_9c + -0x208),0xfd0,1);
  *(undefined4 *)(local_9c + 0x5204) = uVar1;
  if (DAT_10039362 == '\0') {
    .glue::GetDialogItem(_DAT_1003938c,5,&local_56,auStack_5a,auStack_54);
    .glue::SetDialogItem(_DAT_1003938c,5,(int)local_56,uRam10039364,auStack_54);
  }
  else {
    .glue::SetDialogDefaultItem(_DAT_1003938c,1);
    .glue::SetDialogCancelItem(_DAT_1003938c,2);
    .glue::SetDialogTracksCursor(_DAT_1003938c,1);
    sVar2 = .glue::Gestalt(0x6469746c,&local_66);
    if ((sVar2 == 0) && ((local_66 & 1) != 0)) {
      .glue::ShortenDITL(_DAT_1003938c,1);
    }
    else {
      .glue::GetDialogItem(_DAT_1003938c,5,&local_56,auStack_5a,auStack_54);
      .glue::SetDialogItem(_DAT_1003938c,5,(int)local_56,uRam10039368,auStack_54);
    }
  }
  _DAT_10039398 = .glue::GetNewDialog(0x194,0,0xffffffff);
  if (_DAT_10039398 == 0) {
    FUN_100192f8(5);
  }
  uVar1 = .glue::NewRoutineDescriptor(*(undefined4 *)(local_9c + -0x208),0xfd0,1);
  *(undefined4 *)(local_9c + 0x51fc) = uVar1;
  if (DAT_10039362 == '\0') {
    .glue::GetDialogItem(_DAT_10039398,5,&local_56,auStack_5a,auStack_54);
    .glue::SetDialogItem(_DAT_10039398,5,(int)local_56,uRam10039364,auStack_54);
  }
  else {
    .glue::SetDialogDefaultItem(_DAT_10039398,1);
    .glue::SetDialogCancelItem(_DAT_10039398,2);
    .glue::SetDialogTracksCursor(_DAT_10039398,1);
    local_6c = .glue::Gestalt(0x6469746c,&local_6a);
    if ((local_6c == 0) && ((local_6a & 1) != 0)) {
      .glue::ShortenDITL(_DAT_10039398,1);
    }
    else {
      .glue::GetDialogItem(_DAT_10039398,6,&local_56,auStack_5a,auStack_54);
      .glue::SetDialogItem(_DAT_10039398,6,(int)local_56,uRam10039368,auStack_54);
    }
  }
  _DAT_10039388 = .glue::GetNewDialog(0x192,0,0xffffffff);
  if (_DAT_10039388 == 0) {
    FUN_100192f8(5);
  }
  uVar1 = .glue::NewRoutineDescriptor(*(undefined4 *)(local_9c + -0x21c),0xfd0,1);
  *(undefined4 *)(local_9c + 0x5200) = uVar1;
  if (DAT_10039362 == '\0') {
    .glue::GetDialogItem(_DAT_10039388,5,&local_56,auStack_5a,auStack_54);
    .glue::SetDialogItem(_DAT_10039388,5,(int)local_56,uRam10039364,auStack_54);
  }
  else {
    .glue::SetDialogDefaultItem(_DAT_10039388,1);
    .glue::SetDialogCancelItem(_DAT_10039388,2);
    .glue::SetDialogTracksCursor(_DAT_10039388,1);
    local_72 = .glue::Gestalt(0x6469746c,&local_70);
    if ((local_72 == 0) && ((local_70 & 1) != 0)) {
      .glue::ShortenDITL(_DAT_10039388,1);
    }
    else {
      .glue::GetDialogItem(_DAT_10039388,5,&local_56,auStack_5a,auStack_54);
      .glue::SetDialogItem(_DAT_10039388,5,(int)local_56,uRam10039368,auStack_54);
    }
  }
  _DAT_10039384 = .glue::GetNewDialog(0x193,0,0xffffffff);
  if (_DAT_10039384 == 0) {
    FUN_100192f8(5);
  }
  if (DAT_10039362 == '\0') {
    .glue::GetDialogItem(_DAT_10039384,5,&local_56,auStack_5a,auStack_54);
    .glue::SetDialogItem(_DAT_10039384,5,(int)local_56,uRam10039364,auStack_54);
  }
  else {
    .glue::SetDialogDefaultItem(_DAT_10039384,1);
    .glue::SetDialogCancelItem(_DAT_10039384,2);
    .glue::SetDialogTracksCursor(_DAT_10039384,1);
    sVar2 = .glue::Gestalt(0x6469746c,&local_76);
    if ((sVar2 == 0) && ((local_76 & 1) != 0)) {
      .glue::ShortenDITL(_DAT_10039384,1);
    }
    else {
      .glue::GetDialogItem(_DAT_10039384,5,&local_56,auStack_5a,auStack_54);
      .glue::SetDialogItem(_DAT_10039384,5,(int)local_56,uRam10039368,auStack_54);
    }
  }
  _DAT_1003939c = .glue::GetNewDialog(0x195,0,0xffffffff);
  if (_DAT_1003939c == 0) {
    FUN_100192f8(5);
  }
  if (DAT_10039362 != '\0') {
    .glue::SetDialogDefaultItem(_DAT_1003939c,1);
    .glue::SetDialogCancelItem(_DAT_1003939c,2);
    .glue::SetDialogTracksCursor(_DAT_1003939c,1);
  }
  _DAT_100393a8 = .glue::GetNewDialog(0x197,0,0xffffffff);
  if (_DAT_100393a8 == 0) {
    FUN_100192f8(5);
  }
  if (DAT_10039362 != '\0') {
    .glue::SetDialogDefaultItem(_DAT_100393a8,1);
    .glue::SetDialogCancelItem(_DAT_100393a8,2);
    .glue::SetDialogTracksCursor(_DAT_100393a8,1);
  }
  _DAT_100393a0 = .glue::GetNewDialog(0x196,0,0xffffffff);
  if (_DAT_100393a0 == 0) {
    FUN_100192f8(5);
  }
  if (DAT_10039362 != '\0') {
    .glue::SetDialogDefaultItem(_DAT_100393a0,1);
    .glue::SetDialogTracksCursor(_DAT_100393a0,1);
  }
  _DAT_100393a4 = .glue::GetNewDialog(5000,0,0xffffffff);
  if (_DAT_100393a4 == 0) {
    FUN_100192f8(5);
  }
  uVar1 = .glue::NewRoutineDescriptor(*(undefined4 *)(local_9c + -0x238),0xfd0,1);
  *(undefined4 *)(local_9c + 0x5210) = uVar1;
  if (DAT_10039362 != '\0') {
    .glue::SetDialogTracksCursor(_DAT_100393a4,1);
  }
  return;
}

