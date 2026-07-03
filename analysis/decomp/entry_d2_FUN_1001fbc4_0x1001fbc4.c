/* FUN_1001fbc4 @ 0x1001fbc4  depth=2 */

void FUN_1001fbc4(void)

{
  int *piVar1;
  undefined4 uVar2;
  undefined4 uVar3;
  undefined4 local_3c;
  
  piVar1 = (int *).glue::GetGDevice();
  if (*(short *)(local_3c + 0x51ee) == *(short *)(**(int **)(*piVar1 + 0x16) + 0x20)) {
    if (*(short *)(local_3c + 0x613e) != 2) {
      .glue::DrawMenuBar();
      uVar2 = .glue::LMGetGrayRgn();
      .glue::PaintOne(0,uVar2);
      uVar2 = .glue::LMGetGrayRgn();
      uVar3 = .glue::LMGetWindowList();
      .glue::PaintBehind(uVar3,uVar2);
    }
  }
  else {
    .glue::SetDepth(piVar1,(int)*(short *)(local_3c + 0x51ee),1,1);
  }
  return;
}

