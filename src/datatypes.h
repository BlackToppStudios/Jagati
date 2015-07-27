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

#include "crossplatformexport.h"

///////////////////////////////////////////////////////////////////////////////
/// @file
/// @brief All the definitions for datatypes as are defined here.
/// This file is only coincidentally similar to the Mezzanine datatypes.h and
/// any similarities are entirely manually maintained. This is because of the
/// importance of keeping dependencies of this as low as possible.
///////////////////////////////////////

#include <string>
#include <vector>
#include <sstream>

#define MEZZ_LIB

/// @typedef String
/// @brief This allows us to match the Mezzanine types and potentially change from std::string in the future.
typedef std::string String;

/// @typedef StringStream
/// @brief A Datatype used for streaming operations with strings.
typedef std::stringstream StringStream;

/// @typedef StringVector
/// @brief This is a simple datatype for a vector container of strings.
typedef std::vector<String> StringVector;

/// @typedef Char8
/// @brief A datatype to represent one character.
/// @details This should be a char if String is an std::string.
typedef char Char8;

/// @typedef Int8
/// @brief An 8-bit integer.
typedef int8_t Int8;
/// @typedef UInt8
/// @brief An 8-bit unsigned integer.
typedef uint8_t UInt8;
/// @typedef Int16
/// @brief An 16-bit integer.
typedef int16_t Int16;
/// @typedef UInt16
/// @brief An 16-bit unsigned integer.
typedef uint16_t UInt16;
/// @typedef Int32
/// @brief An 32-bit integer.
typedef int32_t Int32;
/// @typedef UInt32
/// @brief An 32-bit unsigned integer.
typedef uint32_t UInt32;
/// @typedef Int64
/// @brief An 64-bit integer.
typedef int64_t Int64;
/// @typedef UInt64
/// @brief An 64-bit unsigned integer.
typedef uint64_t UInt64;

/// @typedef Real
/// @brief A Datatype used to represent a real floating point number.
/// @details This Datatype is currently a typedef to a float, This is to match
/// our compilations of Ogre (rendering subsystem ogre::Real), and Bullet (physics
/// subsystem, btScalar). With a recompilation of all the subsystems and  this
/// there is no theoretical reason why this could not be changed to a
/// double, or even something more extreme like a GMP datatype. Most likely this
/// switch would require atleast some troubleshooting.
typedef float Real;
/// @typedef PreciseReal
/// @brief A Real number that is at least as precise as the Real and could be considerabll moreso
typedef double PreciseReal;

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

/// @brief A large integer type suitable for compile time math and long term microsecond time keeping.
/// @details For reference when this is a 64 bit integer, it can store a number between −9,223,372,036,854,775,808 and 9,223,372,036,854,775,807.
/// In seconds that is approximately 292,277,000,000 years and the universe is only 14,600,000,000 years old. So this is good for any time between
/// 20x the age of the universe before and after the beginning of any chosen epoch. Even if used to track nanoseconds it should be good for
/// 292 years.
#ifdef _MEZZ_CPP11_PARTIAL_
    typedef intmax_t MaxInt;
#else
    typedef long long MaxInt;
#endif



#endif
