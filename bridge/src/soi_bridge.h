/* soi_bridge.h — godot-cpp GDExtension wrapper around the C core.
 *
 * This is glue ONLY (MASTER_PLAN §5.4): it owns a SoiWorld buffer and forwards
 * calls to the freestanding C core. No game logic lives here. Exposed to Godot
 * (GDScript) as a RefCounted `SoiCore`.
 */
#ifndef SOI_BRIDGE_H
#define SOI_BRIDGE_H

#include <godot_cpp/classes/ref_counted.hpp>
#include <godot_cpp/variant/packed_byte_array.hpp>

#include <vector>

extern "C" {
#include "soi_core.h"
}

namespace godot {

class SoiCore : public RefCounted {
    GDCLASS(SoiCore, RefCounted)

    std::vector<uint8_t> world_;   // storage for the C core's SoiWorld
    SoiWorld *w() { return reinterpret_cast<SoiWorld *>(world_.data()); }
    const SoiWorld *w() const { return reinterpret_cast<const SoiWorld *>(world_.data()); }

protected:
    static void _bind_methods();

public:
    SoiCore();
    ~SoiCore() override = default;

    /* lifecycle */
    void init(int64_t seed);
    void set_seed(int64_t seed);
    bool load_level(const PackedByteArray &bord);

    /* one deterministic logic frame */
    void tick(int64_t p1_input, int64_t p2_input);

    /* read-only state (player 1 = P1, 2 = P2) */
    int64_t player_score(int64_t player) const;
    int64_t player_lives(int64_t player) const;
    bool    player_alive(int64_t player) const;
    bool    game_over() const;
    bool    level_complete() const;
    int64_t player_x(int64_t player) const;
    int64_t player_y(int64_t player) const;
    int64_t player_arrows(int64_t player) const;
    int64_t player_balls(int64_t player) const;
    int64_t player_shield(int64_t player) const;
    int64_t player_facing(int64_t player) const;
    int64_t player_invuln(int64_t player) const;
    int64_t player_fast(int64_t player) const;
    int64_t player_has_key(int64_t player) const;
    int64_t player_state(int64_t player) const;
    int64_t player_movectr(int64_t player) const;
    int64_t player_pose(int64_t player) const;
    int64_t player_pose_t(int64_t player) const;
    int64_t goodies_total() const;
    int64_t goodies_left() const;
    int64_t bonus_time() const;
    int64_t tick_count() const;
    int64_t enemy_count() const;
    int64_t projectile_count() const;
    int64_t grid_cell(int64_t col, int64_t row) const;

    /* sound events queued during the last tick (drain each frame) */
    int64_t sfx_count() const;
    int64_t sfx_get(int64_t i) const;

    /* per-entity read accessors (index into the pools; for rendering) */
    bool    enemy_active(int64_t i) const;
    int64_t enemy_type(int64_t i) const;
    int64_t enemy_x(int64_t i) const;
    int64_t enemy_y(int64_t i) const;
    int64_t enemy_dir(int64_t i) const;
    int64_t enemy_fire_cd(int64_t i) const;
    bool    projectile_active(int64_t i) const;
    int64_t projectile_x(int64_t i) const;
    int64_t projectile_y(int64_t i) const;
    bool    projectile_hostile(int64_t i) const;
    int64_t projectile_kind(int64_t i) const;
    int64_t projectile_src_type(int64_t i) const;

    /* determinism helpers for netcode / verification */
    int64_t          state_hash() const;   /* FNV-1a 64 as a Godot int */
    PackedByteArray  serialize() const;
};

} // namespace godot

#endif // SOI_BRIDGE_H
