--[[

    classified.lua
    version 1.1.2
    
    changelog:
    + 1.1.0: getters and setters
    + 1.1.1: made errors bubble up properly because yeah
    + 1.1.2: first github release - added error for indexing
             a class without a static block

    Copyright (C) 2021 Rin <lostkagamine@outlook.com>
    This file is part of classified.

    classified is non-violent software: you can use, redistribute,
    and/or modify it under the terms of the NVPLv7+ as found
    in the LICENSE file in the source code root directory or
    at <https://git.pixie.town/thufie/npl-builder>.
    
    classified comes with ABSOLUTELY NO WARRANTY, to the extent
    permitted by applicable law.  See the NVPL for details.

]]

local _CLASSIFIED_VERSION = '1.1.1'
local _ISSUE_REPORT_LINK = 'https://github.com/ry00001/classified/issues/new'

-- disabling _PEDANTIC will disable the error
-- for indexing a class without a static block
local _PEDANTIC = true

local _classes = {}
local _supers = {}
local _properties = {}

local forbidden = {
    "__new"
}

local function contains(tb,v)
    for _,l in pairs(tb) do
        if l==v then return true end
    end
    return false
end

local function ierror(msg, add)
    if not add then add = 0 end

    local slug = string.format('v%s: %s', _CLASSIFIED_VERSION, msg)

    print('*************************************')
    print('** classified.lua: INTERNAL ERROR  **')
    print('** ------------------------------- **')
    print('** if you are seeing this message, **')
    print('** you have found a bug, report it **')
    print('*************************************')
    print()
    print('** please report this error at this link:')
    print('** '.._ISSUE_REPORT_LINK)
    print('** please include a full stack trace and the error message below')
    print()
    print(slug)
    print()

    error(slug, 2+add)
end

local function iassert(cond, msg)
    if not cond then
        if not msg then
            msg = 'assertion failed'
        else
            msg = 'assertion failed: '..msg
        end

        ierror(msg, 1)
    end
end

local function build(t, ignore, custforbidden)
    local o = {}
    if not custforbidden then
        custforbidden = forbidden
    end

    for i, j in pairs(t) do
        if not ignore and contains(forbidden,i) then goto please_5_5_add_continue_i_beg_you end

        if i == "__THIS_IS_A_PROPERTY_ACCESSOR__" then
            return nil -- Don't.
        end

        if type(j) == "table" then
            local rv = build(j)
            o[i] = rv
        else
            o[i] = j
        end

        local mt = getmetatable(o[i])
        if mt ~= nil and type(o[i]) == "table" then
            setmetatable(o[i], mt)
        end

        ::please_5_5_add_continue_i_beg_you::
    end

    return o
end

local function _construct(n, args)
    iassert(_classes[n] ~= nil, '_classes[n] ~= nil')

    local cls = _classes[n]

    local mem = build(cls.definition)

    if _supers[n] then
        if not cls.ctor then
            -- Call the constructor
            _supers[n](mem, table.unpack(args))
        else
            mem.super = _supers[n]
        end
    end

    if cls.ctor then
        cls.ctor(mem, table.unpack(args))
        mem.super = nil -- Destroy it
    end

    return mem
end

local function _extends(og, new, tb)
    local n = build(_classes[og].definition, true, {})

    if _classes[og].ctor and tb.__new then
        _supers[new] = _classes[og].ctor
        n.__new = tb.__new
    end

    if _classes[og].static then
        local newstatics = build(_classes[og].static, true)
        for a, b in pairs(_classes[new].static or {}) do
            newstatics[a] = b
        end
        _classes[new].static = newstatics
    end

    for i, j in pairs(tb) do
        n[i] = j
    end

    class(new)(n)
end

local _current_class = nil

function static(the)
    if not _classes[_current_class] then
        _classes[_current_class] = {}
    end
    _classes[_current_class].static = the
end

function property(tb)
    if not tb.get and not tb.set then
        error("cannot define empty property", 2)
    end

    local ret = {
        __THIS_IS_A_PROPERTY_ACCESSOR__ = "don't touch this"
    }

    if tb.get then
        ret.get = tb.get
    end

    if tb.set then
        ret.set = tb.set
    end

    return ret
end

function class(name)
    -- lord
    local the = {}
    _current_class = name

    local theCall = function(_, theTable)
        if not _classes[name] then
            _classes[name] = {}
        end

        _classes[name].definition = build(theTable, false, {"__static"})
        _classes[name].ctor = theTable.__new

        _properties[name] = {}

        for a, b in pairs(theTable) do
            if type(b) == "table" and b.__THIS_IS_A_PROPERTY_ACCESSOR__ then
                -- It is in fact a property accessor
                _properties[name][a] = b
            end
        end

        local obj = {}
        
        setmetatable(obj, {
            __call = function(self, ...)
                local c = _construct(name, {...})

                setmetatable(c, {
                    __index = function(self, key)
                        if _properties[name][key] then
                            if not _properties[name][key].get then
                                error("attempt to read a property '"..key.."' with no getter defined", 2) 
                            end

                            return _properties[name][key].get(self)
                        end

                        return rawget(self, key)
                    end,
                    __newindex = function(self, key, value)
                        if _properties[name][key] then
                            if not _properties[name][key].set then
                                error("attempt to write to a property '"..key.."' with no setter defined", 2) 
                            end

                            return _properties[name][key].set(self, value)
                        end

                        rawset(self, key, value)
                    end
                })

                return c
            end,
            __index = function(self, key)
                if not _classes[name].static then
                    if _PEDANTIC then
                        error("attempt to index a class with no static block '"..name.."'", 2)
                    end
                    return nil
                end

                return _classes[name].static[key]
            end
        })

        _G[name] = obj
    end

    the.extends = function(self, og)
        return function(t)
            _extends(og, name, t)
        end
    end

    setmetatable(the, {
        __call = theCall
    })

    return the
end