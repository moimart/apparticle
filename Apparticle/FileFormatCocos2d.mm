//
// Apparticle
// http://apparticle.pjer.ca
//
// Created by Pierre-David Bélanger <pierredavidbelanger@gmail.com>
// Copyright (c) 2013 PjEr.ca. All rights reserved.
//
// This file is part of Apparticle.
//
// Apparticle is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Apparticle is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Apparticle.  If not, see <http://www.gnu.org/licenses/>.
//

#import "FileFormatCocos2d.h"

#import <Godzippa/Godzippa.h>
#import <NSData+Base64/NSData+Base64.h>

#include "libs/json/json.h"

@implementation FileFormatCocos2d

- (void)writeParticleSystem:(ParticleSystem *)part toURL:(NSURL *)url
{
    Json::Value v;
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    
    d[@"maxParticles"] = @(part.totalParticles);
    v["maxParticles"] = (int)part.totalParticles;
    
    d[@"emissionRate"] = @(part.emissionRate);
    v["emissionRate"] = part.emissionRate;
    
    d[@"duration"] = @(part.duration);
    v["duration"] = part.duration;
    
    d[@"sourcePositionx"] = @(part.position.x);
    d[@"sourcePositiony"] = @(part.position.y);
    d[@"sourcePositionVariancex"] = @(part.posVar.x);
    d[@"sourcePositionVariancey"] = @(part.posVar.y);
    v["sourcePositionx"] = part.position.x;
    v["sourcePositiony"] = part.position.y;
    v["sourcePositionVariancex"] = part.posVar.x;
    v["sourcePositionVariancey"] = part.posVar.y;
    
    d[@"particleLifespan"] = @(part.life);
    d[@"particleLifespanVariance"] = @(part.lifeVar);
    v["particleLifespan"] = part.life;
    v["particleLifespanVariance"] = part.lifeVar;
    
    d[@"angle"] = @(part.angle);
    d[@"angleVariance"] = @(part.angleVar);
    v["angle"] = part.angle;
    v["angleVariance"] = part.angleVar;
    
    d[@"startParticleSize"] = @(part.startSize);
    d[@"startParticleSizeVariance"] = @(part.startSizeVar);
    d[@"finishParticleSize"] = @(part.endSize);
    d[@"finishParticleSizeVariance"] = @(part.endSizeVar);
    v["startParticleSize"] = part.startSize;
    v["startParticleSizeVariance"] = part.startSizeVar;
    v["finishParticleSize"] = part.endSize;
    v["finishParticleSizeVariance"] = part.endSizeVar;
    
    d[@"rotationStart"] = @(part.startSpin);
    d[@"rotationStartVariance"] = @(part.startSpinVar);
    d[@"rotationEnd"] = @(part.endSpin);
    d[@"rotationEndVariance"] = @(part.endSpinVar);
    v["rotationStart"] = part.startSpin;
    v["rotationStartVariance"] = part.startSpinVar;
    v["rotationEnd"] = part.endSpin;
    v["rotationEndVariance"] = part.endSpinVar;

    v["rotationYawStart"] = part.startYaw;
    v["rotationYawStartVariance"] = part.startYawVar;
    v["rotationYawEnd"] = part.endYaw;
    v["rotationYawEndVariance"] = part.endYawVar;

    v["rotationPitchStart"] = part.startPitch;
    v["rotationPitchStartVariance"] = part.startPitchVar;
    v["rotationPitchEnd"] = part.endPitch;
    v["rotationPitchEndVariance"] = part.endPitchVar;
    
    d[@"emitterType"] = @(part.emitterMode);
    v["emitterType"] = (int)part.emitterMode;
    
    if ([part isModeGravity]) {
        
        d[@"gravityx"] = @(part.gravity.x);
        d[@"gravityy"] = @(part.gravity.y);
        v["gravityx"] = part.gravity.x;
        v["gravityy"] = part.gravity.y;
        
        d[@"speed"] = @(part.speed);
        d[@"speedVariance"] = @(part.speedVar);
        v["speed"] = part.speed;
        v["speedVariance"] = part.speedVar;
        
        d[@"radialAcceleration"] = @(part.radialAccel);
        d[@"radialAccelVariance"] = @(part.radialAccelVar);
        v["radialAcceleration"] = part.radialAccel;
        v["radialAccelVariance"] = part.radialAccelVar;
        
        d[@"tangentialAcceleration"] = @(part.tangentialAccel);
        d[@"tangentialAccelVariance"] = @(part.tangentialAccelVar);
        v["tangentialAcceleration"] = part.tangentialAccel;
        v["tangentialAccelVariance"] = part.tangentialAccelVar;
        
    } else if ([part isModeRadius]) {
        
        d[@"maxRadius"] = @(part.startRadius);
        d[@"maxRadiusVariance"] = @(part.startRadiusVar);
        v["maxRadius"] = part.startRadius;
        v["maxRadiusVariance"] = part.startRadiusVar;
        
        d[@"minRadius"] = @(part.endRadius);
        d[@"minRadiusVariance"] = @(part.endRadiusVar);
        v["minRadius"] = part.endRadius;
        v["minRadiusVariance"] = part.endRadiusVar;
        
        d[@"rotatePerSecond"] = @(part.rotatePerSecond);
        d[@"rotatePerSecondVariance"] = @(part.rotatePerSecondVar);
        v["rotatePerSecond"] = part.rotatePerSecond;
        v["rotatePerSecondVariance"] = part.rotatePerSecondVar;
        
    }

    if (part.modelFilename != nil)
    {
        if (![part.modelFilename isEqualToString:@""])
            v["modelFilename"] = std::string([part.modelFilename UTF8String]);
    }

    if (part.modelPrefix != nil)
    {
        if (![part.modelPrefix isEqualToString:@""])
            v["modelPrefix"] = std::string([part.modelPrefix UTF8String]);
    }

    d[@"textureFileName"] = part.textureName;
    v["textureFileName"] = std::string([part.textureName UTF8String]);
    
    if (part.textureEmbedded) {
        
        d[@"textureImageData"] = [[[part.textureImage TIFFRepresentation] dataByGZipCompressingWithError:nil] base64EncodedString];
        v["textureImageData"] = std::string([[[[part.textureImage TIFFRepresentation] dataByGZipCompressingWithError:nil] base64EncodedString] UTF8String]);
        
    } else {
    
        NSString *folder = [[url path] stringByDeletingLastPathComponent];
        NSString *textureFileName = [folder stringByAppendingPathComponent:part.textureName];
        if (![[NSFileManager defaultManager] fileExistsAtPath:textureFileName]) {
            // todo: save part.textureImage to textureFileName ...
        }
    
    }
    
    d[@"startColorRed"] = @(part.startColor.r);
    d[@"startColorGreen"] = @(part.startColor.g);
    d[@"startColorBlue"] = @(part.startColor.b);
    d[@"startColorAlpha"] = @(part.startColor.a);
    d[@"startColorVarianceRed"] = @(part.startColorVar.r);
    d[@"startColorVarianceGreen"] = @(part.startColorVar.g);
    d[@"startColorVarianceBlue"] = @(part.startColorVar.b);
    d[@"startColorVarianceAlpha"] = @(part.startColorVar.a);
    v["startColorRed"] = part.startColor.r;
    v["startColorGreen"] = part.startColor.g;
    v["startColorBlue"] = part.startColor.b;
    v["startColorAlpha"] = part.startColor.a;
    v["startColorVarianceRed"] = part.startColorVar.r;
    v["startColorVarianceGreen"] = part.startColorVar.g;
    v["startColorVarianceBlue"] = part.startColorVar.b;
    v["startColorVarianceAlpha"] = part.startColorVar.a;
    
    d[@"finishColorRed"] = @(part.endColor.r);
    d[@"finishColorGreen"] = @(part.endColor.g);
    d[@"finishColorBlue"] = @(part.endColor.b);
    d[@"finishColorAlpha"] = @(part.endColor.a);
    d[@"finishColorVarianceRed"] = @(part.endColorVar.r);
    d[@"finishColorVarianceGreen"] = @(part.endColorVar.g);
    d[@"finishColorVarianceBlue"] = @(part.endColorVar.b);
    d[@"finishColorVarianceAlpha"] = @(part.endColorVar.a);
    v["finishColorRed"] = part.endColor.r;
    v["finishColorGreen"] = part.endColor.g;
    v["finishColorBlue"] = part.endColor.b;
    v["finishColorAlpha"] = part.endColor.a;
    v["finishColorVarianceRed"] = part.endColorVar.r;
    v["finishColorVarianceGreen"] = part.endColorVar.g;
    v["finishColorVarianceBlue"] = part.endColorVar.b;
    v["finishColorVarianceAlpha"] = part.endColorVar.a;
    
    d[@"blendFuncSource"] = @(part.blendFunc.src);
    d[@"blendFuncDestination"] = @(part.blendFunc.dst);
    v["blendFuncSource"] = part.blendFunc.src;
    v["blendFuncDestination"] = part.blendFunc.dst;
    
    //[d writeToURL:url atomically:YES];
    std::string path = std::string([[url absoluteString] UTF8String]);

    size_t lastindex = path.find_last_of(".");

    if (lastindex != std::string::npos)
    {
        std::string json_path = path.substr(0,lastindex) + ".particles";

        Json::StyledWriter w;

        auto content = w.write(v);

        NSString* c = [NSString stringWithUTF8String:content.c_str()];

        NSURL* url2 = [NSURL URLWithString:[NSString stringWithUTF8String:json_path.c_str()]];

        NSError* error;
        [c writeToURL:url2 atomically:YES encoding:NSUTF8StringEncoding error:&error];

        if (error != nil)
            NSLog(@"Couldn't write to %@",[url2 absoluteString]);
    }
}

