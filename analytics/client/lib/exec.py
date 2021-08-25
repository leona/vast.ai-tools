import subprocess

commands = {
    "gpu_power": "nvidia-smi -i {0} --format=csv,noheader,nounits --query-gpu=power.draw -q",
    "syslog": 'cat /var/log/syslog | grep -iE "error|warning"'
}

def exec(key, args=None):
    cmd = commands[key]

    if args != None:
        cmd = cmd.format(args)

    result = subprocess.run(cmd.split(" "), stdout=subprocess.PIPE)
    output = result.stdout.decode('utf-8').strip()
    return output
