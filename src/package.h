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
#ifndef _Package_h
#define _Package_h

#include <string>
#include <vector>

/// @brief This allows us to match the Mezzanine types and potentially change from std::string in the future.
typedef std::string String;

/// @brief This allows us to maybe from std::vector in the future.
typedef std::vector<String> StringList;

const String Placeholder("Not Setup Yet");

//// @brief Used when comparing versions to described the lowest version that matters
enum class VersionScope
{
    Patch,
    Minor,
    Major
};


class Version
{
    private:
        int Major;
        int Minor;
        int Patch;

    public:

        Version(int MajorVersion = 0, int MinorVersion = 0, int PatchVersion = 0);
        String ToString() const;
};

struct Dependency
{
    public:
        String Name;
        Version Required;
        VersionScope CompareAt;
};

typedef std::vector<Dependency> DependencyList;

/// @brief This is the base class for all packages
/// @detail This
class Package
{
    public:
        virtual String Name() const = 0;
        virtual String BriefDescription() const = 0;
        virtual DependencyList DependsOn() const = 0;
        virtual Version CurrentVersion() const = 0;
        virtual void Install() const = 0;
};

class GithubMezzaninePackage
{
    public:
        virtual String GitURL() const = 0;
        virtual void Install() const;
};

class InSourceBinaryPackage
{
    public:
        virtual String Git() const = 0;
        virtual void Install() const;
};


#endif
