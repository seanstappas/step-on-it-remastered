"""Create extracted/sprites_3d/hammer_swing_{l,r}/frames.json from the published hammer_walk config.

The jump-smash art puts the kid on the RIGHT of the 36x41 frame when it swings left (f50-f65) and on the LEFT
when it swings right (f66-f81), so each half needs its own placement -> two families (like the Beenie shots).
"""
import collections
import json
import os

OD = collections.OrderedDict
src = json.load(open('extracted/sprites_3d/hammer_walk/frames.json', encoding='utf-8-sig'), object_pairs_hook=OD)
for side, (a, b), yaw in (('l', (50, 65), 0), ('r', (66, 81), 180)):
    d = OD()
    d['status'] = 'wip'
    d['source'] = 'hammer_sprites'
    d['frames'] = {'range': [a, b]}
    d['mode'] = 'hammer'
    d['note'] = ('WIP: the Hammer jump-smash facing %s (f%02d-f%02d; the game plays them in order over the 16 held '
                 'steps, the strike at f%02d). A two-handed overhead swing: carry -> up -> horizontal strike -> '
                 'down-forward -> back to the shoulder. Same model and look as hammer_walk (opts copied) + hammer.py '
                 '"two_hand".' % ('left' if side == 'l' else 'right', a, b, a + 10))
    for k in ('place_iou_w', 'shift', 'shift_range'):
        d[k] = src[k]
    o = OD(src['opts'])
    o['two_hand'] = True
    d['opts'] = o
    d['sweep'] = [
        {'param': 'yaw', 'start': yaw - 30, 'stop': yaw + 30, 'step': 30},
        {'param': 's_f', 'start': 0, 'stop': 180, 'step': 30},
        {'param': 'e_f', 'start': -20, 'stop': 100, 'step': 60},
        {'param': 'ham', 'start': -180, 'stop': 30, 'step': 30}]
    d['prior'] = [{'frames': [a, b], 'param': 'yaw', 'value': yaw, 'tol': 20, 'period': 360}]
    d['smooth'] = {'yaw': 'free', 's_f': 'free', 'e_f': 'free', 'ham': 'free'}
    op = src['optim']
    d['optim'] = OD([
        ('params', OD([
            ('yaw', {'step': 6, 'min': yaw - 40, 'max': yaw + 40}),
            ('s_f', {'step': 12, 'min': -60, 'max': 240}),
            ('e_f', {'step': 12, 'min': -40, 'max': 150}),
            ('ham', {'step': 10, 'min': -270, 'max': 90}),
            ('t_n', {'step': 10, 'min': -70, 'max': 90, 'init': 0}),
            ('t_f', {'step': 10, 'min': -70, 'max': 90, 'init': 0}),
            ('k_n', {'step': 10, 'min': -20, 'max': 120, 'init': 0}),
            ('k_f', {'step': 10, 'min': -20, 'max': 120, 'init': 0})])),
        ('rounds', op['rounds']), ('scale', op['scale']), ('samples', op['samples']), ('finish', op['finish'])])
    for k in ('scale', 'samples', 'post', 'gate', 'fps'):
        d[k] = src[k]
    p = 'extracted/sprites_3d/hammer_swing_%s' % side
    os.makedirs(p, exist_ok=True)
    with open(p + '/frames.json', 'w', encoding='utf-8', newline='\n') as fh:
        fh.write(json.dumps(d, indent=1) + '\n')
    print('ok', p)
