-- client.lua

-- Blips (can stay in a thread)
CreateThread(function()
    for _, loc in ipairs(Config.RepairLocations) do
        local blip = AddBlipForCoord(loc.coords.x, loc.coords.y, loc.coords.z)
        SetBlipSprite(blip, loc.blip.sprite or 446)
        SetBlipColour(blip, loc.blip.colour or 5)
        SetBlipScale(blip, loc.blip.scale or 0.8)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(loc.name)
        EndTextCommandSetBlipName(blip)
    end
end)

-- Build menu options table
local menuOptions = {}

for _, opt in ipairs(Config.RepairOptions) do
    menuOptions[#menuOptions + 1] = {
        title       = opt.label,
        description = ('$%s • %s'):format(opt.price, opt.description),
        icon        = 'fa-solid fa-wrench',
        arrow       = true,
        onSelect = function()
            local success, reason = lib.callback.await('qbx_repairstation:payAndRepair', false, opt)
            if success then
                DoRepair(opt)
            else
                lib.notify({
                    title       = 'Repair Station',
                    description = reason or 'Could not process payment',
                    type        = 'error',
                    duration    = 4500
                })
            end
        end
    }
end

-- Register the context menu IMMEDIATELY (static menu = register once at load)
lib.registerContext({
    id      = 'repair_menu',
    title   = 'Vehicle Repair Station',
    options = menuOptions
})

-- Target zones (thread is fine here)
CreateThread(function()
    for _, loc in ipairs(Config.RepairLocations) do
        exports.ox_target:addBoxZone({
            coords     = loc.coords,
            size       = loc.size,
            rotation   = loc.heading or 0.0,
            debug      = Config.Debug or false,
            options = {
                {
                    name      = 'repair_vehicle',
                    icon      = 'fa-solid fa-screwdriver-wrench',
                    label     = 'Repair Vehicle',
                    distance  = 4.5,
                    canInteract = function()
                        return cache.vehicle and cache.vehicle ~= 0
                    end,
                    onSelect = function()
                        lib.showContext('repair_menu')
                    end
                }
            }
        })
    end
end)

-- Repair function (unchanged)
function DoRepair(option)
    local veh = cache.vehicle
    if not veh or veh == 0 then
        lib.notify({ description = 'No vehicle found', type = 'error' })
        return
    end

    if lib.progressBar({
        duration   = option.duration,
        label      = 'Repairing vehicle...',
        useWhileDead = false,
        canCancel  = true,
        disable = { move = true, car = true, combat = true },
        anim = {
            dict = 'mini@repair',
            clip = 'fixing_a_ped',
            flag = 49
        },
        prop = {
            model  = `prop_toolbox_03`,
            pos    = vec3(0.05, 0.0, -0.25),
            rot    = vec3(0.0, 0.0, -45.0)
        }
    }) then
        if option.repairType == 'full' or option.repairType == 'engine' then
            SetVehicleEngineHealth(veh, 1000.0)
            SetVehiclePetrolTankHealth(veh, 1000.0)
        end

        if option.repairType == 'full' or option.repairType == 'body' then
            SetVehicleBodyHealth(veh, 1000.0)
            SetVehicleDeformationFixed(veh)
        end

        if option.repairType == 'full' or option.repairType == 'tires' then
            for wheel = 0, 7 do
                SetVehicleTyreFixed(veh, wheel)
            end
        end

        SetVehicleFixed(veh)
        SetVehicleUndriveable(veh, false)
        SetVehicleEngineOn(veh, true, false)
        SetVehicleDirtLevel(veh, 0.0)

        lib.notify({
            title       = 'Repair Station',
            description = 'Vehicle repaired successfully!',
            type        = 'success',
            duration    = 5000
        })
    else
        lib.notify({
            title       = 'Repair Station',
            description = 'Repair cancelled.',
            type        = 'inform',
            duration    = 4000
        })
    end
end