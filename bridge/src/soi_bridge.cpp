/* soi_bridge.cpp — SoiCore method bodies + Godot binding. Glue only. */
#include "soi_bridge.h"

#include <godot_cpp/core/class_db.hpp>

extern "C" {
#include "soi_core.h"
}

using namespace godot;

SoiCore::SoiCore()
{
    world_.assign(soi_world_size(), 0);
    soi_world_init(w(), 1);
}

void SoiCore::init(int64_t seed)
{
    soi_world_init(w(), (uint32_t)seed);
}

void SoiCore::set_seed(int64_t seed)
{
    soi_set_seed(w(), (uint32_t)seed);
}

bool SoiCore::load_level(const PackedByteArray &bord)
{
    if (bord.is_empty()) return false;
    return soi_load_level(w(), bord.ptr(), (size_t)bord.size()) != 0;
}

bool SoiCore::next_level(const PackedByteArray &bord)
{
    if (bord.is_empty()) return false;
    return soi_next_level(w(), bord.ptr(), (size_t)bord.size()) != 0;
}

void SoiCore::set_player_stats(int64_t p, int64_t score, int64_t lives, int64_t arrows, int64_t balls, int64_t shield)
{
    soi_set_player_stats(w(), (int)p, (int)score, (int)lives, (int)arrows, (int)balls, (int)shield);
}

void SoiCore::tick(int64_t p1_input, int64_t p2_input)
{
    soi_tick(w(), (uint8_t)(p1_input & 0xFF), (uint8_t)(p2_input & 0xFF));
}

void SoiCore::tick3(int64_t p1_input, int64_t p2_input, int64_t p3_input)
{
    soi_tick3(w(), (uint8_t)(p1_input & 0xFF), (uint8_t)(p2_input & 0xFF), (uint8_t)(p3_input & 0xFF));
}

void SoiCore::spawn_player3() { soi_spawn_player3(w()); }
void SoiCore::limit_players(int64_t n) { soi_limit_players(w(), (int)n); }

int64_t SoiCore::player_score(int64_t p) const { return soi_player_score(w(), (int)p); }
int64_t SoiCore::player_lives(int64_t p) const { return soi_player_lives(w(), (int)p); }
int64_t SoiCore::player_mult(int64_t p) const  { return soi_player_mult(w(), (int)p); }
int64_t SoiCore::player_no_weapons_reward(int64_t p) const { return soi_player_no_weapons_reward(w(), (int)p); }
bool    SoiCore::player_alive(int64_t p) const { return soi_player_alive(w(), (int)p) != 0; }
bool    SoiCore::game_over() const             { return soi_game_over(w()) != 0; }
bool    SoiCore::level_complete() const        { return soi_level_complete(w()) != 0; }
int64_t SoiCore::player_x(int64_t p) const     { return soi_player_x(w(), (int)p); }
int64_t SoiCore::player_y(int64_t p) const     { return soi_player_y(w(), (int)p); }
int64_t SoiCore::player_arrows(int64_t p) const { return soi_player_arrows(w(), (int)p); }
int64_t SoiCore::player_balls(int64_t p) const { return soi_player_balls(w(), (int)p); }
int64_t SoiCore::player_shield(int64_t p) const { return soi_player_shield(w(), (int)p); }
int64_t SoiCore::player_facing(int64_t p) const { return soi_player_facing(w(), (int)p); }
int64_t SoiCore::player_invuln(int64_t p) const { return soi_player_invuln(w(), (int)p); }
int64_t SoiCore::player_fast(int64_t p) const { return soi_player_fast(w(), (int)p); }
int64_t SoiCore::player_has_key(int64_t p) const { return soi_player_has_key(w(), (int)p); }
int64_t SoiCore::player_state(int64_t p) const { return soi_player_state(w(), (int)p); }
int64_t SoiCore::player_movectr(int64_t p) const { return soi_player_movectr(w(), (int)p); }
int64_t SoiCore::player_pose(int64_t p) const { return soi_player_pose(w(), (int)p); }
int64_t SoiCore::player_pose_t(int64_t p) const { return soi_player_pose_t(w(), (int)p); }
int64_t SoiCore::goodies_total() const         { return soi_goodies_total(w()); }
int64_t SoiCore::goodies_left() const          { return soi_goodies_left(w()); }
int64_t SoiCore::reveal_timer() const          { return soi_reveal_timer(w()); }
int64_t SoiCore::bonus_time() const            { return soi_bonus_time(w()); }
int64_t SoiCore::tick_count() const            { return (int64_t)soi_tick_count(w()); }
int64_t SoiCore::enemy_count() const           { return soi_enemy_count(w()); }
int64_t SoiCore::projectile_count() const      { return soi_projectile_count(w()); }
int64_t SoiCore::grid_cell(int64_t c, int64_t r) const { return (int64_t)soi_grid_cell(w(), (int)c, (int)r); }

