"""Publish hammer_swing_l / hammer_swing_r (status, note, tweens)."""
import collections
import json

OD = collections.OrderedDict
NOTE = ('PASS (16 frames under the kid families\' documented gate dE 17.5). The Hammer jump-smash facing %s '
        '(f%02d-f%02d; the game plays them in order over the 16 held steps of the lifted smash, the wall breaks at '
        'f%02d): a TWO-HANDED overhead swing -- the carry over the shoulder, up past the head, the horizontal strike, '
        'down-forward, back up to the shoulder. Same model and look as hammer_walk (its baked opts, copied) + '
        'hammer.py "two_hand" (the other arm copies the grip arm). Split from one family because the art puts the kid '
        'on the %s of the 36x41 frame (one placement per half; the fitted scale matches the walk within 2%%). The '
        'carry frames%s were seeded with the mallet up-back (the sweep had picked it hanging in front).')
for side, (a, b), where, seeded in (('l', (50, 65), 'right', ' f50-f53/f65'), ('r', (66, 81), 'left', ' (f78: its f62 twin)')):
    p = 'extracted/sprites_3d/hammer_swing_%s/frames.json' % side
    raw = open(p, encoding='utf-8-sig').read()
    d = json.loads(raw, object_pairs_hook=OD)
    d['status'] = 'published'
    d['note'] = NOTE % ('left' if side == 'l' else 'right', a, b, a + 10, where, seeded)
    d['tweens'] = OD([('n', 4), ('runs', [[a, b]])])
    with open(p, 'w', encoding='utf-8', newline='\n') as fh:
        fh.write(json.dumps(d, indent=1) + '\n')
    print('published', p)
