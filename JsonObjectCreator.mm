// Created by Dennis Yu
// dennisredpanda@gmail.com

#include "JsonObjectCreator.h"
#import "ObjC/Runtime.h" //iOS



// Do not pollute the global namespace
namespace JsonObjectCreatorImp
{
    id CreateFromDictionary(id input,  Class theClass);

    
        
    
    
    id CreateFromDictionary(id input, Class theClass)
    {
        if( !input || [input isKindOfClass:[NSNull class]])
            return nil;
        
        
        id object = [[theClass alloc] init];
        
        bool quiet = true;
        
        unsigned int varCount;
        
        Ivar *vars = class_copyIvarList(theClass, &varCount);
        
        if( ! quiet )
            NSLog(@"Variable for %s:\n", class_getName(theClass));
        
        
        for (int i = 0; i < varCount; i++) {
            Ivar var = vars[i];
            
            const char* name = ivar_getName(var);
            const char* typeEncoding = ivar_getTypeEncoding(var);
            
            if( ! quiet)
                NSLog(@":::::%s:%s\n", name , typeEncoding);
            
            // skip the underscore for the name
            ++name;
            NSString* theName = [[NSString alloc] initWithUTF8String: name];
            
            id value = [input objectForKey:theName];
            if( nil != value && ![value isKindOfClass:[NSNull class]])
            {
                const char* name = ivar_getName(vars[i]);
                const char* typeEncoding = ivar_getTypeEncoding(vars[i]);
                
                NSString* className = [[NSString alloc] initWithUTF8String:typeEncoding];
                
                className = [className stringByReplacingOccurrencesOfString:@"@" withString:@""];
                className = [className stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                NSCharacterSet *open = [NSCharacterSet characterSetWithCharactersInString:@"<"];
                NSCharacterSet *close = [NSCharacterSet characterSetWithCharactersInString:@">"];
                NSRange openRange = [className rangeOfCharacterFromSet:open];
                NSRange closeRange = [className rangeOfCharacterFromSet:close];
                
                if (openRange.location != NSNotFound && closeRange.location != NSNotFound)
                {
                    if( closeRange.location > openRange.location)
                    {
                        if( ! quiet)
                        {
                            NSLog(@"HACK ARRAY OBJECT:%s\n", [className UTF8String]);
                        }
                        NSRange range;
                        range.location = openRange.location+1;
                        range.length = closeRange.location - openRange.location - 1;
                        
                        NSString* elementType = [className substringWithRange:range];
                        NSString* arrayType = [className substringToIndex:openRange.location];
                        
                        if( ! quiet)
                        {
                            NSLog(@"ARRAY TYPE:%s\n", [arrayType UTF8String]);
                            NSLog(@"ELEMENT Type:%s\n", [elementType UTF8String]);
                        }
                        
                        
                        if( [value isKindOfClass:[NSArray class]])
                        {
                            
                            
                            
                            NSArray* a = (NSArray*)value;
                            
                            NSMutableArray* temp = [[NSMutableArray alloc]init];
                            for(int j=0;j<a.count;++j)
                            {
                                //id oo = [[NSClassFromString(elementType) alloc] init];
                                id child = CreateFromDictionary(a[j], NSClassFromString(elementType));
                                [temp addObject:child];
                            }
                            //                        id theArray = [NSClassFromString(arrayType) alloc];
                            //                           NSLog(@"NEWLY Created Array:%s\n", [NSStringFromClass([theArray class]) UTF8String]);
                            //                        [((NSArray*)theArray) initWithArray:temp];
                            
                            object_setIvar(object, var, temp);
                            
                            
                            
                            
                                               }
                        
                        
                    }
                }
                else if( [value isKindOfClass:[NSDictionary class]])
                {
                    NSString* childClassName = [[NSString alloc] initWithUTF8String:typeEncoding];
                    
                    childClassName = [childClassName stringByReplacingOccurrencesOfString:@"@" withString:@""];
                    childClassName = [childClassName stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    
                    id child = CreateFromDictionary(value, NSClassFromString(childClassName));
                    object_setIvar(object, var, child);
                }
                else if( [value isKindOfClass:[NSArray class]])
                {
                    // MARK: Array should be in Generic form
                    
                    NSLog(@"******************ERROR********************* USe MutableArray<type> please");
                    
                }
                else
                {
                    if( [value isKindOfClass:[NSString class]])
                    {
                        NSString* str = (NSString*)value;
                        if(! quiet )
                        {
                            NSLog(@"Set Variable Value:%s:%s\n", name, [str UTF8String]);
                        }
                    }
                    object_setIvar(object, var, value);
                }
            }
        }
        
        free(vars);
        return object;
    }

    
}


id JsonObjectCreator::ObjectFromJsonDict(NSDictionary *input, Class theClass)
{
    return JsonObjectCreatorImp::CreateFromDictionary(input, theClass);
}

id JsonObjectCreator::ObjectFromJsonData(NSData* data, Class theClass)
{
    NSError* error = nil;
    id input = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if( error != nil)
    {
        NSLog(@"error: %@", error);
    }
    if( input == nil )
    {
    
        
        NSLog(@"\nERROR:::NSJSONSerialization return nil in ParseJson*******************************");
    }
    
    return JsonObjectCreator::ObjectFromJsonDict(input, theClass);
}