int64_t SoiCore::sfx_count() const             { return soi_sfx_count(w()); }
int64_t SoiCore::sfx_get(int64_t i) const      { return soi_sfx_get(w(), (int)i); }

bool    SoiCore::enemy_active(int64_t i) const { return soi_enemy_active(w(), (int)i) != 0; }
int64_t SoiCore::enemy_type(int64_t i) const   { return soi_enemy_type(w(), (int)i); }
int64_t SoiCore::enemy_x(int64_t i) const      { return soi_enemy_x(w(), (int)i); }
int64_t SoiCore::enemy_y(int64_t i) const      { return soi_enemy_y(w(), (int)i); }
int64_t SoiCore::enemy_dir(int64_t i) const    { return soi_enemy_dir(w(), (int)i); }
int64_t SoiCore::enemy_fire_cd(int64_t i) const { return soi_enemy_fire_cd(w(), (int)i); }
int64_t SoiCore::enemy_is_spawner(int64_t i) const { return soi_enemy_is_spawner(w(), (int)i); }
bool    SoiCore::projectile_active(int64_t i) const { return soi_projectile_active(w(), (int)i) != 0; }
int64_t SoiCore::projectile_x(int64_t i) const { return soi_projectile_x(w(), (int)i); }
int64_t SoiCore::projectile_y(int64_t i) const { return soi_projectile_y(w(), (int)i); }
bool    SoiCore::projectile_hostile(int64_t i) const { return soi_projectile_hostile(w(), (int)i) != 0; }
int64_t SoiCore::projectile_kind(int64_t i) const { return soi_projectile_kind(w(), (int)i); }
int64_t SoiCore::projectile_src_type(int64_t i) const { return soi_projectile_src_type(w(), (int)i); }

int64_t SoiCore::state_hash() const
{
    return (int64_t)soi_state_hash(w());   /* reinterpret the 64-bit hash as a Godot int */
}

PackedByteArray SoiCore::serialize() const
{
    size_t n = soi_serialize(w(), nullptr, 0);   /* measure */
    PackedByteArray out;
    out.resize((int64_t)n);
    if (n > 0)
        soi_serialize(w(), out.ptrw(), (size_t)out.size());
    return out;
}

