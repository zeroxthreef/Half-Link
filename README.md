## Half-Life-Link

![alt text](https://raw.githubusercontent.com/zeroxthreef/Half-Link/master/hlogo.png)

Just a really simple set of instructions for cross compiling [Xash3D](https://github.com/FWGS/xash3d) to the steam link to play Half-Life. The people who make Xash3D did all of the hard work here (Xash3D is super impressive, I really recommend taking a look at the repo).

## Instructions

First clone the [Steam Link SDK](https://github.com/ValveSoftware/steamlink-sdk), and then go to the root of the "steamlink-sdk" directory and create a folder called whatever you want. In my example, I'm just going to use "halflife".
```
cd steamlink-sdk
mkdir halflife
```

You then need to run ``source setenv.sh`` in the sdk root.

Next, modify the "toolchain/steamlink-toolchain.cmake" and set the lines:
```
set(CMAKE_C_FLAGS_INIT "--sysroot=${CMAKE_SYSROOT} -marm -mfloat-abi=hard")
set(CMAKE_CXX_FLAGS_INIT "--sysroot=${CMAKE_SYSROOT} -marm -mfloat-abi=hard")
```

to:
```
set(CMAKE_C_FLAGS_INIT "--sysroot=${CMAKE_SYSROOT} -marm -mfloat-abi=hard -DLINUX -DEGL_API_FB -DHAVE_OPENGLES2 -O3")
set(CMAKE_CXX_FLAGS_INIT "--sysroot=${CMAKE_SYSROOT} -marm -mfloat-abi=hard -DLINUX -DEGL_API_FB -DHAVE_OPENGLES2 -O3")
```

(It was the quickest hack to fix things not compiling. I know there are better ways, and I'm just writing what I did. You'll definitely want to change it back after building)

After that, copy your half-life game files to your halflife folder (or whatever you called it). To quote the Xash3D building and running wiki(dont run this, im just quoting), "Copy valve folder from Half-Life: cp -r $HOME/.steam/steam/steamapps/common/Half-Life/valve $HOME/Games/Xash3D", but don't use that command because it will copy to the wrong place. Do``cp -r $HOME/.steam/steam/steamapps/common/Half-Life/valve ."``(yes, keep the '.'). If that isn't where your halflife files are located, copy from the proper directory instead.

Then, in the sdk root:

```
cd halflife
git clone https://github.com/FWGS/xash3d.git --recursive
git clone https://github.com/FWGS/hlsdk-xash3d.git --recursive
git clone https://github.com/FWGS/nanogl.git xash3d/engine/nanogl
# this doesnt work to the right---> Im keeping it here for when I can get it to work: git clone https://github.com/FWGS/gl-wes-v2.git xash3d/engine/gl-wes-v2
git clone https://github.com/FWGS/xash-extras.git
chmod +x build_steamlink.sh
./build_steamlink.sh
```

Then after all this, copy what the build_steamlink.sh says to do and it should be all good to go.


NOTE: The little hlogo.png image I made and the steam link model are public domain. Everything written here (that I did) is public domain.
