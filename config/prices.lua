Config = Config or {}

-- The vehicle price will be the first option and will change the upgrades price 
Config.VehicleOverridePrice = {
    [`elegy`] = {
        price = 210000
    },
    [`elegy2`] = {
        price = 250000
    }
}

-- If a is not included in "Config.VehicleOverridePrice" then price of the vehicle will be as the class
Config.VehicleClassPrice = {
    ['0'] = 100000, -- Compacts
    ['1'] = 150000, -- Sedans
    ['2'] = 200000, -- SUVs
    ['3'] = 150000, -- Coupes
    ['4'] = 250000, -- Muscle
    ['5'] = 250000, -- Sports Classics
    ['6'] = 200000, -- Sports
    ['7'] = 350000, -- Super
    ['8'] = 200000, -- Motorcycles
    ['9'] = 150000, -- Off-road
    ['10'] = 100000, -- Industrial
    ['11'] = 100000, -- Utility
    ['12'] = 100000, -- Vans
    ['13'] = 1000, -- Cycles
    ['14'] = 100000, -- Boats
    ['15'] = 500000, -- Helicopters
    ['16'] = 500000, -- Planes
    ['17'] = 100000, -- Service
    ['18'] = 100000, -- Emergency
    ['20'] = 100000 -- Commercial
}

-- If a is not included in "Config.VehicleOverridePrice" and the class of the vehicle is not included in the "Config.VehicleClassPrice" the price will be as the "Config.VehicleDefaultPrice"
Config.VehicleDefaultPrice = 200000

-- This multiplier will add to the parts multiplier for the position that is not for whitelist job
Config.PriceMultiplierWithoutTheJob = 2.0

-- The price of the repair for the points with whitelist job (for the open points the "Config.PriceMultiplierWithoutTheJob" multiplier will apply)
Config.VehicleRepairPrice = 1000

-- The multiplier of parts for the points with whitelist job (for the open points the "Config.PriceMultiplierWithoutTheJob" multiplier will add to that)
Config.VehicleCustomisePriceMultiplier = {
    ['engine'] = {5.0, 7.95, 20.56, 25.00, 30.00, 35.00},
    ['brakes'] = {2.0, 4.65, 9.30, 18.60, 20.0},
    ['transmission'] = {5.0, 10.95, 15.93, 20.51, 25.0},
    ['suspension'] = {1.5, 3.72, 7.44, 10.88, 15.77, 25.20, 30.0},
    ['armor'] = {20.0, 50.77, 60.77, 65.0, 75.0, 90.0, 100.0, 115.0},
    ['turbo'] = {5.0, 15.81},

    ['extras'] = 2.0,
    ['windowTint'] = 1.12,

    ['horn'] = 1.12,
    ['speakers'] = 6.98,
    ['trunk'] = 5.58,
    ['hydrulics'] = 5.12,
    ['engine_block'] = 5.12,
    ['air_filter'] = 3.72,
    ['struts'] = 6.51,
    ['tank'] = 4.19,

    ['spoilers'] = 2.65,
    ['front_bumper'] = 2.12,
    ['rear_bumper'] = 2.12,
    ['side_skirts'] = 2.65,
    ['exhaust'] = 2.12,
    ['cage'] = 2.12,
    ['grille'] = 2.72,
    ['hood'] = 2.88,
    ['left_fender'] = 2.12,
    ['right_fender'] = 2.12,
    ['roof'] = 2.58,
    ['arch_cover'] = 4.19,
    ['aerials'] = 1.12,
    ['wings'] = 6.05,
    ['windows'] = 1.0,

    ['dashboard'] = 4.65,
    ['dashboard_color'] = 1.0,
    ['dial'] = 4.19,
    ['door_speaker'] = 5.58,
    ['seat'] = 4.65,
    ['steering_wheel'] = 4.19,
    ['shifter_leaver'] = 3.26,
    ['ornaments'] = 0.9,
    ['interior'] = 6.98,
    ['interior_color'] = 1.0,

    ['primary_paint'] = 1.12,
    ['secondary_paint'] = 0.66,
    ['primary_paint_type'] = 0.5,
    ['secondary_paint_type'] = 0.5,
    ['pearlescent'] = 0.5,

    ['wheels_color'] = 0.66,
    ['smoke_color'] = 1.12,

    ['sport'] = 1.65,
    ['muscle'] = 1.65,
    ['lowrider'] = 1.65,
    ['suv'] = 1.65,
    ['offroad'] = 1.65,
    ['tuner'] = 1.65,
    ['bike_wheels'] = 1.65,
    ['high_end'] = 1.65,

    ['plate_type'] = 1.1,
    ['plate_color'] = 1.1,
    ['plate_holder'] = 3.49,

    ['xenon'] = 0.1,
    ['neon'] = 1.12,

    ['stickers'] = 6.0,
    ['livery'] = 6.0
}
