# Welcome!
Welcome to KaguOS - learning framework for operating system design.

The main idea of this project is to emulate work of CPU and it's interaction with RAM to build our own simple operating system. Note, that this emulation is using string as a unit of RAM instead of byte. This allows to monitor state of RAM easily by monitoring tmp/RAM.txt file. 

We are using bash functions to emulate basic operations like cpu instructions and fetch-decode-execute loop.

# Environment
Bash shell of 5.2+ version is required to run the KaguOS emulation.

The preffered way is to use Ubuntu multipass virtual machine. In case of Linux and MacOS you can also use an alternative way to run KaguOS without multipass.

## Installation for Linux, MacOS and Windows(with multipass)
* Go to https://multipass.run/install and follow the instructions.
* Open Terminal or PowerShell and create new . You can use any name you like instead of **noble**.
```bash
multipass launch 24.04 --name noble
```
* Start your VM if needed:
```bash
multipass start noble
```
* Stop a virtual machine:
```bash
multipass stop noble
```
* Open a shell inside virtual machine:
```bash
multipass shell noble
```

## Ubuntu(without multipass)
On Ubuntu linux you should get all you need from the box.

## MacOS(without multipass)
By default MacOS is delivered with an outdated version of bash. To update it you can use the following steps.
* Open Terminal and check bash version with command **bash -v** .
* Install brew by executing of the following command(see brew.sh for details ):
    **/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"**
* Install bash
    **brew install bash**
* Edit config file for shells with command **sudo nano /etc/shells** by adding the line **/usr/local/bin/bash** before other paths.
* Press **Ctrl+O** and **Enter** to write your changes. Exit from editor with **Ctrl+X**.
* Reopen Terminal and check version of bash **bash -v** .

# How to work with KaguOS
The simplest way to run KaguOS is to use command `./bootloader <path to kernel disk>`
The kernel disk itself contains a list of lines with machine codes and some constant data that may be required to run that instructions.

To write a single instruction we should know the proper format and machine codes. Basic instructions and cpu operations are listed in file *include/operations.sh*. The list of addresses of different registers can be found in `include/registers.sh`. For simplicity we map all the registers to the start of the RAM.

As a result our kernel will be loaded at some higher address which is defined as the constant `KERNEL_START` in *include/system.sh*. It is 41 by default which means that you should add 40 to the line number of the kernel disk to find its address in RAM after load.

## Simple kernel
Let's write the simplest kernel which will halt immediately after start.
To do that we should copy value OP_HALT(code 30) from some address to REG_OP(mapped to address 2 in RAM). It can be done with `INSTR_COPY_FROM_TO_ADDRESS`(code 1). Then we can use `INSTR_CPU_EXEC`(code 0) to execute the real operation - cpu will check the operation code and will perform corresponding calculations.

There is one issue here - to copy OP_HALT code 30 it should be stored somewhere in kernel disk. We can append it after all the kernel instructions.
Our kernel disk will look like:
```
1 ? 2       # INSTR_COPY_FROM_TO_ADDRESS ?(unkown address) REG_OP
0           # INSTR_CPU_EXEC
30          # This line contains data required to kernel program execution OP_HALT code
```
The last step is to determine the address of that last line after loading it to RAM. As it was mentioned above the first line of the kernel disk will be loaded to the line `KERNEL_START`(value 41). Therefore the line with OP_HALT code will be at address 43. Let's complete our code:
```bash
1 43 2
0
30
```
Create a folder `kernels` with command `mkdir kernels` and create `simple` file to store the list of instructions. You can use `nano kernels/simple` or any other editor you like.

Now let's run the kernel with command `./bootloader.sh kernels/simple`. It should produce a single line *CPU halt*. But let's rerun it with a special flag `-j`(e.g. `./bootloader.sh kernels/simple -j`) that will print debug information about executed instructions.

To get more details we can notice that there is a new folder `tmp` with a file `RAM.txt` inside. This file contains a state of RAM at each point of time. It is dumped via `dump_RAM_to_file` call inside `bootloader.sh` to provide us debug capabilities. Further when you will write bigger kernel you may need to comment that dumping to speed up the run of the kernel. But at the moment we will monitor what is happened inside RAM to understand how does it work.

Let's open `tmp/RAM.txt` in VSCode editor. You can find the kernel code starting from the line 41. To monitor state of RAM easily we should add a delay between instructions. We can specify the length of this delay in seconds with `-s=` flag of `bootloader.sh`.
Therefore review `tmp/RAM.txt` while running kernel with 0.5 second delay e.g. `./bootloader.sh kernels/simple -s=0.5`. There are only to changes in RAM - address 2(REG_OP) and address 24 which corresponds to `PROGRAM_COUNTER`(see *include/registers.sh*). Note that in our implementation program counter contains value of line with instruction but this value is decremented by 1. Therefore PROGRAM_COUNTER register value 40 means execution of instruction at address 41 and so on.

## Display message
Now let's extend our kernel with some useful actions. Let's print some message before halt. To do that we will use DISPLAY_BUFFER(address 18), DISPLAY_COLOR(address 20) and OP_DISPLAY_LN(code 17). Supported colors are specified in the file `include/others.sh`. We will use COLOR_GREEN(code 1).
```bash
1 ? 18          # copy string with text from ? address to DISPLAY_BUFFER(18)
1 ? 20          # copy COLOR_GREEN(1) constant from ? address to DISPLAY_COLOR(20)
1 ? 2           # copy OP_DISPLAY_LN(17) constant from ? address to REG_OP(2)
0               # cpu_exec
1 ? 2           # copy OP_HALT(30) constant from ? address to REG_OP(2)
0               # cpu_exec
Green hello!    # Text to be printed
1               # COLOR_GREEN constant
17              # OP_DISPLAY_LN constant
30              # OP_HALT constant
```

