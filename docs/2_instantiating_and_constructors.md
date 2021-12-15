# okay, cool, but how do i instantiate?
to instantiate, simply call your class' name like a function.
```lua
local instance = ClassName()
```
with an instance object, you can access your definitions, and call instance methods. (make sure to always call class methods with a colon.)
```lua
print(instance.mydefinition)
instance:mymethod()
```
# constructors?
you bet. simply define `__new` in your class body as a function.
in classes, `self` is *always* the first argument! you can even make it take any arguments you want.
```lua
class 'WithAConstructor' {
    __new = function(self, arg1, arg2, arg3)
        print(arg1 .. arg2 .. arg3)
    end
}

WithAConstructor('hello', ', ', 'world!')
```