/* syscalls.c: minimum syscalls for nosys
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

/* these methods are not defined anywhere even in nosys
 * so they have to be implemented */

int _close(int file) 
{
  return 0;
}

int _lseek(int file, char* ptr, int dir)
{
  return 0;
}

int _read(int file, char* ptr, int len)
{
  return 0;
}

int _write(int file, char* ptr, int len)
{
  return 0;
}
