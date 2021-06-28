// © Copyright 2010 - 2021 BlackTopp Studios Inc.
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
#ifndef _hello_swig_h
#define _hello_swig_h

///////////////////////////////////////////////////////////////////////////////
/// @file
/// @brief Used to give commands specifically to the SWIG preprocessor
/// @details SWIG is a C/C++ source code preprocessor that reads source files
/// and produces an implementation of bindings for that language. Currently it
/// is only used for Lua. It can be used for other items in the future.
///////////////////////////////////////////////////////////////////////////////

// Prevent doxygen parsing of the items to insert in the bindings files

#ifdef SWIG
    // This block of code is only read by swig.

    %{
        // Code put here will appear in binding file. Useful for fixing scoping issues swig introduces.
    %}

    // These will prepare swig for passing std types like string.
    %include stl.i
    %include stdint.i
    %include std_string.i

    // Since swig will process only one language and only the safe or unsafe version of it at a time
    // this is where the naming of this binding library should occur. This does not affect the
    // ability to load multiple libraries or even scripting languages at the same time if required.
    /// @def SWIG_MODULE_SET
    /// @brief This is set
    #ifdef SWIG_MAIN
        #ifdef SWIG_UNSAFE
            %module Hello
        #else
            #define SWIG_SAFE
            %module HelloSafe
        #endif
        #define SWIG_MODULE_SET
    #endif

    // This is a good place to put warn filters in case the code is not well formed for all swig inputs.
    //%warnfilter(403) Mezzanine::XML::XPathException;
#endif // end SWIG


#endif
