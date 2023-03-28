# Dumper

## Usage

Extract the [dumper ZIP archive](https://github.com/Nahelam/T5SP-Voicelines-Fix/releases/download/1.0/t5sp-voicelines-dumper-1.0.zip) content to the T5 storage folder (for the Python\
script you can put it where you want) then run a solo game on *Kino der Toten*\
(the dumper **MUST** be ran on Kino first if you want to get a proper output for\
all maps in the Plutonium console) and let it do its thing.

The dumper GSC will automatically work and switch on all maps for you. Once\
finished, it will send you back to the main menu. After that, you have to\
export the Plutonium console output and save it into a text file.

Finally, use the Python script `dump_helper.py` from the command line to\
generate the voicelines GSC files. The script takes two arguments, the path of\
your text file containing the console output and the path of the folder where\
you want the GSC files to be created.

<br>

> Usage: python dump_helper.py <pluto_console_output_file> <target_folder>
