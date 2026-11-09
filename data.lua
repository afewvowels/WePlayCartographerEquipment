local MOD = "__WePlayCartographerEquipment__"
local NAME = "wp-cartographer-equipment"

local power_kw = settings.startup["wp-cartographer-power"].value
local interval = settings.startup["wp-cartographer-interval"].value
-- Energy spent per scan; the buffer holds two scans' worth.
local scan_j = math.floor(power_kw * 1000 * interval / 60)

-- Fit armor grids, plus vehicle/universal grids from overhaul mods if present.
local categories = {}
for _, cat in pairs({ "armor", "universal-equipment", "vehicle-equipment" }) do
  if data.raw["equipment-category"][cat] then
    categories[#categories + 1] = cat
  end
end

local prerequisites = {}
if data.raw.technology["modular-armor"] then prerequisites = { "modular-armor" } end

data:extend({
  {
    type = "battery-equipment",
    name = NAME,
    sprite = {
      filename = MOD .. "/graphics/equipment/cartographer-equipment.png",
      width = 128,
      height = 128,
      priority = "medium",
      scale = 0.5
    },
    shape = { width = 2, height = 2, type = "full" },
    energy_source = {
      type = "electric",
      buffer_capacity = (scan_j * 2) .. "J",
      input_flow_limit = (power_kw * 2) .. "kW",
      output_flow_limit = "0W",
      usage_priority = "secondary-input"
    },
    categories = categories
  },
  {
    type = "item",
    name = NAME,
    icon = MOD .. "/graphics/icons/cartographer-equipment.png",
    icon_size = 64,
    place_as_equipment_result = NAME,
    subgroup = "utility-equipment",
    order = "e[cartographer]",
    stack_size = 20
  },
  {
    type = "recipe",
    name = NAME,
    enabled = false,
    energy_required = 10,
    ingredients = {
      { type = "item", name = "radar", amount = 1 },
      { type = "item", name = "electronic-circuit", amount = 10 },
      { type = "item", name = "steel-plate", amount = 5 }
    },
    results = { { type = "item", name = NAME, amount = 1 } }
  },
  {
    type = "technology",
    name = NAME,
    icon = MOD .. "/graphics/technology/cartographer-equipment.png",
    icon_size = 256,
    prerequisites = prerequisites,
    effects = { { type = "unlock-recipe", recipe = NAME } },
    unit = {
      count = 100,
      ingredients = {
        { "automation-science-pack", 1 },
        { "logistic-science-pack", 1 }
      },
      time = 15
    }
  }
})
