
char FUN_10000944(short *param_1,short *param_2,char *param_3,char *param_4,int *param_5,
                 int *param_6)

{
  char cVar1;
  
  if (*param_1 < 1) {
    if (*param_2 != 0) {
      *param_2 = *param_2 + -1;
      if (*param_3 == '\0') goto LAB_100009dc;
      while (cVar1 = *param_4, *param_4 = cVar1 + -1, cVar1 == '\0') {
        *param_4 = *(char *)*param_5;
        *param_5 = *param_5 + 1;
        *param_3 = '\0';
LAB_100009dc:
        cVar1 = *param_4;
        *param_4 = cVar1 + -1;
        if (cVar1 != '\0') {
          cVar1 = *(char *)*param_6;
          *param_6 = *param_6 + 1;
          if (cVar1 == '\0') {
            return '\x01';
          }
          return cVar1;
        }
        *param_4 = *(char *)*param_5;
        *param_5 = *param_5 + 1;
        *param_3 = '\x01';
      }
    }
  }
  else {
    *param_1 = *param_1 + -1;
  }
  return '\0';
}