void SoiCore::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("init", "seed"), &SoiCore::init);
    ClassDB::bind_method(D_METHOD("set_seed", "seed"), &SoiCore::set_seed);
    ClassDB::bind_method(D_METHOD("load_level", "bord"), &SoiCore::load_level);
    ClassDB::bind_method(D_METHOD("next_level", "bord"), &SoiCore::next_level);
    ClassDB::bind_method(D_METHOD("set_player_stats", "player", "score", "lives", "arrows", "balls", "shield"), &SoiCore::set_player_stats);
    ClassDB::bind_method(D_METHOD("tick", "p1_input", "p2_input"), &SoiCore::tick);
    ClassDB::bind_method(D_METHOD("tick3", "p1_input", "p2_input", "p3_input"), &SoiCore::tick3);
    ClassDB::bind_method(D_METHOD("spawn_player3"), &SoiCore::spawn_player3);
    ClassDB::bind_method(D_METHOD("limit_players", "n"), &SoiCore::limit_players);

    ClassDB::bind_method(D_METHOD("player_score", "player"), &SoiCore::player_score);
    ClassDB::bind_method(D_METHOD("player_mult", "player"), &SoiCore::player_mult);
    ClassDB::bind_method(D_METHOD("player_no_weapons_reward", "player"), &SoiCore::player_no_weapons_reward);
    ClassDB::bind_method(D_METHOD("player_lives", "player"), &SoiCore::player_lives);
    ClassDB::bind_method(D_METHOD("player_alive", "player"), &SoiCore::player_alive);
    ClassDB::bind_method(D_METHOD("game_over"), &SoiCore::game_over);
    ClassDB::bind_method(D_METHOD("level_complete"), &SoiCore::level_complete);
    ClassDB::bind_method(D_METHOD("player_x", "player"), &SoiCore::player_x);
    ClassDB::bind_method(D_METHOD("player_y", "player"), &SoiCore::player_y);
    ClassDB::bind_method(D_METHOD("player_arrows", "player"), &SoiCore::player_arrows);
    ClassDB::bind_method(D_METHOD("player_balls", "player"), &SoiCore::player_balls);
    ClassDB::bind_method(D_METHOD("player_shield", "player"), &SoiCore::player_shield);
    ClassDB::bind_method(D_METHOD("player_facing", "player"), &SoiCore::player_facing);
    ClassDB::bind_method(D_METHOD("player_invuln", "player"), &SoiCore::player_invuln);
    ClassDB::bind_method(D_METHOD("player_fast", "player"), &SoiCore::player_fast);
    ClassDB::bind_method(D_METHOD("player_has_key", "player"), &SoiCore::player_has_key);
    ClassDB::bind_method(D_METHOD("player_state", "player"), &SoiCore::player_state);
    ClassDB::bind_method(D_METHOD("player_movectr", "player"), &SoiCore::player_movectr);
    ClassDB::bind_method(D_METHOD("player_pose", "player"), &SoiCore::player_pose);
    ClassDB::bind_method(D_METHOD("player_pose_t", "player"), &SoiCore::player_pose_t);
    ClassDB::bind_method(D_METHOD("goodies_total"), &SoiCore::goodies_total);
    ClassDB::bind_method(D_METHOD("goodies_left"), &SoiCore::goodies_left);
    ClassDB::bind_method(D_METHOD("reveal_timer"), &SoiCore::reveal_timer);
    ClassDB::bind_method(D_METHOD("bonus_time"), &SoiCore::bonus_time);
    ClassDB::bind_method(D_METHOD("tick_count"), &SoiCore::tick_count);
    ClassDB::bind_method(D_METHOD("enemy_count"), &SoiCore::enemy_count);
    ClassDB::bind_method(D_METHOD("projectile_count"), &SoiCore::projectile_count);
    ClassDB::bind_method(D_METHOD("grid_cell", "col", "row"), &SoiCore::grid_cell);

    ClassDB::bind_method(D_METHOD("sfx_count"), &SoiCore::sfx_count);
    ClassDB::bind_method(D_METHOD("sfx_get", "i"), &SoiCore::sfx_get);

    ClassDB::bind_method(D_METHOD("enemy_active", "i"), &SoiCore::enemy_active);
    ClassDB::bind_method(D_METHOD("enemy_type", "i"), &SoiCore::enemy_type);
    ClassDB::bind_method(D_METHOD("enemy_x", "i"), &SoiCore::enemy_x);
    ClassDB::bind_method(D_METHOD("enemy_y", "i"), &SoiCore::enemy_y);
    ClassDB::bind_method(D_METHOD("enemy_dir", "i"), &SoiCore::enemy_dir);
    ClassDB::bind_method(D_METHOD("enemy_fire_cd", "i"), &SoiCore::enemy_fire_cd);
    ClassDB::bind_method(D_METHOD("enemy_is_spawner", "i"), &SoiCore::enemy_is_spawner);
    ClassDB::bind_method(D_METHOD("projectile_active", "i"), &SoiCore::projectile_active);
    ClassDB::bind_method(D_METHOD("projectile_x", "i"), &SoiCore::projectile_x);
    ClassDB::bind_method(D_METHOD("projectile_y", "i"), &SoiCore::projectile_y);
    ClassDB::bind_method(D_METHOD("projectile_hostile", "i"), &SoiCore::projectile_hostile);
    ClassDB::bind_method(D_METHOD("projectile_kind", "i"), &SoiCore::projectile_kind);
    ClassDB::bind_method(D_METHOD("projectile_src_type", "i"), &SoiCore::projectile_src_type);

    ClassDB::bind_method(D_METHOD("state_hash"), &SoiCore::state_hash);
    ClassDB::bind_method(D_METHOD("serialize"), &SoiCore::serialize);
}
