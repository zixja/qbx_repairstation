lib.callback.register('qbx_repairstation:payAndRepair', function(source, option)
    local player = exports.qbx_core:GetPlayer(source)
    if not player then return false, 'Player not found' end

    if player.Functions.RemoveMoney('cash', option.price, 'repair_station') then
        return true
    end

    return false, 'Not enough cash'
end)