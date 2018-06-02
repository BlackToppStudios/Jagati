// © Copyright 2010 - 2018 BlackTopp Studios Inc.
/* This file is part of The Mezzanine Engine.

    The Mezzanine Engine is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    The Mezzanine Engine is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with The Mezzanine Engine.  If not, see <http://www.gnu.org/licenses/>.
*/
/* The original authors have included a copy of the license specified above in the
   'Docs' folder. See 'gpl.txt'
*/
/* We welcome the use of the Mezzanine engine to anyone, including companies who wish to
   Build professional software and charge for their product.

   However there are some practical restrictions, so if your project involves
   any of the following you should contact us and we will try to work something
   out:
    - DRM or Copy Protection of any kind(except Copyrights)
    - Software Patents You Do Not Wish to Freely License
    - Any Kind of Linking to Non-GPL licensed Works
    - Are Currently In Violation of Another Copyright Holder's GPL License
    - If You want to change our code and not add a few hundred MB of stuff to
        your distribution

   These and other limitations could cause serious legal problems if you ignore
   them, so it is best to simply contact us or the Free Software Foundation, if
   you have any questions.

   Joseph Toppi - toppij@gmail.com
   John Blackwood - makoenergy02@gmail.com
*/

#ifndef _hello_2_h
#define _hello_2_h

// A super simple application for the purpose testing builds.
// This file is just a function in a separate compilation unit.

#ifndef S
    // SWIG freaks out on std headers sometimes, better to give it the swig interface files.
    #include <string>
#endif

// This snippet is lifted directly from the Foundation tests. I really want some foundation code in
// there
#include "BitFieldTools.h"
enum class AnotherTestBitField : Mezzanine::UInt8 {
    None    = 0,

    A       = 1,
    B       = 2,
    C       = 4,

    AB      = 3,
    AC      = 5,
    BC      = 6,
    ABC     = 7
};
ENABLE_BITMASK_OPERATORS(AnotherTestBitField)

/// @brief Get a message suitable for output in a "Hello World!" example.
/// @param StreamingLevel Some parts of the message are Bit Controlled. 1->Hello, 2->World, 3->!
/// Currently this is not fully implmented, 
/// @return an std::string containing "Hello World!"
std::string getMessage(AnotherTestBitField StreamingLevel);

#endif