# getters/setters
(or property accessors if you want to be fancy)

to define an accessor, use `property`.
`property` takes a table which must have
at least either `get` or `set` defined as functions.

like this:
```lua
class 'WithAccessors' {
    coolfield = property {
        get = function(self)
            return 'fixed value that cannot change'
        end
    }
}
```

**NOTE**: take care to not write to fields that have
no `set` defined, and to not read from fields that have
no `get` defined. doing this **will** lead to an error!

**ANOTHER NOTE**: providing a table without either `get` or `set`
defined to `property` **will** lead to an error.

inside your get/set functions, `self` refers to the current
instance of the class.

here's one way to create a backing field:
```lua
class 'Backing' {
    coolfield = property {
        get = function(self)
            local value = self.__coolfield
            -- transform it here?
            return value
        end,
        set = function(self, value)
            self.__coolfield = value
        end
    }
}
```