set defer_builds_mode, 3
set cartoon_sampling, 30
set ribbon_sampling, 30
set orthoscopic, on


cmd.set('bg_rgb',0,'',0)

load complex_tleap.prmtop, trajectory
load_traj complex_md_1.nc, trajectory, 0, nc
load_traj complex_md_2.nc, trajectory, 0, nc
preset.publication("trajectory")


cmd.intra_fit("(name CA)",-1)

set ray_opaque_background, off
#png image.png, dpi=300
