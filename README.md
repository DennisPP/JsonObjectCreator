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


```