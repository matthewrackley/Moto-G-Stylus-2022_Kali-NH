#!/usr/bin/env python3

##############################################################
## Script to prepare Kali NetHunter quarterly releases
##
## It parses the YAML sections of devices/devices.cfg and creates:
##
## - "./build-<release>.sh": shell script to build all images
## - "<outputdir>/manifest.json": manifest file mapping image name to display name
##
## Dependencies:
##   sudo apt -y install python3 python3-yaml
##
## Usage:
## ./prep-release.py -i <input file> -o <output directory> -r <release>
##
## E.g.:
## ./prep-release.py -i devices/devices.cfg -o /media/re4son/dev/NetHunter/2020.3/images -r 2020.3

import json
import datetime
import yaml # python3 -m pip install pyyaml --user
import getopt, os, stat, sys

FS_SIZE = "full"
build_script = "" # Generated automatically (./build-<release>.sh)
manifest = ""     # Generated automatically (<outputdir>/manifest.json)
release = ""
outputdir = ""
inputfile = ""
qty_images = 0
qty_devices = 0

## Input:
## ------------------------------------------------------------ ##
##* - angler:
##*     model:   Nexus 6P
##*     note:
##*     images:
##*       - name:    Nexus 6P (Oreo)
##*         id:      xangler
##*         os:      oreo
##*         status:  Stable
##*         rootfs:  full
##*         note:    "** Our preferred low end device **"
##*       - name:    Nexus 6P (LineageOS 17.1)
##*         id:      angler-los
##*         os:      ten
##*         status:  Latest
##*         rootfs:  full
##*         note:    "** Warning: Android ten is very unstable at the moment. **"

def bail(message = "", strerror = ""):
    outstr = ""
    prog = sys.argv[0]
    if message != "":
        outstr = "\nError: {}".format(message)
    if strerror != "":
        outstr += "\nMessage: {}\n".format(strerror)
    else:
        outstr += "\n\nUsage: {} -i <input file> -o <output directory> -r <release>".format(prog)
        outstr += "\nE.g. : {} -i devices/devices.cfg -o images -r {}.1\n".format(prog, datetime.datetime.now().year)
    print(outstr)
    sys.exit(2)

def getargs(argv):
    global inputfile, outputdir, release

    try:
        opts, args = getopt.getopt(argv,"hi:o:r:",["inputfile=","outputdir=","release="])
    except getopt.GetoptError as e:
        bail("Incorrect arguments: {}".format(e))

    if opts:
        for opt, arg in opts:
            if opt == '-h':
                bail()
            elif opt in ("-i", "--inputfile"):
                inputfile = arg
            elif opt in ("-o", "--outputdir"):
                outputdir = arg.rstrip("/")
            elif opt in ("-r", "--release"):
                release = arg
            else:
                bail("Unrecognised argument: " + opt)
    else:
        bail("Failed to read arguments")

    if not release:
        bail("Missing required argument: -r/--release")
    return 0

def yaml_parse(content):
    result = ""
    lines = content.split('\n')
    for line in lines:
        if line.startswith('##*'):
            ## yaml doesn't like tabs so let's replace them with four spaces
            result += line.replace('\t', '    ')[3:] + "\n"
    return yaml.safe_load(result)

def generate_build_script(data):
    global OUTPUT_FILE, FS_SIZE, release, outputdir, qty_devices, qty_images
    build_list = ""
    default = ""

    ## Create script header
    build_list += "#!/usr/bin/env bash\n\n"
    build_list += "RELEASE={}\n".format(release)
    build_list += "OUT_DIR={}\n".format(outputdir)
    build_list += "\n"

    ## Make sure that we have the latest app versions
    build_list += "# Force download all apps:\n"
    build_list += "./build.py -f || exit"
    build_list += "\n\n"

    ## Add builds for NetHunter Lite (Light Edition)
    build_list += "# Kali NetHunter Lite:\n"
    build_list += "# -----------------------------------------------\n"
    build_list += "./build.py -g arm64 -fs full -r ${RELEASE} && mv *${RELEASE}*.zip ${OUT_DIR}\n"
    build_list += "./build.py -g arm64 -fs nano -r ${RELEASE} && mv *${RELEASE}*.zip ${OUT_DIR}\n"
    build_list += "./build.py -g armhf -fs full -r ${RELEASE} && mv *${RELEASE}*.zip ${OUT_DIR}\n"
    build_list += "./build.py -g armhf -fs nano -r ${RELEASE} && mv *${RELEASE}*.zip ${OUT_DIR}\n"

    # Iterate over all the devices
    for element in data:
        # Iterate over all the versions
        for key in element.keys():
            qty_devices += 1
            if 'images' in element[key]:
                for image in element[key]['images']:
                    qty_images += 1
                    build_list += "\n"
                    build_list += "# {}\n".format(image.get('name'))
                    build_list += "# -----------------------------------------------\n"
                    build_list += "./build.py -d {} --{} -fs {} -r ${{RELEASE}} && mv *${{RELEASE}}*.zip ${{OUT_DIR}}\n".format(image.get('id', default), image.get('os', default), image.get('rootfs', FS_SIZE))

    ## Create sha files for each image
    build_list += "\n\n"
    build_list += "cd ${OUT_DIR}/\n"
    build_list += "for f in `dir *-${RELEASE}-*.zip`; do sha256sum ${f} > ${f}.sha256; done\n"
    build_list += "cd -\n"
    return build_list

