# inheritance?
classified also supports single-inheritance!  

after `class 'YourName'`, instead of opening with a `{`, place `: extends 'BaseClass'` to extend it.
```lua
class 'TheBase' {
    base = function(self)
        print('base function')
    end
}

class 'Extension' : extends 'TheBase' {
    extension = function(self)
        print('extended')
    end
}

local ins = Extension()
ins:base()
ins:extension()
```

**NOTE**: the superclass's constructor is called automatically, and actually not accessible. keep this in mind when writing your code.