Now we can replace ? with the addresses were constants will be present in RAM. Text *Green hello!* is at line 7 at kernel disk therefore it will be at address 47. Other constants will be calculated in the same way.
```bash
1 47 18
1 48 20
1 49 2
0
1 50 2
0
Green hello!
1
17
30
```
Create file `kernels/hello`, add the code and run it with `bootloader.sh`.

Let's extend our kernel with another message displayed in COLOR_RED(3):
```bash
1 51 18
1 52 20
1 53 2
0
1 54 18
1 55 20
1 56 2
0
1 57 2
0
Green hello!
1
17
Red hello!
3
17
30
```
Save it as `kernels/helloRed` and run it.

**TASK**: What could be improved to reduce memory usage in this case?

## Read input
Now we can try to use `OP_READ_INPUT`(15) to get some text from the keyboard and write it instead of *Green hello!* message. Note, that in this case input will be stored at `KEYBOARD_BUFFER`(address 22).
```bash
1 ? 2           # write OP_READ_INPUT from ? address to REG_OP
0               # cpu_exec
1 22 18         # copy from KEYBOARD_BUFFER(address 22) to DISPLAY_BUFFER
1 ?  20         # copy COLOR_GREEN from ? address to DISPLAY_COLOR
1 ?  2          # copy OP_DISPLAY_LN from ? address to REG_OP
0               # cpu_exec
1 ?  18         # copy text Red hello! from ? address to DISPLAY_BUFFER
1 ?  20         # copy COLOR_RED from ? address to DISPLAY_COLOR
1 ?  2          # copy OP_DISPLAY_LN from ? address to REG_OP
0               # cpu_exec
1 ? 2           # copy OP_HALT from ? address to REG_OP(2)
0               # cpu_exec
15              # OP_READ_INPUT
1               # COLOR_GREEN
17              # OP_DISPLAY_LN
Red hello!      # Text to be printed in red
3               # COLOR_RED
17              # OP_DISPLAY_LN
30              # OP_HALT
```
Now we can calculate addresses of the constants and replace ?. The first ? should be replaced with 53 and so on:
```bash
1 53 2
0
1 22 18
1 54 20
1 55 2
0
1 56 18
1 57 20
1 58 2
0
1 59 2
0
15
1
17
Red hello!
3
17
30
```
Save the code to *kernels/readInput* and run it.

**TASK**: display some text before reading input to provide some hint for the user.

## Check condition
Now we can consider conditional execution of code. We have unconditional jump INSTR_JUMP(code 3) and conditional INSTR_JUMP_IF(code 4). As a part of this instruction you can specify address of the next instruction to be executed. INSTR_JUMP_IF will perform that jump only if REG_BOOL_RES(address 14) contains 1. Note, that REG_BOOL_RES is set during execution of some of logical operations, for example, OP_CMP_EQ and OP_CMP_NEQ allow to compare values from REG_A and REG_B.

Let's use conditional jump to check user input and print user input only if it is not equal to "red".

```bash
1 ? 2           # write OP_READ_INPUT from ? address to REG_OP
0               # cpu_exec
1 22 4          # copy from KEYBOARD_BUFFER(address 22) to REG_A(address 4)
1 ? 6           # copy constant "red" from ? address to REG_B(address 6)
1 ? 2           # copy OP_CMP_EQ from ? address to REG_OP
0               # cpu_exec
4 ??             # perform INSTR_JUMP_IF(code 4) to the instruction related to Red hello!
1 22 18         # copy from KEYBOARD_BUFFER(address 22) to DISPLAY_BUFFER
1 ?  20         # copy COLOR_GREEN from ? address to DISPLAY_COLOR
1 ?  2          # copy OP_DISPLAY_LN from ? address to REG_OP
0               # cpu_exec
1 ?  18         # copy text Red hello! from ? address to DISPLAY_BUFFER
1 ?  20         # copy COLOR_RED from ? address to DISPLAY_COLOR
1 ?  2          # copy OP_DISPLAY_LN from ? address to REG_OP
0               # cpu_exec
1 ? 2           # copy OP_HALT from ? address to REG_OP(2)
0               # cpu_exec
15              # OP_READ_INPUT
red             # text that will be used for the comparison
8               # OP_CMP_EQ
1               # COLOR_GREEN
17              # OP_DISPLAY_LN
Red hello!      # Text to be printed in red
3               # COLOR_RED
17              # OP_DISPLAY_LN
30              # OP_HALT
```
After calculations we can substitute ? with the real addresses. First line with data OP_READ_INPUT is at line 18 therefore we should start from 58 while filling missed addresses. Also ?? will be 52. As a result:
```bash
1 58 2
0
1 22 4
1 59 6
1 60 2
0
4 52
1 22 18
1 61 20
1 62 2
0
1 63 18
1 64 20
1 65 2
0  
1 66 2 
0
15
red
8
1
17
Red hello!
3
17
30
```
Save it to `kernel/condition` and run it. Enter text *red* and ensure that it will not be printed with green color. Restart kernel and enter any other text and ensure that logic is working fine.

**TASK**: Adjust the kernel so it will run in loop and will prompt user input until the user entered exit.
