import subprocess

commands = {
    "gpu_power": "nvidia-smi -i {0} --format=csv,noheader,nounits --query-gpu=power.draw -q"
}

def exec(key, args):
    cmd = commands[key].format(args)
    result = subprocess.run(cmd.split(" "), stdout=subprocess.PIPE)
    output = result.stdout.decode('utf-8').strip()
    return output
