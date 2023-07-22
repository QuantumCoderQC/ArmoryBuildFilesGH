import sys, os
import bpy
import arm, arm.utils
import arm.make_state as state

target = 'html5'

wrd = bpy.data.worlds['Arm']

wrd.arm_exporterlist.add()
wrd.arm_exporterlist[wrd.arm_exporterlist_index].name = 'Temp'
wrd.arm_exporterlist[wrd.arm_exporterlist_index].arm_project_target = target
wrd.arm_exporterlist[wrd.arm_exporterlist_index].arm_project_scene = bpy.context.scene
wrd.arm_exporterlist_index = len(wrd.arm_exporterlist) - 1

bpy.ops.arm.clean_project()
bpy.ops.arm.build_project()
bpy.ops.arm.publish_project()
code = state.proc_build.poll()
sys.exit(code)
