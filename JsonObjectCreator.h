// Created by Dennis Yu
// dennisredpanda@gmail.com

#ifndef _JSON_OBJECT_CREATOR_
#define _JSON_OBJECT_CREATOR_

#import <Foundation/Foundation.h>


#define MakePlacableInGenericArray(klass) @class klass; @protocol klass @end

class JsonObjectCreator
{
public:
    static id ObjectFromJsonDict(NSDictionary *dictionary, Class theClass);
    static id ObjectFromJsonData(NSData* data, Class theClass);
};


#endif
