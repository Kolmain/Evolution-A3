    private["_cfg", "_name", "_DescShort", "_DescLong", "_Type", "_Count", "_Pic"];
    _name = _this;
    _cfg = (configFile >> "CfgMagazines" >> _name);

    _DescShort = if (isText(_cfg >> "displayName")) then {
        getText(_cfg >>"displayName")
    }
    else {
        "/"
    };

    _DescLong  = if (isText(_cfg >> "Library" >> "libTextDesc")) then {
        getText(_cfg >> "Library" >>"libTextDesc")
    }
    else {
        "/"
    };

    _Pic = if (isText(_cfg >> "picture")) then {
        getText(_cfg >> "picture")
    }
    else {
        "/"
    };

    _Type = if (isText(_cfg >> "type")) then {
        parseNumber(getText(_cfg >>"type"))
    }
    else {
        getNumber(_cfg >> "type")
    };

    _Count = if (isText(_cfg >> "count")) then {
        parseNumber(getText(_cfg >> "count"))
    }
    else {
        getNumber(_cfg >> "count")
    };

    [_DescShort, _DescLong, _Type, _Pic]
