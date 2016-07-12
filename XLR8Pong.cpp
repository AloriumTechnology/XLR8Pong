/*--------------------------------------------------------------------
 Copyright (c) 2016 Alorim Technology.  All right reserved.
 This file is part of the Alorium Technology XLR8 Pong library.
 Written by Ted Holler of Alorium Technology (info@aloriumtech.com)

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

#include <Arduino.h>

#include "XLR8Pong.h"

#define PADL0  _SFR_MEM8(0xE0)
#define PADL1  _SFR_MEM8(0xE1)
#define PNGCR  _SFR_MEM8(0xE2)

void Pong::paddle_pos0(byte position){
  PADL0 = position; 
}

void Pong::paddle_pos1(byte position){
  PADL1 = position; 
}

void Pong::start_game(){
  PNGCR = 0x02;
}

void Pong::set_pngcr(byte data){
  PNGCR = data;
}

void Pong::reset_game(){
  PNGCR = 0x01;
}
