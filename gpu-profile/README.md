## GPU Profile switcher

This script monitors docker container start events and applies GPU settings based on the docker image being used, or applying default settings you define.

To install it run
```bash
wget https://raw.githubusercontent.com/leona/vast.ai-tools/master/gpu-profile/setup.sh -O - | sudo bash
```

To uninstall it run
```bash
wget https://raw.githubusercontent.com/leona/vast.ai-tools/master/gpu-profile/setup.sh -O - | sudo bash -s uninstall
```

Set the default config (this gets prompted during install but can be run again)
```bash
gpu-profile default
```

Create config for a specific docker image. Run the command again to update certain values.
```bash
gpu-profile nxie/aio-miner
```

After setting config the daemon gets restarted and it will apply to your running containers without any downtime. I recommend doing clock and memory changes while unlisted though.

When you first install, it is recommended to reboot and then check the logs at `/var/log/gpu-profile.log` to ensure it can run properly on boot.

## Issues

nvidia-settings requires an X server for some stupid reason. If you're having issues with clocks not setting this is probably the cause and you'll need to ensure running `X :0` does not show errors other than "already running". If anybody knows a way to overclock without nvidia-settings, please let me know.

If you are just looking to apply different power limits for mining and for renters, then you don't need to worry about X, it should just work, although errors will still be displayed in the logs for the other settings.
