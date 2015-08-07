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
#ifndef _menu_cpp
#define _menu_cpp

#include "menu.h"

#include <iostream>
#include <exception>
#include <indexer.h>

using namespace std;

void Menu::Display() const
{
    std::cout << std::endl << Render() ;//<< std::endl;
}

String Menu::Render() const
{
    StringStream DisplayRenderer;
    DisplayRenderer << "Please Select From the Following:";
    for(auto option : WithIndex(Actions))
    {
        DisplayRenderer << setw(4) << right << option.first << ") "
                        << setw(24) << left << option.second->name();
    }

    return DisplayRenderer.str();
}

String Menu::GetInput() const
{
    String Entry;
    while(!std::regex_match(Entry, AcceptableInput))
    {
        while(!(std::cin >> Entry))
        {
            std::cin.clear();
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            Display();
        }
    }
    return Entry;
}

void Menu::AddAction(Action* ToAdd)
{
    Actions.push_back(ToAdd);
    SetAcceptableInput();
}

void Menu::SetAcceptableInput()
{
    StringStream RegexMaker;
    RegexMaker << "[0";

    if(Actions.size()==1)
        { RegexMaker << Actions.size() << "]"; }

    if(Actions.size()>1 && Actions.size() <10)
        { RegexMaker << "-" << Actions.size() << "]"; }

    if(Actions.size()>10 && Actions.size() < 20)
        { RegexMaker << "][1-" << Actions.size()-10 << "]"; }

    if(Actions.size()>20)
        { throw std::invalid_argument("Menu cannot be more than 20 entries in size"); }

    AcceptableInput = std::regex(RegexMaker.str());
}

Menu::~Menu()
{
    for(Action* OnePointer : Actions)
        { delete OnePointer; }
}



#endif