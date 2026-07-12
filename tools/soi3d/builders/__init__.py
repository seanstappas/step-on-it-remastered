"""soi3d.builders -- one self-registering module per sprite family (auto-discovered by soi3d.discover()).

Drop a new <family>.py here that defines an @register("<family>") function taking the argv after the
mode (args[0] = out path) and returning the out path. Reuse soi3d.common for shared geometry/materials;
keep geometry unique to this sprite local to the module. No other file needs editing.
"""
