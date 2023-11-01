/* linker.ld: example linker script for STM32H563
 * Copyright (C) 2023 Mete Balci

 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

__FLASH_BASE = 0x08000000;
__FLASH_SIZE = 2048K;

__RAM_BASE = 0x20000000;
__RAM_SIZE = 640K;

/* heap is just after bss section */
__HEAP_SIZE  = 1K;

/* stack is at the end of memory, growing down */
__STACK_SIZE = 1K;

/* No need to set an explicit entry point */
/* defaults to start of code section, .text, thus __FLASH_BASE */
/*ENTRY(Reset_Handler)*/

/* Memories */
/* org is shortcut for ORIGIN, len for LENGTH */
MEMORY
{
  RAM   (rwx) : org = __RAM_BASE,   len = __RAM_SIZE
  FLASH (rx)  : org = __FLASH_BASE, len = __FLASH_SIZE
}

/* Sections */
SECTIONS
{
  .text :
  {
    KEEP(*(.vectors))
    *(.text*)
    *(.rodata*)
    . = ALIGN(4);
  } >FLASH

  _sidata = LOADADDR(.data);

  .data :
  {
    . = ALIGN(4);
    _sdata = .;
    *(.data*)
    . = ALIGN(4);
    _edata = .;

  } >RAM AT> FLASH

  .bss :
  {
    . = ALIGN(4);
    _sbss = .;
    *(.bss*)
    . = ALIGN(4);
    _ebss = .;
  } >RAM

  .heap (COPY) :
  {
    . = ALIGN(4);
    __end__ = .;
    . = . + __HEAP_SIZE;
    . = ALIGN(4);
    __HeapLimit = .;
  } > RAM

  .stack (COPY) :
  {
    . = ALIGN(4);
    __StackLimit = .;
    . = . + __STACK_SIZE;
    . = ALIGN(4);
    __StackTop = .;
  } > RAM

}

