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

void    SoiCore::set_play_mode(int64_t mode) { soi_set_play_mode(w(), (int)mode); }
int64_t SoiCore::play_mode() const          { return soi_play_mode(w()); }
void    SoiCore::set_friendly_fire(bool on)  { soi_set_friendly_fire(w(), on ? 1 : 0); }
bool    SoiCore::friendly_fire() const       { return soi_friendly_fire(w()) != 0; }
void    SoiCore::set_victory_rule(int64_t r) { soi_set_victory_rule(w(), (int)r); }
int64_t SoiCore::victory_rule() const        { return (int64_t)soi_victory_rule(w()); }
int64_t SoiCore::player_kills(int64_t p) const { return (int64_t)soi_player_kills(w(), (int)p); }
int64_t SoiCore::versus_winner() const       { return (int64_t)soi_versus_winner(w()); }
void    SoiCore::new_game(int64_t mode)      { soi_new_game(w(), (int)mode); }
bool    SoiCore::challenge_round() const    { return soi_challenge_round(w()) != 0; }
bool    SoiCore::challenge_failed() const   { return soi_challenge_failed(w()) != 0; }
void    SoiCore::set_input_assist(bool on)  { soi_set_input_assist(w(), on ? 1 : 0); }
void    SoiCore::abort_game()               { soi_abort_game(w()); }

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
int64_t SoiCore::player_jump_t(int64_t p) const { return soi_player_jump_t(w(), (int)p); }
int64_t SoiCore::player_frame(int64_t p) const { return soi_player_frame(w(), (int)p); }
int64_t SoiCore::goodies_total() const         { return soi_goodies_total(w()); }
int64_t SoiCore::goodies_left() const          { return soi_goodies_left(w()); }
int64_t SoiCore::reveal_timer() const          { return soi_reveal_timer(w()); }
int64_t SoiCore::bonus_time() const            { return soi_bonus_time(w()); }
int64_t SoiCore::player_bonus(int64_t p) const { return soi_player_bonus(w(), (int)p); }
bool    SoiCore::music_hurry() const           { return soi_music_hurry(w()) != 0; }
int64_t SoiCore::tick_count() const            { return (int64_t)soi_tick_count(w()); }
int64_t SoiCore::enemy_count() const           { return soi_enemy_count(w()); }
int64_t SoiCore::projectile_count() const      { return soi_projectile_count(w()); }
int64_t SoiCore::grid_cell(int64_t c, int64_t r) const { return (int64_t)soi_grid_cell(w(), (int)c, (int)r); }
int64_t SoiCore::grid_cols() const              { return (int64_t)soi_grid_cols(w()); }
int64_t SoiCore::grid_rows() const              { return (int64_t)soi_grid_rows(w()); }
int64_t SoiCore::pit_death_y() const            { return (int64_t)soi_pit_death_y(w()); }

int64_t SoiCore::sfx_count() const             { return soi_sfx_count(w()); }
int64_t SoiCore::sfx_get(int64_t i) const      { return soi_sfx_get(w(), (int)i); }

int64_t SoiCore::death_count() const           { return soi_death_count(w()); }
int64_t SoiCore::death_x(int64_t i) const      { return soi_death_x(w(), (int)i); }
int64_t SoiCore::death_y(int64_t i) const      { return soi_death_y(w(), (int)i); }
int64_t SoiCore::death_type(int64_t i) const   { return soi_death_type(w(), (int)i); }
int64_t SoiCore::death_dir(int64_t i) const    { return soi_death_dir(w(), (int)i); }
int64_t SoiCore::fx_count() const              { return soi_fx_count(w()); }
int64_t SoiCore::fx_get(int64_t i, int64_t f) const { return soi_fx_get(w(), (int)i, (int)f); }
int64_t SoiCore::blockanim(int64_t i) const    { return soi_blockanim(w(), (int)i); }

