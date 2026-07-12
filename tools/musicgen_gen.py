#!/usr/bin/env python3
"""Local, GPU MusicGen-Melody generation: reinterpret one of our songs in a new style
while FOLLOWING its melody/harmony (melody-conditioned). Open weights, no API key.

  python tools/musicgen_gen.py <melody_audio> <out_wav> "<style prompt>" [seconds] [model] [seed]

<melody_audio> is any wav/ogg whose melody+chords steer the generation (we use the
faithful render extracted/music/<song>.ogg). MusicGen generates up to 30s per call;
longer pieces are produced by the caller stitching segments.
"""
import os, sys
os.environ.setdefault("HF_HOME", r"D:\SOI-tools\hf-cache")
import torch, numpy as np, soundfile as sf, librosa
from transformers import AutoProcessor, MusicgenMelodyForConditionalGeneration

SR = 32000  # MusicGen audio sample rate


def main():
    mel_path = sys.argv[1]
    out_path = sys.argv[2]
    prompt   = sys.argv[3]
    seconds  = min(float(sys.argv[4]) if len(sys.argv) > 4 else 30.0, 30.0)
    model_id = sys.argv[5] if len(sys.argv) > 5 else "facebook/musicgen-melody-large"
    seed     = int(sys.argv[6]) if len(sys.argv) > 6 else 0
    offset   = float(os.environ.get("MG_OFFSET", "0"))   # start of the melody window (s)

    torch.manual_seed(seed)
    print(f"[musicgen] loading {model_id} (first run downloads ~6GB to D:) ...", flush=True)
    proc = AutoProcessor.from_pretrained(model_id)
    model = MusicgenMelodyForConditionalGeneration.from_pretrained(model_id).to("cuda")

    if mel_path.lower() in ("none", "text", "-"):
        inputs = proc(text=[prompt], padding=True, return_tensors="pt").to("cuda")
        print("[musicgen] TEXT-ONLY (no melody conditioning)", flush=True)
    else:
        mel, _ = librosa.load(mel_path, sr=SR, mono=True, offset=offset, duration=seconds)
        inputs = proc(audio=mel, sampling_rate=SR, text=[prompt], padding=True, return_tensors="pt").to("cuda")
    tokens = int(seconds * 50)
    print(f"[musicgen] input keys: { {k: tuple(v.shape) for k, v in inputs.items()} }", flush=True)
    guidance = float(os.environ.get("MG_GUIDANCE", "3.0"))
    do_sample = os.environ.get("MG_SAMPLE", "1") != "0"
    temp = float(os.environ.get("MG_TEMP", "1.0"))
    print(f"[musicgen] generating ~{seconds:.0f}s ({tokens} tokens) guidance={guidance} sample={do_sample} on {torch.cuda.get_device_name(0)} ...", flush=True)
    with torch.no_grad():
        audio = model.generate(**inputs, max_new_tokens=tokens, guidance_scale=guidance,
                               do_sample=do_sample, temperature=temp)
    wav = audio[0].cpu().float().numpy().squeeze()
    peak = float(np.max(np.abs(wav)) or 1.0)
    wav = (wav / peak) * 0.97
    os.makedirs(os.path.dirname(out_path) or ".", exist_ok=True)
    sf.write(out_path, wav, SR)
    print(f"[musicgen] wrote {out_path}  ({wav.shape[0]/SR:.1f}s @ {SR}Hz)", flush=True)


if __name__ == "__main__":
    main()
