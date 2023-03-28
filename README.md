# T5SP Voicelines Fix

These scripts fixes the voicelines issue for [Plutonium](https://plutonium.pw/) T5SP **dedicated servers**.


## Issue details

When T5SP is running in dedicated server mode, its sound engine is disabled thus\
sound files aren't loaded.

In order to play a voiceline, the server tries to determine the number of\
variants the voiceline has through a GSC function called `get_number_variants`\
located in `_zombiemode_spawner.gsc`:

```gsc

get_number_variants(aliasPrefix)
{
    for(i = 0; i < 100; i++)
    {
        if(!SoundExists(aliasPrefix + "_" + i))
        {
            return i;
        }
    }
}
```

Given that the server doesn't load sounds, the function `SoundExists` always\
returns 0 and the [GSC function in charge of handling voicelines](https://github.com/plutoniummod/t5-scripts/blob/main/ZM/Common/maps/_zombiemode_audio.gsc#L645) returns\
immediately without doing anything because it thinks there are no variants to\
play.

`SoundExists` is a *built-in* function, which means its source code isn't written in\
GSC but is directly built into the game executable. We cannot easily put our\
hands on it and that wouldn't be in accordance with the [Plutonium cheat policy](https://plutonium.pw/docs/anticheat/).

## Dumping & hardcoding

The GSC files of the `vox_defs` folders have been generated with the help of the\
two following scripts:

- [zm_vox_dumper.gsc](https://github.com/Nahelam/t5sp-voicelines-fix/blob/main/dumper/scripts/sp/zom/zm_vox_dumper.gsc): retrieves and prints all voicelines names and their number\
of variants in a pre-formatted GSC syntax to the Plutonium console. The number\
of variants is obtained by calling `get_number_variants`, on each map, for each\
voiceline.

- [dump_helper.py](https://github.com/Nahelam/t5sp-voicelines-fix/blob/main/dumper/dump_helper.py): parses the console output text file (that you have to export\
somehow) and generates all the GSC files with hardcoded arrays in a dedicated\
folder for each map.

If you want to try this process yourself, take a look [here](https://github.com/Nahelam/T5SP-Voicelines-Fix/tree/main/dumper).

## Loading

The core of the fix resides in the following script:

- [zm_vox_fix.gsc](https://github.com/Nahelam/t5sp-voicelines-fix/blob/main/fix_main/scripts/sp/zom/zm_vox_fix.gsc): loads the hardcoded voicelines arrays and assigns them properly\
to the players. One array is dedicated to George (Call of the Dead) because his\
voicelines were also affected by the sound issue.

## Installation

Download the [latest release](https://github.com/Nahelam/t5sp-voicelines-fix/releases/latest/), extract the ZIP archive content to the T5\
storage folder of your dedicated server and you're good to go.

Default T5 storage folder on Windows: `%LOCALAPPDATA%\Plutonium\storage\t5`