- (void) readParticleSystem:(ParticleSystem *)part fromJson:(Json::Value&)v url:(NSURL*)url
{
    CGPoint p;
    ccColor4F c;
    ccBlendFunc b;

    part.totalParticles = v["maxParticles"].asFloat();

    part.duration = v["duration"].asFloat();

    p.x = v["sourcePositionx"].asDouble();
    p.y = v["sourcePositiony"].asDouble();
    part.position = p;
    p.x = v["sourcePositionVariancex"].asDouble();
    p.y = v["sourcePositionVariancey"].asDouble();
    part.posVar = p;

    part.life = v["particleLifespan"].asFloat();
    part.lifeVar = v["particleLifespanVariance"].asFloat();

    if (v["emissionRate"].isNumeric())
        part.emissionRate = v["emissionRate"].asFloat();
    else
        part.emissionRate = part.totalParticles / part.life;

    part.angle = v["angle"].asFloat();
    part.angleVar = v["angleVariance"].asFloat();

    part.startSize = v["startParticleSize"].asFloat();
    part.startSizeVar = v["startParticleSizeVariance"].asFloat();
    part.endSize = v["finishParticleSize"].asFloat();
    part.endSizeVar = v["finishParticleSizeVariance"].asFloat();

    part.startSpin = v["rotationStart"].asFloat();
    part.startSpinVar = v["rotationStartVariance"].asFloat();
    part.endSpin = v["rotationEnd"].asFloat();
    part.endSpinVar = v["rotationEndVariance"].asFloat();

    if (v["rotationYawStart"].isNumeric())
    {
        part.startYaw = v["rotationYawStart"].asFloat();
        part.startYawVar = v["rotationYawStartVariance"].asFloat();
        part.endYaw = v["rotationYawEnd"].asFloat();
        part.endYawVar = v["rotationYawEndVariance"].asFloat();
    }
    else
    {
        part.startYaw = part.startYawVar = part.endYaw = part.endYawVar = 0;
    }

    if (v["rotationPitchStart"].isNumeric())
    {
        part.startPitch = v["rotationPitchStart"].asFloat();
        part.startPitchVar = v["rotationPitchStartVariance"].asFloat();
        part.endPitch = v["rotationPitchEnd"].asFloat();
        part.endPitchVar = v["rotationPitchEndVariance"].asFloat();
    }
    else
    {
        part.startPitch = part.startPitchVar = part.endPitch = part.endPitchVar = 0;
    }

    part.emitterMode = v["emitterType"].asInt();

    if ([part isModeGravity]) {

        p.x = v["gravityx"].asDouble();
        p.y =v["gravityy"].asDouble();
        part.gravity = p;

        part.speed = v["speed"].asFloat();
        part.speedVar = v["speedVariance"].asFloat();

        part.radialAccel = v["radialAcceleration"].asFloat();
        part.radialAccelVar = v["radialAccelVariance"].asFloat();

        part.tangentialAccel = v["tangentialAcceleration"].asFloat();
        part.tangentialAccelVar = v["tangentialAccelVariance"].asFloat();

    } else if ([part isModeRadius]) {

        part.startRadius = v["maxRadius"].asFloat();
        part.startRadiusVar = v["maxRadiusVariance"].asFloat();

        part.endRadius = v["minRadius"].asFloat();
        part.endRadiusVar = v["minRadiusVariance"].asFloat();

        part.rotatePerSecond = v["rotatePerSecond"].asFloat();
        part.rotatePerSecondVar = v["rotatePerSecondVariance"].asFloat();

    }

    if (v["modelFilename"].isString())
        part.modelFilename = [NSString stringWithUTF8String:v["modelFilename"].asString().c_str()];

    if (v["modelPrefix"].isString())
        part.modelPrefix = [NSString stringWithUTF8String:v["modelPrefix"].asString().c_str()];

    part.textureName = [NSString stringWithUTF8String:v["textureFileName"].asString().c_str()];

    if (v["textureImageData"].isString())
    {

        NSString* texture_data = [NSString stringWithUTF8String:v["textureImageData"].asString().c_str()];
        part.textureEmbedded = YES;

        part.textureImage = [[NSImage alloc] initWithData:[[NSData dataFromBase64String:texture_data] dataByGZipDecompressingDataWithError:nil]];

    } else {

        part.textureEmbedded = NO;

        NSString *folder = [[url path] stringByDeletingLastPathComponent];
        NSString *textureFileName = [folder stringByAppendingPathComponent:part.textureName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:textureFileName]) {
            part.textureImage = [[NSImage alloc] initWithContentsOfFile:textureFileName];
        }

    }

    c.r = v["startColorRed"].asFloat();
    c.g = v["startColorGreen"].asFloat();
    c.b = v["startColorBlue"].asFloat();
    c.a = v["startColorAlpha"].asFloat();
    part.startColor = c;
    c.r = v["startColorVarianceRed"].asFloat();
    c.g = v["startColorVarianceGreen"].asFloat();
    c.b = v["startColorVarianceBlue"].asFloat();
    c.a = v["startColorVarianceAlpha"].asFloat();
    part.startColorVar = c;

    c.r = v["finishColorRed"].asFloat();
    c.g = v["finishColorGreen"].asFloat();
    c.b = v["finishColorBlue"].asFloat();
    c.a = v["finishColorAlpha"].asFloat();
    part.endColor = c;
    c.r = v["finishColorVarianceRed"].asFloat();
    c.g = v["finishColorVarianceGreen"].asFloat();
    c.b = v["finishColorVarianceBlue"].asFloat();
    c.a = v["finishColorVarianceAlpha"].asFloat();
    part.endColorVar = c;

    b.src = v["blendFuncSource"].asUInt();
    b.dst = v["blendFuncDestination"].asUInt();
    part.blendFunc = b;
}


