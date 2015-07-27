// © Copyright 2010 - 2015 BlackTopp Studios Inc.
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
#ifndef _datatypes_h
#define _datatypes_h

///////////////////////////////////////////////////////////////////////////////
/// @file
/// @brief All the definitions for datatypes as are defined here.
/// This file is only coincidentally similar to the Mezzanine datatypes.h and
/// any similarities are entirely manually maintained. This is because of the
/// importance of keeping dependencies of this as low as possible.
///////////////////////////////////////

#include <string>
#include <vector>

/// @typedef String
/// @brief This allows us to match the Mezzanine types and potentially change from std::string in the future.
typedef std::string String;

/// @typedef StringList
/// @brief This allows us to maybe from std::vector in the future.
typedef std::vector<String> StringList;

/// @typedef Int8
/// @brief An 8-bit integer.
typedef int8_t Int8;

/// @typedef UInt8
/// @brief An 8-bit unsigned integer.
typedef uint8_t UInt8;

/// @typedef Whole
/// @brief Whole is an unsigned integer, it will be at least 32bits in size.
/// @details This is a typedef to unsigned Long. but could be smaller in some situations.  In
/// general it will be the most efficient unsigned type for math.
typedef unsigned long Whole;

/// @typedef Integer
/// @brief A datatype used to represent any integer close to.
/// @details This is a typedef to int, but could int16 or smaller to improve performance in some situtations, In general it will be the most efficient signed type for math.
typedef int Integer;

/// @typedef Boole
/// @brief Generally acts a single bit, true or false
/// @details Normally just a bool, but on some platform alignment matters more than size, so this could be as large as one cpu word in size.
typedef bool Boole;


#endif
