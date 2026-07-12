import sys, mido
GM = {0: "Ac.Grand", 6: "Harpsichord", 7: "Clavi", 11: "Vibraphone", 16: "DrawbarOrg",
      20: "ReedOrg", 24: "NylonGtr", 29: "OverdriveGtr", 30: "DistGtr", 36: "SlapBass",
      48: "Strings", 52: "ChoirAahs", 61: "BrassSect", 62: "SynBrass", 66: "TenorSax",
      68: "Oboe", 81: "SawLead", 87: "BassLead", 88: "NewAgePad", 90: "WarmPad"}
path = sys.argv[1]
win = (float(sys.argv[2]), float(sys.argv[3])) if len(sys.argv) > 3 else None
mid = mido.MidiFile(path)
prog, notes = {}, {}
t = 0.0
for msg in mid:
    t += msg.time
    if msg.type == "program_change":
        prog[msg.channel] = msg.program
    if msg.type == "note_on" and msg.velocity > 0:
        notes.setdefault(msg.channel, []).append((t, msg.note))
print("channel | program | #notes | pitchrange | first_note_t")
for ch in sorted(notes):
    ns = notes[ch]; pits = [n for _, n in ns]; p = prog.get(ch, 0)
    print("  ch%2d | %3d %-11s | %4d | %3d-%3d | %.1fs" %
          (ch, p, GM.get(p, ""), len(ns), min(pits), max(pits), ns[0][0]))
if win:
    print("\n--- notes starting in %.1f-%.1fs (t, ch, prog, pitch) ---" % win)
    rows = []
    for ch in sorted(notes):
        for (nt, pit) in notes[ch]:
            if win[0] <= nt <= win[1]:
                rows.append((nt, ch, prog.get(ch, 0), pit))
    for nt, ch, p, pit in sorted(rows):
        print("  %5.2fs ch%d prog%d(%s) pitch%d" % (nt, ch, p, GM.get(p, ""), pit))
