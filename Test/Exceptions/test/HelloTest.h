// © Copyright 2010 - 2020 BlackTopp Studios Inc.
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
#ifndef hello_test_h
#define hello_test_h


// Add other headers you need here
#include "Hello.h"
#include "MezzException.h"

DEFAULT_TEST_GROUP(HelloTest, HelloTest)
{
    using String = Mezzanine::String;

    String ExpectedFilename = "hello.cpp";

    // Tests should use the macros from TestMacros.h to automatically function, filename and line number.
    try
    {
        tryBaseActionButFail();
    } catch (const Mezzanine::Exception::Base& e) {
        TEST_EQUAL("BaseThrownLine", 49u, e.GetOriginatingLine());
        TEST_EQUAL("BaseThrownMessage", String("Base Exception"), String(e.GetMessage()));
        TEST_EQUAL("BaseThrownWhat", String("Base Exception"), String(e.what()));
        TEST_EQUAL("BaseThrownFunction", String("tryBaseActionButFail"), String(e.GetOriginatingFunction()));
        TEST_EQUAL("BaseThrownTypename", String("Base"), String(e.TypeName()));

        String AllLowerFile = Mezzanine::Testing::AllLower(String(e.GetOriginatingFile()));
        TEST_STRING_CONTAINS("BaseThrownFile", ExpectedFilename, AllLowerFile);

        //TEST("BaseCastBaseNope", (nullptr != dynamic_cast<const Mezzanine::Exception::Base*>(&e)) );
        TEST("BaseCastAnimalNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Animal*>(&e)) );
        TEST("BaseCastMammalNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Mammal*>(&e)) );
        TEST("BaseCastDogNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Dog*>(&e)) );
        TEST("BaseCastCatNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Cat*>(&e)) );
        TEST("BaseCastFishNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Fish*>(&e)) );
    }

    try
    {
        tryAnimalActionButFail();
    } catch (const Mezzanine::Exception::Animal& e) {
        TEST_EQUAL("AnimalThrownLine", 54u, e.GetOriginatingLine());
        TEST_EQUAL("AnimalThrownMessage", String("Animal Exception"), String(e.GetMessage()));
        TEST_EQUAL("AnimalThrownWhat", String("Animal Exception"), String(e.what()));
        TEST_EQUAL("AnimalThrownFunction", String("tryAnimalActionButFail"), String(e.GetOriginatingFunction()));
        TEST_EQUAL("AnimalThrownTypename", String("Animal"), String(e.TypeName()));

        String AllLowerFile = Mezzanine::Testing::AllLower(String(e.GetOriginatingFile()));
        TEST_STRING_CONTAINS("AnimalThrownFile", ExpectedFilename, AllLowerFile);

        TEST("AnimalCastBaseGood", (nullptr != dynamic_cast<const Mezzanine::Exception::Base*>(&e)) );
        //TEST("AnimalCastAnimalNope", (nullptr != dynamic_cast<const Mezzanine::Exception::Animal*>(&e)) );
        TEST("AnimalCastMammalNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Mammal*>(&e)) );
        TEST("AnimalCastDogNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Dog*>(&e)) );
        TEST("AnimalCastCatNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Cat*>(&e)) );
        TEST("AnimalCastFishNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Fish*>(&e)) );
    }

    try
    {
        tryMammalActionButFail();
    } catch (const Mezzanine::Exception::Mammal& e) {
        TEST_EQUAL("MammalThrownLine", 59u, e.GetOriginatingLine());
        TEST_EQUAL("MammalThrownMessage", String("Mammal Exception"), String(e.GetMessage()));
        TEST_EQUAL("MammalThrownWhat", String("Mammal Exception"), String(e.what()));
        TEST_EQUAL("MammalThrownFunction", String("tryMammalActionButFail"), String(e.GetOriginatingFunction()));
        TEST_EQUAL("MammalThrownTypename", String("Mammal"), String(e.TypeName()));

        String AllLowerFile = Mezzanine::Testing::AllLower(String(e.GetOriginatingFile()));
        TEST_STRING_CONTAINS("MammalThrownFile", ExpectedFilename, AllLowerFile);

        TEST("MammalCastBaseGood", (nullptr != dynamic_cast<const Mezzanine::Exception::Base*>(&e)) );
        TEST("MammalCastAnimalGood", (nullptr != dynamic_cast<const Mezzanine::Exception::Animal*>(&e)) );
        //TEST("MammalCastMammalNope", (nullptr != dynamic_cast<const Mezzanine::Exception::Mammal*>(&e)) );
        TEST("MammalCastDogNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Dog*>(&e)) );
        TEST("MammalCastCatNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Cat*>(&e)) );
        TEST("MammalCastFishNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Fish*>(&e)) );
    }

    try
    {
        tryDogActionButFail();
    } catch (const Mezzanine::Exception::Dog& e) {
        TEST_EQUAL("DogThrownLine", 64u, e.GetOriginatingLine());
        TEST_EQUAL("DogThrownMessage", String("Dog Exception"), String(e.GetMessage()));
        TEST_EQUAL("DogThrownWhat", String("Dog Exception"), String(e.what()));
        TEST_EQUAL("DogThrownFunction", String("tryDogActionButFail"), String(e.GetOriginatingFunction()));
        TEST_EQUAL("DogThrownTypename", String("Dog"), String(e.TypeName()));

        String AllLowerFile = Mezzanine::Testing::AllLower(String(e.GetOriginatingFile()));
        TEST_STRING_CONTAINS("DogThrownFile", ExpectedFilename, AllLowerFile);

        TEST("DogCastBaseGood", (nullptr != dynamic_cast<const Mezzanine::Exception::Base*>(&e)) );
        TEST("DogCastAnimalGood", (nullptr != dynamic_cast<const Mezzanine::Exception::Animal*>(&e)) );
        TEST("DogCastMammalGood", (nullptr != dynamic_cast<const Mezzanine::Exception::Mammal*>(&e)) );
        //TEST("DogCastDogNope", (nullptr != dynamic_cast<const Mezzanine::Exception::Dog*>(&e)) );
        TEST("DogCastCatNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Cat*>(&e)) );
        TEST("DogCastFishNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Fish*>(&e)) );
    }

    try
    {
        tryCatActionButFail();
    } catch (const Mezzanine::Exception::Cat& e) {
        TEST_EQUAL("CatThrownLine", 69u, e.GetOriginatingLine());
        TEST_EQUAL("CatThrownMessage", String("Cat Exception"), String(e.GetMessage()));
        TEST_EQUAL("CatThrownWhat", String("Cat Exception"), String(e.what()));
        TEST_EQUAL("CatThrownFunction", String("tryCatActionButFail"), String(e.GetOriginatingFunction()));
        TEST_EQUAL("CatThrownTypename", String("Cat"), String(e.TypeName()));

        String AllLowerFile = Mezzanine::Testing::AllLower(String(e.GetOriginatingFile()));
        TEST_STRING_CONTAINS("CatThrownFile", ExpectedFilename, AllLowerFile);


        TEST("CatCastBaseGood", (nullptr != dynamic_cast<const Mezzanine::Exception::Base*>(&e)) );
        TEST("CatCastAnimalGood", (nullptr != dynamic_cast<const Mezzanine::Exception::Animal*>(&e)) );
        TEST("CatCastMammalGood", (nullptr != dynamic_cast<const Mezzanine::Exception::Mammal*>(&e)) );
        TEST("CatCastDogNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Dog*>(&e)) );
        //TEST("CatCastCatNope", (nullptr == dynamic_cast<const Mezzanine::Exception::Cat*>(&e)) );
        TEST("CatCastFishNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Fish*>(&e)) );
    }

    try
    {
        tryFishActionButFail();
    } catch (const Mezzanine::Exception::Fish& e) {
        TEST_EQUAL("FishThrownLine", 74u, e.GetOriginatingLine());
        TEST_EQUAL("FishThrownMessage", String("Fish Exception"), String(e.GetMessage()));
        TEST_EQUAL("FishThrownWhat", String("Fish Exception"), String(e.what()));
        TEST_EQUAL("FishThrownFunction", String("tryFishActionButFail"), String(e.GetOriginatingFunction()));
        TEST_EQUAL("FishThrownTypename", String("Fish"), String(e.TypeName()));

        String AllLowerFile = Mezzanine::Testing::AllLower(String(e.GetOriginatingFile()));
        TEST_STRING_CONTAINS("FishThrownFile", ExpectedFilename, AllLowerFile);

        TEST("FishCastBaseGood", (nullptr != dynamic_cast<const Mezzanine::Exception::Base*>(&e)) );
        TEST("FishCastAnimalGood", (nullptr != dynamic_cast<const Mezzanine::Exception::Animal*>(&e)) );
        TEST("FishCastMammalNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Mammal*>(&e)) );
        TEST("FishCastDogNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Dog*>(&e)) );
        TEST("FishCastCatNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Cat*>(&e)) );
        //TEST("FishCastFishNull", (nullptr == dynamic_cast<const Mezzanine::Exception::Fish*>(&e)) );
    }

}

#endif
