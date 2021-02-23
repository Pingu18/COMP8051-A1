//
//  CPlusPlus.cpp
//  MixedLanguages
//
//  Created by Borna Noureddin on 2013-10-09.
//  Copyright (c) 2013 Borna Noureddin. All rights reserved.
//

#include "CPlusPlus.hpp"

int CPlusPlus::GetVal()
{
    return val;
}

void CPlusPlus::SetVal(int newVal)
{
    val = newVal;
}

void CPlusPlus::IncrVal(int incr)
{
    val += incr;
}
