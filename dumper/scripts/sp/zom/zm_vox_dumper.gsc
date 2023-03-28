init()
{
    level.map_list = [];
    level.map_list[level.map_list.size] = "zombie_theater";
    level.map_list[level.map_list.size] = "zombie_pentagon";
    level.map_list[level.map_list.size] = "zombie_cosmodrome";
    level.map_list[level.map_list.size] = "zombie_coast";
    level.map_list[level.map_list.size] = "zombie_temple";
    level.map_list[level.map_list.size] = "zombie_moon";
    level.map_list[level.map_list.size] = "zombie_cod5_prototype";
    level.map_list[level.map_list.size] = "zombie_cod5_asylum";
    level.map_list[level.map_list.size] = "zombie_cod5_sumpf";
    level.map_list[level.map_list.size] = "zombie_cod5_factory";

    level.vox_dump_map_index = GetDvarInt("vox_dump_map_index");

    if(!isDefined(level.vox_dump_map_index))
    {
        level.vox_dump_map_idx = 0;
        SetDvar("vox_dump_map_index", level.vox_dump_map_index);
    }

    level thread on_player_connected();
}

on_player_connected()
{
    for (;;)
    {
        level waittill("connected", player);
        player thread on_player_spawned();
    }
}

on_player_spawned()
{
    self waittill("spawned_player");
    self developer_check();
    wait 5;
    self EnableInvulnerability();
    self vox_dump();
    wait 2;
    self next_map();
}

next_map()
{
    level.vox_dump_map_index++;

    if (level.vox_dump_map_index == level.map_list.size)
    {
        SetDvar("vox_dump_map_index", 0);
        self iPrintLn("vox dump done for all maps, exiting...");
        print("++++++++ Vox dump done for all maps, exiting... ++++++++");
        wait 2;
        ExitLevel(false);
    }

    else
    {
        next_map = level.map_list[level.vox_dump_map_index];
        SetDvar("vox_dump_map_index", level.vox_dump_map_index);
        self iPrintLn("switching to " + next_map);
        wait 2;
        ChangeLevel(next_map);
    }
}

developer_check()
{
    if (GetDvarInt("developer") <= 0)
    {
        wait 5;
        self iPrintLn("developer dvar not set");
        wait 2;
        self SetClientDvar("developer", 1);
        countdown = 3;
        for(; countdown > 0; countdown--)
        {
            self iPrintLn("restarting in " + countdown);
            wait 1;
        }
        map_restart();
    }
}

vox_dump()
{
    self iPrintLn("vox dump started, please wait...");

    begin = "-----------------------------------------------------------BEGIN\n";
    info = "Map: " + level.script + "\n";
    end = "-------------------------------------------------------------END\n";
    tab = "\t";
    plr_vox_array_str = "level.pvox";

    nb_characters = 4;
    plr_vox_variants = [];

    for (i = 0; i < nb_characters; i++)
    {
        plr_vox_variants[i] = [];
    }

    prefix = level.plr_vox["prefix"];
    keys = GetArrayKeys(level.plr_vox);

    for (i = 0; i < keys.size; i++)
    {
        if (keys[i] == "prefix")
        {
            continue;
        }

        sub_keys = GetArrayKeys(level.plr_vox[keys[i]]);

        for (j = 0; j < sub_keys.size; j++)
        {
            alias = level.plr_vox[keys[i]][sub_keys[j]];

            for (k = 0; k < plr_vox_variants.size; k++)
            {
                full_name = prefix + k + "_" + alias;
                nb_variants = maps\_zombiemode_spawner::get_number_variants(full_name);

                if (nb_variants > 0)
                {
                    plr_vox_variants[k][alias] = nb_variants;
                }

                wait 0.05;
            }
        }
    }

    print(begin + info + "main()\n{\n" + tab + plr_vox_array_str + " = [];");
    output = "";

    for (i = 0; i < plr_vox_variants.size; i++)
    {
        line_begin = plr_vox_array_str + "[" + i + "]";
        output += (tab + line_begin + " = [];\n");

        keys = GetArrayKeys(plr_vox_variants[i]);
        keys = maps\_utility::alphabetize(keys);

        for (j = 0; j < keys.size; j++)
        {
            output += (tab + line_begin + "[\"" + keys[j] + "\"] = " + plr_vox_variants[i][keys[j]] + ";\n");
        }

        if (((i + 1) == plr_vox_variants.size) && (level.script != "zombie_coast"))
        {
            output += "}\n";
            print(output);
            print(end);
            self iPrintLn("vox dump finished, check pluto console");
            return;
        }

        print(output);
        output = "";
    }

    director_vox_array_str = "level.dvox";
    director_vox_variants = [];
    keys = StrTok("water,taunt,start,search,react,lucid,human,find,angry", ",");

    for(i = 0; i < keys.size; i++)
    {
        alias = "vox_romero_" + keys[i];
        nb_variants = maps\_zombiemode_spawner::get_number_variants(alias);

        if (nb_variants > 0)
        {
            director_vox_variants[alias] = nb_variants;
        }

        wait 0.05;
    }

    output = (tab + director_vox_array_str + " = [];\n");
    keys = GetArrayKeys(director_vox_variants);

    for (i = 0; i < keys.size; i++)
    {
        output += (tab + director_vox_array_str + "[\"" + keys[i] + "\"] = " + director_vox_variants[keys[i]] + ";\n");
    }

    output += "}\n";
    print(output);
    print(end);

    self iPrintLn("vox dump finished, check pluto console");
}

