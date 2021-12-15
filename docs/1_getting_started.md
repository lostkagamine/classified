# getting started
simply copy `classified.lua` into your project, then `require` or `dofile` it,
then you'll be ready to go. to define a class, use this syntax:
```lua
class 'ClassName' {

}
```
the table is your *class body*. it will contain *definitions* and *methods*.
here is a simple definition:
```lua
class 'ClassName' {
    mydefinition = 'foobar'
}
```
and this is a method:
```lua
class 'ClassName' {
    mymethod = function(self)
        print('hello there')
    end
}
```