bool    SoiCore::enemy_active(int64_t i) const { return soi_enemy_active(w(), (int)i) != 0; }
int64_t SoiCore::enemy_type(int64_t i) const   { return soi_enemy_type(w(), (int)i); }
int64_t SoiCore::enemy_x(int64_t i) const      { return soi_enemy_x(w(), (int)i); }
int64_t SoiCore::enemy_y(int64_t i) const      { return soi_enemy_y(w(), (int)i); }
int64_t SoiCore::enemy_dir(int64_t i) const    { return soi_enemy_dir(w(), (int)i); }
int64_t SoiCore::enemy_fire_cd(int64_t i) const { return soi_enemy_fire_cd(w(), (int)i); }
int64_t SoiCore::enemy_turn(int64_t i) const { return soi_enemy_turn(w(), (int)i); }
int64_t SoiCore::enemy_bud(int64_t i) const { return soi_enemy_bud(w(), (int)i); }
int64_t SoiCore::enemy_anim(int64_t i) const { return soi_enemy_anim(w(), (int)i); }
bool SoiCore::enemy_vertical(int64_t i) const { return soi_enemy_vertical(w(), (int)i) != 0; }
int64_t SoiCore::enemy_is_spawner(int64_t i) const { return soi_enemy_is_spawner(w(), (int)i); }
bool    SoiCore::projectile_active(int64_t i) const { return soi_projectile_active(w(), (int)i) != 0; }
int64_t SoiCore::projectile_x(int64_t i) const { return soi_projectile_x(w(), (int)i); }
int64_t SoiCore::projectile_y(int64_t i) const { return soi_projectile_y(w(), (int)i); }
bool    SoiCore::projectile_hostile(int64_t i) const { return soi_projectile_hostile(w(), (int)i) != 0; }
int64_t SoiCore::projectile_kind(int64_t i) const { return soi_projectile_kind(w(), (int)i); }
int64_t SoiCore::projectile_src_type(int64_t i) const { return soi_projectile_src_type(w(), (int)i); }
int64_t SoiCore::projectile_pierce(int64_t i) const { return soi_projectile_pierce(w(), (int)i); }
bool SoiCore::projectile_fired_left(int64_t i) const { return soi_projectile_fired_left(w(), (int)i) != 0; }

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

int64_t SoiCore::snapshot_size() const
{
    return (int64_t)soi_snapshot_size();
}

PackedByteArray SoiCore::snapshot_save() const
{
    PackedByteArray out;
    out.resize((int64_t)soi_snapshot_size());
    soi_snapshot_save(w(), out.ptrw());
    return out;
}

void SoiCore::snapshot_load(const PackedByteArray &buf)
{
    if (buf.size() >= (int64_t)soi_snapshot_size()) {
        soi_snapshot_load(w(), buf.ptr());
    }
}

int64_t SoiCore::net_hash() const
{
    return (int64_t)soi_net_hash(w());
}

int64_t SoiCore::tp_freeze() const
{
    return (int64_t)soi_tp_freeze(w());
}

int64_t SoiCore::switch_block_frame(int64_t col, int64_t row) const
{
    return (int64_t)soi_switch_block_frame(w(), (int)col, (int)row);
}


