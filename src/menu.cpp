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
#include <stdexcept>
#include <iomanip>

#include "indexer.h"

using namespace std;

Menu::Menu(const String& Name)
    : MenuName(Name)
{ }

Menu::~Menu()
{
    for(Action* OnePointer : Actions)
    { delete OnePointer; }
}

void Menu::AddActions()
    {}

void Menu::AddAction(Action* ToAdd)
{
    if(Actions.size()>=MaxSize)
        { throw std::range_error(String("Too many menu entries added already.")); }
    Actions.push_back(ToAdd);
}

Action* Menu::VerifyEntry(const String& Entry) const
{
    StringStream Converter;
    Converter << Entry;
    Whole EntryNumber = 0;
    Converter >> EntryNumber;
    if(EntryNumber && EntryNumber <= Actions.size())
        { return Actions.at(EntryNumber-1); }
    else
        { return nullptr; }
}


void Menu::Display(std::ostream& OutputStream) const
    { OutputStream << std::endl << Render() << std::endl; }

String Menu::Render() const
{
    StringStream DisplayRenderer;
    DisplayRenderer << right << setw(5 + MenuName.size()) << MenuName << endl << endl
                    << "Please Select From the Following:" << endl;
    for(auto option : WithIndex(Actions))
    {
        DisplayRenderer << setw(10) << right << option.first + 1 << ") "
                        << setw(48) << left << option.second->Name() << endl;
    }

    return DisplayRenderer.str();
}

Action* Menu::GetInput() const
{
    String Entry;
    Action* Results = nullptr;
    while(! (Results = VerifyEntry(Entry)) )
    {
        Display();
        cout << "Your choice: ";
        if(!(std::cin >> Entry))
        {
            std::cin.clear();
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
        }
    }
    return Results;
}


Boole Menu::DoInput() const
    { (*GetInput())(); }


void Menu::DoMenuUntilExit() const
{
    while(DoInput()){}
}



#endif
