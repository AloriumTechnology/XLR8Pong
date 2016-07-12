/*--------------------------------------------------------------------
  Copyright (c) 2016 Alorium Technology.  All rights reserved.
  This file is part of the Alorium Technology XLR8 Pong Library.
  Written by Ted Holler of 
    Alorium Technology (info@aloriumtech.com) 
    
  This example shows how to read the buttons and potentiometers on the Paddle
  Controllers.  This information is then written to the Pong's memory map
  registers that are used to start/reset the game along with paddle movement.

  XLR8 Pong is free software: you can redistribute it and/or modify
  it under the terms of the GNU Lesser General Public License as
  published by the Free Software Foundation, either version 3 of
  the License, or (at your option) any later version.
  
  XLR8 Pong is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU Lesser General Public License for more details.
  You should have received a copy of the GNU Lesser General Public
  License along with XLR8 Servo.  If not, see
  <http://www.gnu.org/licenses/>.
  --------------------------------------------------------------------*/

#include <XLR8Pong.h>

int  pad0;
int  pad1;
Pong pong;

void setup() {
  pinMode(7, INPUT); 
  pinMode(6, INPUT);
}

void loop() {
 
 //Read Player's 0 button
 byte but0 = digitalRead(7);
 //Read Player's 1 button
 byte but1 = digitalRead(6);
 
 if(but0==0) pong.start_game(); //start the game if Player 0 button is pushed
 if(but1==0) pong.reset_game(); //resert the game if Playter 1 button is pushed
 
 pad0 = analogRead(A0); //Get the position of Player 0 paddle controller
 pad1 = analogRead(A1); //Get the position of Player 1 paddle controller
 
 pong.paddle_pos0( (pad0/4) ); //position the Player 0 paddle using the controller's data 
                               //(divide by 4 so paddle isn't so jittery)
 pong.paddle_pos1( (pad1/4) ); //position the Player 1 paddle using the controller's data
}
