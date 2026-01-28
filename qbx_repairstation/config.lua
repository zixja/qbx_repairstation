Config = {}

Config.Debug = false  -- true = show zone outlines

Config.RepairLocations = {
    {
        name     = 'Glass Heroes Auto Repair',
        coords   = vector3(-200.013, -1380.952, 31.258),
        size     = vector3(6.0, 6.0, 3.0),
        heading  = 70.0,
        blip = { sprite = 446, colour = 5, scale = 0.75 }
    },
    {
        name     = 'Sandy Shores Auto Repair',
        coords   = vector3(1774.973, 3333.608, 41.318),
        size     = vector3(6.0, 6.0, 3.0),
        heading  = 0.0,
        blip = { sprite = 446, colour = 5, scale = 0.75 }
    },
    {
        name     = 'Paleto Bay Auto Repair',
        coords   = vector3(110.670, 6626.182, 31.787),
        size     = vector3(5.5, 5.5, 3.0),
        heading  = 45.0,
        blip = { sprite = 446, colour = 5, scale = 0.75 }
    }
    -- add more locations here
}

Config.RepairOptions = {
    {
        label       = 'Full Repair',
        description = 'Engine + Body + Tires + Clean',
        price       = 1200,
        duration    = 14000,
        repairType  = 'full'
    },
    {
        label       = 'Engine Only',
        description = 'Fix engine & fuel tank',
        price       = 450,
        duration    = 8000,
        repairType  = 'engine'
    },
    {
        label       = 'Body Only',
        description = 'Repair body damage',
        price       = 600,
        duration    = 9000,
        repairType  = 'body'
    },
    {
        label       = 'Tires Only',
        description = 'Fix / replace burst tires',
        price       = 250,
        duration    = 5000,
        repairType  = 'tires'
    }
}