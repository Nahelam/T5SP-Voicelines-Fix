init()
{
    if (isDefined(level.pvox))
    {
        setup_players_sound_dialog_array();
        level thread on_player_connected();
    }

    if (isDefined(level.dvox))
    {
        setup_director_sound_dialog_array();

        level._director_zombie_enter_level = level.director_zombie_enter_level;
        level.director_zombie_enter_level = ::assign_director_sound_dialog_array;
    }
}

assign_director_sound_dialog_array()
{
    self.sound_dialog = level.director_sound_dialog;
    self.sound_dialog_available = self.sound_dialog;

    self [[level._director_zombie_enter_level]]();
}

on_player_connected()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread assign_player_sound_dialog_array();
    }
}

assign_player_sound_dialog_array()
{
    self waittill("spawned_player");

    while (!self.initialized)
    {
        wait 0.05;
    }

    self.sound_dialog = level.players_sound_dialog[self.entity_num];
    self.sound_dialog_available = self.sound_dialog;
}

setup_players_sound_dialog_array()
{
    level.players_sound_dialog = [];

    for (i = 0; i < level.pvox.size; i++)
    {
        level.players_sound_dialog[i] = [];
        keys = GetArrayKeys(level.pvox[i]);

        for (j = 0; j < keys.size; j++)
        {
            level.players_sound_dialog[i][keys[j]] = [];
            nb_variants = level.pvox[i][keys[j]];

            for (k = 0; k < nb_variants; k++)
            {
                level.players_sound_dialog[i][keys[j]][k] = k;
            }
        }
    }
}

setup_director_sound_dialog_array()
{
    level.director_sound_dialog = [];

    keys = GetArrayKeys(level.dvox);
    for (i = 0; i < keys.size; i++)
    {
        level.director_sound_dialog[keys[i]] = [];
        nb_variants = level.dvox[keys[i]];

        for (j = 0; j < nb_variants; j++)
        {
            level.director_sound_dialog[keys[i]][j] = j;
        }
    }
}

