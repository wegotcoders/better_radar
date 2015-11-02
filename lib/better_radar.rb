require 'open-uri'
require 'nokogiri'

# Gem Information
require "better_radar/version"
require "better_radar/configuration"

# Element Parents
require "better_radar/element/base"
require "better_radar/element/factory"
require "better_radar/element/entity"
require "better_radar/element/categorical_information"
require "better_radar/element/storable"

# Entities
require "better_radar/element/sport"
require "better_radar/element/category"
require "better_radar/element/tournament"
require "better_radar/element/outright"
require "better_radar/element/match"
require "better_radar/element/competitor"

# Data Elements
require "better_radar/element/bet"
require "better_radar/element/odds"
require "better_radar/element/goal"
require "better_radar/element/card"
require "better_radar/element/player"
require "better_radar/element/round"
require "better_radar/element/bet_result"
require "better_radar/element/bet_probability"

# User facing classes
require "better_radar/client"
require "better_radar/parser"
require "better_radar/document"

# Utility
require "better_radar/logger"