void SoiCore::_bind_methods()
{
    ClassDB::bind_method(D_METHOD("init", "seed"), &SoiCore::init);
    ClassDB::bind_method(D_METHOD("set_seed", "seed"), &SoiCore::set_seed);
    ClassDB::bind_method(D_METHOD("load_level", "bord"), &SoiCore::load_level);
    ClassDB::bind_method(D_METHOD("next_level", "bord"), &SoiCore::next_level);
    ClassDB::bind_method(D_METHOD("set_player_stats", "player", "score", "lives", "arrows", "balls", "shield"), &SoiCore::set_player_stats);
    ClassDB::bind_method(D_METHOD("set_play_mode", "mode"), &SoiCore::set_play_mode);
    ClassDB::bind_method(D_METHOD("play_mode"), &SoiCore::play_mode);
    ClassDB::bind_method(D_METHOD("set_friendly_fire", "on"), &SoiCore::set_friendly_fire);
    ClassDB::bind_method(D_METHOD("friendly_fire"), &SoiCore::friendly_fire);
    ClassDB::bind_method(D_METHOD("set_victory_rule", "rule"), &SoiCore::set_victory_rule);
    ClassDB::bind_method(D_METHOD("victory_rule"), &SoiCore::victory_rule);
    ClassDB::bind_method(D_METHOD("player_kills", "player"), &SoiCore::player_kills);
    ClassDB::bind_method(D_METHOD("versus_winner"), &SoiCore::versus_winner);
    ClassDB::bind_method(D_METHOD("new_game", "mode"), &SoiCore::new_game);
    ClassDB::bind_method(D_METHOD("challenge_round"), &SoiCore::challenge_round);
    ClassDB::bind_method(D_METHOD("challenge_failed"), &SoiCore::challenge_failed);
    ClassDB::bind_method(D_METHOD("set_input_assist", "on"), &SoiCore::set_input_assist);
    ClassDB::bind_method(D_METHOD("abort_game"), &SoiCore::abort_game);
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
    ClassDB::bind_method(D_METHOD("player_jump_t", "player"), &SoiCore::player_jump_t);
    ClassDB::bind_method(D_METHOD("player_frame", "player"), &SoiCore::player_frame);
    ClassDB::bind_method(D_METHOD("goodies_total"), &SoiCore::goodies_total);
    ClassDB::bind_method(D_METHOD("goodies_left"), &SoiCore::goodies_left);
    ClassDB::bind_method(D_METHOD("reveal_timer"), &SoiCore::reveal_timer);
    ClassDB::bind_method(D_METHOD("bonus_time"), &SoiCore::bonus_time);
    ClassDB::bind_method(D_METHOD("player_bonus", "player"), &SoiCore::player_bonus);
    ClassDB::bind_method(D_METHOD("music_hurry"), &SoiCore::music_hurry);
    ClassDB::bind_method(D_METHOD("tick_count"), &SoiCore::tick_count);
    ClassDB::bind_method(D_METHOD("enemy_count"), &SoiCore::enemy_count);
    ClassDB::bind_method(D_METHOD("projectile_count"), &SoiCore::projectile_count);
    ClassDB::bind_method(D_METHOD("grid_cell", "col", "row"), &SoiCore::grid_cell);
    ClassDB::bind_method(D_METHOD("grid_cols"), &SoiCore::grid_cols);
    ClassDB::bind_method(D_METHOD("grid_rows"), &SoiCore::grid_rows);
    ClassDB::bind_method(D_METHOD("pit_death_y"), &SoiCore::pit_death_y);

    ClassDB::bind_method(D_METHOD("sfx_count"), &SoiCore::sfx_count);
    ClassDB::bind_method(D_METHOD("sfx_get", "i"), &SoiCore::sfx_get);
    ClassDB::bind_method(D_METHOD("death_count"), &SoiCore::death_count);
    ClassDB::bind_method(D_METHOD("death_x", "i"), &SoiCore::death_x);
    ClassDB::bind_method(D_METHOD("death_y", "i"), &SoiCore::death_y);
    ClassDB::bind_method(D_METHOD("death_type", "i"), &SoiCore::death_type);
    ClassDB::bind_method(D_METHOD("death_dir", "i"), &SoiCore::death_dir);
    ClassDB::bind_method(D_METHOD("fx_count"), &SoiCore::fx_count);
    ClassDB::bind_method(D_METHOD("fx_get", "i", "field"), &SoiCore::fx_get);
    ClassDB::bind_method(D_METHOD("blockanim", "i"), &SoiCore::blockanim);

    ClassDB::bind_method(D_METHOD("enemy_active", "i"), &SoiCore::enemy_active);
    ClassDB::bind_method(D_METHOD("enemy_type", "i"), &SoiCore::enemy_type);
    ClassDB::bind_method(D_METHOD("enemy_x", "i"), &SoiCore::enemy_x);
    ClassDB::bind_method(D_METHOD("enemy_y", "i"), &SoiCore::enemy_y);
    ClassDB::bind_method(D_METHOD("enemy_dir", "i"), &SoiCore::enemy_dir);
    ClassDB::bind_method(D_METHOD("enemy_fire_cd", "i"), &SoiCore::enemy_fire_cd);
    ClassDB::bind_method(D_METHOD("enemy_turn", "i"), &SoiCore::enemy_turn);
    ClassDB::bind_method(D_METHOD("enemy_bud", "i"), &SoiCore::enemy_bud);
    ClassDB::bind_method(D_METHOD("enemy_anim", "i"), &SoiCore::enemy_anim);
    ClassDB::bind_method(D_METHOD("enemy_vertical", "i"), &SoiCore::enemy_vertical);
    ClassDB::bind_method(D_METHOD("enemy_is_spawner", "i"), &SoiCore::enemy_is_spawner);
    ClassDB::bind_method(D_METHOD("projectile_active", "i"), &SoiCore::projectile_active);
    ClassDB::bind_method(D_METHOD("projectile_x", "i"), &SoiCore::projectile_x);
    ClassDB::bind_method(D_METHOD("projectile_y", "i"), &SoiCore::projectile_y);
    ClassDB::bind_method(D_METHOD("projectile_hostile", "i"), &SoiCore::projectile_hostile);
    ClassDB::bind_method(D_METHOD("projectile_kind", "i"), &SoiCore::projectile_kind);
    ClassDB::bind_method(D_METHOD("projectile_src_type", "i"), &SoiCore::projectile_src_type);
    ClassDB::bind_method(D_METHOD("projectile_pierce", "i"), &SoiCore::projectile_pierce);
    ClassDB::bind_method(D_METHOD("projectile_fired_left", "i"), &SoiCore::projectile_fired_left);

    ClassDB::bind_method(D_METHOD("state_hash"), &SoiCore::state_hash);
    ClassDB::bind_method(D_METHOD("serialize"), &SoiCore::serialize);

    ClassDB::bind_method(D_METHOD("snapshot_size"), &SoiCore::snapshot_size);
    ClassDB::bind_method(D_METHOD("snapshot_save"), &SoiCore::snapshot_save);
    ClassDB::bind_method(D_METHOD("snapshot_load", "buf"), &SoiCore::snapshot_load);
    ClassDB::bind_method(D_METHOD("net_hash"), &SoiCore::net_hash);
    ClassDB::bind_method(D_METHOD("tp_freeze"), &SoiCore::tp_freeze);
    ClassDB::bind_method(D_METHOD("switch_block_frame", "col", "row"), &SoiCore::switch_block_frame);
}
