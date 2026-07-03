
void FUN_10026580(void)

{
  undefined4 uVar1;
  short sVar2;
  undefined4 local_2c;
  
  uVar1 = .glue::NewRoutineDescriptor(PTR_PTR_LAB_1003406c,0xfe0,1);
  *(undefined4 *)(local_2c + 0x61a0) = uVar1;
  uVar1 = .glue::NewRoutineDescriptor(*(undefined4 *)(local_2c + -0x10c),0xfe0,1);
  *(undefined4 *)(local_2c + 0x619c) = uVar1;
  uVar1 = .glue::NewRoutineDescriptor(*(undefined4 *)(local_2c + -0x114),0xfe0,1);
  *(undefined4 *)(local_2c + 0x6198) = uVar1;
  uVar1 = .glue::NewRoutineDescriptor(*(undefined4 *)(local_2c + -0x11c),0xfe0,1);
  *(undefined4 *)(local_2c + 0x6194) = uVar1;
  sVar2 = .glue::AEInstallEventHandler(0x61657674,0x6f617070,*(undefined4 *)(local_2c + 0x61a0),0,0)
  ;
  if (sVar2 == 0) {
    sVar2 = .glue::AEInstallEventHandler
                      (0x61657674,0x6f646f63,*(undefined4 *)(local_2c + 0x619c),0,0);
  }
  if (sVar2 == 0) {
    sVar2 = .glue::AEInstallEventHandler
                      (0x61657674,0x70646f63,*(undefined4 *)(local_2c + 0x6198),0,0);
  }
  if (sVar2 == 0) {
    sVar2 = .glue::AEInstallEventHandler
                      (0x61657674,0x71756974,*(undefined4 *)(local_2c + 0x6194),0,0);
  }
  if (sVar2 != 0) {
    FUN_100192f8(0xc);
  }
  return;
}

