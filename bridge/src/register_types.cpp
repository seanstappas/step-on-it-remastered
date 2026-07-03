/* register_types.cpp — GDExtension entry point. Registers SoiCore with Godot. */
#include "soi_bridge.h"

#include <godot_cpp/core/class_db.hpp>
#include <godot_cpp/core/defs.hpp>
#include <godot_cpp/godot.hpp>

using namespace godot;

static void soi_initialize(ModuleInitializationLevel level)
{
    if (level != MODULE_INITIALIZATION_LEVEL_SCENE) return;
    ClassDB::register_class<SoiCore>();
}

static void soi_terminate(ModuleInitializationLevel level)
{
    (void)level;
}

extern "C" {
/* Entry symbol referenced by godot_project/soi.gdextension. */
GDExtensionBool GDE_EXPORT soi_library_init(GDExtensionInterfaceGetProcAddress p_get_proc_address,
                                            const GDExtensionClassLibraryPtr p_library,
                                            GDExtensionInitialization *r_initialization)
{
    GDExtensionBinding::InitObject init_obj(p_get_proc_address, p_library, r_initialization);
    init_obj.register_initializer(soi_initialize);
    init_obj.register_terminator(soi_terminate);
    init_obj.set_minimum_library_initialization_level(MODULE_INITIALIZATION_LEVEL_SCENE);
    return init_obj.init();
}
}
