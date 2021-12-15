# statics?
we have them.
use `static {}` *inside* of a class body to define a static block,
then place whatever you want static inside of it.
```lua
class 'ThisIsStatic' {
    static {
        somethingstatic = 'barfoo'
    }
}
```

to retrieve static values, index the class.
(values can be anything you want, including functions and tables.)
```lua
print(ThisIsStatic.somethingstatic)
```

**NOTE**: ***never*** call `static` unless you are inside of a class body.
this is extraordinarily undefined behaviour because of how it works internally,
and i am not responsible if classified crashes your program or eats your dog or both.

**NOTE**: attempting to index a class that does not have a
`static` block **will** raise an error, unless pedantic mode
is disabled. (see the source code.)