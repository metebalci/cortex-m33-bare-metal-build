
# Information

This is a companion repository to my blog posts [Demystifying Arm Cortex-M33 Bare Metal: Startup](https://metebalci.com/blog/demystifying-arm-cortex-m33-bare-metal-startup/) and [Demystifying Arm Cortex-M33 Bare Metal: Compile, Assembly and Link](https://metebalci.com/blog/demystifying-arm-cortex-m33-bare-metal-compile-assembly-and-link/).

This repository contains a Makefile based template project for Arm Cortex-M33 bare metal C/Assembly application, particularly for STM32H563. The startup code `startup_stm32h563.s` and the linker script `linker.ld` are minimal with my modifications (mostly removals) to the original files in CMSIS and STM32CubeH5.

Makefile, startup code and the linker script contain useful comments if you want to modify them for your project.

# Usage

You need to have [Arm GNU Toolchain](https://developer.arm.com/Tools%20and%20Software/GNU%20Toolchain) executables in path.

When you run `make` first time, it downloads (clones) CMSIS 5.9.0 and STM32CubeH5 1.1.0 from github.

`make flash` programs the MCU using STM32_Programmer_CLI.

# License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

