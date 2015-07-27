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
#ifndef _stringtool_h
#define _stringtool_h

#include "datatypes.h"


///////////////////////////////////////////////////////////////////////////////
// Globals, mostly used for comparison and such
const String Blank = "";

///////////////////////////////////////////////////////////////////////////////
// String Manipulation and checks

/// @brief Trims all whitespaces and tabs from a one or both sides of a string.
/// @param Source The original string to be trimmed.
/// @param Left Whether or not to trim the left side of the string.
/// @param Right Whether or not to trim the right side of the string.
void MEZZ_LIB Trim(String& Source, Boole Left = true, Boole Right = true);
/// @brief Splits a string into multiple substrings based on the specified delimiters.
/// @param Source The string to be split.
/// @param Delims The characters to look for and use as split points in the source string.
/// @param MaxSplits The maximum number of splits to perform on this string.  Value of zero means unlimited splits.
/// @return Returns a vector containing all the substrings generated from the source string.
StringVector MEZZ_LIB Split(const String& Source, const String& Delims = " \t\n", const Whole& MaxSplits = 0);
/// @brief Converts all lower case characters in a string to their respective upper case.
/// @param Source The string to be converted.
void MEZZ_LIB ToUpperCase(String& Source);
/// @brief Create a copy of the String that is upper case.
/// @return The copy of string with lower case letters identified by the local converted to upper case.
String UpperCaseCopy(String Source);
/// @brief Converts all upper case characters in a string to their respective lower case.
/// @param Source The string to be converted.
void MEZZ_LIB ToLowerCase(String& Source);
/// @brief Create a copy of the String that is lower case.
/// @return The copy of string with upper case letters identified by the local converted to lower case.
String LowerCaseCopy(String Source);
/// @brief Checks a string to see if it starts with a specific pattern.
/// @param Str The string to check.
/// @param Pattern The sequence to check for at the start of the string.
/// @param CaseSensitive If false this function will check lower-case copies for the pattern, otherwise the strings will be checked as is.
/// @return Returns true if the string starts with the provided pattern, false otherwise.
Boole MEZZ_LIB StartsWith(const String& Str, const String& Pattern, const Boole CaseSensitive);
/// @brief Checks a string to see if it ends with a specific pattern.
/// @param Str The string to check.
/// @param Pattern The sequence to check for at the end of the string.
/// @param CaseSensitive If false this function will check lower-case copies for the pattern, otherwise the strings will be checked as is.
/// @return Returns true if the string ends with the provided pattern, false otherwise.
Boole MEZZ_LIB EndsWith(const String& Str, const String& Pattern, const Boole CaseSensitive);
/// @brief Replaces all instances of multiple consecutive whitespaces with only a single whitespace.
/// @param Source The string to be altered.
void MEZZ_LIB RemoveDuplicateWhitespaces(String& Source);

///////////////////////////////////////////////////////////////////////////////
// Convert-To-Data functions

/// @brief Converts a string into a Boole.
/// @param ToConvert The string to be converted to a Boole.
/// @return Returns a Boole with the converted value.
Boole MEZZ_LIB ConvertToBool(const String& ToConvert, const Boole Default = false);
/// @brief Converts a string into a Real.
/// @param ToConvert The string to be converted to a Real.
/// @return Returns a Real with the converted value.
Real MEZZ_LIB ConvertToReal(const String& ToConvert);
/// @brief Converts a string into an Integer.
/// @param ToConvert The string to be converted to an Integer.
/// @return Returns an Integer with the converted value.
Integer MEZZ_LIB ConvertToInteger(const String& ToConvert);
/// @brief Converts a string into an Whole.
/// @param ToConvert The string to be converted to an Whole.
/// @return Returns an Whole with the converted value.
Whole MEZZ_LIB ConvertToWhole(const String& ToConvert);
/// @brief Converts a string into an Int8.
/// @param ToConvert The string to be converted to an Int8.
/// @return Returns an Int8 with the converted value.
Int8 MEZZ_LIB ConvertToInt8(const String& ToConvert);
/// @brief Converts a string into a UInt8.
/// @param ToConvert The string to be converted to a UInt8.
/// @return Returns a UInt8 with the converted value.
UInt8 MEZZ_LIB ConvertToUInt8(const String& ToConvert);
/// @brief Converts a string into an Int16.
/// @param ToConvert The string to be converted to an Int16.
/// @return Returns an Int16 with the converted value.
Int16 MEZZ_LIB ConvertToInt16(const String& ToConvert);
/// @brief Converts a string into a UInt16.
/// @param ToConvert The string to be converted to a UInt16.
/// @return Returns a UInt16 with the converted value.
UInt16 MEZZ_LIB ConvertToUInt16(const String& ToConvert);
/// @brief Converts an string into an Int32.
/// @param ToConvert The string to be converted to an Int32.
/// @return Returns an Int32 with the converted value.
Int32 MEZZ_LIB ConvertToInt32(const String& ToConvert);
/// @brief Converts a string into a UInt32.
/// @param ToConvert The string to be converted to a UInt32.
/// @return Returns a UInt32 with the converted value.
UInt32 MEZZ_LIB ConvertToUInt32(const String& ToConvert);

///////////////////////////////////////////////////////////////////////////////
// Convert-To-String functions

/// @brief Converts any into a string.
/// @param ToConvert Stream class instance to be converted.
/// @return Returns a string containing the lexicagraphically converted data.
template<typename T>
String ConvertToString(const T& ToConvert)
{
    StringStream converter;
    converter << ToConvert;
    return converter.str();
}

#endif
