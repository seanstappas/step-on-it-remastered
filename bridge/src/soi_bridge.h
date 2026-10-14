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
    bool next_level(const PackedByteArray &bord);
    void set_player_stats(int64_t p, int64_t score, int64_t lives, int64_t arrows, int64_t balls, int64_t shield);
    void set_play_mode(int64_t mode);   /* 1 One, 2 Alternate, 3 Cooperate (shared pool), 4 Compete, 5 Versus */
    int64_t play_mode() const;
    void set_friendly_fire(bool on);
    bool friendly_fire() const;
    void set_victory_rule(int64_t rule);
    int64_t victory_rule() const;
    int64_t player_kills(int64_t player) const;
    int64_t versus_winner() const;
    void new_game(int64_t mode);        /* set the mode + apply the new-game stats (FUN_1002b060) */
    bool challenge_round() const;       /* board holds a Knight/Gargoyle (FUN_10017a70) */
    bool challenge_failed() const;      /* challenge round lost: every active player is down */
    void set_input_assist(bool on);
    void abort_game();

    /* one deterministic logic frame */
    void tick(int64_t p1_input, int64_t p2_input);
    void tick3(int64_t p1_input, int64_t p2_input, int64_t p3_input);
    void spawn_player3();   /* remaster: activate the 3rd co-op player */
    void limit_players(int64_t n);   /* deactivate players beyond n (1-player: turn P2 off) */

    /* read-only state (player 1 = P1, 2 = P2) */
    int64_t player_score(int64_t player) const;
    int64_t player_lives(int64_t player) const;
    int64_t player_mult(int64_t player) const;
    int64_t player_no_weapons_reward(int64_t player) const;
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
    int64_t player_jump_t(int64_t player) const;
    int64_t player_frame(int64_t player) const;
    int64_t goodies_total() const;
    int64_t goodies_left() const;
    int64_t reveal_timer() const;
    int64_t bonus_time() const;
    int64_t player_bonus(int64_t player) const;
    bool music_hurry() const;
    int64_t tick_count() const;
    int64_t enemy_count() const;
    int64_t projectile_count() const;
    int64_t grid_cell(int64_t col, int64_t row) const;
    int64_t grid_cols() const;
    int64_t grid_rows() const;
    int64_t pit_death_y() const;

    /* sound events queued during the last tick (drain each frame) */
    int64_t sfx_count() const;
    int64_t sfx_get(int64_t i) const;

    /* enemy-death effects queued during the last tick (drives the cosmetic death "pop") */
    int64_t death_count() const;
    int64_t death_x(int64_t i) const;
    int64_t death_y(int64_t i) const;
    int64_t death_type(int64_t i) const;
    int64_t death_dir(int64_t i) const;
    int64_t fx_count() const;
    int64_t fx_get(int64_t i, int64_t field) const;
    int64_t blockanim(int64_t i) const;

    /* per-entity read accessors (index into the pools; for rendering) */
    bool    enemy_active(int64_t i) const;
    int64_t enemy_type(int64_t i) const;
    int64_t enemy_x(int64_t i) const;
    int64_t enemy_y(int64_t i) const;
    int64_t enemy_dir(int64_t i) const;
    int64_t enemy_fire_cd(int64_t i) const;
    int64_t enemy_turn(int64_t i) const;
    int64_t enemy_bud(int64_t i) const;
    int64_t enemy_anim(int64_t i) const;
    bool enemy_vertical(int64_t i) const;
    int64_t enemy_is_spawner(int64_t i) const;
    bool    projectile_active(int64_t i) const;
    int64_t projectile_x(int64_t i) const;
    int64_t projectile_y(int64_t i) const;
    bool    projectile_hostile(int64_t i) const;
    int64_t projectile_kind(int64_t i) const;
    int64_t projectile_src_type(int64_t i) const;
    int64_t projectile_pierce(int64_t i) const;
    bool projectile_fired_left(int64_t i) const;

    /* determinism helpers for netcode / verification */
    int64_t          state_hash() const;   /* FNV-1a 64 as a Godot int */
    PackedByteArray  serialize() const;

    /* rollback snapshot & netcode hash */
    int64_t          snapshot_size() const;
    PackedByteArray  snapshot_save() const;
    void             snapshot_load(const PackedByteArray &buf);
    int64_t          net_hash() const;
    int64_t          tp_freeze() const;
    int64_t          switch_block_frame(int64_t col, int64_t row) const;
};

} // namespace godot

#endif // SOI_BRIDGE_H
