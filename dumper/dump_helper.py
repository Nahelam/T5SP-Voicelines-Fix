import sys
import os

def helper():
    with open(pluto_console_output_file, 'r') as f:
        lines = f.readlines()

    tmp_list = []
    scripts = {}
    inside_delimiter = False
    content = []

    for line in lines:
        if line.strip() == "-----------------------------------------------------------BEGIN":
            inside_delimiter = True
            content = []
        elif line.strip() == "-------------------------------------------------------------END":
            inside_delimiter = False
            tmp_list.append(content)
        elif inside_delimiter:
            content.append(line)

    for element in tmp_list:
        map_name = ""
        for line in element:
            if line.startswith("Map: "):
                map_name = line.split("Map: ")[1].strip()
                element.remove(line)
                break

        if map_name:
            new_content = [line.replace(' ' * 8, ' ' * 4) for line in element]
            new_content = [line if "[SCRIPT]" not in line else '\n' for line in new_content]

            while len(new_content) > 1 and new_content[-1] == '\n' and new_content[-2] == '\n':
                new_content.pop()

            scripts[map_name] = new_content

    if not os.path.exists(target_folder):
        os.mkdir(target_folder)

    for key, value in scripts.items():
        folder_name = os.path.join(target_folder, key)
        if not os.path.exists(folder_name):
            os.mkdir(folder_name)

        file_name = key.replace("zombie", "zm") + "_vox.gsc"
        file_path = os.path.join(folder_name, file_name)

        with open(file_path, 'w', newline='\n') as f:
            for line in value:
                f.write(line)

        print(f"{file_path} written")


if len(sys.argv) != 3:
    print("Error: Incorrect number of arguments")
    print("Usage: python dump_helper.py <pluto_console_output_file> <target_folder>")
    sys.exit(1)

pluto_console_output_file = sys.argv[1]
target_folder = sys.argv[2]

helper()