- (void)readParticleSystem:(ParticleSystem *)part fromURL:(NSURL *)url
{
    CGPoint p;
    ccColor4F c;
    ccBlendFunc b;

    NSData* data0 = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:NULL];

    const char* bytes = (const char*)[data0 bytes];
    auto size = [data0 length];

    if (bytes[0] == '{')
    {
        Json::Reader r;
        Json::Value v;

        if (r.parse(bytes, (const char*)(bytes + (size - 1)), v))
            [self readParticleSystem:part fromJson:v url:url];

        return;
    }
    
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfURL:url];
    
    part.totalParticles = [d[@"maxParticles"] floatValue];
    
    part.duration = [d[@"duration"] floatValue];
    
    p.x = [d[@"sourcePositionx"] doubleValue];
    p.y =[d[@"sourcePositiony"] doubleValue];
    part.position = p;
    p.x = [d[@"sourcePositionVariancex"] doubleValue];
    p.y =[d[@"sourcePositionVariancey"] doubleValue];
    part.posVar = p;
    
    part.life = [d[@"particleLifespan"] floatValue];
    part.lifeVar = [d[@"particleLifespanVariance"] floatValue];
    
    if (d[@"emissionRate"])
        part.emissionRate = [d[@"emissionRate"] floatValue];
    else
        part.emissionRate = part.totalParticles / part.life;
    
    part.angle = [d[@"angle"] floatValue];
    part.angleVar = [d[@"angleVariance"] floatValue];
    
    part.startSize = [d[@"startParticleSize"] floatValue];
    part.startSizeVar = [d[@"startParticleSizeVariance"] floatValue];
    part.endSize = [d[@"finishParticleSize"] floatValue];
    part.endSizeVar = [d[@"finishParticleSizeVariance"] floatValue];
    
    part.startSpin = [d[@"rotationStart"] floatValue];
    part.startSpinVar = [d[@"rotationStartVariance"] floatValue];
    part.endSpin = [d[@"rotationEnd"] floatValue];
    part.endSpinVar = [d[@"rotationEndVariance"] floatValue];
    
    part.emitterMode = [d[@"emitterType"] integerValue];

    part.modelFilename = @"";
    part.modelPrefix = @"";
    
    if ([part isModeGravity]) {
        
        p.x = [d[@"gravityx"] doubleValue];
        p.y =[d[@"gravityy"] doubleValue];
        part.gravity = p;
        
        part.speed = [d[@"speed"] floatValue];
        part.speedVar = [d[@"speedVariance"] floatValue];
        
        part.radialAccel = [d[@"radialAcceleration"] floatValue];
        part.radialAccelVar = [d[@"radialAccelVariance"] floatValue];
        
        part.tangentialAccel = [d[@"tangentialAcceleration"] floatValue];
        part.tangentialAccelVar = [d[@"tangentialAccelVariance"] floatValue];
        
    } else if ([part isModeRadius]) {
        
        part.startRadius = [d[@"maxRadius"] floatValue];
        part.startRadiusVar = [d[@"maxRadiusVariance"] floatValue];
        
        part.endRadius = [d[@"minRadius"] floatValue];
        part.endRadiusVar = [d[@"minRadiusVariance"] floatValue];
        
        part.rotatePerSecond = [d[@"rotatePerSecond"] floatValue];
        part.rotatePerSecondVar = [d[@"rotatePerSecondVariance"] floatValue];
        
    }
    
    part.textureName = d[@"textureFileName"];
    
    if (d[@"textureImageData"]) {
        
        part.textureEmbedded = YES;
        
        part.textureImage = [[NSImage alloc] initWithData:[[NSData dataFromBase64String:[d[@"textureImageData"] description]] dataByGZipDecompressingDataWithError:nil]];
        
    } else {
        
        part.textureEmbedded = NO;
        
        NSString *folder = [[url path] stringByDeletingLastPathComponent];
        NSString *textureFileName = [folder stringByAppendingPathComponent:part.textureName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:textureFileName]) {
            part.textureImage = [[NSImage alloc] initWithContentsOfFile:textureFileName];
        }
        
    }
    
    c.r = [d[@"startColorRed"] floatValue];
    c.g = [d[@"startColorGreen"] floatValue];
    c.b = [d[@"startColorBlue"] floatValue];
    c.a = [d[@"startColorAlpha"] floatValue];
    part.startColor = c;
    c.r = [d[@"startColorVarianceRed"] floatValue];
    c.g = [d[@"startColorVarianceGreen"] floatValue];
    c.b = [d[@"startColorVarianceBlue"] floatValue];
    c.a = [d[@"startColorVarianceAlpha"] floatValue];
    part.startColorVar = c;
    
    c.r = [d[@"finishColorRed"] floatValue];
    c.g = [d[@"finishColorGreen"] floatValue];
    c.b = [d[@"finishColorBlue"] floatValue];
    c.a = [d[@"finishColorAlpha"] floatValue];
    part.endColor = c;
    c.r = [d[@"finishColorVarianceRed"] floatValue];
    c.g = [d[@"finishColorVarianceGreen"] floatValue];
    c.b = [d[@"finishColorVarianceBlue"] floatValue];
    c.a = [d[@"finishColorVarianceAlpha"] floatValue];
    part.endColorVar = c;
    
    b.src = [d[@"blendFuncSource"] unsignedIntValue];
    b.dst = [d[@"blendFuncDestination"] unsignedIntValue];
    part.blendFunc = b;
}

