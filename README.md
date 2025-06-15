# Dawn Farming Tools

This repository contains a simple World of Warcraft addon and a companion
Python script to help schedule Dawn of the Infinites groups.

## DoTIName Addon

Copy the `DoTIName` folder into your WoW `Interface/AddOns` directory.
On login the addon records the current character details and allows you to set
a username with `/dotiname <name>`. Use `/dotiexport` to show a window
containing all recorded characters in plain text format:

```
Name Level iLvl Class Spec UserName
```

You can copy this text and paste it into the Python tool below.

## Group Optimizer

The `group_optimizer.py` script reads the exported text and groups characters
into five-person parties without repeating a username within the same group.
Usage:

```bash
python3 group_optimizer.py data.txt       # read from file
python3 group_optimizer.py -             # paste data via stdin
```

Results are printed to the terminal. Add `--csv` to also generate a
`groups.csv` file. The last imported data is saved to `last_import.txt` for
convenience.
