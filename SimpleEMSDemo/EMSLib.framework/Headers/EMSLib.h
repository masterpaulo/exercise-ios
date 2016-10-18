//
//  EMSFramework.h
//  EMSFramework
//
//  Created by Naz Mariano on 10/06/2016.
//  Copyright © 2016 locomoviles.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 0.0.3 - Merged with packet debug. Added code to prevent data corruption. libevostreamms.a also replaced with a new one.
 */

typedef void (^ResponseBlock)(NSDictionary *response, NSError *error);
//! Project version number for EMSFramework.
FOUNDATION_EXPORT double EMSFrameworkVersionNumber;

//! Project version string for EMSFramework.
FOUNDATION_EXPORT const unsigned char EMSFrameworkVersionString[];

#import <EMSLib/EMS.h>
#import <EMSLib/AudioSpecificConfig.h>
#import <EMSLib/EMSAPI.h>
#import <EMSLib/EMSSourceStream.h>
#import <EMSLib/Protocols.h>
#import <EMSLib/ASCIICli.h>

