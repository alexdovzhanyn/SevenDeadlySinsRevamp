require 'gosu'
require 'json'
require 'pry'
require 'observer'
require_relative 'lib/game/metadata'
require_relative 'lib/engine/game_state'
require_relative 'lib/engine/scene'
require_relative 'lib/engine/helper'
require_relative 'lib/engine/camera'
require_relative 'lib/bounding_box'
require_relative 'lib/engine/level_mapper'
require_relative 'lib/humanoid'
require_relative 'lib/player.rb'
require_relative 'lib/game/scenes/title_scene'
require_relative 'lib/game/scenes/main_menu_scene'
require_relative 'lib/game/scenes/game_scene'

include Helper

GameState.set_state(
  tiles: Gosu::Image.load_tiles('./assets/tiles/map_tiles.png', 16, 16, {retro: true}) # Retro means no weird border around smaller tiles
)
