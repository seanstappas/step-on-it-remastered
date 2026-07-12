from PIL import Image
import numpy as np, sys
def add_glint(path, out=None, cx=0.32, cy=0.20, rad=0.14, color=(165,250,165), core=0.55):
    im=Image.open(path).convert("RGBA"); a=np.asarray(im).astype(float)
    H,W=a.shape[:2]; alpha=a[...,3]/255.0
    yy,xx=np.mgrid[0:H,0:W]; gx,gy=cx*W,cy*H; r=rad*min(W,H)
    d=np.sqrt((xx-gx)**2+(yy-gy)**2)/r
    blob=np.clip(1-d,0,1)**2                    # soft outer
    blob=blob*(1-core)+np.clip(1-d/0.45,0,1)**2*core  # brighter core
    blob=np.clip(blob,0,1)*alpha
    for i in range(3):
        base=a[...,i]/255.0; add=color[i]/255.0
        a[...,i]=(1-(1-base)*(1-add*blob))*255
    Image.fromarray(np.clip(a,0,255).astype(np.uint8)).save(out or path)
if __name__=="__main__":
    add_glint(sys.argv[1], sys.argv[2] if len(sys.argv)>2 else None)
    print("glint added")
