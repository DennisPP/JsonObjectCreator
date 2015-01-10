# JsonObjectCreator
Objective C Object create from Json String using reflection


## Usage


```

@interface UserObject : NSObject
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) NSString* username;
@property (strong, nonatomic) NSString* profile_picture;
@end



NSData* data; // the data u get from internet, e.t.c

UserObject* user = (UserObject*)JsonObjectCreator::ObjectFromJsonData(data, UserObject.class);

// use your user object now 

NSLog(@"%@", user.username);


```


## Composited Object


```

@interface CommentObject : NSObject
@property (strong, nonatomic) NSString* created_time;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) UserObject* from;
@end


NSData* data; // the data u get from internet, e.t.c

CommentObject* comment = (CommentObject*)JsonObjectCreator::ObjectFromJsonData(data, CommentObject.class);

// use your comment object's user object now 

NSLog(@"%@", comment.user.username);

```


## Array

Arrays are treated specially and used a language HACK, see this

for example, the system need to store list of comments instead of just one, 
so we have a Comment Array class now

We first add the following line under the CommentObject

MakePlacableInGenericArray(CommentObject)

this actually use the protocol mechanism in a HACK way so that the implementation can have
a way to know the type of the array that is to be created for the array


```

@interface CommentObject : NSObject
@property (strong, nonatomic) NSString* created_time;
@property (strong, nonatomic) NSString* text;
@property (strong, nonatomic) UserObject* from;
@end

MakePlacableInGenericArray(CommentObject)


```

And the CommentObjectArray

```
@interface CommentObjectArray : NSObject
@property (strong, nonatomic) NSNumber* count;
@property (strong, nonatomic) NSMutableArray<CommentObject>* data;
@end 


```


