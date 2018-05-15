// A super simple application for the purpose testing builds.
// This file is just a function in a separate compilation unit.

#include "Hello2.h"
#include "StreamLogging.h"
#include "BitFieldTools.h"

#include <sstream>

using namespace Mezzanine;
#include <iostream>
std::string getMessage(AnotherTestBitField StreamingLevel)
{
    // Non-Sensical way to implement this, but it uses the first features in the foundation that
    // require linking.
    std::stringstream AssemblerBufferProvider;
    LogStream Assembler(AssemblerBufferProvider);
    Assembler.SetLoggingLevel(LogLevel::None);
    if( (AnotherTestBitField::C & StreamingLevel) != AnotherTestBitField::None )
        { Assembler.SetLoggingLevel(LogLevel::Warn | Assembler.GetLoggingLevel()); }
    if( (AnotherTestBitField::B & StreamingLevel) != AnotherTestBitField::None )
        { Assembler.SetLoggingLevel(LogLevel::Error | Assembler.GetLoggingLevel()); }
    if( (AnotherTestBitField::A & StreamingLevel) != AnotherTestBitField::None )
        { Assembler.SetLoggingLevel(LogLevel::Fatal | Assembler.GetLoggingLevel()); }
    Assembler << LogFatal << "Hello ";
    Assembler << LogError << "World";
    Assembler << LogWarn << "!";
    return AssemblerBufferProvider.str();
}
