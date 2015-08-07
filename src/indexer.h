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

// This code originated on Stack overflow and was shared under a Creative commons with attributions
// and share alike license - cc by-sa 3.0.
// http://stackoverflow.com/questions/10962290/find-position-of-element-in-c11-range-based-for-loop
// By Matthieu M.

// Example use:
//    std::vector<int> v{1, 2, 3, 4, 5, 6, 7, 8, 9};
//    for (auto p: index(v)) {
//        std::cout << p.first << ": " << p.second << "\n";
//    }


#include "datatypes.h"

#include <iostream>
#include <iterator>
#include <limits>
#include <vector>

template <typename T>
class Indexer
{
    public:
        class iterator
        {
                typedef typename iterator_extractor<T>::type inner_iterator;

                typedef typename std::iterator_traits<inner_iterator>::reference inner_reference;
            public:
                typedef std::pair<size_t, inner_reference> reference;

                iterator(inner_iterator it): _pos(0), _it(it) {}

                reference operator*() const { return reference(_pos, *_it); }

                iterator& operator++() { ++_pos; ++_it; return *this; }
                iterator operator++(int) { iterator tmp(*this); ++*this; return tmp; }

                bool operator==(iterator const& it) const { return _it == it._it; }
                bool operator!=(iterator const& it) const { return !(*this == it); }

            private:
                size_t _pos;
                inner_iterator _it;
        };

        Indexer(T& t): _container(t) {}

        iterator begin() const { return iterator(_container.begin()); }
        iterator end() const { return iterator(_container.end()); }

    private:
        T& _container;
}; // class Indexer

template <typename T>
Indexer<T> WithIndex(T& t) { return Indexer<T>(t); }
