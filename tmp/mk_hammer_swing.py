"""Create extracted/sprites_3d/hammer_swing/frames.json from the published hammer_walk config."""
import collections
import json
import os

OD = collections.OrderedDict
src = json.load(open('extracted/sprites_3d/hammer_walk/frames.json', encoding='utf-8-sig'), object_pairs_hook=OD)
d = OD()
d['status'] = 'wip'
d['source'] = 'hammer_sprites'
d['frames'] = {'range': [50, 81]}
d['mode'] = 'hammer'
d['note'] = ('WIP: the Hammer jump-smash (f50-f65 facing left, f66-f81 facing right; the game plays them in order '
             'over the 16 held steps, the strike at f60/f76). A two-handed overhead swing: carry (f50) -> up (f57) -> '
             'horizontal strike (f60) -> down-forward (f61) -> back to the shoulder (f65). Same model and look as '
             'hammer_walk (opts copied) + hammer.py "two_hand".')
for k in ('place_iou_w', 'shift', 'shift_range'):
    d[k] = src[k]
o = OD(src['opts'])
o['two_hand'] = True
d['opts'] = o
d['sweep'] = [
    {'param': 'yaw', 'start': 0, 'stop': 360, 'step': 180, 'period': 360},
    {'param': 's_f', 'start': 0, 'stop': 180, 'step': 30},
    {'param': 'e_f', 'start': -20, 'stop': 100, 'step': 60},
    {'param': 'ham', 'start': -180, 'stop': 30, 'step': 30}]
d['prior'] = [
    {'frames': [50, 65], 'param': 'yaw', 'value': 0, 'tol': 20, 'period': 360},
    {'frames': [66, 81], 'param': 'yaw', 'value': 180, 'tol': 20, 'period': 360}]
d['smooth'] = {'yaw': 'free', 's_f': 'free', 'e_f': 'free', 'ham': 'free'}
op = src['optim']
d['optim'] = OD([
    ('params', OD([
        ('yaw', {'step': 6, 'min': -40, 'max': 220}),
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
os.makedirs('extracted/sprites_3d/hammer_swing', exist_ok=True)
with open('extracted/sprites_3d/hammer_swing/frames.json', 'w', encoding='utf-8', newline='\n') as fh:
    fh.write(json.dumps(d, indent=1) + '\n')
print('ok', len(o))
