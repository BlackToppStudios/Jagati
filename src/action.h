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
#ifndef _action_h
#define _action_h

#include <datatypes.h>


/// @brief Represents one action a menu can take.
class Action
{
    protected:
        ///@brief Whatever has been jammed in here for things the action should take into account.
        StringVector Arguments;

    public:
        ////////////////////////////////////////////////////////////////////////////////////////////
        // Argument functionality

        /// @brief Argument accepting constructor
        /// @param Args A group of arguments to be used once the command is executed.
        Action(StringVector Args);

        /// @brief Adds an argument to the command
        /// @param Arg An argument to add to the list of args during the call.
        void AddArgument(String Arg);

        ////////////////////////////////////////////////////////////////////////////////////////////
        // Virtual functions

        /// @brief Get the name of this action, could be use for display or internal tracking
        /// @return A String that provides a brief one or two word description of this
        virtual String Name() const = 0;

        /// @brief Get what the menu will display.
        /// @return A one sentence description
        virtual String MenuEntry() const = 0;

        /// @brief Do the command.
        virtual void operator()() = 0;

        Action() = default;
        virtual ~Action() = default;
};

#include <iostream>
class TestAction : public Action
{
    public:
        TestAction() = default;
        virtual String Name() const
            { return String("Foo"); }

        virtual String MenuEntry() const
            { return String("When Selected this will do foo"); }

        virtual void operator()()
            { std::cout << "FOO!" << std::endl; }

        virtual ~TestAction() = default;
};



#endif
