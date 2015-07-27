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
#ifndef _main_cpp
#define _main_cpp

#include <cstdlib>
#include <iostream>

#include "main.h"
#include "autodetect.h"
#include "resourceutilities.h"

#include <tclap/CmdLine.h>

using namespace std;

/// @brief This is the entry point ...
/// @return This will return EXIT_SUCCESS, it will do more later.
/// @param argc Is interpretted as the amount of passed arguments
/// @param argv Is interpretted as the arguments passed in from the launching shell.
int main (int ArgCount, char** ArgVars)
{
    HandleCommandLineArgs(ArgCount, ArgVars);
    std::cout << "Found some packages: " << Packages.size() << endl;
    return EXIT_SUCCESS;
}


namespace {
    Boole WorkStationInstallation = false;
    Boole LaunchMenu = true;
}

/// @brief Checks the command line options if the menu should be used
/// @return A true or false
Boole UseMenu()
    { return LaunchMenu; }

/// @brief Checks the command line options if the menu should be used
/// @return A true or false
Boole WorkStationInstall()
    { return WorkStationInstallation; }


void HandleCommandLineArgs(int ArgCount, char** ArgVars)
{
    CacheMainArgs(ArgCount, ArgVars);
    try
    {
        TCLAP::CmdLine cmd("Jagati - Mezzanine installer", ' ', "July 27, 2015");
        TCLAP::SwitchArg WorkStationInstallationSwitch("w","workstation","Enter interactive shell after other items are executed.", cmd, false);

        cmd.parse(ArgCount, ArgVars);

        WorkStationInstallation = WorkStationInstallationSwitch.getValue();



    } catch (TCLAP::ArgException &e) {
        cerr << "error: " << e.error() << " for arg " << e.argId() << endl;
    }
    /*try
    {
        TCLAP::CmdLine cmd("EntreLua - Mezzanine Lua Shell", ' ', "0.01 with Lua5.1");

        TCLAP::ValuesConstraint<Mezzanine::String> LibaryVals( Results.LibraryList );
        TCLAP::MultiArg<string> OpenlibArg("o", "openlib", "Library to open before shell starts", false, &LibaryVals, cmd);
        TCLAP::MultiArg<string> CloselibArg("c", "closelib", "Do not open a Library that might be opened before shell starts", false, &LibaryVals, cmd);

        TCLAP::MultiArg<String> LoadArg("l", "load", "Requires/Loads a Module. Force opening of Package lib.", false, "filename", cmd);
        TCLAP::ValueArg<std::string> StatementArg("e", "execute", "Execute a Lua script entered at the command line.", false, "", "Lua String", cmd);
        TCLAP::SwitchArg InteractiveSwitch("i","interactive","Enter interactive shell after other items are executed.", cmd, false);
        TCLAP::SwitchArg StdinSwitch(":","stdin","Read from the Standard Input and execute whatever is found there.", cmd, false);
        TCLAP::SwitchArg SimpleSwitch("s","simple","Use a simpler shell input method with fewer features but that is compatible in more places.", cmd, false);
        TCLAP::SwitchArg NoMezzanineSwitch("n", "no-mezzanine", "Do not load/open the Mezzanine by default.", cmd, false);
        TCLAP::SwitchArg UnsafeSwitch("u", "unsafe", "Load the unrestricted Mezzanine library instead of MezzanineSafe.", cmd, false);
        TCLAP::UnlabeledMultiArg<String> ScriptAndArgs( "script", "A script to execute instead of an interactive shell", false, "script [args]", cmd);
        TCLAP::SwitchArg StackSwitch("S", "Stack", "Display stack counts after each command execution.", cmd, false);

        cmd.parse(argc, argv);

        Results.OpenList = OpenlibArg.getValue();
        Results.CloseList = CloselibArg.getValue();
        Results.LoadList = LoadArg.getValue();
        Results.StatementToExecute = StatementArg.getValue();
        Results.Interactive = InteractiveSwitch.getValue();
        Results.ReadFromStdIn = StdinSwitch.getValue();
        Results.SimpleShell = SimpleSwitch.getValue();
        Results.NoMezzanine = NoMezzanineSwitch.getValue();
        Results.LoadUnsafeMezzanine = UnsafeSwitch.getValue();
        Results.ScriptFile = ScriptAndArgs.getValue();
        Results.DisplayStackCounts = StackSwitch.getValue();
    } catch (TCLAP::ArgException &e) {
        cerr << "error: " << e.error() << " for arg " << e.argId() << endl;
    }*/
}


#endif

