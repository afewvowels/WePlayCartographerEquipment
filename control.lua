-- WePlay: Cartographer Equipment
-- Every scan interval, each player's armor grid and current vehicle grid are
-- checked for a charged cartographer. The best charged unit pays the scan
-- cost and the area around the player is charted.

local NAME = "wp-cartographer-equipment"
local CHUNK = 32

local interval = settings.startup["wp-cartographer-interval"].value
local power_kw = settings.startup["wp-cartographer-power"].value
local SCAN_J = math.floor(power_kw * 1000 * interval / 60)

local cfg = {}

local function read_settings()
  local g = settings.global
  cfg.radius = g["wp-cartographer-radius"].value
  cfg.quality_bonus = g["wp-cartographer-quality-bonus"].value / 100
  cfg.generate = g["wp-cartographer-generate"].value
end

-- Returns the charged unit with the biggest range in this grid, and its radius.
local function best_in_grid(grid, best, best_radius)
  if not (grid and grid.valid) then return best, best_radius end
  for _, eq in pairs(grid.equipment) do
    if eq.name == NAME and eq.energy >= SCAN_J then
      local level = eq.quality and eq.quality.level or 0
      local radius = cfg.radius * (1 + cfg.quality_bonus * level)
      if not best or radius > best_radius then
        best, best_radius = eq, radius
      end
    end
  end
  return best, best_radius
end

local function armor_grid(character)
  local inv = character.get_inventory(defines.inventory.character_armor)
  if not inv then return nil end
  local armor = inv[1]
  if armor and armor.valid_for_read then return armor.grid end
  return nil
end

local function scan(player)
  local character = player.character
  if not (character and character.valid) then return end

  local best, radius = best_in_grid(armor_grid(character), nil, 0)
  local vehicle = player.vehicle
  if vehicle and vehicle.valid then
    best, radius = best_in_grid(vehicle.grid, best, radius)
  end
  if not best then return end

  best.energy = best.energy - SCAN_J

  local surface = character.surface
  local pos = character.position
  if cfg.generate then
    surface.request_to_generate_chunks(pos, math.ceil(radius / CHUNK))
  end
  character.force.chart(surface, {
    { pos.x - radius, pos.y - radius },
    { pos.x + radius, pos.y + radius }
  })
end

script.on_init(read_settings)
script.on_load(read_settings)
script.on_configuration_changed(read_settings)
script.on_event(defines.events.on_runtime_mod_setting_changed, read_settings)

script.on_nth_tick(interval, function()
  for _, player in pairs(game.connected_players) do
    scan(player)
  end
end)
