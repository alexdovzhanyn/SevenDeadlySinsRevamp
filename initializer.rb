require 'gosu'
require 'json'
require 'pry'
require 'observer'
require 'rydux'
require_relative 'lib/game/metadata'
require_relative 'lib/engine/game_state'
require_relative 'lib/engine/scene'
require_relative 'lib/engine/helper'
require_relative 'lib/engine/camera'
require_relative 'lib/bounding_box'
require_relative 'lib/engine/level_mapper'
require_relative 'lib/humanoid'
require_relative 'lib/player.rb'
require_relative 'lib/game/gui/button'
require_relative 'lib/game/scenes/video_settings_scene'
require_relative 'lib/game/scenes/title_scene'
require_relative 'lib/game/scenes/main_menu_scene'
require_relative 'lib/game/scenes/game_scene'
require_relative 'lib/game/scenes/options_scene'

require_relative 'lib/game/reducers/game_reducer'

include Helper

Store = Rydux::Store.new(game: GameReducer)

Store.dispatch(type: 'LOAD_TILES')
