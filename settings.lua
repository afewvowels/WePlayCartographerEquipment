data:extend({
  -- Startup: these size the equipment's internal battery.
  {
    type = "int-setting",
    name = "wp-cartographer-power",
    setting_type = "startup",
    default_value = 150,
    minimum_value = 1,
    maximum_value = 100000,
    order = "a"
  },
  {
    type = "int-setting",
    name = "wp-cartographer-interval",
    setting_type = "startup",
    default_value = 120,
    minimum_value = 10,
    maximum_value = 3600,
    order = "b"
  },
  -- Runtime: change mid-game.
  {
    type = "int-setting",
    name = "wp-cartographer-radius",
    setting_type = "runtime-global",
    default_value = 256,
    minimum_value = 16,
    maximum_value = 1024,
    order = "c"
  },
  {
    type = "int-setting",
    name = "wp-cartographer-quality-bonus",
    setting_type = "runtime-global",
    default_value = 25,
    minimum_value = 0,
    maximum_value = 200,
    order = "d"
  },
  {
    type = "bool-setting",
    name = "wp-cartographer-generate",
    setting_type = "runtime-global",
    default_value = true,
    order = "e"
  }
})
