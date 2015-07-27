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
#ifndef _stringtool_cpp
#define _stringtool_cpp

#include "stringtool.h"


#include <sstream>
#include <algorithm>
#include <cctype>


///////////////////////////////////////////////////////////////////////////////
// String Manipulation and checks

void Trim(String& Source, Boole Left, Boole Right)
{
    static const String Delims = " \t\r";
    if(Right)
        Source.erase(Source.find_last_not_of(Delims)+1);
    if(Left)
        Source.erase(0,Source.find_first_not_of(Delims));
}

StringVector Split(const String& Source, const String& Delims, const Whole& MaxSplits)
{
    StringVector Ret;
    Ret.reserve( MaxSplits ? MaxSplits+1 : 10 );
    Whole Splits = 0;

    size_t Start = 0;
    size_t Pos = 0;

    do
    {
        Pos = Source.find_first_of(Delims,Start);
        if(Pos == Start)
        {
            Start = Pos + 1;
        }
        else if(Pos == String::npos || (MaxSplits && Splits == MaxSplits))
        {
            Ret.push_back(Source.substr(Start));
            break;
        }
        else
        {
            Ret.push_back(Source.substr(Start,Pos - Start));
            Start = Pos + 1;
        }
        Start = Source.find_first_not_of(Delims,Start);
        ++Splits;
    }while(Pos != String::npos);

    return Ret;
}

void ToUpperCase(String& Source)
{
    std::transform(Source.begin(),Source.end(),Source.begin(),::toupper);
}

String UpperCaseCopy(String Source)
{
    ToUpperCase(Source);
    return Source;
}

void ToLowerCase(String& Source)
    { std::transform(Source.begin(),Source.end(),Source.begin(),::tolower); }

String LowerCaseCopy(String Source)
{
    ToLowerCase(Source);
    return Source;
}

Boole StartsWith(const String& Str, const String& Pattern, const Boole CaseSensitive)
{
    size_t StrLen = Str.length();
    size_t PatternLen = Pattern.length();

    if(PatternLen > StrLen || PatternLen == 0)
        return false;

    String Start = Str.substr(0,PatternLen);

    if(CaseSensitive)
    {
        String LowerPattern = Pattern;
        ToLowerCase(Start);
        ToLowerCase(LowerPattern);
        return (Start == LowerPattern);
    }

    return (Start == Pattern);
}

Boole EndsWith(const String& Str, const String& Pattern, const Boole CaseSensitive)
{
    size_t StrLen = Str.length();
    size_t PatternLen = Pattern.length();

    if(PatternLen > StrLen || PatternLen == 0)
        return false;

    String End = Str.substr(StrLen - PatternLen,PatternLen);

    if( !CaseSensitive ) {
        String LowerPattern = Pattern;
        ToLowerCase(End);
        ToLowerCase(LowerPattern);
        return (End == LowerPattern);
    }

    return (End == Pattern);
}

void RemoveDuplicateWhitespaces(String& Source)
{
    for( size_t CurrIndex = Source.find_first_of("  ") ; CurrIndex != String::npos ; CurrIndex = Source.find_first_of("  ",CurrIndex) )
    {
        size_t EndIndex = CurrIndex;
        while( Source[EndIndex] == ' ' ) EndIndex++;
        Source.replace(CurrIndex,EndIndex-CurrIndex," ");
        CurrIndex++;
    }
}

///////////////////////////////////////////////////////////////////////////////
// Convert-To-Data functions

Boole ConvertToBool(const String& ToConvert, const Boole Default)
{
    String StrCopy = ToConvert;
    ToLowerCase(StrCopy);
    if("true" == StrCopy) return true;
    else if("yes" == StrCopy) return true;
    else if("1" == StrCopy) return true;
    else if("false" == StrCopy) return false;
    else if("no" == StrCopy) return false;
    else if("0" == StrCopy) return false;
    else return Default;
}

Real ConvertToReal(const String& ToConvert)
{
    StringStream converter(ToConvert);
    Real Result;
    converter >> Result;
    return Result;
}

Integer ConvertToInteger(const String& ToConvert)
{
    StringStream converter(ToConvert);
    Integer Result;
    converter >> Result;
    return Result;
}

Whole ConvertToWhole(const String& ToConvert)
{
    StringStream converter(ToConvert);
    Whole Result;
    converter >> Result;
    return Result;
}

Int8 ConvertToInt8(const String& ToConvert)
{
    StringStream converter(ToConvert);
    Int8 Result;
    converter >> Result;
    return Result;
}

UInt8 ConvertToUInt8(const String& ToConvert)
{
    StringStream converter(ToConvert);
    UInt8 Result;
    converter >> Result;
    return Result;
}

Int16 ConvertToInt16(const String& ToConvert)
{
    StringStream converter(ToConvert);
    Int16 Result;
    converter >> Result;
    return Result;
}

UInt16 ConvertToUInt16(const String& ToConvert)
{
    StringStream converter(ToConvert);
    UInt16 Result;
    converter >> Result;
    return Result;
}

Int32 ConvertToInt32(const String& ToConvert)
{
    StringStream converter(ToConvert);
    Int32 Result;
    converter >> Result;
    return Result;
}

UInt32 ConvertToUInt32(const String& ToConvert)
{
    StringStream converter(ToConvert);
    UInt32 Result;
    converter >> Result;
    return Result;
}

#endif