def jsonarray(devices, manufacture, name, filename):
    if not manufacture in devices:
        devices[manufacture] = []
    jsondata = {"name": name, "filename": filename}
    devices[manufacture].append(jsondata)
    return devices

def generate_manifest(data):
    global FS_SIZE, release
    default = ""
    devices = {}

    ## Add NetHunter Lite (Light Editions)
    jsonarray(devices, "NetHunter Lite", "NetHunter Lite ARM64 (Full)", "nethunter-{}-{}-{}-kalifs-{}.zip".format(release, "generic", "arm64", "full"))
    jsonarray(devices, "NetHunter Lite", "NetHunter Lite ARM64 (Nano)", "nethunter-{}-{}-{}-kalifs-{}.zip".format(release, "generic", "arm64", "nano"))
    jsonarray(devices, "NetHunter Lite", "NetHunter Lite ARMhf (Full)", "nethunter-{}-{}-{}-kalifs-{}.zip".format(release, "generic", "armhf", "full"))
    jsonarray(devices, "NetHunter Lite", "NetHunter Lite ARMhf (Nano)", "nethunter-{}-{}-{}-kalifs-{}.zip".format(release, "generic", "armhf", "nano"))

    # Iterate over all the devices
    for element in data:
        # Iterate over all the versions
        for key in element.keys():
            if 'images' in element[key]:
                for image in element[key]['images']:
                    name = image.get('name', default)
                    manufacture = name.split()[0]
                    filename = "nethunter-{}-{}-{}-kalifs-{}.zip".format(release, image.get('id', default), image.get('os', default), image.get('rootfs', FS_SIZE))
                    jsonarray(devices, manufacture, name, filename)
    return json.dumps(devices, indent = 2)

def deduplicate(data):
    # Remove duplicate lines
    clean_data = ""
    lines_seen = set()
    for line in data.splitlines():
        if line not in lines_seen: # not a duplicate
            clean_data += line + "\n"
            lines_seen.add(line)
    return clean_data

def createdir(dir):
    try:
        if not os.path.exists(dir):
            os.makedirs(dir)
    except:
        bail('Directory "' + dir + '" does not exist and cannot be created')
    return 0

def readfile(file):
    try:
        with open(file) as f:
            data = f.read()
            f.close()
    except:
        bail("Cannot open input file: " + file)
    return data

def writefile(data, file):
    try:
        with open(file, 'w') as f:
            f.write(str(data))
            f.close()
    except:
        bail("Cannot write to output file: " + file)
    return 0

def mkexec(file):
    # chmod 755
    try:
        os.chmod(file, 0o755)
    except Exception as e:
        error = "{}:{}".format(sys.exc_info()[0], sys.exc_info()[1])
        bail("Cannot make executable: " + file, error)
    return 0

def main(argv):
    global inputfile, outputdir, release

    # Parse command-line arguments
    if len(sys.argv) > 1:
        getargs(argv)
    else:
        bail("Missing arguments")

    # Assign variables
    manifest = outputdir + "/manifest.json"
    build_script = "./build-" + release + ".sh"
    data = readfile(inputfile)

    # Get data
    res = yaml_parse(data)
    build_list = generate_build_script(res)
    manifest_list = generate_manifest(res)

    # Create output directory if required
    createdir(outputdir)

    # Create release build script
    writefile(build_list, build_script)
    mkexec(build_script)

    # Create manifest file
    writefile(manifest_list, manifest)

    # Print result and exit
    print('\nStats:')
    print('  - Devices\t: {}'.format(qty_devices))
    print('  - Images\t: {}'.format(qty_images))
    print("\n")
    print('Image directory created\t: {}/'.format(outputdir))
    print('Manifest file created\t: {}'.format(manifest))
    print('Build script created\t: {}\n'.format(build_script))

    exit(0)

if __name__ == "__main__":
    main(sys.argv[1:])