- (void)readParticleSystem:(ParticleSystem *)part fromPreset:(NSString *)preset {
    
    Class presetPartClass = NSClassFromString(preset);
    if (!presetPartClass) return;
    
    CCParticleSystemQuad *presetPart = [[presetPartClass alloc] init];
    if (!presetPart) return;
    
    part.totalParticles = presetPart.totalParticles;
    
    part.duration = presetPart.duration;
    
    part.position = presetPart.position;
    part.posVar = presetPart.posVar;
    
    part.life = presetPart.life;
    part.lifeVar = presetPart.lifeVar;
    
    part.emissionRate = presetPart.emissionRate;
    
    part.angle = presetPart.angle;
    part.angleVar = presetPart.angleVar;
    
    part.startSize = presetPart.startSize;
    part.startSizeVar = presetPart.startSizeVar;
    part.endSize = presetPart.endSize;
    part.endSizeVar = presetPart.endSizeVar;
    
    part.startSpin = presetPart.startSpin;
    part.startSpinVar = presetPart.startSpinVar;
    part.endSpin = presetPart.endSpin;
    part.endSpinVar = presetPart.endSpinVar;
    
    part.emitterMode = presetPart.emitterMode;
    
    if ([part isModeGravity])
    {
        part.gravity = presetPart.gravity;
        
        part.speed = presetPart.speed;
        part.speedVar = presetPart.speedVar;
        
        part.radialAccel = presetPart.radialAccel;
        part.radialAccelVar = presetPart.radialAccelVar;
        
        part.tangentialAccel = presetPart.tangentialAccel;
        part.tangentialAccelVar = presetPart.tangentialAccelVar;
    }
    else
    if ([part isModeRadius])
    {
        part.startRadius = presetPart.startRadius;
        part.startRadiusVar = presetPart.startRadiusVar;
        
        part.endRadius = presetPart.endRadius;
        part.endRadiusVar = presetPart.endRadiusVar;
        
        part.rotatePerSecond = presetPart.rotatePerSecond;
        part.rotatePerSecondVar = presetPart.rotatePerSecondVar;
    }
    
    part.textureEmbedded = NO;
    part.textureImage = [NSImage imageNamed:@"fire.png"];
    part.textureName = @"fire.png";
    
    part.startColor = presetPart.startColor;
    part.startColorVar = presetPart.startColorVar;
    
    part.endColor = presetPart.endColor;
    part.endColorVar = presetPart.endColorVar;
    
    part.blendFunc = presetPart.blendFunc;

    part.modelFilename = @"";
    part.modelPrefix = @"";
}

@end
