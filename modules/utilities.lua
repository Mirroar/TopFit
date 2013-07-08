local addonName, ns, _ = ...

function ns:PlayerCanDualWield()
    -- Hunter: While it's possible to dual wield, it is not a "top fit" to do so - ignore that
    -- 673 (Rogue, Death Knight), 86629 (Shaman), 124146 (Monk), 23588 (Warrior)
    return IsSpellKnown(674) or IsSpellKnown(86629) or IsSpellKnown(124146) or IsSpellKnown(23588)
end

function ns:PlayerHasTitansGrip()
    return IsSpellKnown(46917)
end
