
undefined4 .debug::_CheckStack(ushort param_1,undefined4 param_2,uint *param_3)

{
  undefined4 uVar1;
  uint uVar2;
  ushort uStack0000001a;
  
  if (*param_3 / 10 == param_1 + 1) {
    uStack0000001a = param_1;
    .glue::SetHandleSize(param_2,*param_3 + 200);
    uVar1 = .glue::MemError();
    uVar2 = .glue::GetHandleSize(param_2);
    *param_3 = uVar2;
  }
  else {
    uVar1 = 0;
  }
  return uVar1;
}

