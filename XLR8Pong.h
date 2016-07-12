/*--------------------------------------------------------------------
  Copyright (c) 2015 Alorim Technology.  All right reserved.
  This file is part of the Alorium Technology XLR8 Servo library.
  Written by Ted Holler of Alorium Technology 
 

 This library is free software: you can redistribute it and/or modify
 it under the terms of the GNU Lesser General Public License as
 published by the Free Software Foundation, either version 3 of
 the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library.  If not, see
 <http://www.gnu.org/licenses/>.
 --------------------------------------------------------------------*/


#ifndef XLR8PONG_H
#define XLR8PONG_H

// #ARDUINO_XLR8 is passed from IDE to the compiler if XLR8 is selected properly
#ifdef ARDUINO_XLR8

class Pong
{
public:
  void
    paddle_pos0(byte position),
    paddle_pos1(byte position),
    start_game(),
    set_pngcr(byte data),
    reset_game();
};

#else
#error "XLR8Pong library requires Tools->Board->XLR8xxx selection. Install boards from https://github.com/AloriumTechnology/Arduino_Boards"
#endif

#endif
